const express = require("express");
const router = express.Router();
const bankController = require("../controllers/bankController");
const { verifyToken } = require("../middleware/authMiddleware");

router.post("/", verifyToken, bankController.addBank);
router.get("/", verifyToken, bankController.getAllBanks);

module.exports = router;