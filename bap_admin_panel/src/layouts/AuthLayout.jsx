// layouts/AuthLayout.jsx
// =====================================================================
// Centered card layout for unauthenticated pages (login, etc.).
// =====================================================================

import { Outlet } from "react-router-dom";
import { useTheme } from "../contexts/ThemeContext";
import { Sun, Moon } from "lucide-react";
import styles from "./AuthLayout.module.css";

export function AuthLayout() {
    const { theme, toggleTheme } = useTheme();

    return (
        <div className={styles.wrapper}>
            <button
                type="button"
                className={styles.themeToggle}
                aria-label="Toggle theme"
                onClick={toggleTheme}
            >
                {theme === "dark" ? (
                    <Sun className={styles.icon} />
                ) : (
                    <Moon className={styles.icon} />
                )}
            </button>
            <div className={styles.card}>
                <div className={styles.brand}>
                    <span className={styles.brandMark} aria-hidden="true">B</span>
                    <span className={styles.brandText}>BAP Admin</span>
                </div>
                <Outlet />
            </div>
            <footer className={styles.footer}>
                <span>© 2026 BAP · All rights reserved</span>
            </footer>
        </div>
    );
}