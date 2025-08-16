const express = require("express");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const router = express.Router();
const documentController = require("../controllers/documentController");
const { verifyToken } = require("../middleware/authMiddleware");

// Ensure uploads directory exists
const uploadDir = path.join(__dirname, "..", "uploads");
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// Multer setup
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + "_" + file.originalname.replace(/\s+/g, "_");
    cb(null, uniqueName);
  },
});

const upload = multer({ storage });

// Upload document - expects 'file' field in FormData
router.post(
  "/upload",
  verifyToken,
  upload.single("file"), // Field name MUST match frontend
  documentController.uploadDocument
);

// Get documents by case ID
router.get("/:caseid", verifyToken, documentController.getDocumentsByCase);

// Download document by filename
router.get("/download/:filename", verifyToken, documentController.downloadDocument);

// Delete document by caseId
router.delete("/:id", documentController.deleteDocument);

module.exports = router;