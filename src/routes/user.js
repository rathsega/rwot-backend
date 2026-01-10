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
        `SELECT u.id, u.name, u.email, r.rolename, u.phone FROM users u
         JOIN roles r ON u.roleid = r.id
         WHERE r.rolename = $1`,
        [role]
      );
    } else {
      result = await pool.query(
        `SELECT u.id, u.name, u.email, r.rolename, u.phone FROM users u
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

router.put("/:id", verifyToken, async (req, res) => {
  const { id } = req.params;
  const { name, email, phone, role } = req.body;
  //get role id by role name
  
  try {
    const roleResult = await pool.query("SELECT id FROM roles WHERE rolename = $1", [role]);
    const roleid = roleResult.rows[0]?.id;
    if (!roleid) return res.status(400).json({ error: "Invalid role" });

    const updateUser = await pool.query(
      `UPDATE users SET name = $1, email = $2, phone = $3, roleid = $4
       WHERE id = $5 RETURNING *`,
      [name, email, phone, roleid, id]
    );
    if (updateUser.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User updated", user: updateUser.rows[0] });
  } catch (err) {
    console.error("Update User Error:", err);
    res.status(500).json({ error: "Failed to update user" });
  }
});

router.post("/register", async (req, res) => {
  const { email, password, phone, role } = req.body;
  const name = req.body.name || company;

  try {
    const roleResult = await pool.query("SELECT id FROM roles WHERE rolename = $1", [role || "Individual"]);
    const roleid = roleResult.rows[0]?.id;
    if (!roleid) return res.status(400).json({ error: "Invalid role" });

    const hashedPassword = password;

    //Validate if email already exists
    const emailCheck = await pool.query("SELECT id FROM users WHERE email = $1", [email]);
    if (emailCheck.rows.length > 0) {
      return res.status(400).json({ error: "Email already exists" });
    }

    //Validate if phone already exists
    const phoneCheck = await pool.query("SELECT id FROM users WHERE phone = $1", [phone]);
    if (phoneCheck.rows.length > 0) {
      return res.status(400).json({ error: "Phone number already exists" });
    }

    const userResult = await pool.query(
      "INSERT INTO users (name, email, password, phone, roleid) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [name, email, hashedPassword, phone, roleid]
    );

    const user = userResult.rows[0];

    res.status(201).json({ message: "User registered", user });
  } catch (err) {
    console.error("User Registration Error:", err);
    res.status(500).json({ error: "Failed to register user" });
  }
});

router.delete("/:id", verifyToken, async (req, res) => {
  const { id } = req.params;
  try {
    const deleteUser = await pool.query("DELETE FROM users WHERE id = $1 RETURNING *", [id]);
    if (deleteUser.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User deleted", user: deleteUser.rows[0] });
  } catch (err) {
    console.error("Delete User Error:", err);
    res.status(500).json({ error: "Failed to delete user" });
  }
});

router.get("/getKamAndTelecallers", verifyToken, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT u.id, u.name, u.email, r.rolename, u.phone FROM users u
       JOIN roles r ON u.roleid = r.id
       WHERE r.rolename IN ('KAM', 'Telecaller')`
    );
    res.json({ users: result.rows });
  } catch (err) {
    console.error("Fetch KAM and Telecallers Error:", err);
    res.status(500).json({ error: "Failed to fetch users" });
  }
});
   

module.exports = router;