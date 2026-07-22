// api/dashboardApi.js
// =====================================================================
// Dashboard data fetches.
// Contract: GET /api/dashboard/stats (admin-only, see backend).
// The response is normalized here so components can rely on `name`,
// `Date` instances, and camelCase throughout.
// =====================================================================

import { apiClient } from "./client";

function normalizeUser(u) {
    if (!u) return u;
    return {
        id: u.id,
        email: u.email,
        role: u.role,
        isActive: u.is_active ?? u.isActive ?? true,
        // Backend uses `full_name`; components expect `name`.
        name: u.name ?? u.full_name ?? u.fullName ?? null,
        createdAt: u.created_at ? new Date(u.created_at) : null,
    };
}

function normalizeStats(data) {
    return {
        snapshotTime: data.snapshotTime ? new Date(data.snapshotTime) : new Date(),
        overview: data.overview || {},
        recentUsers: Array.isArray(data.recentUsers)
            ? data.recentUsers.map(normalizeUser)
            : [],
        content: data.content || {},
        media: data.media || {},
        learning: data.learning || {},
    };
}

export const dashboardApi = {
    async getStats() {
        const res = await apiClient.get("/dashboard/stats");
        return normalizeStats(res.data || {});
    },
};
