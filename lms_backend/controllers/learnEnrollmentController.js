// controllers/learnEnrollmentController.js
// ============================================================================
// Phase 6 — Learner enrollment + vertical-progress rollup.
//
// Endpoints (mounted at /api/learn, see routes/learnRoutes.js):
//   GET    /verticals/:id/enroll            my enrollment in this vertical
//   POST   /verticals/:id/enroll            enroll (idempotent upsert, 201 new / 200 existing)
//   DELETE /verticals/:id/enroll            drop (200 if was enrolled, 404 if not)
//   GET    /enrollments                     list my enrollments (paginated, ?status)
//   GET    /verticals/:id/progress          my vertical progress (counts + % + enrollment status)
//
// Locked decisions:
//   #30 — Enrollment scope is vertical-level for v1. One row per (user, vertical)
//         UNIQUE. Module / section scopes are future work.
//   #31 — Vertical completion is derived from content_progress, not stored.
//         No separate vertical_progress or section_progress tables.
//   #32 — Enrollment status: active / completed / dropped. Progress status:
//         started / completed. CHECK constraints at the DB level.
//   #33 — Enrollments and progress are user-scoped. Only req.user.id can read
//         or write. The userId is NEVER accepted from the request body or
//         query string — it's always derived from the JWT.
//   #34 — Enroll / start / complete are idempotent upserts. POST returns 201
//         on first write, 200 on subsequent writes. DELETE is also idempotent
//         in the sense that re-enrolling after drop is a new 201 row.
//   #35 — A vertical must be published before it can be enrolled in. Direct
//         enrollment URLs on draft / archived / deleted verticals return 404.
//         Same visibility rule as Phase 5.
//   #36 — The vertical progress rollup includes: totalBlocks, completedBlocks,
//         percent (integer 0-100), totalSections, completedSections,
//         enrollmentStatus. Sections are counted as completed when ALL their
//         blocks are completed.
// ============================================================================

const db = require("../config/db");

const {
    validatePage,
    validateLimit
} = require("../utils/validation");

// ----------------------------------------------------------------------------
// helpers
// ----------------------------------------------------------------------------

function parseId(value, fieldName) {
    const parsed = Number(value);
    if (!Number.isInteger(parsed) || parsed <= 0) {
        return { ok: false, message: `Invalid ${fieldName}` };
    }
    return { ok: true, value: parsed };
}

function buildPagination({ page, limit, totalRecords }) {
    const totalPages = Math.max(1, Math.ceil(totalRecords / limit));
    return {
        page,
        limit,
        totalRecords,
        totalPages,
        hasNextPage: page < totalPages,
        hasPrevPage: page > 1,
        nextPage: page < totalPages ? page + 1 : null,
        prevPage: page > 1 ? page - 1 : null
    };
}

