// api/client.js
// =====================================================================
// Axios instance used by every API call in the app.
//
// Responsibilities:
//   * attach `Authorization: Bearer <token>` if a token exists in storage
//   * on 401 responses, clear auth storage and emit a global
//     `bap:auth:expired` event so AuthContext can react (logout + redirect)
//   * normalize backend error envelopes into Error objects with a `.message`
//     and an optional `.code` / `.status`
// =====================================================================

import axios from "axios";
import { storage } from "../utils/storage";

const baseURL = import.meta.env.VITE_API_BASE_URL || "http://localhost:5000/api";

export const AUTH_EXPIRED_EVENT = "bap:auth:expired";

export const apiClient = axios.create({
    baseURL,
    headers: {
        "Content-Type": "application/json",
    },
    timeout: 30_000,
});

apiClient.interceptors.request.use((config) => {
    const token = storage.getToken();
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        const status = error.response?.status;
        const message =
            error.response?.data?.message ||
            error.message ||
            "Network error";

        if (status === 401) {
            // Clear auth storage and let the AuthContext react.
            storage.clearAuth();
            window.dispatchEvent(new CustomEvent(AUTH_EXPIRED_EVENT));
        }

        const wrapped = new Error(message);
        wrapped.status = status;
        wrapped.code = error.response?.data?.code;
        wrapped.original = error;
        return Promise.reject(wrapped);
    }
);
