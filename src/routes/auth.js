const express = require("express");
const router = express.Router();
const authController = require("../controllers/authController");
const { verifyToken } = require("../middleware/authMiddleware");

router.post("/register", authController.register);
router.post("/login", authController.login);
router.get("/me", verifyToken, authController.me);

router.post("/logout", (req, res) => {
  res.clearCookie("token", {
    httpOnly: true,
    sameSite: "Lax", // adjust if using frontend on different domain
    secure: "production", // only secure in prod
  });
  res.status(200).json({ message: "Logged out successfully" });
});

module.exports = router;