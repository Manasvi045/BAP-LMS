// controllers/learnController.js
// ============================================================================
// Learner-facing read API (Phase 5).
//
// Endpoints (mounted at /api/learn):
//   GET /verticals                    list published verticals (paginated, ?search)
//   GET /verticals/:id                get one published vertical
//   GET /verticals/:id/tree           full vertical tree: V + M + S + blocks
//   GET /verticals/:id/modules        list published modules of a vertical
//   GET /modules/:id                  get one published module (parent vertical must be published)
//   GET /modules/:id/sections         list published sections of a module
//   GET /sections/:id                 get one published section (parent chain must be published)
//   GET /sections/:id/blocks          list content blocks of a published section
//   GET /blocks/:id                   get one content block (parent chain must be published)
//
// Locked decisions:
//   #25 — /api/learn/* prefix. Distinct from /api/verticals (admin/editor write
//         surface). Response shape omits created_by / updated_by / deleted_at /
//         published_by audit fields; keeps the learner-facing fields only.
//   #26 — Tree endpoint returns the full V → M → S → blocks hierarchy in one
//         response. Useful for Flutter to render a course catalog without
//         N round trips.
//   #27 — No writes on /api/learn. All mutations go through the admin endpoints.
//   #28 — Cross-parent visibility: a published section within a draft module
//         is invisible; a published module within a draft vertical is invisible.
//         Checked via JOINs in the get-by-id paths.
//   #29 — Any authenticated user (admin / editor / learner) can read. The role
//         is not used in the query — only JWT validity matters.
//
// Visibility:
//   * status = 'published' AND deleted_at IS NULL is required at every level.
//   * Cross-parent JOINs ensure that a published child of an unpublished parent
//     is not visible.
// ============================================================================

const db = require("../config/db");

