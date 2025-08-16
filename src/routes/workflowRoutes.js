const express = require("express");
const router = express.Router();
const workflowController = require("../controllers/workflowController");
const { verifyToken } = require("../middleware/authMiddleware");

router.post("/update", verifyToken, workflowController.updateStage);
router.get("/history/:caseid", verifyToken, workflowController.getStageHistory);
router.get("/current/:caseid", verifyToken, workflowController.getCurrentStage);

module.exports = router;