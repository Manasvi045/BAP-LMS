// controllers/contentBlockController.js
// ============================================================================
// Content Block CRUD (Phase 4.5).
//
// Endpoints:
//   GET    /api/content-blocks              list  (paginated, filtered)
//   GET    /api/content-blocks/:id          get one
//   POST   /api/content-blocks              create (sectionId, type, content required)
//   PUT    /api/content-blocks/:id          update (re-parenting allowed;
//                                                 type change requires content)
//   DELETE /api/content-blocks/:id          soft delete
//
// Distinct from V/M/S:
//   * No slug, no name, no description, no metadata, no status.
//   * Visibility flows from the parent section's status.
//   * `type` is constrained to ALLOWED_BLOCK_TYPES (utils/validators/blockType).
//   * `content` JSONB payload validated per type
//     (utils/validators/contentBlock.validateContentByType).
// ============================================================================

const db = require("../config/db");

const {
    validateContentBlockId,
    validateSectionIdRequired,
    validateSectionIdOptional,
    validateDisplayOrder,
    validateTypeFilter,
    validateContentByType
} = require("../utils/validators/contentBlock");

const { validateBlockType } = require("../utils/validators/blockType");

const {
    validatePage,
    validateLimit
} = require("../utils/validation");

// ----------------------------------------------------------------------------
// helpers
// ----------------------------------------------------------------------------

// Verify a parent section exists and is not soft-deleted.
async function fetchActiveSection(sectionId) {
    const result = await db.query(
        `SELECT id, deleted_at FROM sections WHERE id = $1`,
        [sectionId]
    );
    if (result.rows.length === 0) return null;
    if (result.rows[0].deleted_at !== null) return null;
    return result.rows[0];
}

// ----------------------------------------------------------------------------
// controllers
// ----------------------------------------------------------------------------

