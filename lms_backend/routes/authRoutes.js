const express = require("express");
const router = express.Router();
const authenticate = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");
const {
    registerUser,
    loginUser,
    changePassword
} = require("../controllers/authController");


router.post("/login", loginUser);
router.post("/register", registerUser);
router.post("/change-password", authenticate, changePassword);
router.get(
    "/profile",
    authenticate,
    (req, res) => {

        res.json({
            success: true,
            user: req.user
        });

    }
);
router.get(
    "/admin-test",
    authenticate,
    authorize("admin"),
    (req, res) => {
        res.json({
            success: true,
            message: "Welcome Admin!",
            user: req.user
        });
    }
);
module.exports = router;