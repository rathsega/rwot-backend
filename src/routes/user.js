const express = require("express");
const router = express.Router();
const pool = require("../db");
const { verifyToken } = require("../middleware/authMiddleware");
const { getUsersByRole } = require("../controllers/userController");

// ✅ Route: Get users by role via query param (?role=KAM)
router.get("/", async (req, res) => {
  const { role } = req.query;
  try {
    let result;
    if (role) {
      result = await pool.query(
        `SELECT u.id, u.name, u.email, r.rolename FROM users u
         JOIN roles r ON u.roleid = r.id
         WHERE r.rolename = $1`,
        [role]
      );
    } else {
      result = await pool.query(
        `SELECT u.id, u.name, u.email, r.rolename FROM users u
         JOIN roles r ON u.roleid = r.id`
      );
    }
    res.json({ users: result.rows });
  } catch (err) {
    console.error("Fetch Users Error:", err);
    res.status(500).json({ error: "Failed to fetch users" });
  }
});

// ✅ Route: Get users by role via URL param (/role/KAM)
router.get("/role/:rolename", verifyToken, getUsersByRole);

// ✅ Route: Add new user
router.post("/", async (req, res) => {
  const { fullname, email, phone, password, role, company } = req.body;
  if (!fullname || !email || !phone || !password || !role || !company) {
    return res.status(400).json({ error: "All fields are required" });
  }
  try {
    const roleResult = await pool.query("SELECT id FROM roles WHERE rolename = $1", [role]);
    const roleid = roleResult.rows[0]?.id;
    if (!roleid) return res.status(400).json({ error: "Invalid role" });

    const insertUser = await pool.query(
      `INSERT INTO users (name, email, phone, password, company, roleid)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [fullname, email, phone, password, company, roleid]
    );

    res.status(201).json({ message: "User added", user: insertUser.rows[0] });
  } catch (err) {
    console.error("Add User Error:", err);
    res.status(500).json({ error: "Failed to add user" });
  }
});

// ✅ Route: Check if email exists
router.get("/check-email", async (req, res) => {
  const { email } = req.query;
  try {
    const result = await pool.query("SELECT id FROM users WHERE email = $1", [email]);
    return res.json({ exists: result.rows.length > 0 });
  } catch (err) {
    console.error("Check Email Error:", err);
    return res.status(500).json({ error: "Error checking email" });
  }
});

module.exports = router;