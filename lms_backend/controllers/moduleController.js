// controllers/moduleController.js
// ============================================================================
// Module CRUD + publishing workflow (Phases 4.3 + 4.6).
//
// Endpoints:
//   GET    /api/modules              list  (paginated, filtered, soft-delete-aware)
//   GET    /api/modules/:id          get one
//   POST   /api/modules              create (parent verticalId required, status='draft')
//   PUT    /api/modules/:id          partial-update (re-parenting allowed; status gated by state machine)
//   DELETE /api/modules/:id          soft delete
//
// Slug rules:
//   * Auto-derived from name; client may override.
//   * Uniqueness scoped to (vertical_id, slug).
//   * Collision -> append "-2", "-3", ...
//   * Empty slug -> fallback to `item-{shortId}`.
//   * Sticky on rename — only changes when body supplies `slug`.
//
// Publishing (Phase 4.6): see controllers/verticalController.js for the
// state-machine rules. Apply here verbatim.
// ============================================================================

const db = require("../config/db");

const {
    validateName,
    validateDescription,
    validateMetadata,
    validateDisplayOrder,
    validateStatus,
    validateModuleId,
    validateVerticalIdRequired,
    validateVerticalIdOptional
} = require("../utils/validators/module");

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
// helpers
// ----------------------------------------------------------------------------

// Verify a parent vertical exists and is not soft-deleted.
// Returns the row (or null) so callers can reuse it.
async function fetchActiveVertical(verticalId) {
    const result = await db.query(
        `SELECT id, deleted_at FROM verticals WHERE id = $1`,
        [verticalId]
    );
    if (result.rows.length === 0) return null;
    if (result.rows[0].deleted_at !== null) return null;
    return result.rows[0];
}

// ----------------------------------------------------------------------------
// controllers
// ----------------------------------------------------------------------------

