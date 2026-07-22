// utils/storage.js
// =====================================================================
// Typed wrappers around localStorage. Every value goes in/out as JSON.
// Keeps a single namespace prefix so we don't collide with anything else
// the user might have in their browser storage.
// =====================================================================

const PREFIX = "bap:";

function key(name) {
    return PREFIX + name;
}

function safeParse(raw, fallback) {
    if (raw == null) return fallback;
    try {
        return JSON.parse(raw);
    } catch {
        return fallback;
    }
}

export const storage = {
    getToken() {
        return safeParse(localStorage.getItem(key("token")), null);
    },

    setToken(token) {
        if (token == null) {
            localStorage.removeItem(key("token"));
        } else {
            localStorage.setItem(key("token"), JSON.stringify(token));
        }
    },

    getUser() {
        return safeParse(localStorage.getItem(key("user")), null);
    },

    setUser(user) {
        if (user == null) {
            localStorage.removeItem(key("user"));
        } else {
            localStorage.setItem(key("user"), JSON.stringify(user));
        }
    },

    getTheme() {
        return localStorage.getItem(key("theme")) || "light";
    },

    setTheme(theme) {
        localStorage.setItem(key("theme"), theme);
    },

    /** Clear auth-related keys (token + user) but preserve theme. */
    clearAuth() {
        localStorage.removeItem(key("token"));
        localStorage.removeItem(key("user"));
    },

    /** Wipe everything bap-prefixed (used on hard reset / logout-all). */
    clearAll() {
        for (const k of Object.keys(localStorage)) {
            if (k.startsWith(PREFIX)) localStorage.removeItem(k);
        }
    },
};
