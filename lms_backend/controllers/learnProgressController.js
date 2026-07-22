// controllers/learnProgressController.js
// ============================================================================
// Phase 6 — Learner progress tracking + section rollup.
//
// Endpoints (mounted at /api/learn, see routes/learnRoutes.js):
//   GET  /blocks/:id/progress              my progress for this block
//   POST /blocks/:id/start                 mark block started (idempotent upsert)
//   POST /blocks/:id/complete              mark block completed (idempotent upsert)
//   GET  /sections/:id/progress            section rollup for me (counts + %)
//
// Locked decisions: see learnEnrollmentController.js header for #30-#36.
// Inherits the same cross-parent visibility rule: the block must belong to a
// fully-published chain (section + module + vertical all published) before
// any progress operation is allowed.
//
// User-scoping:
//   * req.user.id is ALWAYS the subject. There is no userId query param or
//     body field accepted — learners cannot read or write another user's
//     progress.
//   * The same row cannot exist twice for (user, block) — UNIQUE index —
//     so progress writes are upserts.
// ============================================================================

const db = require("../config/db");

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

// ----------------------------------------------------------------------------
// GET /api/learn/blocks/:id/progress
// ----------------------------------------------------------------------------
const getMyBlockProgress = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const userId = req.user.id;
        const blockId = idResult.value;

        // JOIN with sections + modules + verticals to enforce cross-parent visibility.
        // The query returns the block metadata only — no progress — if visibility passes.
        // Progress is then fetched separately by (user_id, block_id).
        const blockResult = await db.query(
            `SELECT b.id, b.section_id, b.type, b.content, b.display_order
             FROM content_blocks b
             JOIN sections s ON b.section_id = s.id
             JOIN modules m ON s.module_id = m.id
             JOIN verticals v ON m.vertical_id = v.id
             WHERE b.id = $1
               AND b.deleted_at IS NULL
               AND s.deleted_at IS NULL
               AND s.status = 'published'
               AND m.deleted_at IS NULL
               AND m.status = 'published'
               AND v.deleted_at IS NULL
               AND v.status = 'published'`,
            [blockId]
        );

        if (blockResult.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Content block not found" });
        }

        const progressResult = await db.query(
            `SELECT status, created_at, updated_at, completed_at
             FROM content_progress
             WHERE user_id = $1 AND block_id = $2`,
            [userId, blockId]
        );

        if (progressResult.rows.length === 0) {
            return res.status(200).json({
                success: true,
                data: {
                    blockId,
                    status: null,
                    startedAt: null,
                    completedAt: null
                }
            });
        }

        const row = progressResult.rows[0];
        return res.status(200).json({
            success: true,
            data: {
                blockId,
                status: row.status,
                startedAt: row.created_at,
                completedAt: row.completed_at
            }
        });
    } catch (err) {
        console.error("getMyBlockProgress error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// ----------------------------------------------------------------------------
// POST /api/learn/blocks/:id/start
// ----------------------------------------------------------------------------
// Idempotent upsert: creates a row with status='started' if absent; no-op if
// the row already exists in either status. Returns 201 on first creation,
// 200 on subsequent calls.
const markBlockStarted = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const userId = req.user.id;
        const blockId = idResult.value;

        // Visibility check.
        const vCheck = await db.query(
            `SELECT b.id
             FROM content_blocks b
             JOIN sections s ON b.section_id = s.id
             JOIN modules m ON s.module_id = m.id
             JOIN verticals v ON m.vertical_id = v.id
             WHERE b.id = $1
               AND b.deleted_at IS NULL
               AND s.deleted_at IS NULL
               AND s.status = 'published'
               AND m.deleted_at IS NULL
               AND m.status = 'published'
               AND v.deleted_at IS NULL
               AND v.status = 'published'`,
            [blockId]
        );
        if (vCheck.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Content block not found" });
        }

        // Upsert: insert with status='started' if absent; preserve any existing
        // status (don't downgrade from 'completed' to 'started'). The ON CONFLICT
        // DO NOTHING clause returns 0 rows when the row exists — that's how we
        // distinguish "created" vs "existing".
        const insertResult = await db.query(
            `INSERT INTO content_progress (user_id, block_id, status, updated_at)
             VALUES ($1, $2, 'started', CURRENT_TIMESTAMP)
             ON CONFLICT (user_id, block_id) DO NOTHING
             RETURNING id`,
            [userId, blockId]
        );
        const wasCreated = insertResult.rows.length > 0;

        // Re-fetch the canonical row to return its current state.
        const result = await db.query(
            `SELECT status, created_at, updated_at, completed_at
             FROM content_progress
             WHERE user_id = $1 AND block_id = $2`,
            [userId, blockId]
        );
        const row = result.rows[0];
        const status = wasCreated ? 201 : 200;

        return res.status(status).json({
            success: true,
            data: {
                blockId,
                status: row.status,
                startedAt: row.created_at,
                completedAt: row.completed_at
            }
        });
    } catch (err) {
        console.error("markBlockStarted error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// ----------------------------------------------------------------------------
// POST /api/learn/blocks/:id/complete
// ----------------------------------------------------------------------------
// Idempotent upsert: creates a row with status='completed' if absent; promotes
// from 'started' to 'completed' if already started; no-op if already completed.
const markBlockCompleted = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const userId = req.user.id;
        const blockId = idResult.value;

        // Visibility check.
        const vCheck = await db.query(
            `SELECT b.id
             FROM content_blocks b
             JOIN sections s ON b.section_id = s.id
             JOIN modules m ON s.module_id = m.id
             JOIN verticals v ON m.vertical_id = v.id
             WHERE b.id = $1
               AND b.deleted_at IS NULL
               AND s.deleted_at IS NULL
               AND s.status = 'published'
               AND m.deleted_at IS NULL
               AND m.status = 'published'
               AND v.deleted_at IS NULL
               AND v.status = 'published'`,
            [blockId]
        );
        if (vCheck.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Content block not found" });
        }

        // Idempotent upsert to completed. The first insert that creates a row
        // returns it; if the row already exists, we update to completed (and
        // set completed_at) without changing startedAt.
        const insertResult = await db.query(
            `INSERT INTO content_progress (user_id, block_id, status, completed_at, updated_at)
             VALUES ($1, $2, 'completed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
             ON CONFLICT (user_id, block_id) DO UPDATE
             SET status = 'completed',
                 completed_at = COALESCE(content_progress.completed_at, CURRENT_TIMESTAMP),
                 updated_at = CURRENT_TIMESTAMP
             RETURNING status, created_at, updated_at, completed_at, (xmax = 0) AS was_created`,
            [userId, blockId]
        );

        const row = insertResult.rows[0];
        const wasCreated = row.was_created;
        delete row.was_created;

        // Promote the parent section's last_accessed_at for the user via the
        // enrollment's last_accessed_at. Optional telemetry — but useful for
        // "continue where you left off" UIs. Update the most recent enrollment
        // touched by completing a block in this vertical.
        await db.query(
            `UPDATE enrollments
             SET last_accessed_at = CURRENT_TIMESTAMP,
                 updated_at = CURRENT_TIMESTAMP
             WHERE user_id = $1
               AND vertical_id = (
                   SELECT m.vertical_id
                   FROM content_blocks b
                   JOIN sections s ON b.section_id = s.id
                   JOIN modules m ON s.module_id = m.id
                   WHERE b.id = $2
               )
               AND status = 'active'`,
            [userId, blockId]
        );

        // Auto-complete the enrollment if all sections are now done.
        await maybeMarkEnrollmentCompleted(userId, blockId);

        return res.status(wasCreated ? 201 : 200).json({
            success: true,
            data: {
                blockId,
                status: row.status,
                startedAt: row.created_at,
                completedAt: row.completed_at
            }
        });
    } catch (err) {
        console.error("markBlockCompleted error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// Auto-promote enrollment to 'completed' when every section in the vertical
// has all its blocks completed by the user. Runs after markBlockCompleted.
// Silently does nothing if no enrollment or already completed.
async function maybeMarkEnrollmentCompleted(userId, blockId) {
    try {
        await db.query(
            `UPDATE enrollments
             SET status = 'completed',
                 completed_at = CURRENT_TIMESTAMP,
                 updated_at = CURRENT_TIMESTAMP
             WHERE user_id = $1
               AND status = 'active'
               AND vertical_id = (
                   SELECT m.vertical_id
                   FROM content_blocks b
                   JOIN sections s ON b.section_id = s.id
                   JOIN modules m ON s.module_id = m.id
                   WHERE b.id = $2
               )
               AND NOT EXISTS (
                   SELECT 1
                   FROM content_blocks b
                   JOIN sections s ON b.section_id = s.id
                   JOIN modules m ON s.module_id = m.id
                   WHERE m.vertical_id = (
                       SELECT m2.vertical_id
                       FROM content_blocks b2
                       JOIN sections s2 ON b2.section_id = s2.id
                       JOIN modules m2 ON s2.module_id = m2.id
                       WHERE b2.id = $2
                   )
                     AND b.deleted_at IS NULL
                     AND s.deleted_at IS NULL
                     AND s.status = 'published'
                     AND m.deleted_at IS NULL
                     AND m.status = 'published'
                     AND NOT EXISTS (
                         SELECT 1 FROM content_progress p
                         WHERE p.user_id = $1
                           AND p.block_id = b.id
                           AND p.status = 'completed'
                     )
               )`,
            [userId, blockId]
        );
    } catch (err) {
        // Auto-complete is best-effort. Log but don't fail the request.
        console.error("maybeMarkEnrollmentCompleted error:", err);
    }
}

// ----------------------------------------------------------------------------
// GET /api/learn/sections/:id/progress
// ----------------------------------------------------------------------------
const getMySectionProgress = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const userId = req.user.id;
        const sectionId = idResult.value;

        // Visibility check + rollup in one query.
        const query = `
            WITH section_info AS (
                SELECT s.id AS section_id
                FROM sections s
                JOIN modules m ON s.module_id = m.id
                JOIN verticals v ON m.vertical_id = v.id
                WHERE s.id = $1
                  AND s.deleted_at IS NULL
                  AND s.status = 'published'
                  AND m.deleted_at IS NULL
                  AND m.status = 'published'
                  AND v.deleted_at IS NULL
                  AND v.status = 'published'
            ),
            blocks AS (
                SELECT b.id
                FROM content_blocks b, section_info si
                WHERE b.section_id = si.section_id
                  AND b.deleted_at IS NULL
            ),
            totals AS (
                SELECT COUNT(*)::int AS total_blocks FROM blocks
            ),
            completed AS (
                SELECT COUNT(*)::int AS completed_blocks
                FROM content_progress p
                JOIN blocks b ON p.block_id = b.id
                WHERE p.user_id = $2 AND p.status = 'completed'
            )
            SELECT
                (SELECT section_id FROM section_info) AS section_id,
                t.total_blocks,
                c.completed_blocks,
                CASE WHEN t.total_blocks = 0 THEN 0
                     ELSE ROUND(100.0 * c.completed_blocks / t.total_blocks)::int
                END AS percent_complete
            FROM totals t, completed c
        `;

        const result = await db.query(query, [sectionId, userId]);
        const row = result.rows[0];

        if (!row || row.section_id === null) {
            return res.status(404).json({ success: false, message: "Section not found" });
        }

        return res.status(200).json({
            success: true,
            data: {
                sectionId,
                totalBlocks: row.total_blocks,
                completedBlocks: row.completed_blocks,
                percentComplete: row.percent_complete
            }
        });
    } catch (err) {
        console.error("getMySectionProgress error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    getMyBlockProgress,
    markBlockStarted,
    markBlockCompleted,
    getMySectionProgress
};