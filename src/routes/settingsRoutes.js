const express = require("express");
const router = express.Router();
const settingsController = require("../controllers/settingsController");
const { verifyToken } = require("../middleware/authMiddleware");
const { requireRole } = require("../middleware/roleMiddleware");

// Get all settings (any authenticated user)
router.get("/", verifyToken, settingsController.getSettings);

// Get specific setting by key (any authenticated user)
router.get("/:key", verifyToken, settingsController.getSetting);

// Update/create setting (admin only)
router.post("/", verifyToken, requireRole(["Admin"]), settingsController.upsertSetting);

// Delete setting (admin only)
router.delete("/:key", verifyToken, requireRole(["Admin"]), settingsController.deleteSetting);

module.exports = router;
