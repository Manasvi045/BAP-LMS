// controllers/verticalController.js
// ============================================================================
// Vertical CRUD + publishing workflow (Phases 4.2 + 4.6).
//
// Endpoints:
//   GET    /api/verticals        list  (paginated, filtered, soft-delete-aware)
//   GET    /api/verticals/:id    get one
//   POST   /api/verticals        create (status always defaults to 'draft')
//   PUT    /api/verticals/:id    partial-update: only fields in body are touched
//                                 status transitions gated by the state machine
//                                 in utils/validators/status.js
//   DELETE /api/verticals/:id    soft delete
//
// Slug rules (db/schema/phase4_design.md §8):
//   * Auto-derived from name; client may override.
//   * Collision -> append "-2", "-3", ...; reserve 4 chars for the suffix.
//   * Empty slug -> fallback to `item-{shortId}`.
//
// Publishing (Phase 4.6):
//   * status is always 'draft' on create; body.status is ignored.
//   * On PUT, body.status drives the state machine in ./utils/validators/status.
//   * Transitions into 'published' populate published_at / published_by.
//   * published_at / published_by are preserved across unpublish / archive.
// ============================================================================

const db = require("../config/db");

const {
    validateName,
    validateDescription,
    validateMetadata,
    validateDisplayOrder,
    validateStatus,
    validateVerticalId
} = require("../utils/validators/vertical");

const { validateStatusTransition } = require("../utils/validators/status");

const {
    generateUniqueSlug
} = require("../utils/slug");

const {
    validatePage,
    validateLimit,
    validateSearch
} = require("../utils/validation");

// ----------------------------------------------------------------------------
// controllers
// ----------------------------------------------------------------------------

