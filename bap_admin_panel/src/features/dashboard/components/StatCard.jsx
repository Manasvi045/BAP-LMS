// features/dashboard/components/StatCard.jsx
// =====================================================================
// Reusable stat tile. Shows an icon, a label, and a numeric value.
// `accent` swaps the palette (primary | success | warning | info).
// =====================================================================

import styles from "./StatCard.module.css";

export function StatCard({
    icon: Icon,
    label,
    value,
    accent = "primary",
    hint,
    loading = false,
}) {
    const accentCls = styles[`accent_${accent}`] || styles.accent_primary;
    return (
        <div className={`${styles.card} ${accentCls}`}>
            <div className={styles.head}>
                <span className={styles.iconBox} aria-hidden="true">
                    {Icon ? <Icon className={styles.icon} /> : null}
                </span>
                <span className={styles.label}>{label}</span>
            </div>
            <div className={styles.value}>
                {loading ? <span className={styles.skeleton}>—</span> : value}
            </div>
            {hint && <div className={styles.hint}>{hint}</div>}
        </div>
    );
}