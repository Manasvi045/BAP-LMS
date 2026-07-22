// routes/ProtectedRoute.jsx
// =====================================================================
// Route guard: requires an authenticated user. Optionally accepts a list
// of allowed roles; if the user lacks one, redirect to /unauthorized.
// =====================================================================

import { Navigate, Outlet, useLocation } from "react-router-dom";
import { useAuth } from "../features/auth/hooks/useAuth";

export function ProtectedRoute({ roles }) {
    const { user, ready } = useAuth();
    const location = useLocation();

    if (!ready) return null;

    if (!user) {
        return <Navigate to="/login" replace state={{ from: location }} />;
    }
    if (Array.isArray(roles) && roles.length > 0 && !roles.includes(user.role)) {
        return <Navigate to="/unauthorized" replace />;
    }
    return <Outlet />;
}