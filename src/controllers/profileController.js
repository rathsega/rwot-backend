const pool = require("../db");
const fs = require("fs");
const path = require("path");

exports.getProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const result = await pool.query(
      `SELECT u.id, u.name, u.email, u.phone, u.company, r.rolename AS role
       FROM users u
       JOIN roles r ON u.roleid = r.id
       WHERE u.id = $1`,
      [userId]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: "User not found" });
    const user = result.rows[0];
    res.json({ profile: user });
  } catch (err) {
    console.error("Get Profile Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.updateProfile = async (req, res) => {
  const { name, phone, company } = req.body;
  try {
    const userId = req.user.id;
    const result = await pool.query(
      `UPDATE users SET name = $1, phone = $2, company = $3 WHERE id = $4 
       RETURNING id, name, email, phone, company`,
      [name, phone, company, userId]
    );

    const roleResult = await pool.query(
      `SELECT r.rolename AS role FROM roles r JOIN users u ON u.roleid = r.id WHERE u.id = $1`,
      [userId]
    );

    res.json({ profile: { ...result.rows[0], role: roleResult.rows[0].role } });
  } catch (err) {
    console.error("Update Profile Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.uploadAvatar = async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: "No file uploaded" });
    const filename = `avatar_${req.user.id}_${Date.now()}.jpg`;
    const uploadPath = path.join(__dirname, "..", "uploads", filename);
    fs.writeFileSync(uploadPath, req.file.buffer);

    const avatarUrl = `${process.env.BASE_URL}/uploads/${filename}`;
    await pool.query("UPDATE users SET avatar = $1 WHERE id = $2", [avatarUrl, req.user.id]);
    res.json({ avatar: avatarUrl });
  } catch (err) {
    console.error("Upload Avatar Error:", err);
    res.status(500).json({ error: "Upload failed" });
  }
};