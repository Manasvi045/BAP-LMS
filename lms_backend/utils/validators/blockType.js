// utils/validators/blockType.js
// ============================================================================
// Single source of truth for allowed content-block types.
// Per locked design decision #17 — adding a new type means editing this file
// and the per-type payload validator; no DB migration.
// ============================================================================

const ALLOWED_BLOCK_TYPES = ["text", "image", "video", "quiz"];

const isAllowedBlockType = (value) => {
    return typeof value === "string" && ALLOWED_BLOCK_TYPES.includes(value);
};

// Used by contentBlock validators to confirm `type` is allowed.
// Returns {ok, value|null, message}.
const validateBlockType = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: false, message: "type is required" };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "type must be a string" };
    }
    if (!ALLOWED_BLOCK_TYPES.includes(value)) {
        return {
            ok: false,
            message: `type must be one of: ${ALLOWED_BLOCK_TYPES.join(", ")}`
        };
    }
    return { ok: true, value };
};

module.exports = {
    ALLOWED_BLOCK_TYPES,
    isAllowedBlockType,
    validateBlockType
};