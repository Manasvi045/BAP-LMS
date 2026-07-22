// components/layout/Sidebar.jsx
// =====================================================================
// Primary navigation. Items live as data so we can filter by role.
// Active state is derived from NavLink's `isActive`.
// =====================================================================

import { NavLink } from "react-router-dom";
import {
    LayoutDashboard,
    Users,
    BookOpen,
    Settings,
} from "lucide-react";
import { ROLES, ADMIN_PANEL_ROLES } from "../../utils/constants";
import styles from "./Sidebar.module.css";

const ICON = Object.freeze({
    dashboard: LayoutDashboard,
    users: Users,
    verticals: BookOpen,
    settings: Settings,
});

const NAV_ITEMS = Object.freeze([
    {
        to: "/dashboard",
        label: "Dashboard",
        icon: ICON.dashboard,
        roles: ADMIN_PANEL_ROLES,
    },
    {
        to: "/users",
        label: "Users",
        icon: ICON.users,
        roles: [ROLES.ADMIN],
    },
    {
        to: "/verticals",
        label: "Verticals",
        icon: ICON.verticals,
        roles: ADMIN_PANEL_ROLES,
    },
    {
        to: "/settings",
        label: "Settings",
        icon: ICON.settings,
        roles: [ROLES.ADMIN],
    },
]);

export function Sidebar({ user }) {
    const role = user?.role;
    const items = NAV_ITEMS.filter((item) => item.roles.includes(role));

    return (
        <aside className={styles.sidebar} aria-label="Primary navigation">
            <div className={styles.brand}>
                <span className={styles.brandMark} aria-hidden="true">B</span>
                <span className={styles.brandText}>BAP Admin</span>
            </div>
            <nav className={styles.nav}>
                {items.map((item) => {
                    const Icon = item.icon;
                    return (
                        <NavLink
                            key={item.to}
                            to={item.to}
                            className={({ isActive }) =>
                                `${styles.link} ${isActive ? styles.linkActive : ""}`
                            }
                        >
                            <Icon className={styles.icon} aria-hidden="true" />
                            <span className={styles.label}>{item.label}</span>
                        </NavLink>
                    );
                })}
            </nav>
            <div className={styles.footer}>
                <span className={styles.footerHint}>v0.1 · Phase 1</span>
            </div>
        </aside>
    );
}