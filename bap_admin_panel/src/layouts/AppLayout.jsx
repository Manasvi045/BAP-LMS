// layouts/AppLayout.jsx
// =====================================================================
// Authenticated app shell: sidebar + navbar + outlet. The full
// application's content lives inside `<Outlet/>`.
// =====================================================================

import { useState } from "react";
import { Outlet } from "react-router-dom";
import { Sidebar } from "../components/layout/Sidebar";
import { Navbar } from "../components/layout/Navbar";
import { useAuth } from "../features/auth/hooks/useAuth";
import styles from "./AppLayout.module.css";

export function AppLayout() {
    const { user, logout } = useAuth();
    const [mobileOpen, setMobileOpen] = useState(false);

    return (
        <div className={styles.app}>
            <div className={`${styles.sidebar} ${mobileOpen ? styles.sidebarOpen : ""}`}>
                <Sidebar user={user} />
            </div>
            <div className={styles.main}>
                <Navbar
                    user={user}
                    onMenuClick={() => setMobileOpen((v) => !v)}
                    onLogout={logout}
                />
                <main className={styles.content}>
                    <Outlet />
                </main>
            </div>
            {mobileOpen && (
                <div
                    className={styles.backdrop}
                    onClick={() => setMobileOpen(false)}
                    aria-hidden="true"
                />
            )}
        </div>
    );
}