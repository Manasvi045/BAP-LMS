// features/dashboard/components/OverviewGrid.jsx
// =====================================================================
// Six-tile overview: total / active / inactive / admins / editors /
// learners. Pulls counts from the normalized stats payload.
// =====================================================================

import {
    Users,
    UserCheck,
    UserX,
    ShieldCheck,
    PencilLine,
    GraduationCap,
} from "lucide-react";
import { StatCard } from "./StatCard";
import styles from "./OverviewGrid.module.css";

export function OverviewGrid({ overview, loading }) {
    const o = overview || {};
    const tiles = [
        {
            icon: Users,
            label: "Total users",
            value: o.totalUsers ?? 0,
            accent: "primary",
            hint: "All accounts on the platform",
        },
        {
            icon: UserCheck,
            label: "Active",
            value: o.activeUsers ?? 0,
            accent: "success",
            hint: "Currently allowed to sign in",
        },
        {
            icon: UserX,
            label: "Inactive",
            value: o.inactiveUsers ?? 0,
            accent: "warning",
            hint: "Deactivated by an admin",
        },
        {
            icon: ShieldCheck,
            label: "Administrators",
            value: o.admins ?? 0,
            accent: "danger",
            hint: "Full access",
        },
        {
            icon: PencilLine,
            label: "Editors",
            value: o.editors ?? 0,
            accent: "info",
            hint: "Content management",
        },
        {
            icon: GraduationCap,
            label: "Learners",
            value: o.learners ?? 0,
            accent: "primary",
            hint: "Use the Flutter app",
        },
    ];

    return (
        <div className={styles.grid}>
            {tiles.map((tile) => (
                <StatCard
                    key={tile.label}
                    icon={tile.icon}
                    label={tile.label}
                    value={tile.value}
                    accent={tile.accent}
                    hint={tile.hint}
                    loading={loading}
                />
            ))}
        </div>
    );
}