const pool = require("../db");

// Get all settings
const getSettings = async (req, res) => {
    try {
        const result = await pool.query("SELECT * FROM app_settings");
        const settings = {};
        result.rows.forEach(row => {
            settings[row.setting_key] = row.setting_value;
        });
        res.json({ settings });
    } catch (err) {
        console.error("Error fetching settings:", err);
        res.status(500).json({ error: "Failed to fetch settings" });
    }
};

// Get a specific setting by key
const getSetting = async (req, res) => {
    try {
        const { key } = req.params;
        const result = await pool.query(
            "SELECT setting_value FROM app_settings WHERE setting_key = $1",
            [key]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: "Setting not found" });
        }
        res.json({ value: result.rows[0].setting_value });
    } catch (err) {
        console.error("Error fetching setting:", err);
        res.status(500).json({ error: "Failed to fetch setting" });
    }
};

// Update or create a setting (admin only)
const upsertSetting = async (req, res) => {
    try {
        const { key, value, description } = req.body;
        if (!key || value === undefined) {
            return res.status(400).json({ error: "Key and value are required" });
        }

        const result = await pool.query(
            `INSERT INTO app_settings (setting_key, setting_value, description, updated_by)
             VALUES ($1, $2, $3, $4)
             ON CONFLICT (setting_key) 
             DO UPDATE SET setting_value = $2, description = COALESCE($3, app_settings.description), updated_by = $4, updated_at = NOW()
             RETURNING *`,
            [key, value, description || null, req.user?.id || null]
        );
        res.json({ setting: result.rows[0] });
    } catch (err) {
        console.error("Error upserting setting:", err);
        res.status(500).json({ error: "Failed to update setting" });
    }
};

// Delete a setting (admin only)
const deleteSetting = async (req, res) => {
    try {
        const { key } = req.params;
        const result = await pool.query(
            "DELETE FROM app_settings WHERE setting_key = $1 RETURNING *",
            [key]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: "Setting not found" });
        }
        res.json({ message: "Setting deleted successfully" });
    } catch (err) {
        console.error("Error deleting setting:", err);
        res.status(500).json({ error: "Failed to delete setting" });
    }
};

module.exports = {
    getSettings,
    getSetting,
    upsertSetting,
    deleteSetting
};
