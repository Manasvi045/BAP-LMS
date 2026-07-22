// utils/validators/contentBlock.js
// ============================================================================
// Input validators for the Content Block entity.
//
// Distinct from V/M/S:
//   * No name, no slug, no description, no metadata column, no status.
//   * Visibility flows from the parent section's status.
//   * `type` must be in ALLOWED_BLOCK_TYPES (validated against the constant
//     exported by ./blockType).
//   * `content` is a JSONB payload whose shape depends on `type`.
//
// v1 payload shapes:
//
//   text:
//     { markdown: string (1..50000 chars) }
//     optional: { }   (only markdown)
//
//   image:
//     { url: string (1..2048 chars) }
//     optional: alt?: string, caption?: string
//
//   video:
//     { url: string (1..2048 chars) }
//     optional: duration?: number >= 0
//
//   quiz:
//     {
//       questions: [
//         {
//           prompt: string (1..500 chars),
//           options: [ { text: string (1..500 chars) }, ... ]   (>= 2 options)
//         }
//       ]
//     }
//     1..100 questions per block.
// ============================================================================

const { isAllowedBlockType } = require("./blockType");

// ----------------------------------------------------------------------------
// Common helpers
// ----------------------------------------------------------------------------

const validateId = (value, fieldName = "id") => {
    const parsed = Number(value);
    if (!Number.isInteger(parsed) || parsed <= 0) {
        return { ok: false, message: `Invalid ${fieldName}` };
    }
    return { ok: true, value: parsed };
};

const validateContentBlockId = (value) => validateId(value, "id");

const validateSectionIdRequired = (value) => {
    if (value === undefined || value === null) {
        return { ok: false, message: "sectionId is required" };
    }
    return validateId(value, "sectionId");
};

const validateSectionIdOptional = (value) => {
    if (value === undefined || value === null) {
        return { ok: true, value: null };
    }
    return validateId(value, "sectionId");
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

// Optional type filter on list endpoints.
// Returns { ok, value: null|allowed-type, message }.
const validateTypeFilter = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: null };
    }
    if (!isAllowedBlockType(value)) {
        return {
            ok: false,
            message: `type must be one of: text, image, video, quiz`
        };
    }
    return { ok: true, value };
};

// ----------------------------------------------------------------------------
// Per-type content payload validators
// ----------------------------------------------------------------------------

function validateObjectContent(content) {
    if (content === undefined || content === null) return false;
    return typeof content === "object" && !Array.isArray(content);
}

function validateTextContent(content) {
    if (!validateObjectContent(content)) {
        return { ok: false, message: "content must be a JSON object" };
    }
    if (typeof content.markdown !== "string") {
        return { ok: false, message: "content.markdown must be a string" };
    }
    const md = content.markdown;
    if (md.trim().length === 0) {
        return { ok: false, message: "content.markdown cannot be empty" };
    }
    if (md.length > 50000) {
        return { ok: false, message: "content.markdown must be 50000 characters or fewer" };
    }
    return { ok: true, value: content };
}

function validateImageContent(content) {
    if (!validateObjectContent(content)) {
        return { ok: false, message: "content must be a JSON object" };
    }
    if (typeof content.url !== "string") {
        return { ok: false, message: "content.url must be a string" };
    }
    if (content.url.trim().length === 0) {
        return { ok: false, message: "content.url cannot be empty" };
    }
    if (content.url.length > 2048) {
        return { ok: false, message: "content.url must be 2048 characters or fewer" };
    }
    if (content.alt !== undefined && typeof content.alt !== "string") {
        return { ok: false, message: "content.alt must be a string" };
    }
    if (content.caption !== undefined && typeof content.caption !== "string") {
        return { ok: false, message: "content.caption must be a string" };
    }
    return { ok: true, value: content };
}

function validateVideoContent(content) {
    if (!validateObjectContent(content)) {
        return { ok: false, message: "content must be a JSON object" };
    }
    if (typeof content.url !== "string") {
        return { ok: false, message: "content.url must be a string" };
    }
    if (content.url.trim().length === 0) {
        return { ok: false, message: "content.url cannot be empty" };
    }
    if (content.url.length > 2048) {
        return { ok: false, message: "content.url must be 2048 characters or fewer" };
    }
    if (content.duration !== undefined && content.duration !== null) {
        if (typeof content.duration !== "number" || !Number.isFinite(content.duration) || content.duration < 0) {
            return { ok: false, message: "content.duration must be a non-negative number" };
        }
    }
    return { ok: true, value: content };
}

function validateQuizContent(content) {
    if (!validateObjectContent(content)) {
        return { ok: false, message: "content must be a JSON object" };
    }
    if (!Array.isArray(content.questions)) {
        return { ok: false, message: "content.questions must be an array" };
    }
    if (content.questions.length === 0) {
        return { ok: false, message: "content.questions must have at least 1 question" };
    }
    if (content.questions.length > 100) {
        return { ok: false, message: "content.questions must have 100 or fewer questions" };
    }
    for (let qi = 0; qi < content.questions.length; qi++) {
        const q = content.questions[qi];
        if (typeof q !== "object" || q === null || Array.isArray(q)) {
            return { ok: false, message: `questions[${qi}] must be an object` };
        }
        if (typeof q.prompt !== "string" || q.prompt.trim().length === 0) {
            return { ok: false, message: `questions[${qi}].prompt must be a non-empty string` };
        }
        if (q.prompt.length > 500) {
            return { ok: false, message: `questions[${qi}].prompt must be 500 characters or fewer` };
        }
        if (!Array.isArray(q.options)) {
            return { ok: false, message: `questions[${qi}].options must be an array` };
        }
        if (q.options.length < 2) {
            return { ok: false, message: `questions[${qi}].options must have at least 2 options` };
        }
        for (let oi = 0; oi < q.options.length; oi++) {
            const opt = q.options[oi];
            if (typeof opt !== "object" || opt === null || Array.isArray(opt)) {
                return { ok: false, message: `questions[${qi}].options[${oi}] must be an object` };
            }
            if (typeof opt.text !== "string" || opt.text.trim().length === 0) {
                return { ok: false, message: `questions[${qi}].options[${oi}].text must be a non-empty string` };
            }
            if (opt.text.length > 500) {
                return { ok: false, message: `questions[${qi}].options[${oi}].text must be 500 characters or fewer` };
            }
        }
    }
    return { ok: true, value: content };
}

// Dispatch on type. Returns {ok, value, message}.
function validateContentByType(type, content) {
    if (!isAllowedBlockType(type)) {
        return { ok: false, message: `unsupported type: ${type}` };
    }
    switch (type) {
        case "text":  return validateTextContent(content);
        case "image": return validateImageContent(content);
        case "video": return validateVideoContent(content);
        case "quiz":  return validateQuizContent(content);
        default:      return { ok: false, message: `unsupported type: ${type}` };
    }
}

module.exports = {
    validateContentBlockId,
    validateSectionIdRequired,
    validateSectionIdOptional,
    validateDisplayOrder,
    validateTypeFilter,
    validateContentByType
};