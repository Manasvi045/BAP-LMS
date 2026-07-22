// contexts/AuthContext.jsx
// =====================================================================
// Authentication context. Single source of truth for `user`, `token`,
// `isAuthenticated`, and `mustChangePassword` for the whole admin panel.
//
// Boot sequence:
//   1. Read token + user from localStorage synchronously (instant render).
//   2. Validate the JWT `exp` (with a small skew). If expired/invalid,
//      clear storage and stay unauthenticated — no network round-trip.
//   3. Expose `login()` / `logout()` to mutate state.
//
// We deliberately do NOT call a /me endpoint here (the backend has none in
// v1). The login response carries the full user object, and the JWT
// contains id+email+role. That's enough for the admin panel's needs.
// =====================================================================

import {
    createContext,
    useCallback,
    useContext,
    useEffect,
    useMemo,
    useState,
} from "react";
import { storage } from "../utils/storage";
import { authApi } from "../api/authApi";
import { AUTH_EXPIRED_EVENT } from "../api/client";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
    // Initial state pulled synchronously from storage so the first render
    // already knows whether the user is signed in.
    const [token, setToken] = useState(() => storage.getToken());
    const [user, setUser] = useState(() => storage.getUser());
    const [ready, setReady] = useState(true); // Synchronous boot — no spinner needed.

    // ---- login / logout -------------------------------------------------

    const login = useCallback(async ({ email, password }) => {
        const data = await authApi.login({ email, password });
        if (!data?.token || !data?.user) {
            throw new Error("Login response missing token or user");
        }
        storage.setToken(data.token);
        storage.setUser(data.user);
        setToken(data.token);
        setUser(data.user);
        return data.user;
    }, []);

    const logout = useCallback(() => {
        storage.clearAuth();
        setToken(null);
        setUser(null);
    }, []);

    // ---- JWT expiry validation on mount + on token change ---------------

    useEffect(() => {
        if (!token) return;
        if (!authApi.isTokenValid(token)) {
            // Expired before any API call was made.
            storage.clearAuth();
            setToken(null);
            setUser(null);
        }
    }, [token]);

    // ---- global 401 listener (from axios interceptor) -------------------

    useEffect(() => {
        const handler = () => {
            setToken(null);
            setUser(null);
        };
        window.addEventListener(AUTH_EXPIRED_EVENT, handler);
        return () => window.removeEventListener(AUTH_EXPIRED_EVENT, handler);
    }, []);

    // ---- derived state --------------------------------------------------

    const value = useMemo(
        () => ({
            user,
            token,
            isAuthenticated: !!token && !!user,
            ready,
            login,
            logout,
        }),
        [user, token, ready, login, logout]
    );

    return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuthContext() {
    const ctx = useContext(AuthContext);
    if (!ctx) {
        throw new Error("useAuthContext must be used within <AuthProvider>");
    }
    return ctx;
}