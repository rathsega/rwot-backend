const express = require("express");
const router = express.Router();
const bankController = require("../controllers/bankController");
const { verifyToken } = require("../middleware/authMiddleware");

router.post("/", verifyToken, bankController.addBank);
router.get("/", verifyToken, bankController.getAllBanks);
router.get("/products", verifyToken, bankController.getAllProducts);
router.get("/products/:product", verifyToken, bankController.getBanksByProduct);
router.put("/:id", verifyToken, bankController.updateBank);
router.delete("/:id", verifyToken, bankController.deleteBank);

module.exports = router;