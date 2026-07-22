// utils/validators/module.js
// ============================================================================
// Input validators for the Module entity.
// Each helper returns:
//   { ok: true,  value: <normalized value> }
//   { ok: false, message: "..." }
// Controllers map !ok to a 400 response with the message.
//
// validateStatus is re-exported from ./status (Phase 4.6 — single source of
// truth for the status state machine).
// ============================================================================

const { validateStatus } = require("./status");

const validateName = (value) => {
    if (typeof value !== "string") {
        return { ok: false, message: "name must be a string" };
    }
    const trimmed = value.trim();
    if (trimmed.length === 0) {
        return { ok: false, message: "name cannot be empty" };
    }
    if (trimmed.length > 255) {
        return { ok: false, message: "name must be 255 characters or fewer" };
    }
    return { ok: true, value: trimmed };
};

const validateDescription = (value) => {
    if (value === undefined || value === null) {
        return { ok: true, value: null };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "description must be a string" };
    }
    return { ok: true, value };
};

const validateMetadata = (value) => {
    if (value === undefined || value === null) {
        return { ok: true, value: {} };
    }
    if (typeof value !== "object" || Array.isArray(value)) {
        return { ok: false, message: "metadata must be a JSON object" };
    }
    return { ok: true, value };
};

const validateDisplayOrder = (value) => {
    if (value === undefined || value === null) {
        return { ok: true, value: 0 };
    }
    const parsed = typeof value === "string" ? Number(value) : value;
    if (!Number.isInteger(parsed)) {
        return { ok: false, message: "displayOrder must be an integer" };
    }
    return { ok: true, value: parsed };
};

// Positive integer id (works for vertical_id, module_id, etc.).
const validateId = (value, fieldName = "id") => {
    const parsed = Number(value);
    if (!Number.isInteger(parsed) || parsed <= 0) {
        return { ok: false, message: `Invalid ${fieldName}` };
    }
    return { ok: true, value: parsed };
};

const validateModuleId = (value) => validateId(value, "id");

// Required positive integer — verticalId is REQUIRED on create, OPTIONAL on update.
const validateVerticalIdRequired = (value) => {
    if (value === undefined || value === null) {
        return { ok: false, message: "verticalId is required" };
    }
    return validateId(value, "verticalId");
};

const validateVerticalIdOptional = (value) => {
    if (value === undefined || value === null) {
        return { ok: true, value: null };
    }
    return validateId(value, "verticalId");
};

module.exports = {
    validateName,
    validateDescription,
    validateMetadata,
    validateDisplayOrder,
    validateStatus,
    validateModuleId,
    validateVerticalIdRequired,
    validateVerticalIdOptional
};