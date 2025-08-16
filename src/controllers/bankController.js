const pool = require("../db");

// Add a bank with product list
exports.addBank = async (req, res) => {
  const { name, email, phone, products } = req.body;

  try {
    const result = await pool.query(
      "INSERT INTO banks (name, email, phone, products) VALUES ($1, $2, $3, $4) RETURNING *",
      [name, email, phone, JSON.stringify(products)]
    );
    res.status(201).json({ message: "Bank added", bank: result.rows[0] });
  } catch (err) {
    console.error("Add Bank Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Get all banks
exports.getAllBanks = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM banks");
    res.status(200).json({ banks: result.rows });
  } catch (err) {
    console.error("Get Banks Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};