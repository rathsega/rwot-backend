const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET /api/roles - Fetch all roles
router.get('/', async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM roles ORDER BY id ASC");
    res.json({ roles: result.rows });
  } catch (err) {
    console.error("Roles API Error:", err);
    res.status(500).json({ error: "Failed to fetch roles" });
  }
});

module.exports = router;