const pool = require("../db");

// GET /api/users or /api/users?role=KAM or /api/users/role/KAM
exports.getUsersByRole = async (req, res) => {
  try {
    const role = req.params.rolename || req.query.role;

    let query = `
      SELECT u.id, u.name, u.email, u.phone, u.company, r.rolename
    `;

    // If role is KAM, add case assignment count for today
    if (role === "KAM") {
      query += `, 
        COALESCE(ca_count.assignment_count, 0) as today_assignments
      FROM users u
      JOIN roles r ON u.roleid = r.id
      LEFT JOIN (
        SELECT assigned_to, COUNT(*) as assignment_count
        FROM case_assignments 
        WHERE role = 'KAM' 
        AND DATE(assigned_date) = CURRENT_DATE
        GROUP BY assigned_to
      ) ca_count ON ca_count.assigned_to = u.id
      `;
    } else {
      query += `
      FROM users u
      JOIN roles r ON u.roleid = r.id
      `;
    }

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