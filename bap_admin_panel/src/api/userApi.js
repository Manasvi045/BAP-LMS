// api/userApi.js
// =====================================================================
// User CRUD endpoints. Backend returns users with `full_name` and
// `is_active` snake-case — normalize to `name` + `isActive` (Date
// instances for timestamps) so the rest of the app uses a single
// shape.
// =====================================================================

import { apiClient } from "./client";

function normalizeUser(u) {
    if (!u) return u;
    return {
        id: u.id,
        email: u.email,
        role: u.role,
        isActive: u.is_active ?? u.isActive ?? true,
        mustChangePassword: !!u.must_change_password,
        name: u.name ?? u.full_name ?? u.fullName ?? null,
        createdAt: u.created_at ? new Date(u.created_at) : null,
        updatedAt: u.updated_at ? new Date(u.updated_at) : null,
    };
}

export const userApi = {
    async list({
        search,
        role,
        status,
        page = 1,
        limit = 10,
    } = {}) {
        const res = await apiClient.get("/users", {
            params: {
                search: search || undefined,
                role: role || undefined,
                status: status || undefined,
                page,
                limit,
            },
        });
        const data = res.data || {};
        return {
            pagination: data.pagination || null,
            data: Array.isArray(data.data) ? data.data.map(normalizeUser) : [],
        };
    },

    async getById(id) {
        const res = await apiClient.get(`/users/${id}`);
        return normalizeUser(res.data?.data);
    },

    /** Admin-only user creation. Backend accepts
     *  { fullName, email, role, password? } on POST /api/admin/create-user.
     *  If `password` is omitted, the backend auto-generates a secure
     *  temporary password and returns it as `temporaryPassword` in the
     *  success body. Returns `{ user, temporaryPassword? }`.
     */
    async create({ fullName, email, password, role }) {
        const body = { fullName, email, role };
        if (password !== undefined && password !== null && password !== "") {
            body.password = password;
        }
        const res = await apiClient.post("/admin/create-user", body);
        return {
            user: normalizeUser(res.data?.user),
            temporaryPassword: res.data?.temporaryPassword || null,
        };
    },

    async update(id, { fullName, email, role }) {
        const body = { fullName, email };
        if (role !== undefined && role !== null && role !== "") {
            body.role = role;
        }
        const res = await apiClient.put(`/users/${id}`, body);
        return normalizeUser(res.data?.data);
    },

    async updateStatus(id, isActive) {
        const res = await apiClient.patch(`/users/${id}/status`, { isActive });
        return normalizeUser(res.data?.data);
    },

    async resetPassword(id, newPassword) {
        const res = await apiClient.patch(`/users/${id}/password`, {
            newPassword: newPassword || undefined,
        });
        // Server returns { success, message, temporaryPassword }.
        return {
            message: res.data?.message,
            temporaryPassword: res.data?.temporaryPassword,
        };
    },
};
