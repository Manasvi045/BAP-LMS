require("dotenv").config();
//imported routes
const authRoutes = require("./routes/authRoutes");
const adminRoutes = require("./routes/adminRoutes");
const userRoutes = require("./routes/userRoutes");
const dashboardRoutes = require("./routes/dashboardRoutes");
const verticalRoutes = require("./routes/verticalRoutes");
const moduleRoutes = require("./routes/moduleRoutes");
const sectionRoutes = require("./routes/sectionRoutes");
const contentBlockRoutes = require("./routes/contentBlockRoutes");
const mediaRoutes = require("./routes/mediaRoutes");
const learnRoutes = require("./routes/learnRoutes");

const express = require("express");
const cors = require("cors");

const app = express();

const pool = require("./config/db");

app.use(cors());
app.use(express.json());
//Registered routes
app.use("/api/auth", authRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/users", userRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/verticals", verticalRoutes);
app.use("/api/modules", moduleRoutes);
app.use("/api/sections", sectionRoutes);
app.use("/api/content-blocks", contentBlockRoutes);
app.use("/api/media", mediaRoutes);
app.use("/api/learn", learnRoutes);

// Home Route
app.get("/", (req, res) => {
    res.send("🚀 BAP LMS Backend Running");
});

// Database Test Route
app.get("/db-test", async (req, res) => {
    try {
        const result = await pool.query("SELECT NOW()");
        res.json({
            success: true,
            serverTime: result.rows[0].now,
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({
            success: false,
            message: "Database connection failed",
        });
    }
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});