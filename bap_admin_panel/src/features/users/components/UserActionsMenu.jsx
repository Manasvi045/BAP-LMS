// features/users/components/UserActionsMenu.jsx
// =====================================================================
// Dropdown menu next to each user row. Items are passed as data so the
// parent controls what each row can do. Closes on outside click and
// ESC.
// =====================================================================

import { useEffect, useRef, useState } from "react";
import { MoreHorizontal } from "lucide-react";
import styles from "./UserActionsMenu.module.css";

export function UserActionsMenu({ items = [], label = "Actions" }) {
    const [open, setOpen] = useState(false);
    const rootRef = useRef(null);

    useEffect(() => {
        if (!open) return undefined;
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
    }, [open]);

    if (items.length === 0) return null;

    return (
        <div className={styles.root} ref={rootRef}>
            <button
                type="button"
                className={styles.trigger}
                aria-haspopup="menu"
                aria-expanded={open}
                aria-label={label}
                onClick={() => setOpen((v) => !v)}
            >
                <MoreHorizontal className={styles.triggerIcon} aria-hidden="true" />
            </button>
            {open && (
                <div className={styles.menu} role="menu">
                    {items.map((item, i) => {
                        const Icon = item.icon;
                        return (
                            <button
                                key={i}
                                type="button"
                                role="menuitem"
                                className={`${styles.item} ${item.danger ? styles.danger : ""} ${
                                    item.disabled ? styles.disabled : ""
                                }`}
                                disabled={item.disabled}
                                onClick={() => {
                                    setOpen(false);
                                    item.onClick?.();
                                }}
                            >
                                {Icon && (
                                    <Icon
                                        className={styles.itemIcon}
                                        aria-hidden="true"
                                    />
                                )}
                                {item.label}
                            </button>
                        );
                    })}
                </div>
            )}
        </div>
    );
}