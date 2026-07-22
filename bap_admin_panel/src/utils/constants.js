// utils/constants.js
// =====================================================================
// Single source of truth for cross-cutting constants.
// =====================================================================

export const APP_NAME = import.meta.env.VITE_APP_NAME || "BAP Admin";

export const ROLES = Object.freeze({
    ADMIN: "admin",
    EDITOR: "editor",
    USER: "user",
});

export const ROLE_LABELS = Object.freeze({
    [ROLES.ADMIN]: "Administrator",
    [ROLES.EDITOR]: "Editor",
    [ROLES.USER]: "Learner",
});

// Roles allowed to use the admin panel at all.
// The "user" (learner) role is intentionally NOT included — they consume
// content via the Flutter app, not via this panel.
export const ADMIN_PANEL_ROLES = Object.freeze([ROLES.ADMIN, ROLES.EDITOR]);

// Roles allowed to access User Management.
export const USER_MGMT_ROLES = Object.freeze([ROLES.ADMIN]);

export const QUERY_KEYS = Object.freeze({
    ME: ["auth", "me"],
    DASHBOARD_STATS: ["dashboard", "stats"],
    USERS: ["users"],
    USER: (id) => ["users", "detail", id],
});

export const STORAGE_KEYS = Object.freeze({
    TOKEN: "bap:token",
    USER: "bap:user",
    THEME: "bap:theme",
});

// Filter values accepted by GET /api/users.
export const USER_FILTER_ROLES = Object.freeze([
    ROLES.ADMIN,
    ROLES.EDITOR,
    ROLES.USER,
]);

export const USER_FILTER_STATUSES = Object.freeze(["active", "inactive"]);

export const USER_PAGE_SIZE = 10;
