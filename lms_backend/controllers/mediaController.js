// controllers/mediaController.js
// ============================================================================
// Media library (Phase 4.7).
//
// Endpoints:
//   GET    /api/media              list (paginated, filtered, soft-delete-aware)
//   GET    /api/media/:id          get one
//   POST   /api/media              register a media URL + metadata
//   DELETE /api/media/:id          soft delete (admin or owner)
//
// Locked decisions:
//   #22 — Storage backend is the caller's choice. v1 registers URLs only;
//         no file upload in this phase.
//   #23 — Editors see/delete their own media; admins see/delete all.
//   #24 — Soft delete only; hard delete / recycle-bin purge is a future
//         admin action.
//
// URLs flow into content_blocks.content.image.url / video.url and into
// verticals / modules / sections metadata. No FK constraint on those string
// fields — the media table is a metadata library keyed by the unique URL.
// ============================================================================

const db = require("../config/db");

const {
    validateMediaId,
    validateUrl,
    validateOriginalFilename,
    validateContentType,
    validateSizeBytes,
    validateKind,
    validateOptionalPositiveInt,
    validateOwnerIdOptional,
    validateKindFilter
} = require("../utils/validators/media");

const { validatePage, validateLimit } = require("../utils/validation");

// ----------------------------------------------------------------------------
// controllers
// ----------------------------------------------------------------------------

