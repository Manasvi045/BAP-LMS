// api/authApi.js
// =====================================================================
// Auth-related API calls. Backend shape:
//   POST /api/auth/login     -> { success, message, token, mustChangePassword, user }
//   POST /api/auth/register  -> { success, message, user }        (no token by default)
//   POST /api/auth/change-password -> { success, message }
// (No /me endpoint exists yet — front-end tracks user from login response
//  and falls back to JWT payload for auto-login.)
// =====================================================================

import { apiClient } from "./client";

/** Normalize backend user shape (fullName) into the front-end
 *  canonical shape (`name`) so every component reads the same field.
 */
function normalizeUser(u) {
    if (!u) return u;
    return {
        id: u.id,
        email: u.email,
        role: u.role,
        name: u.name ?? u.fullName ?? u.full_name ?? null,
        mustChangePassword: !!u.mustChangePassword,
    };
}

export const authApi = {
    /** Login with email + password. Returns the normalized response. */
    async login({ email, password }) {
        const res = await apiClient.post("/auth/login", { email, password });
        const data = res.data || {};
        return {
            ...data,
            user: normalizeUser(data.user),
        };
    },

    /** Self-service password change. Backend verifies `currentPassword`
     *  against the caller's hash (taken from the JWT — so this can only
     *  ever change the caller's own password, never someone else's) and
     *  then hashes + stores `newPassword`. Also clears
     *  `must_change_password` so a forced rotation gets satisfied. */
    async changePassword({ currentPassword, newPassword, confirmPassword }) {
        const res = await apiClient.post("/auth/change-password", {
            currentPassword,
            newPassword,
            confirmPassword,
        });
        return { message: res.data?.message || "Password updated." };
    },

    /** Decode JWT payload (no signature verification — server validates that
     *  on every call). Returns the payload object or null on parse failure.
     */
    decodeToken(token) {
        if (!token || typeof token !== "string") return null;
        try {
            const parts = token.split(".");
            if (parts.length < 2) return null;
            // base64url -> base64 (replace URL-safe chars, pad to multiple of 4)
            let payload = parts[1].replace(/-/g, "+").replace(/_/g, "/");
            while (payload.length % 4 !== 0) {
                payload += "=";
            }
            const decoded = JSON.parse(atob(payload));
            return decoded;
        } catch {
            return null;
        }
    },

    /** True if the JWT is still within its `exp` window (with a 30s skew). */
    isTokenValid(token, skewSeconds = 30) {
        const decoded = this.decodeToken(token);
        if (!decoded || typeof decoded.exp !== "number") return false;
        const nowSec = Math.floor(Date.now() / 1000);
        return decoded.exp > nowSec - skewSeconds;
    },
};
