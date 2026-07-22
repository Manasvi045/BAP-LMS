// components/layout/ProfileMenu.jsx
// =====================================================================
// Avatar + dropdown. Triggering element shows the user's initials.
// Menu lists the email, a "Change password" action, and Sign-out.
//
// Change password is a self-service flow: any signed-in user (admin or
// editor) can open it from here. The modal calls
// POST /api/auth/change-password, which derives the user id from the
// JWT — so even an admin can't use this dialog to change someone
// else's password.
// =====================================================================

import { useEffect, useRef, useState } from "react";
import { KeyRound, LogOut } from "lucide-react";
import { ROLE_LABELS } from "../../utils/constants";
import { ChangePasswordModal } from "../../features/auth/components/ChangePasswordModal";
import styles from "./ProfileMenu.module.css";

function initialsFrom(user) {
    if (!user) return "?";
    const source = user.name || user.email || "";
    return source
        .split(/\s+/)
        .filter(Boolean)
        .map((p) => p[0].toUpperCase())
        .slice(0, 2)
        .join("") || "?";
}

export function ProfileMenu({ user, onLogout }) {
    const [open, setOpen] = useState(false);
    const [changePasswordOpen, setChangePasswordOpen] = useState(false);
    const rootRef = useRef(null);

    useEffect(() => {
        function onDocClick(e) {
            if (rootRef.current && !rootRef.current.contains(e.target)) {
                setOpen(false);
            }
        }
        function onKey(e) {
            if (e.key === "Escape") setOpen(false);
        }
        document.addEventListener("mousedown", onDocClick);
        document.addEventListener("keydown", onKey);
        return () => {
            document.removeEventListener("mousedown", onDocClick);
            document.removeEventListener("keydown", onKey);
        };
    }, []);

    function handleLogout() {
        setOpen(false);
        if (onLogout) onLogout();
    }

    function handleChangePassword() {
        setOpen(false);
        setChangePasswordOpen(true);
    }

    return (
        <>
            <div className={styles.root} ref={rootRef}>
                <button
                    type="button"
                    className={styles.avatar}
                    aria-haspopup="menu"
                    aria-expanded={open}
                    onClick={() => setOpen((v) => !v)}
                >
                    {initialsFrom(user)}
                </button>
                {open && (
                    <div className={styles.menu} role="menu">
                        <div className={styles.header}>
                            <span className={styles.headerName}>
                                {user?.name || "Signed in"}
                            </span>
                            <span className={styles.headerEmail}>{user?.email}</span>
                            <span className={styles.headerRole}>
                                {ROLE_LABELS[user?.role] || user?.role}
                            </span>
                        </div>
                        <button
                            type="button"
                            role="menuitem"
                            className={styles.menuItem}
                            onClick={handleChangePassword}
                        >
                            <KeyRound
                                className={styles.menuIcon}
                                aria-hidden="true"
                            />
                            Change password
                        </button>
                        <button
                            type="button"
                            role="menuitem"
                            className={styles.menuItem}
                            onClick={handleLogout}
                        >
                            <LogOut className={styles.menuIcon} aria-hidden="true" />
                            Sign out
                        </button>
                    </div>
                )}
            </div>
            <ChangePasswordModal
                open={changePasswordOpen}
                onClose={() => setChangePasswordOpen(false)}
            />
        </>
    );
}