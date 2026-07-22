// Centralized input validation helpers.
// Each helper returns:
//   { ok: true, value: <normalized value> }
//   { ok: false, message: "..." }
// Controllers map !ok to a 400 response with the message.

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const ALLOWED_ROLES = ["admin", "editor", "user"];
const ALLOWED_STATUS_FILTERS = ["active", "inactive"];

const validateFullName = (value) => {
    if (typeof value !== "string") {
        return { ok: false, message: "fullName must be a string" };
    }
    const trimmed = value.trim();
    if (trimmed.length === 0) {
        return { ok: false, message: "fullName cannot be empty" };
    }
    if (trimmed.length > 100) {
        return { ok: false, message: "fullName must be 100 characters or fewer" };
    }
    return { ok: true, value: trimmed };
};

const validateEmail = (value) => {
    if (typeof value !== "string") {
        return { ok: false, message: "email must be a string" };
    }
    const trimmed = value.trim().toLowerCase();
    if (trimmed.length === 0) {
        return { ok: false, message: "email cannot be empty" };
    }
    if (trimmed.length > 255) {
        return { ok: false, message: "email must be 255 characters or fewer" };
    }
    if (!EMAIL_REGEX.test(trimmed)) {
        return { ok: false, message: "Invalid email format" };
    }
    return { ok: true, value: trimmed };
};

const validatePassword = (value, fieldName = "password") => {
    if (typeof value !== "string") {
        return { ok: false, message: `${fieldName} must be a string` };
    }
    if (value.length < 8) {
        return { ok: false, message: `${fieldName} must be at least 8 characters` };
    }
    if (value.length > 255) {
        return { ok: false, message: `${fieldName} must be 255 characters or fewer` };
    }
    return { ok: true, value };
};

const validateRole = (value) => {
    if (typeof value !== "string") {
        return { ok: false, message: "role must be a string" };
    }
    if (!ALLOWED_ROLES.includes(value)) {
        return {
            ok: false,
            message: `role must be one of: ${ALLOWED_ROLES.join(", ")}`
        };
    }
    return { ok: true, value };
};

const validateUserId = (value, fieldName = "id") => {
    const parsed = Number(value);
    if (!Number.isInteger(parsed) || parsed <= 0) {
        return { ok: false, message: `Invalid ${fieldName}` };
    }
    return { ok: true, value: parsed };
};

const validateBoolean = (value, fieldName) => {
    if (typeof value !== "boolean") {
        return { ok: false, message: `${fieldName} must be a boolean` };
    }
    return { ok: true, value };
};

const validateOptionalString = (value, fieldName) => {
    if (value === undefined || value === null) {
        return { ok: true, value: undefined };
    }
    if (typeof value !== "string") {
        return { ok: false, message: `${fieldName} must be a string` };
    }
    return { ok: true, value };
};

// Query-string validators (all optional — return defaults if missing)

const validateSearch = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: undefined };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "search must be a string" };
    }
    if (value.length > 100) {
        return { ok: false, message: "search must be 100 characters or fewer" };
    }
    return { ok: true, value };
};

const validateRoleFilter = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: undefined };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "role filter must be a string" };
    }
    if (!ALLOWED_ROLES.includes(value)) {
        return {
            ok: false,
            message: `role filter must be one of: ${ALLOWED_ROLES.join(", ")}`
        };
    }
    return { ok: true, value };
};

const validateStatusFilter = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: undefined };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "status filter must be a string" };
    }
    if (!ALLOWED_STATUS_FILTERS.includes(value)) {
        return {
            ok: false,
            message: `status filter must be one of: ${ALLOWED_STATUS_FILTERS.join(", ")}`
        };
    }
    return { ok: true, value };
};

const validatePage = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: 1 };
    }
    const parsed = Number(value);
    if (!Number.isInteger(parsed) || parsed < 1) {
        return { ok: false, message: "page must be a positive integer" };
    }
    return { ok: true, value: parsed };
};

const validateLimit = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: 10 };
    }
    const parsed = Number(value);
    if (!Number.isInteger(parsed) || parsed < 1) {
        return { ok: false, message: "limit must be a positive integer" };
    }
    if (parsed > 100) {
        return { ok: false, message: "limit must be 100 or fewer" };
    }
    return { ok: true, value: parsed };
};

module.exports = {
    validateFullName,
    validateEmail,
    validatePassword,
    validateRole,
    validateUserId,
    validateBoolean,
    validateOptionalString,
    validateSearch,
    validateRoleFilter,
    validateStatusFilter,
    validatePage,
    validateLimit
};