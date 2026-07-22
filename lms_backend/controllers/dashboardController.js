const db = require("../config/db");

// GET /api/dashboard/stats
// Admin-only. Aggregated metrics for the LMS admin landing page.
// The response shape is the long-term contract for the dashboard.
// Sections that don't exist yet (content, media, learning) return 0
// placeholders — when those modules land, only the placeholder values
// get replaced; the frontend never breaks.
const getStats = async (req, res) => {
    try {
        // Query 1 — All user counts in a single aggregate scan.
        // COUNT(*) FILTER (...) keeps the scan to a single pass.
        const userStatsResult = await db.query(`
            SELECT
                COUNT(*)::int AS total_users,
                COUNT(*) FILTER (WHERE is_active = TRUE)::int AS active_users,
                COUNT(*) FILTER (WHERE is_active = FALSE)::int AS inactive_users,
                COUNT(*) FILTER (WHERE role = 'admin')::int AS admins,
                COUNT(*) FILTER (WHERE role = 'editor')::int AS editors,
                COUNT(*) FILTER (WHERE role = 'user')::int AS learners
            FROM users
        `);

        // Query 2 — Most recent 5 users (explicit columns only — no SELECT *).
        const recentResult = await db.query(`
            SELECT id, full_name, email, role, is_active, created_at
            FROM users
            ORDER BY created_at DESC
            LIMIT 5
        `);

        const u = userStatsResult.rows[0];

        res.status(200).json({
            success: true,
            snapshotTime: new Date().toISOString(),
            overview: {
                totalUsers: u.total_users,
                activeUsers: u.active_users,
                inactiveUsers: u.inactive_users,
                admins: u.admins,
                editors: u.editors,
                learners: u.learners
            },
            recentUsers: recentResult.rows,
            content: {
                verticals: 0,
                modules: 0,
                sections: 0,
                publishedContent: 0,
                draftContent: 0
            },
            media: {
                images: 0,
                videos: 0
            },
            learning: {
                quizzes: 0,
                completedAttempts: 0,
                certificatesIssued: 0
            }
        });
    } catch (error) {
        console.error("Dashboard Stats Error:", error);
        res.status(500).json({
            success: false,
            message: "Server Error"
        });
    }
};

module.exports = { getStats };