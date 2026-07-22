// utils/slug.js
// ============================================================================
// Slug generation utilities for Phase 4 — Content Management.
// Implements the policy in db/schema/phase4_design.md §8.
//
// Conventions:
//   * Lowercase, hyphen-separated, ASCII-only.
//   * Numeric suffix on collision (-2, -3, ...).
//   * Empty result -> fallback to `item-{shortId}`.
//   * Truncation: reserve 4 chars for "-NNN" so base <= 146.
//   * Slug is sticky on rename — set once on create, never re-derived
//     unless the caller explicitly supplies a new slug.
//
// Entity scope:
//   * verticals   — slug is globally unique (no scope).
//   * modules     — slug is unique within (vertical_id).
//   * sections    — slug is unique within (module_id).
//   * content_blocks have no slug.
// ============================================================================

const crypto = require("crypto");
const slugify = require("slugify");
const db = require("../config/db");

const SLUG_REGEX = /^[a-z0-9-]+$/;
const SLUG_MAX_LEN = 150;
const SUFFIX_RESERVE = 4;

// ----------------------------------------------------------------------------
// Pure helpers (no DB).
// ----------------------------------------------------------------------------

// Derive a slug from a name. Returns null if the result would be empty
// (non-Latin / punctuation-only). Caller should apply the fallback in that case.
function deriveFromName(name) {
    if (typeof name !== "string") return null;

    const result = slugify(name, {
        lower: true,
        strict: false,
        replacement: "-",
        trim: true
    });

    // slugify does not collapse consecutive separators by default.
    const collapsed = result.replace(/-+/g, "-");

    return collapsed.length > 0 ? collapsed : null;
}

// Validate the format of a client-supplied slug.
//   - Lowercase letters, digits, hyphens only.
function validateSlugFormat(slug) {
    return typeof slug === "string" && SLUG_REGEX.test(slug);
}

// Truncate a base slug to leave room for a numeric suffix.
// Reserves SUFFIX_RESERVE chars (default 4) for "-NNN".
function truncateForSuffix(base) {
    const maxBase = SLUG_MAX_LEN - SUFFIX_RESERVE;
    return base.length > maxBase ? base.slice(0, maxBase) : base;
}

// Fallback slug for names that produce an empty string after slugify.
// Caller supplies a unique shortId.
function emptySlugFallback(shortId) {
    return `item-${shortId}`;
}

// Short id for empty-slug fallback. 8 chars, base64url (URL-safe).
function generateShortId() {
    return crypto.randomBytes(4).toString("base64url").slice(0, 8);
}

// ----------------------------------------------------------------------------
// DB-aware helpers.
//
// `table` is the content table to query (whitelisted to internal callers —
// controllers pass the table they own; never user input).
//
// `scopeColumn` / `scopeValue` enable parent-scoped uniqueness when set:
//   - modules: { scopeColumn: 'vertical_id', scopeValue: <vertical.id> }
//   - sections: { scopeColumn: 'module_id',   scopeValue: <module.id> }
//   - verticals: omit both for global uniqueness.
//
// `excludeId` is the row's own id when updating; null on create.
// ----------------------------------------------------------------------------

// Resolve a base slug to a unique value among ACTIVE rows in the target table.
async function resolveUniqueSlug({
    table,
    base,
    scopeColumn = null,
    scopeValue = null,
    excludeId = null
}) {
    let suffix = 0;
    let candidate = base;

    while (true) {
        const conditions = ["slug = $1", "deleted_at IS NULL"];
        const params = [candidate];

        if (scopeColumn !== null && scopeValue !== null) {
            conditions.push(`${scopeColumn} = $${params.length + 1}`);
            params.push(scopeValue);
        }
        if (excludeId !== null) {
            conditions.push(`id <> $${params.length + 1}`);
            params.push(excludeId);
        }

        const result = await db.query(
            `SELECT id FROM ${table} WHERE ${conditions.join(" AND ")}`,
            params
        );

        if (result.rows.length === 0) return candidate;

        suffix++;
        candidate = truncateForSuffix(base) + `-${suffix + 1}`;
    }
}

// Generate the final slug for create/update.
// Throws an Error with .status when a client-supplied slug fails format validation.
async function generateUniqueSlug({
    table,
    name,
    clientSlug,
    scopeColumn = null,
    scopeValue = null,
    excludeId = null
}) {
    let base;

    if (clientSlug !== undefined && clientSlug !== null && clientSlug !== "") {
        const trimmed = String(clientSlug).trim();
        if (!validateSlugFormat(trimmed)) {
            const err = new Error(
                "slug must contain only lowercase letters, digits, and hyphens"
            );
            err.status = 400;
            throw err;
        }
        base = trimmed;
    } else {
        const derived = deriveFromName(name);
        base = derived !== null ? derived : emptySlugFallback(generateShortId());
    }

    return resolveUniqueSlug({
        table,
        base,
        scopeColumn,
        scopeValue,
        excludeId
    });
}

module.exports = {
    SLUG_REGEX,
    SLUG_MAX_LEN,
    SUFFIX_RESERVE,
    deriveFromName,
    validateSlugFormat,
    truncateForSuffix,
    emptySlugFallback,
    generateShortId,
    resolveUniqueSlug,
    generateUniqueSlug
};