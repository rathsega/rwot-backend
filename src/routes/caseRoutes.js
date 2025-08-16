const express = require("express");
const router = express.Router();
const caseController = require("../controllers/caseController");
const { verifyToken } = require("../middleware/authMiddleware");


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

// Fetch case by role
router.post("/by-role", verifyToken, caseController.getCasesByRole);

router.put("/edit/:caseid", verifyToken, caseController.editCase); // ✅ NEW edit endpoint

module.exports = router;