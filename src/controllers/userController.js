const pool = require("../db");

// GET /api/users or /api/users?role=KAM or /api/users/role/KAM
exports.getUsersByRole = async (req, res) => {
  try {
    const role = req.params.rolename || req.query.role;

    let query = `
      SELECT u.id, u.name, u.email, u.phone, u.company, r.rolename
      FROM users u
      JOIN roles r ON u.roleid = r.id
    `;

    const values = [];

    if (role) {
      query += ` WHERE r.rolename = $1`;
      values.push(role);
    }

    const result = await pool.query(query, values);
    res.json({ users: result.rows });
  } catch (err) {
    console.error("Get Users By Role Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};