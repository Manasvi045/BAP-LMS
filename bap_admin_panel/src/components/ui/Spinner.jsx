// components/ui/Spinner.jsx
// =====================================================================
// Spinner primitive. Use for full-page loading or inline-buttons. Pure
// CSS animation — no JS, no library.
// =====================================================================

import styles from "./Spinner.module.css";

export function Spinner({ size = "md", label, className = "", center = false }) {
    const sizeCls = styles[`size_${size}`] || styles.size_md;
    const cls = `${styles.spinner} ${sizeCls} ${className}`.trim();
    if (center) {
        return (
            <div className={styles.center}>
                <div className={cls} role="status" aria-label={label || "Loading"} />
                {label && <span className={styles.label}>{label}</span>}
            </div>
        );
    }
    return (
        <div
            className={cls}
            role="status"
            aria-label={label || "Loading"}
        />
    );
}