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
  const { caseid, comment, text } = req.body;
  const commentText = comment || text || "";
  const userRole = req.user?.rolename || "Unknown";
  const commentby = req.user?.name || req.user?.email || "Unknown";

  try {
    const result = await pool.query(
      `INSERT INTO comments (caseid, comment, role, commentby, created_at) VALUES ($1, $2, $3, $4, NOW()) RETURNING *`,
      [caseid, commentText, userRole, commentby]
    );
    res.status(201).json({ message: "Comment added", comment: result.rows[0] });
  } catch (err) {
    console.error("Add Comment Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};