const pool = require("../db");

exports.requireRole = (allowedRoles) => async (req, res, next) => {
  try {
    const userId = req.user.id;

    const result = await pool.query(
      `SELECT roles.rolename FROM users
       JOIN roles ON users.roleid = roles.id
       WHERE users.id = $1`,
      [userId]
    );

    const role = result.rows[0]?.rolename;
    if (!role || !allowedRoles.includes(role)) {
      return res.status(403).json({ error: "Access denied" });
    }

    req.user.role = role; // add role to request object
    next();
  } catch (err) {
    console.error("Role check error:", err);
    res.status(500).json({ error: "Server error" });
  }
};