const listMedia = async (req, res) => {
    try {
        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({ success: false, message: pageResult.message });
        }

        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({ success: false, message: limitResult.message });
        }

        const kindFilterResult = validateKindFilter(req.query.kind);
        if (!kindFilterResult.ok) {
            return res.status(400).json({
                success: false,
                message: kindFilterResult.message
            });
        }

        // Editors are scoped to their own media by default. Admins see all.
        // Admins can also scope via ?ownerId=N.
        let ownerScope = req.user.id;
        if (req.user.role === "admin") {
            const ownerFilterResult = validateOwnerIdOptional(req.query.ownerId);
            if (!ownerFilterResult.ok) {
                return res.status(400).json({
                    success: false,
                    message: ownerFilterResult.message
                });
            }
            if (ownerFilterResult.value !== null) {
                ownerScope = ownerFilterResult.value;
            } else {
                ownerScope = null; // null = no scope (admins see all)
            }
        } else {
            // Editors attempting ?ownerId=other -> 403
            if (req.query.ownerId !== undefined &&
                req.query.ownerId !== "" &&
                String(req.query.ownerId) !== String(req.user.id)) {
                return res.status(403).json({
                    success: false,
                    message: "Only admin can scope by ownerId"
                });
            }
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
        const kind = kindFilterResult.value;

        const conditions = [];
        const values = [];
        let idx = 1;

        if (!includeDeleted) {
            conditions.push("deleted_at IS NULL");
        }
        if (ownerScope !== null) {
            conditions.push(`owner_id = $${idx}`);
            values.push(ownerScope);
            idx++;
        }
        if (kind !== null) {
            conditions.push(`kind = $${idx}`);
            values.push(kind);
            idx++;
        }

        const whereClause = conditions.length > 0
            ? " WHERE " + conditions.join(" AND ")
            : "";

        const countResult = await db.query(
            `SELECT COUNT(*) AS total FROM media${whereClause}`,
            [...values]
        );
        const totalRecords = Number(countResult.rows[0].total);
        const totalPages = Math.max(1, Math.ceil(totalRecords / limit));

        const offset = (page - 1) * limit;
        const listQuery = `
            SELECT id, owner_id, url, original_filename, content_type, size_bytes,
                   kind, width, height, duration_seconds,
                   created_by, updated_by, created_at, updated_at, deleted_at
            FROM media
            ${whereClause}
            ORDER BY id DESC
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
        console.error("listMedia error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const getMediaById = async (req, res) => {
    try {
        const idResult = validateMediaId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }

        const result = await db.query(
            `SELECT id, owner_id, url, original_filename, content_type, size_bytes,
                    kind, width, height, duration_seconds,
                    created_by, updated_by, created_at, updated_at, deleted_at
             FROM media
             WHERE id = $1 AND deleted_at IS NULL`,
            [idResult.value]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: "Media not found" });
        }

        // Editors can only fetch their own.
        if (req.user.role !== "admin" &&
            result.rows[0].owner_id !== req.user.id) {
            return res.status(403).json({
                success: false,
                message: "Forbidden"
            });
        }

        return res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        console.error("getMediaById error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const createMedia = async (req, res) => {
    try {
        const urlResult = validateUrl(req.body.url);
        if (!urlResult.ok) {
            return res.status(400).json({ success: false, message: urlResult.message });
        }

        const nameResult = validateOriginalFilename(req.body.originalFilename);
        if (!nameResult.ok) {
            return res.status(400).json({ success: false, message: nameResult.message });
        }

        const contentTypeResult = validateContentType(req.body.contentType);
        if (!contentTypeResult.ok) {
            return res.status(400).json({
                success: false,
                message: contentTypeResult.message
            });
        }

        const sizeResult = validateSizeBytes(req.body.sizeBytes);
        if (!sizeResult.ok) {
            return res.status(400).json({ success: false, message: sizeResult.message });
        }

        const kindResult = validateKind(req.body.kind);
        if (!kindResult.ok) {
            return res.status(400).json({ success: false, message: kindResult.message });
        }

        const widthResult = validateOptionalPositiveInt(req.body.width, "width");
        if (!widthResult.ok) {
            return res.status(400).json({ success: false, message: widthResult.message });
        }

        const heightResult = validateOptionalPositiveInt(req.body.height, "height");
        if (!heightResult.ok) {
            return res.status(400).json({ success: false, message: heightResult.message });
        }

        const durationResult = validateOptionalPositiveInt(req.body.durationSeconds, "durationSeconds");
        if (!durationResult.ok) {
            return res.status(400).json({ success: false, message: durationResult.message });
        }

        const result = await db.query(
            `INSERT INTO media
                 (owner_id, url, original_filename, content_type, size_bytes,
                  kind, width, height, duration_seconds,
                  created_by, updated_by)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $10)
             RETURNING id, owner_id, url, original_filename, content_type, size_bytes,
                       kind, width, height, duration_seconds,
                       created_by, updated_by, created_at, updated_at, deleted_at`,
            [
                req.user.id,
                urlResult.value,
                nameResult.value,
                contentTypeResult.value,
                sizeResult.value,
                kindResult.value,
                widthResult.value,
                heightResult.value,
                durationResult.value,
                req.user.id
            ]
        );

        return res.status(201).json({ success: true, data: result.rows[0] });
    } catch (err) {
        if (err.code === "23505") {
            // unique_violation on the (url) partial unique index.
            return res.status(409).json({
                success: false,
                message: "A media row with this URL already exists"
            });
        }
        console.error("createMedia error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

const deleteMedia = async (req, res) => {
    try {
        const idResult = validateMediaId(req.params.id);
        if (!idResult.ok) {
            return res.status(400).json({ success: false, message: idResult.message });
        }
        const id = idResult.value;

        const existing = await db.query(
            `SELECT id, owner_id, deleted_at FROM media WHERE id = $1`,
            [id]
        );
        if (existing.rows.length === 0 || existing.rows[0].deleted_at !== null) {
            return res.status(404).json({ success: false, message: "Media not found" });
        }

        // Admins delete anything; editors delete only their own.
        if (req.user.role !== "admin" && existing.rows[0].owner_id !== req.user.id) {
            return res.status(403).json({
                success: false,
                message: "Only admin or the owner can delete this media"
            });
        }

        await db.query(
            `UPDATE media
             SET deleted_at = CURRENT_TIMESTAMP,
                 updated_by = $1,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $2`,
            [req.user.id, id]
        );

        return res.status(200).json({
            success: true,
            message: "Media deleted"
        });
    } catch (err) {
        console.error("deleteMedia error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    listMedia,
    getMediaById,
    createMedia,
    deleteMedia
};