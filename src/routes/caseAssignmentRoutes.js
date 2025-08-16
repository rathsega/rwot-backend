const express = require("express");
const router = express.Router();
const controller = require("../controllers/caseAssignmentController");
const { verifyToken } = require("../middleware/authMiddleware");
const { requireRole } = require("../middleware/roleMiddleware");

router.post("/", verifyToken, requireRole(["KAM", "Operations"]), controller.assignCase);
router.get("/", verifyToken, controller.getAssignments);

module.exports = router;