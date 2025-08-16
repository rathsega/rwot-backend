const pool = require("../db");

// Get all comments for a case
exports.getCommentsByCaseId = async (req, res) => {
  const { caseid } = req.params;

  try {
    const result = await pool.query(
      "SELECT * FROM comments WHERE caseid = $1 ORDER BY created_at DESC",
      [caseid]
    );
    res.json({ comments: result.rows });
  } catch (err) {
    console.error("Get Comments Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Add a comment
exports.addComment = async (req, res) => {
  const { caseid, comment } = req.body;
  const userRole = req.user?.role || "Unknown"; // fallback in case we don't expand user profile fully

  try {
    const result = await pool.query(
      `INSERT INTO comments (caseid, comment, role) VALUES ($1, $2, $3) RETURNING *`,
      [caseid, comment, userRole]
    );
    res.status(201).json({ message: "Comment added", comment: result.rows[0] });
  } catch (err) {
    console.error("Add Comment Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};