// pages/DashboardPage.jsx
// =====================================================================
// Role-aware dashboard. Admins see the live stats from /api/dashboard/
// stats; editors get a soft landing that links into Verticals (the
// /api/dashboard/stats endpoint is admin-only, so editors cannot hit
// it). The branch happens here so the route stays single and stable.
// =====================================================================

import { AlertTriangle } from "lucide-react";
import { useAuth } from "../features/auth/hooks/useAuth";
import { useDashboardStats } from "../features/dashboard/hooks/useDashboardStats";
import { OverviewGrid } from "../features/dashboard/components/OverviewGrid";
import { RecentUsersCard } from "../features/dashboard/components/RecentUsersCard";
import { MetricsPlaceholderCard } from "../features/dashboard/components/MetricsPlaceholderCard";
import { EditorLanding } from "../features/dashboard/components/EditorLanding";
import { ROLES, ROLE_LABELS } from "../utils/constants";
import styles from "./DashboardPage.module.css";

function AdminDashboard() {
    const stats = useDashboardStats();
    if (stats.isError) {
        return (
            <div className={styles.errorCard} role="alert">
                <AlertTriangle className={styles.errorIcon} aria-hidden="true" />
                <div>
                    <h2 className={styles.errorTitle}>
                        Couldn't load dashboard stats
                    </h2>
                    <p className={styles.errorText}>
                        {stats.error?.message || "Network error. Try again."}
                    </p>
                </div>
            </div>
        );
    }

    const data = stats.data;
    return (
        <>
            <OverviewGrid overview={data?.overview} loading={stats.isLoading} />
            <div className={styles.row}>
                <RecentUsersCard
                    users={data?.recentUsers}
                    loading={stats.isLoading}
                />
                <MetricsPlaceholderCard
                    content={data?.content}
                    media={data?.media}
                    learning={data?.learning}
                />
            </div>
            {data?.snapshotTime && (
                <p className={styles.snapshotHint}>
                    Snapshot from{" "}
                    {data.snapshotTime.toLocaleString(undefined, {
                        dateStyle: "medium",
                        timeStyle: "short",
                    })}
                </p>
            )}
        </>
    );
}

export function DashboardPage() {
    const { user } = useAuth();
    const isAdmin = user?.role === ROLES.ADMIN;

    return (
        <div className={styles.page}>
            <header className={styles.header}>
                <h1 className={styles.title}>Dashboard</h1>
                <p className={styles.subtitle}>
                    Welcome back, {user?.name || user?.email}. You are signed
                    in as <strong>{ROLE_LABELS[user?.role] || user?.role}</strong>.
                </p>
            </header>

            {isAdmin ? <AdminDashboard /> : <EditorLanding user={user} />}
        </div>
    );
}