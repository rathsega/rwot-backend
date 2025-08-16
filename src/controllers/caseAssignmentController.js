const pool = require("../db");

exports.assignCase = async (req, res) => {
  const { caseid, assigned_to, role } = req.body;
  const assigned_by = req.user.id;

  try {
    await pool.query(
      `INSERT INTO case_assignments (caseid, assigned_to, role, assigned_by)
       VALUES ($1, $2, $3, $4)`,
      [caseid, assigned_to, role, assigned_by]
    );

    res.status(201).json({ message: `Case ${caseid} assigned to ${role}` });
  } catch (err) {
    console.error("Assignment error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getAssignments = async (req, res) => {
  const userId = req.user.id;

  try {
    const result = await pool.query(
      `SELECT * FROM case_assignments WHERE assigned_to = $1`,
      [userId]
    );

    res.status(200).json({ assignments: result.rows });
  } catch (err) {
    console.error("Get Assignments Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};