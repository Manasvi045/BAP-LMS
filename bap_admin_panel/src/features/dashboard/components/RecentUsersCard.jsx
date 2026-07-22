// features/dashboard/components/RecentUsersCard.jsx
// =====================================================================
// Compact table of the most-recently-created users. Pure presentation —
// all normalization happens in dashboardApi.
// =====================================================================

import { UserRoleBadge } from "./UserRoleBadge";
import styles from "./RecentUsersCard.module.css";

const dateFormatter = new Intl.DateTimeFormat(undefined, {
    year: "numeric",
    month: "short",
    day: "numeric",
});

function initialsOf(name, email) {
    const source = name || email || "";
    return source
        .split(/\s+/)
        .filter(Boolean)
        .map((p) => p[0].toUpperCase())
        .slice(0, 2)
        .join("") || "?";
}

export function RecentUsersCard({ users, loading }) {
    const list = Array.isArray(users) ? users : [];

    return (
        <section className={styles.card}>
            <header className={styles.header}>
                <h2 className={styles.title}>Recent users</h2>
                <p className={styles.subtitle}>Last 5 accounts created</p>
            </header>

            {loading ? (
                <div className={styles.empty}>Loading…</div>
            ) : list.length === 0 ? (
                <div className={styles.empty}>No users yet.</div>
            ) : (
                <div className={styles.tableWrap}>
                    <table className={styles.table}>
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Role</th>
                                <th>Joined</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {list.map((u) => (
                                <tr key={u.id}>
                                    <td>
                                        <div className={styles.userCell}>
                                            <span className={styles.avatar} aria-hidden="true">
                                                {initialsOf(u.name, u.email)}
                                            </span>
                                            <span className={styles.userText}>
                                                <span className={styles.userName}>
                                                    {u.name || "—"}
                                                </span>
                                                <span className={styles.userEmail}>
                                                    {u.email}
                                                </span>
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <UserRoleBadge role={u.role} />
                                    </td>
                                    <td className={styles.muted}>
                                        {u.createdAt
                                            ? dateFormatter.format(u.createdAt)
                                            : "—"}
                                    </td>
                                    <td>
                                        <span
                                            className={`${styles.statusDot} ${
                                                u.isActive
                                                    ? styles.statusActive
                                                    : styles.statusInactive
                                            }`}
                                        >
                                            <span className={styles.dot} />
                                            {u.isActive ? "Active" : "Inactive"}
                                        </span>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}
        </section>
    );
}