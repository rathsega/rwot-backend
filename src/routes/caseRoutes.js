const express = require("express");
const router = express.Router();
const caseController = require("../controllers/caseController");
const { verifyToken } = require("../middleware/authMiddleware");


// GET case counts by status
router.get("/counts", verifyToken, caseController.getCaseCounts);

// GET all or role-filtered cases
router.get("/", verifyToken, caseController.getCases);

// POST a new case
router.post("/", verifyToken, caseController.createCase);

// ✅ PUT update case by caseid
router.put("/:caseid", verifyToken, caseController.updateCase);

// Get case by ID
router.get("/:caseid", verifyToken, caseController.getCaseById);

// PATCH: Update status only (Banker)
router.patch("/:caseid/status", verifyToken, caseController.updateCaseStatus);
router.patch("/:caseid/bankstatus", verifyToken, caseController.updateBankStatus);

// POST: Generate Client
router.post("/:caseid/generate-client", verifyToken, caseController.generateClient);

// Fetch case by role
router.post("/by-role", verifyToken, caseController.getCasesByRole);

router.put("/edit/:caseid", verifyToken, caseController.editCase); // ✅ NEW edit endpoint

// Document Configuration Endpoints
router.post("/:caseid/document-config", verifyToken, caseController.saveDocumentConfigs);
router.get("/:caseid/document-config", verifyToken, caseController.getDocumentConfigs);
router.delete("/:caseid/document-config/:bankid", verifyToken, caseController.deleteDocumentConfig);

// Provisional Document Endpoints
router.get("/:caseid/provisional-documents", verifyToken, caseController.getProvisionalDocumentsByCase);
router.get("/:caseid/all-provisional-documents", verifyToken, caseController.getAllProvisionalDocumentsByCase);
router.post("/:caseid/provisional-documents", verifyToken, caseController.addProvisionalDocument);
router.delete("/:caseid/provisional-documents/:id", verifyToken, caseController.deleteProvisionalDocument);

module.exports = router;