const listContentBlocks = async (req, res) => {
    try {
        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({ success: false, message: pageResult.message });
        }

        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({ success: false, message: limitResult.message });
        }

        const sectionFilterResult = validateSectionIdOptional(req.query.sectionId);
        if (!sectionFilterResult.ok) {
            return res.status(400).json({
                success: false,
                message: sectionFilterResult.message
            });
        }

        const typeFilterResult = validateTypeFilter(req.query.type);
        if (!typeFilterResult.ok) {
            return res.status(400).json({
                success: false,
                message: typeFilterResult.message
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
        const sectionId = sectionFilterResult.value;
        const type = typeFilterResult.value;

        const conditions = [];
        const values = [];
        let idx = 1;

        if (!includeDeleted) {
            conditions.push("deleted_at IS NULL");
        }
        if (sectionId !== null) {
            conditions.push(`section_id = $${idx}`);
            values.push(sectionId);
            idx++;
        }
        if (type !== null) {
            conditions.push(`type = $${idx}`);
            values.push(type);
            idx++;
        }

        const whereClause = conditions.length > 0
            ? " WHERE " + conditions.join(" AND ")
            : "";

        const countResult = await db.query(
            `SELECT COUNT(*) AS total FROM content_blocks${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);
        const totalPages = Math.max(1, Math.ceil(totalRecords / limit));

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT id, section_id, type, content, display_order,
                   created_by, updated_by, created_at, updated_at, deleted_at
            FROM content_blocks
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
        console.error("listContentBlocks error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const getContentBlockById = async (req, res) => {
    try {
        const idResult = validateContentBlockId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }

        const result = await db.query(
            `SELECT id, section_id, type, content, display_order,
                    created_by, updated_by, created_at, updated_at, deleted_at
             FROM content_blocks
             WHERE id = $1 AND deleted_at IS NULL`,
            [idResult.value]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Content block not found" });
        }

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("getContentBlockById error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const createContentBlock = async (req, res) => {
    try {
        const sectionResult = validateSectionIdRequired(req.body.sectionId);
        if (!sectionResult.ok) {
            return res.status(400).json({ success: false, message: sectionResult.message });
        }

        const orderResult = validateDisplayOrder(req.body.displayOrder);
        if (!orderResult.ok) {
            return res.status(400).json({ success: false, message: orderResult.message });
        }

        const typeResult = validateBlockType(req.body.type);
        if (!typeResult.ok) {
            return res.status(400).json({ success: false, message: typeResult.message });
        }

        const contentResult = validateContentByType(typeResult.value, req.body.content);
        if (!contentResult.ok) {
            return res.status(400).json({ success: false, message: contentResult.message });
        }

        const parent = await fetchActiveSection(sectionResult.value);
        if (parent === null) {
            return res.status(404).json({
                success: false,
                message: "Parent section not found"
            });
        }

        const result = await db.query(
            `INSERT INTO content_blocks
                 (section_id, type, content, display_order, created_by, updated_by)
             VALUES ($1, $2, $3, $4, $5, $5)
             RETURNING id, section_id, type, content, display_order,
                       created_by, updated_by, created_at, updated_at, deleted_at`,
            [
                sectionResult.value,
                typeResult.value,
                contentResult.value,
                orderResult.value,
                req.user.id
            ]
        );

        return res.status(201).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("createContentBlock error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const updateContentBlock = async (req, res) => {
    try {
        const idResult = validateContentBlockId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const id = idResult.value;

        const existing = await db.query(
            `SELECT id, section_id, type, content, deleted_at
             FROM content_blocks WHERE id = $1`,
            [id]
        );
        if (existing.rows.length === 0 || existing.rows[0].deleted_at !== null) {
            return res.status(404).json({ success: false, message: "Content block not found" });
        }
        const current = existing.rows[0];

        const orderResult = validateDisplayOrder(req.body.displayOrder);
        if (!orderResult.ok) {
            return res.status(400).json({ success: false, message: orderResult.message });
        }

        // type is OPTIONAL on update. If supplied, must be allowed.
        let requestedType = null;
        if (req.body.type !== undefined && req.body.type !== null && req.body.type !== "") {
            const typeResult = validateBlockType(req.body.type);
            if (!typeResult.ok) {
                return res.status(400).json({ success: false, message: typeResult.message });
            }
            requestedType = typeResult.value;
        }
        const typeChanged =
            requestedType !== null && requestedType !== current.type;
        const effectiveType = requestedType !== null ? requestedType : current.type;

        // content is OPTIONAL on update. If supplied, validate against effectiveType.
        // If type changed without content, reject.
        if (typeChanged && req.body.content === undefined) {
            return res.status(400).json({
                success: false,
                message: "type change requires content to be supplied"
            });
        }

        let nextContent = current.content;
        if (req.body.content !== undefined) {
            if (req.body.content === null) {
                // explicit null is rejected — content is NOT NULL in the schema
                return res.status(400).json({
                    success: false,
                    message: "content cannot be null"
                });
            }
            const contentResult = validateContentByType(effectiveType, req.body.content);
            if (!contentResult.ok) {
                return res.status(400).json({ success: false, message: contentResult.message });
            }
            nextContent = contentResult.value;
        }

        // Re-parenting: sectionId is optional on update.
        const sectionResult = validateSectionIdOptional(req.body.sectionId);
        if (!sectionResult.ok) {
            return res.status(400).json({ success: false, message: sectionResult.message });
        }

        let targetSectionId = current.section_id;
        if (sectionResult.value !== null && sectionResult.value !== current.section_id) {
            const newParent = await fetchActiveSection(sectionResult.value);
            if (newParent === null) {
                return res.status(404).json({
                    success: false,
                    message: "Parent section not found"
                });
            }
            targetSectionId = newParent.id;
        }

        const result = await db.query(
            `UPDATE content_blocks
             SET type = $1,
                 content = $2,
                 display_order = $3,
                 section_id = $4,
                 updated_by = $5,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $6
             RETURNING id, section_id, type, content, display_order,
                       created_by, updated_by, created_at, updated_at, deleted_at`,
            [
                effectiveType,
                nextContent,
                orderResult.value,
                targetSectionId,
                req.user.id,
                id
            ]
        );

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("updateContentBlock error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const deleteContentBlock = async (req, res) => {
    try {
        const idResult = validateContentBlockId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const id = idResult.value;

        const existing = await db.query(
            `SELECT id, deleted_at FROM content_blocks WHERE id = $1`,
            [id]
        );
        if (existing.rows.length === 0 || existing.rows[0].deleted_at !== null) {
            return res.status(404).json({ success: false, message: "Content block not found" });
        }

        await db.query(
            `UPDATE content_blocks
             SET deleted_at = CURRENT_TIMESTAMP,
                 updated_by = $1,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $2`,
            [req.user.id, id]
        );

        return res.status(200).json({
            success: true,
            message: "Content block deleted"
        });
    } catch (err) {
        console.error("deleteContentBlock error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    listContentBlocks,
    getContentBlockById,
    createContentBlock,
    updateContentBlock,
    deleteContentBlock
};