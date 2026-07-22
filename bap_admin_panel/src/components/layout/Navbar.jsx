// components/layout/Navbar.jsx
// =====================================================================
// Top bar for the authenticated app shell. Hosts the sidebar toggle, the
// page title (set by the route), and the user profile menu.
// =====================================================================

import { Menu, Sun, Moon } from "lucide-react";
import { useTheme } from "../../contexts/ThemeContext";
import { ROLE_LABELS } from "../../utils/constants";
import { ProfileMenu } from "./ProfileMenu";
import styles from "./Navbar.module.css";

export function Navbar({ user, onMenuClick, onLogout }) {
    const { theme, toggleTheme } = useTheme();

    return (
        <header className={styles.navbar}>
            <div className={styles.left}>
                <button
                    type="button"
                    className={styles.iconButton}
                    aria-label="Toggle navigation"
                    onClick={onMenuClick}
                >
                    <Menu className={styles.icon} />
                </button>
                <div className={styles.user}>
                    <span className={styles.userName}>{user?.name || user?.email}</span>
                    <span className={styles.userRole}>
                        {ROLE_LABELS[user?.role] || user?.role}
                    </span>
                </div>
            </div>

            <div className={styles.right}>
                <button
                    type="button"
                    className={styles.iconButton}
                    aria-label="Toggle theme"
                    onClick={toggleTheme}
                >
                    {theme === "dark" ? (
                        <Sun className={styles.icon} />
                    ) : (
                        <Moon className={styles.icon} />
                    )}
                </button>
                <ProfileMenu user={user} onLogout={onLogout} />
            </div>
        </header>
    );
}