// ----------------------------------------------------------------------------
// GET /api/learn/enrollments — list my enrollments
// ----------------------------------------------------------------------------
const listMyEnrollments = async (req, res) => {
    try {
        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({ success: false, message: pageResult.message });
        }
        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({ success: false, message: limitResult.message });
        }
        const statusFilter = req.query.status;
        if (statusFilter !== undefined && statusFilter !== "" &&
            !["active", "completed", "dropped"].includes(statusFilter)) {
            return res.status(400).json({
                success: false,
                message: "status must be one of: active, completed, dropped"
            });
        }

        const page = pageResult.value;
        const limit = limitResult.value;
        const userId = req.user.id;

        const conditions = [
            "e.user_id = $1",
            "v.deleted_at IS NULL",
            "v.status = 'published'"
        ];
        const values = [userId];
        let idx = 2;

        if (statusFilter) {
            conditions.push(`e.status = $${idx}`);
            values.push(statusFilter);
            idx++;
        }

        const whereClause = " WHERE " + conditions.join(" AND ");

        const countResult = await db.query(
            `SELECT COUNT(*) AS total
             FROM enrollments e
             JOIN verticals v ON e.vertical_id = v.id
             ${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT
                e.id, e.user_id, e.vertical_id, e.status,
                e.created_at, e.updated_at, e.completed_at, e.last_accessed_at,
                v.name AS vertical_name, v.slug AS vertical_slug
            FROM enrollments e
            JOIN verticals v ON e.vertical_id = v.id
            ${whereClause}
            ORDER BY e.updated_at DESC, e.id DESC
            LIMIT $${idx} OFFSET $${idx + 1}
        `;
        values.push(limit, offset);
        const result = await db.query(listQuery, values);

        return res.status(200).json({
            success: true,
            pagination: buildPagination({ page, limit, totalRecords }),
            data: result.rows
        });
    } catch (err) {
        console.error("listMyEnrollments error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// ----------------------------------------------------------------------------
// GET /api/learn/verticals/:id/enroll — my enrollment in this vertical
// ----------------------------------------------------------------------------
const getMyEnrollment = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const userId = req.user.id;
        const verticalId = idResult.value;

        // Verify vertical is visible (published, not deleted).
        const vCheck = await db.query(
            `SELECT id FROM verticals
             WHERE id = $1 AND deleted_at IS NULL AND status = 'published'`,
            [verticalId]
        );
        if (vCheck.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }

        const result = await db.query(
            `SELECT id, user_id, vertical_id, status,
                    created_at, updated_at, completed_at, last_accessed_at
             FROM enrollments
             WHERE user_id = $1 AND vertical_id = $2`,
            [userId, verticalId]
        );

        if (result.rows.length === 0) {
            return res.status(200).json({
                success: true,
                data: null
            });
        }

        return res.status(200).json({
            success: true,
            data: result.rows[0]
        });
    } catch (err) {
        console.error("getMyEnrollment error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// ----------------------------------------------------------------------------
// POST /api/learn/verticals/:id/enroll — enroll (idempotent upsert)
// ----------------------------------------------------------------------------
const enrollInVertical = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const userId = req.user.id;
        const verticalId = idResult.value;

        // Verify vertical is visible.
        const vCheck = await db.query(
            `SELECT id FROM verticals
             WHERE id = $1 AND deleted_at IS NULL AND status = 'published'`,
            [verticalId]
        );
        if (vCheck.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }

        // Upsert: insert with status='active', or update existing to 'active' if
        // it was 'completed' or 'dropped'. Refresh updated_at.
        const result = await db.query(
            `INSERT INTO enrollments (user_id, vertical_id, status, updated_at)
             VALUES ($1, $2, 'active', CURRENT_TIMESTAMP)
             ON CONFLICT (user_id, vertical_id)
             DO UPDATE SET
                 status = 'active',
                 updated_at = CURRENT_TIMESTAMP,
                 completed_at = NULL
             RETURNING id, user_id, vertical_id, status,
                       created_at, updated_at, completed_at, last_accessed_at,
                       (xmax = 0) AS was_created`,
            [userId, verticalId]
        );

        const row = result.rows[0];
        const status = row.was_created ? 201 : 200;

        // Strip the was_created helper.
        delete row.was_created;

        return res.status(status).json({
            success: true,
            data: row
        });
    } catch (err) {
        console.error("enrollInVertical error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// ----------------------------------------------------------------------------
// DELETE /api/learn/verticals/:id/enroll — drop (mark as dropped)
// ----------------------------------------------------------------------------
const dropEnrollment = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const userId = req.user.id;
        const verticalId = idResult.value;

        const result = await db.query(
            `UPDATE enrollments
             SET status = 'dropped', updated_at = CURRENT_TIMESTAMP
             WHERE user_id = $1 AND vertical_id = $2
               AND status != 'dropped'
             RETURNING id, user_id, vertical_id, status,
                       created_at, updated_at, completed_at, last_accessed_at`,
            [userId, verticalId]
        );

        if (result.rows.length === 0) {
            // Either no row, or already dropped. Distinguish for a clearer signal.
            const existing = await db.query(
                `SELECT id, user_id, vertical_id, status,
                        created_at, updated_at, completed_at, last_accessed_at
                 FROM enrollments
                 WHERE user_id = $1 AND vertical_id = $2`,
                [userId, verticalId]
            );
            if (existing.rows.length === 0) {
                return res.status(404).json({ success: false, message: "Not enrolled in this vertical" });
            }
            // Already dropped — return 200 with current state (idempotent).
            return res.status(200).json({
                success: true,
                data: existing.rows[0],
                alreadyDropped: true
            });
        }

        return res.status(200).json({
            success: true,
            data: result.rows[0]
        });
    } catch (err) {
        console.error("dropEnrollment error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// ----------------------------------------------------------------------------
// GET /api/learn/verticals/:id/progress — my vertical progress rollup
// ----------------------------------------------------------------------------
const getMyVerticalProgress = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const userId = req.user.id;
        const verticalId = idResult.value;

        // Verify vertical is visible.
        const vCheck = await db.query(
            `SELECT id FROM verticals
             WHERE id = $1 AND deleted_at IS NULL AND status = 'published'`,
            [verticalId]
        );
        if (vCheck.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }

        // Roll up:
        //   * totalBlocks = blocks across all published sections of all published modules
        //     of this vertical.
        //   * completedBlocks = my completed progress rows across the same.
        //   * totalSections = published sections across all published modules.
        //   * completedSections = sections where ALL blocks are completed by me.
        const query = `
            WITH visible AS (
                SELECT s.id AS section_id, b.id AS block_id
                FROM content_blocks b
                JOIN sections s ON b.section_id = s.id
                JOIN modules m ON s.module_id = m.id
                WHERE m.vertical_id = $1
                  AND b.deleted_at IS NULL
                  AND s.deleted_at IS NULL
                  AND s.status = 'published'
                  AND m.deleted_at IS NULL
                  AND m.status = 'published'
            ),
            block_counts AS (
                SELECT
                    COUNT(*)::int AS total_blocks,
                    COUNT(DISTINCT section_id)::int AS total_sections
                FROM visible
            ),
            my_completed AS (
                SELECT v.section_id, v.block_id
                FROM visible v
                JOIN content_progress p ON p.block_id = v.block_id
                WHERE p.user_id = $2 AND p.status = 'completed'
            ),
            completed_block_counts AS (
                SELECT COUNT(*)::int AS completed_blocks FROM my_completed
            ),
            completed_section_counts AS (
                SELECT COUNT(*)::int AS completed_sections
                FROM (
                    SELECT v.section_id,
                           COUNT(*) AS total,
                           COUNT(*) FILTER (WHERE mc.block_id IS NOT NULL) AS done
                    FROM visible v
                    LEFT JOIN my_completed mc ON mc.block_id = v.block_id
                    GROUP BY v.section_id
                    HAVING COUNT(*) = COUNT(*) FILTER (WHERE mc.block_id IS NOT NULL)
                       AND COUNT(*) > 0
                ) sections_done
            )
            SELECT
                bc.total_blocks,
                cbc.completed_blocks,
                CASE WHEN bc.total_blocks = 0 THEN 0
                     ELSE ROUND(100.0 * cbc.completed_blocks / bc.total_blocks)::int
                END AS percent_complete,
                bc.total_sections,
                csc.completed_sections,
                (SELECT status FROM enrollments
                 WHERE user_id = $2 AND vertical_id = $1) AS enrollment_status
            FROM block_counts bc, completed_block_counts cbc, completed_section_counts csc
        `;

        const result = await db.query(query, [verticalId, userId]);
        const row = result.rows[0];

        return res.status(200).json({
            success: true,
            data: {
                verticalId,
                enrollmentStatus: row.enrollment_status || null,
                totalBlocks: row.total_blocks,
                completedBlocks: row.completed_blocks,
                percentComplete: row.percent_complete,
                totalSections: row.total_sections,
                completedSections: row.completed_sections
            }
        });
    } catch (err) {
        console.error("getMyVerticalProgress error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    listMyEnrollments,
    getMyEnrollment,
    enrollInVertical,
    dropEnrollment,
    getMyVerticalProgress
};