const listModules = async (req, res) => {
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

        const verticalFilterResult = validateVerticalIdOptional(req.query.verticalId);
        if (!verticalFilterResult.ok) {
            return res.status(400).json({
                success: false,
                message: verticalFilterResult.message
            });
        }

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
        const verticalId = verticalFilterResult.value;

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
        if (verticalId !== null) {
            conditions.push(`vertical_id = $${idx}`);
            values.push(verticalId);
            idx++;
        }

        const whereClause = conditions.length > 0
            ? " WHERE " + conditions.join(" AND ")
            : "";

        const countResult = await db.query(
            `SELECT COUNT(*) AS total FROM modules${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);
        const totalPages = Math.max(1, Math.ceil(totalRecords / limit));

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT id, vertical_id, name, slug, description, metadata,
                   display_order, status,
                   published_at, published_by,
                   created_by, updated_by, created_at, updated_at, deleted_at
            FROM modules
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
        console.error("listModules error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const getModuleById = async (req, res) => {
    try {
        const idResult = validateModuleId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }

        const result = await db.query(
            `SELECT id, vertical_id, name, slug, description, metadata,
                    display_order, status,
                    published_at, published_by,
                    created_by, updated_by, created_at, updated_at, deleted_at
             FROM modules
             WHERE id = $1 AND deleted_at IS NULL`,
            [idResult.value]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Module not found" });
        }

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("getModuleById error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const createModule = async (req, res) => {
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

        const verticalResult = validateVerticalIdRequired(req.body.verticalId);
        if (!verticalResult.ok) {
            return res.status(400).json({ success: false, message: verticalResult.message });
        }
        const verticalId = verticalResult.value;

        // Verify parent vertical exists and is not soft-deleted.
        const parent = await fetchActiveVertical(verticalId);
        if (parent === null) {
            return res.status(404).json({
                success: false,
                message: "Parent vertical not found"
            });
        }

        // Locked decision #19: body.status is ignored on create.
        // New rows always start as 'draft'.

        let slug;
        try {
            slug = await generateUniqueSlug({
                table: "modules",
                name: nameResult.value,
                clientSlug: req.body.slug,
                scopeColumn: "vertical_id",
                scopeValue: verticalId,
                excludeId: null
            });
        } catch (err) {
            return res.status(err.status || 500).json({
                success: false,
                message: err.message || "Server error"
            });
        }

        const result = await db.query(
            `INSERT INTO modules
                 (vertical_id, name, slug, description, metadata,
                  display_order, status, created_by, updated_by)
             VALUES ($1, $2, $3, $4, $5, $6, 'draft', $7, $7)
             RETURNING id, vertical_id, name, slug, description, metadata,
                       display_order, status,
                       published_at, published_by,
                       created_by, updated_by, created_at, updated_at, deleted_at`,
            [
                verticalId,
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
        console.error("createModule error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const updateModule = async (req, res) => {
    try {
        const idResult = validateModuleId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const id = idResult.value;

        const existing = await db.query(
            `SELECT id, vertical_id, name, slug, description, metadata,
                    display_order, status,
                    published_at, published_by, deleted_at
             FROM modules WHERE id = $1`,
            [id]
        );
        if (existing.rows.length === 0 || existing.rows[0].deleted_at !== null) {
            return res.status(404).json({ success: false, message: "Module not found" });
        }
        const current = existing.rows[0];

        // Partial update: start from current values, overlay only fields present in body.
        const next = {
            vertical_id: current.vertical_id,
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

        // Status: validate against the state machine.
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
                    const httpStatus = tr.message.startsWith("Only ") ? 403 : 400;
                    return res.status(httpStatus).json({ success: false, message: tr.message });
                }
                next.status = r.value;
                if (r.value === "published") {
                    next.published_at = new Date();
                    next.published_by = req.user.id;
                }
            }
        }

        // Re-parenting: verticalId is optional on update.
        if (req.body.verticalId !== undefined && req.body.verticalId !== null) {
            const r = validateVerticalIdOptional(req.body.verticalId);
            if (!r.ok) return res.status(400).json({ success: false, message: r.message });
            if (r.value !== null && r.value !== current.vertical_id) {
                const newParent = await fetchActiveVertical(r.value);
                if (newParent === null) {
                    return res.status(404).json({
                        success: false,
                        message: "Parent vertical not found"
                    });
                }
                next.vertical_id = newParent.id;
            }
        }

        // Slug: sticky unless body supplies one. Uniqueness is scoped to
        // (targetVerticalId, slug) — including after re-parenting.
        if (req.body.slug !== undefined && req.body.slug !== null && req.body.slug !== "") {
            try {
                next.slug = await generateUniqueSlug({
                    table: "modules",
                    name: next.name,
                    clientSlug: req.body.slug,
                    scopeColumn: "vertical_id",
                    scopeValue: next.vertical_id,
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
            `UPDATE modules
             SET vertical_id = $1,
                 name = $2,
                 slug = $3,
                 description = $4,
                 metadata = $5,
                 display_order = $6,
                 status = $7,
                 published_at = $8,
                 published_by = $9,
                 updated_by = $10,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $11
             RETURNING id, vertical_id, name, slug, description, metadata,
                       display_order, status,
                       published_at, published_by,
                       created_by, updated_by, created_at, updated_at, deleted_at`,
            [
                next.vertical_id,
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
        console.error("updateModule error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const deleteModule = async (req, res) => {
    try {
        const idResult = validateModuleId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const id = idResult.value;

        const existing = await db.query(
            `SELECT id, deleted_at FROM modules WHERE id = $1`,
            [id]
        );
        if (existing.rows.length === 0 || existing.rows[0].deleted_at !== null) {
            return res.status(404).json({ success: false, message: "Module not found" });
        }

        await db.query(
            `UPDATE modules
             SET deleted_at = CURRENT_TIMESTAMP,
                 updated_by = $1,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $2`,
            [req.user.id, id]
        );

        return res.status(200).json({
            success: true,
            message: "Module deleted"
        });
    } catch (err) {
        console.error("deleteModule error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    listModules,
    getModuleById,
    createModule,
    updateModule,
    deleteModule
};