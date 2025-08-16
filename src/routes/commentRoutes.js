const express = require("express");
const router = express.Router();
const commentController = require("../controllers/commentController");
const { verifyToken } = require("../middleware/authMiddleware");

router.get("/:caseid", verifyToken, commentController.getCommentsByCaseId);
router.post("/", verifyToken, commentController.addComment);

module.exports = router;