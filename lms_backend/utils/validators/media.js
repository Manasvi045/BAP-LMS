// utils/validators/media.js
// ============================================================================
// Input validators for the Media library entity (Phase 4.7).
//
// v1 surface — URL registration. No file upload. The body describes an
// already-hosted asset that the caller wants to track in our media library.
//
// Fields and limits:
//   url              TEXT            required, http(s) only, max 2048 chars
//   originalFilename VARCHAR(255)    required, non-empty after trim
//   contentType      VARCHAR(100)    required, MIME format (type/subtype)
//   sizeBytes        BIGINT          required, 1..100 MB
//   kind             VARCHAR(20)     optional, default 'other'
//                                   ∈ {image, video, audio, document, other}
//   width            INTEGER         optional, non-negative (image/video)
//   height           INTEGER         optional, non-negative (image/video)
//   durationSeconds  INTEGER         optional, non-negative (video/audio)
//
// URL uniqueness is enforced at the DB level (partial unique index), so two
// active registrations of the same URL are impossible without an upstream
// soft-delete cycle.
// ============================================================================

const ALLOWED_KINDS = ["image", "video", "audio", "document", "other"];

const MAX_SIZE_BYTES = 100 * 1024 * 1024; // 100 MB

function isAllowedKind(value) {
    return typeof value === "string" && ALLOWED_KINDS.includes(value);
}

const validateId = (value, fieldName = "id") => {
    const parsed = Number(value);
    if (!Number.isInteger(parsed) || parsed <= 0) {
        return { ok: false, message: `Invalid ${fieldName}` };
    }
    return { ok: true, value: parsed };
};

const validateMediaId = (value) => validateId(value, "id");

const validateUrl = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: false, message: "url is required" };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "url must be a string" };
    }
    if (value.length > 2048) {
        return { ok: false, message: "url must be 2048 characters or fewer" };
    }
    let parsed;
    try {
        parsed = new URL(value);
    } catch {
        return { ok: false, message: "url is not a valid URL" };
    }
    if (parsed.protocol !== "http:" && parsed.protocol !== "https:") {
        return { ok: false, message: "url must use http or https" };
    }
    return { ok: true, value };
};

const validateOriginalFilename = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: false, message: "originalFilename is required" };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "originalFilename must be a string" };
    }
    const trimmed = value.trim();
    if (trimmed.length === 0) {
        return { ok: false, message: "originalFilename cannot be empty" };
    }
    if (trimmed.length > 255) {
        return { ok: false, message: "originalFilename must be 255 characters or fewer" };
    }
    return { ok: true, value: trimmed };
};

const validateContentType = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: false, message: "contentType is required" };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "contentType must be a string" };
    }
    if (value.length > 100) {
        return { ok: false, message: "contentType must be 100 characters or fewer" };
    }
    // MIME-type shape: type/subtype. Allow charset / boundary params.
    if (!/^[a-z0-9-]+\/[a-z0-9-]+/.test(value)) {
        return {
            ok: false,
            message: "contentType must be a valid MIME type (type/subtype)"
        };
    }
    return { ok: true, value };
};

const validateSizeBytes = (value) => {
    if (value === undefined || value === null) {
        return { ok: false, message: "sizeBytes is required" };
    }
    const parsed = typeof value === "string" ? Number(value) : value;
    if (!Number.isInteger(parsed) || parsed <= 0) {
        return { ok: false, message: "sizeBytes must be a positive integer" };
    }
    if (parsed > MAX_SIZE_BYTES) {
        return {
            ok: false,
            message: `sizeBytes must be ${MAX_SIZE_BYTES / 1024 / 1024} MB or fewer`
        };
    }
    return { ok: true, value: parsed };
};

const validateKind = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: "other" };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "kind must be a string" };
    }
    if (!isAllowedKind(value)) {
        return {
            ok: false,
            message: `kind must be one of: ${ALLOWED_KINDS.join(", ")}`
        };
    }
    return { ok: true, value };
};

// Optional non-negative integer (used for width/height/durationSeconds).
const validateOptionalPositiveInt = (value, fieldName) => {
    if (value === undefined || value === null) {
        return { ok: true, value: null };
    }
    const parsed = typeof value === "string" ? Number(value) : value;
    if (!Number.isInteger(parsed) || parsed < 0) {
        return {
            ok: false,
            message: `${fieldName} must be a non-negative integer`
        };
    }
    return { ok: true, value: parsed };
};

// Optional ownerId filter — must be a positive integer or undefined.
// Only meaningful for admin to scope their list.
const validateOwnerIdOptional = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: null };
    }
    return validateId(value, "ownerId");
};

// Optional kind filter — returns {ok, value: null|allowed-kind}.
const validateKindFilter = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: null };
    }
    if (!isAllowedKind(value)) {
        return {
            ok: false,
            message: `kind filter must be one of: ${ALLOWED_KINDS.join(", ")}`
        };
    }
    return { ok: true, value };
};

module.exports = {
    ALLOWED_KINDS,
    MAX_SIZE_BYTES,
    validateMediaId,
    validateUrl,
    validateOriginalFilename,
    validateContentType,
    validateSizeBytes,
    validateKind,
    validateOptionalPositiveInt,
    validateOwnerIdOptional,
    validateKindFilter
};