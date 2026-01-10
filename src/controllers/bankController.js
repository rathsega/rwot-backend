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

// Get all unique Products across banks
exports.getAllProducts = async (req, res) => {
  try {
    const result = await pool.query("SELECT products FROM banks");
    const productSet = new Set();
    result.rows.forEach(row => {
      if (row.products) {
        let products;
        try {
          products = typeof row.products === "string" ? JSON.parse(row.products) : row.products;
        } catch {
          products = [];
        }
        if (Array.isArray(products)) {
          products.forEach(product => productSet.add(product));
        }
      }
    });
    res.status(200).json({ products: Array.from(productSet) });
  } catch (err) {
    console.error("Get Products Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

//Fetch all banks offering a specific product
exports.getBanksByProduct = async (req, res) => {
  const { product } = req.params;

  try {
    const result = await pool.query(
      "SELECT * FROM banks WHERE products::jsonb @> $1::jsonb",
      [JSON.stringify([product])]
    );
    res.status(200).json({ banks: result.rows });
  } catch (err) {
    console.error("Get Banks by Product Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
}

// Update bank details including products
exports.updateBank = async (req, res) => {
  const { id } = req.params;
  const { name, email, phone, products } = req.body;

  try {
    const result = await pool.query(
      "UPDATE banks SET name = $1, email = $2, phone = $3, products = $4 WHERE id = $5 RETURNING *",
      [name, email, phone, JSON.stringify(products), id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Bank not found" });
    }

    res.status(200).json({ message: "Bank updated", bank: result.rows[0] });
  } catch (err) {
    console.error("Update Bank Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
}
// Delete a bank by ID
exports.deleteBank = async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool.query("DELETE FROM banks WHERE id = $1 RETURNING *", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Bank not found" });
    }

    res.status(200).json({ message: "Bank deleted", bank: result.rows[0] });
  } catch (err) {
    console.error("Delete Bank Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};