const path = require("path");
const fs = require("fs");
const pool = require("../db");

// Upload handler (one file per docname per case)
exports.uploadDocument = async (req, res) => {
  try {
    const { caseid, doctype, docname } = req.body;
    const file = req.file;

    if (!file || !caseid || !doctype || !docname) {
      return res.status(400).json({ error: "Missing required fields or file" });
    }

    // 1. Delete existing document for same caseid, doctype, docname
    const existing = await pool.query(
      `SELECT * FROM documents WHERE caseid = $1 AND doctype = $2 AND docname = $3`,
      [caseid, doctype, docname]
    );

    if (existing.rows.length > 0) {
      const existingFile = existing.rows[0].filename;
      const filePath = path.join(__dirname, "..", "uploads", existingFile);
      if (fs.existsSync(filePath)) fs.unlinkSync(filePath);

      await pool.query(
        `DELETE FROM documents WHERE id = $1`,
        [existing.rows[0].id]
      );
    }

    // 2. Insert new document
    await pool.query(
      `INSERT INTO documents (caseid, doctype, docname, filename, uploadedat)
       VALUES ($1, $2, $3, $4, NOW())`,
      [caseid, doctype, docname, file.filename]
    );

    // Clear case cache since documents have changed
    if (global.caseCache) {
      global.caseCache.clear();
    }

    return res.status(200).json({ message: "Document uploaded successfully" });
  } catch (error) {
    console.error("Upload Error:", error);
    return res.status(500).json({ error: "Upload failed" });
  }
};

// Fetch all documents for a case
exports.getDocumentsByCase = async (req, res) => {
  const { caseid } = req.params;

  try {
    const result = await pool.query(
      "SELECT * FROM documents WHERE caseid = $1 ORDER BY uploadedat DESC",
      [caseid]
    );
    res.json({ documents: result.rows });
  } catch (err) {
    console.error("Get Documents Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Download document
exports.downloadDocument = async (req, res) => {
  const { filename } = req.params;
  const filePath = path.join(__dirname, "../../uploads", filename);
  res.download(filePath);
};

exports.deleteDocument = async (req, res) => {
  const { id } = req.params;
  try {
    // Optional: fetch filename if you want to delete the physical file too
    const result = await pool.query("SELECT filename FROM documents WHERE id = $1", [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: "Document not found" });

    const { filename } = result.rows[0];

    // Delete document row
    await pool.query("DELETE FROM documents WHERE id = $1", [id]);

    // Optional: delete file from disk (if needed)
    const filePath = path.join(__dirname, "..", "uploads", filename);
    if (fs.existsSync(filePath)) fs.unlinkSync(filePath);

    // Clear case cache since documents have changed
    if (global.caseCache) {
      global.caseCache.clear();
    }

    res.json({ message: "Document deleted successfully" });
  } catch (err) {
    console.error("Delete Document Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.downloadDocumentNew = async (req, res) => {
  try {
    const { filename } = req.params;
    const filePath = path.join(__dirname, "..", "uploads", filename); // <-- corrected path
    console.log("Requested file path:", filePath);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ error: "File not found" });
    }

    res.download(filePath, err => {
      if (err) {
        console.error("Download Error:", err);
        return res.status(500).json({ error: "Download failed" });
      }
    });
  } catch (err) {
    console.error("Download Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
}