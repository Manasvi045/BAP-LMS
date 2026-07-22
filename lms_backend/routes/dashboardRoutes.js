const express = require("express");
const router = express.Router();

const authenticateToken = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

const { getStats } = require("../controllers/dashboardController");

router.get(
    "/stats",
    authenticateToken,
    authorize("admin"),
    getStats
);

module.exports = router;