const listVerticals = async (req, res) => {
    try {
        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({ success: false, message: pageResult.message });
        }

        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({ success: false, message: limitResult.message });
        }

        const statusResult = validateStatus(req.query.status);
        if (!statusResult.ok) {
            return res.status(400).json({ success: false, message: statusResult.message });
        }

        const searchResult = validateSearch(req.query.search);
        if (!searchResult.ok) {
            return res.status(400).json({ success: false, message: searchResult.message });
        }

        // includeDeleted is admin-only (trash/recycle-bin affordance).
        const includeDeleted = req.query.includeDeleted === "true";
        if (includeDeleted && req.user.role !== "admin") {
            return res.status(403).json({
                success: false,
                message: "Only admin can include deleted records"
            });
        }

        const page = pageResult.value;
        const limit = limitResult.value;
        const status = statusResult.value;
        const search = searchResult.value;

        const conditions = [];
        const values = [];
        let idx = 1;

        if (!includeDeleted) {
            conditions.push("deleted_at IS NULL");
        }
        if (status) {
            conditions.push(`status = $${idx}`);
            values.push(status);
            idx++;
        }
        if (search) {
            conditions.push(`(name ILIKE $${idx} OR description ILIKE $${idx})`);
            values.push(`%${search}%`);
            idx++;
        }

        const whereClause = conditions.length > 0
            ? " WHERE " + conditions.join(" AND ")
            : "";

        const countResult = await db.query(
            `SELECT COUNT(*) AS total FROM verticals${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);
        const totalPages = Math.max(1, Math.ceil(totalRecords / limit));

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT id, name, slug, description, metadata, display_order, status,
                   published_at, published_by,
                   created_by, updated_by, created_at, updated_at, deleted_at
            FROM verticals
            ${whereClause}
            ORDER BY display_order ASC, id ASC
            LIMIT $${idx} OFFSET $${idx + 1}
        `;
        values.push(limit, offset);
        const result = await db.query(listQuery, values);

        return res.status(200).json({
            success: true,
            pagination: {
                page,
                limit,
                totalRecords,
                totalPages,
                hasNextPage: page < totalPages,
                hasPrevPage: page > 1,
                nextPage: page < totalPages ? page + 1 : null,
                prevPage: page > 1 ? page - 1 : null
            },
            data: result.rows
        });
    } catch (err) {
        console.error("listVerticals error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const getVerticalById = async (req, res) => {
    try {
        const idResult = validateVerticalId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }

        const result = await db.query(
            `SELECT id, name, slug, description, metadata, display_order, status,
                    published_at, published_by,
                    created_by, updated_by, created_at, updated_at, deleted_at
             FROM verticals
             WHERE id = $1 AND deleted_at IS NULL`,
            [idResult.value]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("getVerticalById error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const createVertical = async (req, res) => {
    try {
        const nameResult = validateName(req.body.name);
        if (!nameResult.ok) {
            return res.status(400).json({ success: false, message: nameResult.message });
        }

        const descResult = validateDescription(req.body.description);
        if (!descResult.ok) {
            return res.status(400).json({ success: false, message: descResult.message });
        }

        const metaResult = validateMetadata(req.body.metadata);
        if (!metaResult.ok) {
            return res.status(400).json({ success: false, message: metaResult.message });
        }

        const orderResult = validateDisplayOrder(req.body.displayOrder);
        if (!orderResult.ok) {
            return res.status(400).json({ success: false, message: orderResult.message });
        }

        // Locked decision #19: body.status is ignored on create.
        // New rows always start as 'draft'.

        let slug;
        try {
            slug = await generateUniqueSlug({
                table: "verticals",
                name: nameResult.value,
                clientSlug: req.body.slug,
                excludeId: null
            });
        } catch (err) {
            return res.status(err.status || 500).json({
                success: false,
                message: err.message || "Server error"
            });
        }

        const result = await db.query(
            `INSERT INTO verticals
                 (name, slug, description, metadata, display_order, status, created_by, updated_by)
             VALUES ($1, $2, $3, $4, $5, 'draft', $6, $6)
             RETURNING id, name, slug, description, metadata, display_order, status,
                       published_at, published_by,
                       created_by, updated_by, created_at, updated_at, deleted_at`,
            [
                nameResult.value,
                slug,
                descResult.value,
                metaResult.value,
                orderResult.value,
                req.user.id
            ]
        );

        return res.status(201).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("createVertical error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const updateVertical = async (req, res) => {
    try {
        const idResult = validateVerticalId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const id = idResult.value;

        const existing = await db.query(
            `SELECT id, name, slug, description, metadata, display_order, status,
                    published_at, published_by, deleted_at
             FROM verticals WHERE id = $1`,
            [id]
        );
        if (existing.rows.length === 0 || existing.rows[0].deleted_at !== null) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }
        const current = existing.rows[0];

        // Partial update: start from current values, overlay only fields present in body.
        const next = {
            name: current.name,
            slug: current.slug,
            description: current.description,
            metadata: current.metadata,
            display_order: current.display_order,
            status: current.status,
            published_at: current.published_at,
            published_by: current.published_by
        };

        if (req.body.name !== undefined) {
            const r = validateName(req.body.name);
            if (!r.ok) return res.status(400).json({ success: false, message: r.message });
            next.name = r.value;
        }

        if (req.body.description !== undefined) {
            const r = validateDescription(req.body.description);
            if (!r.ok) return res.status(400).json({ success: false, message: r.message });
            next.description = r.value;
        }

        if (req.body.metadata !== undefined) {
            const r = validateMetadata(req.body.metadata);
            if (!r.ok) return res.status(400).json({ success: false, message: r.message });
            next.metadata = r.value;
        }

        if (req.body.displayOrder !== undefined) {
            const r = validateDisplayOrder(req.body.displayOrder);
            if (!r.ok) return res.status(400).json({ success: false, message: r.message });
            next.display_order = r.value;
        }

        // Status: validate against the state machine. Skip the state machine
        // check when status isn't changing (idempotent same-status is allowed).
        if (req.body.status !== undefined) {
            const r = validateStatus(req.body.status);
            if (!r.ok) return res.status(400).json({ success: false, message: r.message });
            if (r.value !== null && r.value !== current.status) {
                const tr = validateStatusTransition({
                    from: current.status,
                    to: r.value,
                    role: req.user.role
                });
                if (!tr.ok) {
                    // Role-gated transitions return 403; illegal pairs return 400.
                    const httpStatus = tr.message.startsWith("Only ") ? 403 : 400;
                    return res.status(httpStatus).json({ success: false, message: tr.message });
                }
                next.status = r.value;
                if (r.value === "published") {
                    // Locked decision #20: stamp publish metadata on transitions into published.
                    next.published_at = new Date();
                    next.published_by = req.user.id;
                }
            }
        }

        // Slug is sticky unless the body explicitly supplies one.
        if (req.body.slug !== undefined && req.body.slug !== null && req.body.slug !== "") {
            try {
                next.slug = await generateUniqueSlug({
                    table: "verticals",
                    name: next.name,
                    clientSlug: req.body.slug,
                    excludeId: id
                });
            } catch (err) {
                return res.status(err.status || 500).json({
                    success: false,
                    message: err.message || "Server error"
                });
            }
        }

        const result = await db.query(
            `UPDATE verticals
             SET name = $1,
                 slug = $2,
                 description = $3,
                 metadata = $4,
                 display_order = $5,
                 status = $6,
                 published_at = $7,
                 published_by = $8,
                 updated_by = $9,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $10
             RETURNING id, name, slug, description, metadata, display_order, status,
                       published_at, published_by,
                       created_by, updated_by, created_at, updated_at, deleted_at`,
            [
                next.name,
                next.slug,
                next.description,
                next.metadata,
                next.display_order,
                next.status,
                next.published_at,
                next.published_by,
                req.user.id,
                id
            ]
        );

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("updateVertical error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const deleteVertical = async (req, res) => {
    try {
        const idResult = validateVerticalId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const id = idResult.value;

        const existing = await db.query(
            `SELECT id, deleted_at FROM verticals WHERE id = $1`,
            [id]
        );
        if (existing.rows.length === 0 || existing.rows[0].deleted_at !== null) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }

        await db.query(
            `UPDATE verticals
             SET deleted_at = CURRENT_TIMESTAMP,
                 updated_by = $1,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $2`,
            [req.user.id, id]
        );

        return res.status(200).json({
            success: true,
            message: "Vertical deleted"
        });
    } catch (err) {
        console.error("deleteVertical error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    listVerticals,
    getVerticalById,
    createVertical,
    updateVertical,
    deleteVertical
};