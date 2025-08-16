const express = require("express");
const router = express.Router();
const { getProfile, updateProfile, uploadAvatar } = require("../controllers/profileController");
const { verifyToken } = require("../middleware/authMiddleware");
const multer = require("multer");

const upload = multer({ storage: multer.memoryStorage() });

router.get("/", verifyToken, getProfile);
router.patch("/", verifyToken, updateProfile);
router.post("/avatar", verifyToken, upload.single("avatar"), uploadAvatar);

module.exports = router;