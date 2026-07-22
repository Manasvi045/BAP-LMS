const express = require("express");

const router = express.Router();

const {
    getAllUsers,
    getUserById,
    updateUser,
    updateUserStatus,
    resetUserPassword
} = require("../controllers/userController");


const authenticateToken = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

router.get(
    "/",
    authenticateToken,
    authorize("admin"),
    getAllUsers
);

router.get(
    "/:id",
    authenticateToken,
    authorize("admin"),
    getUserById
);

router.put(
    "/:id",
    authenticateToken,
    authorize("admin"),
    updateUser
);

router.patch(
    "/:id/status",
    authenticateToken,
    authorize("admin"),
    updateUserStatus
);

router.patch(
    "/:id/password",
    authenticateToken,
    authorize("admin"),
    resetUserPassword
);

module.exports = router;