const {
    validatePage,
    validateLimit,
    validateSearch
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

// Standard pagination response envelope (matches admin endpoints).
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
// controllers
// ----------------------------------------------------------------------------

// GET /api/learn/verticals
const listVerticalsLearn = async (req, res) => {
    try {
        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({ success: false, message: pageResult.message });
        }
        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({ success: false, message: limitResult.message });
        }
        const searchResult = validateSearch(req.query.search);
        if (!searchResult.ok) {
            return res.status(400).json({ success: false, message: searchResult.message });
        }

        const page = pageResult.value;
        const limit = limitResult.value;
        const search = searchResult.value;

        const conditions = ["deleted_at IS NULL", "status = 'published'"];
        const values = [];
        let idx = 1;

        if (search) {
            conditions.push(`(name ILIKE $${idx} OR description ILIKE $${idx})`);
            values.push(`%${search}%`);
            idx++;
        }

        const whereClause = " WHERE " + conditions.join(" AND ");

        const countResult = await db.query(
            `SELECT COUNT(*) AS total FROM verticals${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT id, name, slug, description, metadata, display_order,
                   published_at, created_at, updated_at
            FROM verticals
            ${whereClause}
            ORDER BY display_order ASC, id ASC
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
        console.error("listVerticalsLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// GET /api/learn/verticals/:id
const getVerticalLearn = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }

        const result = await db.query(
            `SELECT id, name, slug, description, metadata, display_order,
                    published_at, created_at, updated_at
             FROM verticals
             WHERE id = $1 AND deleted_at IS NULL AND status = 'published'`,
            [idResult.value]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("getVerticalLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// GET /api/learn/verticals/:id/tree
const getVerticalTreeLearn = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const verticalId = idResult.value;

        // 1. Vertical — must be published.
        const vResult = await db.query(
            `SELECT id, name, slug, description, metadata, display_order,
                    published_at, created_at, updated_at
             FROM verticals
             WHERE id = $1 AND deleted_at IS NULL AND status = 'published'`,
            [verticalId]
        );
        if (vResult.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }
        const vertical = vResult.rows[0];

        // 2. Modules of vertical — only published.
        const mResult = await db.query(
            `SELECT id, vertical_id, name, slug, description, metadata,
                    display_order, published_at, created_at, updated_at
             FROM modules
             WHERE vertical_id = $1 AND deleted_at IS NULL AND status = 'published'
             ORDER BY display_order ASC, id ASC`,
            [verticalId]
        );
        const modules = mResult.rows;

        if (modules.length === 0) {
            return res.status(200).json({
                success: true,
                data: { vertical, modules: [] }
            });
        }

        // 3. Sections of those modules — only published.
        const moduleIds = modules.map((m) => m.id);
        const sResult = await db.query(
            `SELECT id, module_id, name, slug, description, metadata,
                    display_order, published_at, created_at, updated_at
             FROM sections
             WHERE module_id = ANY($1::int[])
               AND deleted_at IS NULL
               AND status = 'published'
             ORDER BY display_order ASC, id ASC`,
            [moduleIds]
        );
        const sections = sResult.rows;

        if (sections.length === 0) {
            return res.status(200).json({
                success: true,
                data: {
                    vertical,
                    modules: modules.map((m) => ({ ...m, sections: [] }))
                }
            });
        }

        // 4. Blocks of those sections — content_blocks have no status; visibility
        //    flows from the parent section which is already known to be published.
        const sectionIds = sections.map((s) => s.id);
        const bResult = await db.query(
            `SELECT id, section_id, type, content, display_order
             FROM content_blocks
             WHERE section_id = ANY($1::int[])
               AND deleted_at IS NULL
             ORDER BY display_order ASC, id ASC`,
            [sectionIds]
        );
        const blocks = bResult.rows;

        // 5. Assemble tree: sections under modules, blocks under sections.
        const sectionsByModule = new Map();
        for (const section of sections) {
            if (!sectionsByModule.has(section.module_id)) {
                sectionsByModule.set(section.module_id, []);
            }
            sectionsByModule.get(section.module_id).push(section);
        }
        const blocksBySection = new Map();
        for (const block of blocks) {
            if (!blocksBySection.has(block.section_id)) {
                blocksBySection.set(block.section_id, []);
            }
            blocksBySection.get(block.section_id).push(block);
        }

        const assembledModules = modules.map((m) => ({
            ...m,
            sections: (sectionsByModule.get(m.id) || []).map((s) => ({
                ...s,
                blocks: blocksBySection.get(s.id) || []
            }))
        }));

        return res.status(200).json({
            success: true,
            data: {
                vertical,
                modules: assembledModules
            }
        });
    } catch (err) {
        console.error("getVerticalTreeLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// GET /api/learn/verticals/:id/modules
const listModulesForVerticalLearn = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const verticalId = idResult.value;

        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({ success: false, message: pageResult.message });
        }
        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({ success: false, message: limitResult.message });
        }
        const searchResult = validateSearch(req.query.search);
        if (!searchResult.ok) {
            return res.status(400).json({ success: false, message: searchResult.message });
        }

        // Verify vertical is published. 404 if not — locked decision #28.
        const vCheck = await db.query(
            `SELECT id FROM verticals
             WHERE id = $1 AND deleted_at IS NULL AND status = 'published'`,
            [verticalId]
        );
        if (vCheck.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Vertical not found" });
        }

        const page = pageResult.value;
        const limit = limitResult.value;
        const search = searchResult.value;

        const conditions = [
            "vertical_id = $1",
            "deleted_at IS NULL",
            "status = 'published'"
        ];
        const values = [verticalId];
        let idx = 2;

        if (search) {
            conditions.push(`(name ILIKE $${idx} OR description ILIKE $${idx})`);
            values.push(`%${search}%`);
            idx++;
        }

        const whereClause = " WHERE " + conditions.join(" AND ");

        const countResult = await db.query(
            `SELECT COUNT(*) AS total FROM modules${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT id, vertical_id, name, slug, description, metadata,
                    display_order, published_at, created_at, updated_at
            FROM modules
            ${whereClause}
            ORDER BY display_order ASC, id ASC
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
        console.error("listModulesForVerticalLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// GET /api/learn/modules/:id
const getModuleLearn = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const moduleId = idResult.value;

        // JOIN with verticals to enforce cross-parent visibility.
        const result = await db.query(
            `SELECT m.id, m.vertical_id, m.name, m.slug, m.description, m.metadata,
                    m.display_order, m.published_at, m.created_at, m.updated_at
             FROM modules m
             JOIN verticals v ON m.vertical_id = v.id
             WHERE m.id = $1
               AND m.deleted_at IS NULL
               AND m.status = 'published'
               AND v.deleted_at IS NULL
               AND v.status = 'published'`,
            [moduleId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Module not found" });
        }

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("getModuleLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// GET /api/learn/modules/:id/sections
const listSectionsForModuleLearn = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const moduleId = idResult.value;

        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({ success: false, message: pageResult.message });
        }
        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({ success: false, message: limitResult.message });
        }
        const searchResult = validateSearch(req.query.search);
        if (!searchResult.ok) {
            return res.status(400).json({ success: false, message: searchResult.message });
        }

        // Verify module is published AND its parent vertical is published.
        const mCheck = await db.query(
            `SELECT m.id
             FROM modules m
             JOIN verticals v ON m.vertical_id = v.id
             WHERE m.id = $1
               AND m.deleted_at IS NULL
               AND m.status = 'published'
               AND v.deleted_at IS NULL
               AND v.status = 'published'`,
            [moduleId]
        );
        if (mCheck.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Module not found" });
        }

        const page = pageResult.value;
        const limit = limitResult.value;
        const search = searchResult.value;

        const conditions = [
            "module_id = $1",
            "deleted_at IS NULL",
            "status = 'published'"
        ];
        const values = [moduleId];
        let idx = 2;

        if (search) {
            conditions.push(`(name ILIKE $${idx} OR description ILIKE $${idx})`);
            values.push(`%${search}%`);
            idx++;
        }

        const whereClause = " WHERE " + conditions.join(" AND ");

        const countResult = await db.query(
            `SELECT COUNT(*) AS total FROM sections${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT id, module_id, name, slug, description, metadata,
                    display_order, published_at, created_at, updated_at
            FROM sections
            ${whereClause}
            ORDER BY display_order ASC, id ASC
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
        console.error("listSectionsForModuleLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// GET /api/learn/sections/:id
const getSectionLearn = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const sectionId = idResult.value;

        // JOIN with modules + verticals to enforce cross-parent visibility.
        const result = await db.query(
            `SELECT s.id, s.module_id, s.name, s.slug, s.description, s.metadata,
                    s.display_order, s.published_at, s.created_at, s.updated_at
             FROM sections s
             JOIN modules m ON s.module_id = m.id
             JOIN verticals v ON m.vertical_id = v.id
             WHERE s.id = $1
               AND s.deleted_at IS NULL
               AND s.status = 'published'
               AND m.deleted_at IS NULL
               AND m.status = 'published'
               AND v.deleted_at IS NULL
               AND v.status = 'published'`,
            [sectionId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Section not found" });
        }

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("getSectionLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// GET /api/learn/sections/:id/blocks
const listBlocksForSectionLearn = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const sectionId = idResult.value;

        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({ success: false, message: pageResult.message });
        }
        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({ success: false, message: limitResult.message });
        }
        const typeFilter = req.query.type;
        if (typeFilter !== undefined && typeFilter !== "" &&
            !["text", "image", "video", "quiz"].includes(typeFilter)) {
            return res.status(400).json({
                success: false,
                message: "type must be one of: text, image, video, quiz"
            });
        }

        // Verify section is published AND its parents are published.
        const sCheck = await db.query(
            `SELECT s.id
             FROM sections s
             JOIN modules m ON s.module_id = m.id
             JOIN verticals v ON m.vertical_id = v.id
             WHERE s.id = $1
               AND s.deleted_at IS NULL
               AND s.status = 'published'
               AND m.deleted_at IS NULL
               AND m.status = 'published'
               AND v.deleted_at IS NULL
               AND v.status = 'published'`,
            [sectionId]
        );
        if (sCheck.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Section not found" });
        }

        const page = pageResult.value;
        const limit = limitResult.value;

        const conditions = [
            "section_id = $1",
            "deleted_at IS NULL"
        ];
        const values = [sectionId];
        let idx = 2;

        if (typeFilter) {
            conditions.push(`type = $${idx}`);
            values.push(typeFilter);
            idx++;
        }

        const whereClause = " WHERE " + conditions.join(" AND ");

        const countResult = await db.query(
            `SELECT COUNT(*) AS total FROM content_blocks${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT id, section_id, type, content, display_order
            FROM content_blocks
            ${whereClause}
            ORDER BY display_order ASC, id ASC
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
        console.error("listBlocksForSectionLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

// GET /api/learn/blocks/:id
const getBlockLearn = async (req, res) => {
    try {
        const idResult = parseId(req.params.id, "id");
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const blockId = idResult.value;

        // JOIN with sections + modules + verticals to enforce cross-parent visibility.
        const result = await db.query(
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

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Content block not found" });
        }

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("getBlockLearn error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    listVerticalsLearn,
    getVerticalLearn,
    getVerticalTreeLearn,
    listModulesForVerticalLearn,
    getModuleLearn,
    listSectionsForModuleLearn,
    getSectionLearn,
    listBlocksForSectionLearn,
    getBlockLearn
};