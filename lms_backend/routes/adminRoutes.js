const express = require("express");
const router = express.Router();

const authenticate = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

const {
    createUser
} = require("../controllers/adminController");


// Create User (Admin Only)
router.post(
    "/create-user",
    authenticate,
    authorize("admin"),
    createUser
);


module.exports = router;