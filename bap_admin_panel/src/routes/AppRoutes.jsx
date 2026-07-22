// routes/AppRoutes.jsx
// =====================================================================
// All in-app routes. Authenticated routes are wrapped in ProtectedRoute
// (which also enforces role-based access). Public routes use the
// AuthLayout centered-card layout.
// =====================================================================

import { Routes, Route, Navigate } from "react-router-dom";
import { AppLayout } from "../layouts/AppLayout";
import { AuthLayout } from "../layouts/AuthLayout";
import { LoginPage } from "../features/auth/pages/LoginPage";
import { DashboardPage } from "../pages/DashboardPage";
import { NotFoundPage } from "../pages/NotFoundPage";
import { UnauthorizedPage } from "../pages/UnauthorizedPage";
import { ProtectedRoute } from "./ProtectedRoute";
import { UsersPage } from "../features/users/pages/UsersPage";
import { ADMIN_PANEL_ROLES, USER_MGMT_ROLES } from "../utils/constants";

export function AppRoutes() {
    return (
        <Routes>
            {/* Public auth routes */}
            <Route element={<AuthLayout />}>
                <Route path="/login" element={<LoginPage />} />
            </Route>

            {/* Standalone error pages */}
            <Route path="/unauthorized" element={<UnauthorizedPage />} />
            <Route path="/404" element={<NotFoundPage />} />

            {/* Authenticated app routes */}
            <Route element={<ProtectedRoute roles={ADMIN_PANEL_ROLES} />}>
                <Route element={<AppLayout />}>
                    <Route path="/dashboard" element={<DashboardPage />} />

                    {/* Phase 3 — User Management (admin only) */}
                    <Route element={<ProtectedRoute roles={USER_MGMT_ROLES} />}>
                        <Route path="/users" element={<UsersPage />} />
                    </Route>

                    {/* Phase 4+ placeholders */}
                    <Route path="/verticals" element={<DashboardPage />} />
                    <Route path="/settings" element={<DashboardPage />} />
                </Route>
            </Route>

            {/* Index → dashboard for authed users, otherwise login */}
            <Route
                path="/"
                element={<Navigate to="/dashboard" replace />}
            />

            {/* Catch-all */}
            <Route path="*" element={<NotFoundPage />} />
        </Routes>
    );
}