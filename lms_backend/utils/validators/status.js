// utils/validators/status.js
// ============================================================================
// Status validation + publishing state machine (Phase 4.6).
//
// Allowed statuses: draft | review | published | archived.
// Defined in db/schema/phase4_design.md §7 (locked decision #7).
//
// Locked decision #18 — state machine.
//
//   from      to          requiredRole
//   draft     draft       -              (no-op, idempotent)
//   draft     review      -              (submit)
//   review    draft       -              (reject/recall)
//   review    review      -              (no-op)
//   review    published   admin          (approve/publish)
//   published draft       admin          (unpublish/recall)
//   published published   -              (no-op)
//   published archived    admin          (archive)
//   archived  draft       admin          (unarchive/restore)
//   archived  archived    -              (no-op)
//
// Anything not in this table is rejected (400 "illegal transition").
// Role-gated transitions return 403 when attempted by the wrong role.
// Locked decision #19 — status on create is always 'draft'; body field ignored.
// Locked decision #20 — published_at / published_by populated on transitions
// into 'published'; preserved across unpublish / archive cycles.
//
// Used by controllers/verticalController.js, controllers/moduleController.js,
// controllers/sectionController.js to gate PUT status updates.
// ============================================================================

const ALLOWED_STATUSES = ["draft", "review", "published", "archived"];

const isAllowedStatus = (value) => {
    return typeof value === "string" && ALLOWED_STATUSES.includes(value);
};

// Validate a status value supplied in a request body (POST or PUT).
// Undefined / null / empty -> {ok: true, value: null} (signals "no field").
const validateStatus = (value) => {
    if (value === undefined || value === null || value === "") {
        return { ok: true, value: null };
    }
    if (typeof value !== "string") {
        return { ok: false, message: "status must be a string" };
    }
    if (!isAllowedStatus(value)) {
        return {
            ok: false,
            message: `status must be one of: ${ALLOWED_STATUSES.join(", ")}`
        };
    }
    return { ok: true, value };
};

// State machine: from -> to => required role (null = any role).
const TRANSITIONS = {
    draft:     { draft: null,    review: null },
    review:    { draft: null,    review: null, published: "admin" },
    published: { draft: "admin", published: null, archived: "admin" },
    archived:  { draft: "admin", archived: null }
};

// Validate a status transition against the state machine + role rules.
// Caller supplies req.user.role (e.g. "admin" or "editor").
// Returns {ok: true, value: <target status>} on success.
// On illegal pair (not in TRANSITIONS) -> {ok: false, message: ...} (=> 400).
// On insufficient role (correct pair, wrong role) -> {ok: false, message: "Only X can ..."} (=> 403).
const validateStatusTransition = ({ from, to, role }) => {
    if (!isAllowedStatus(from)) {
        return { ok: false, message: `invalid current status: ${from}` };
    }
    if (!isAllowedStatus(to)) {
        return {
            ok: false,
            message: `status must be one of: ${ALLOWED_STATUSES.join(", ")}`
        };
    }
    const fromMap = TRANSITIONS[from];
    if (!Object.prototype.hasOwnProperty.call(fromMap, to)) {
        return {
            ok: false,
            message: `illegal status transition: ${from} -> ${to}`
        };
    }
    const requiredRole = fromMap[to];
    if (requiredRole !== null && role !== requiredRole) {
        return {
            ok: false,
            message: `Only ${requiredRole}s can transition status from ${from} to ${to}`
        };
    }
    return { ok: true, value: to };
};

module.exports = {
    ALLOWED_STATUSES,
    isAllowedStatus,
    validateStatus,
    validateStatusTransition
};
