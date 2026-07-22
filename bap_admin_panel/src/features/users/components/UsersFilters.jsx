// features/users/components/UsersFilters.jsx
// =====================================================================
// Search + role + status filters. Pure controlled inputs — the parent
// owns the state. Designed to be debounced upstream if needed.
// =====================================================================

import { Search } from "lucide-react";
import { ROLES, ROLE_LABELS, USER_FILTER_ROLES, USER_FILTER_STATUSES } from "../../../utils/constants";
import styles from "./UsersFilters.module.css";

export function UsersFilters({ value, onChange }) {
    const update = (patch) => onChange({ ...value, ...patch, page: 1 });

    return (
        <div className={styles.bar}>
            <div className={styles.searchWrap}>
                <Search className={styles.searchIcon} aria-hidden="true" />
                <input
                    type="search"
                    className={styles.search}
                    placeholder="Search name or email…"
                    value={value.search || ""}
                    onChange={(e) => update({ search: e.target.value })}
                    aria-label="Search users"
                />
            </div>

            <select
                className={styles.select}
                value={value.role || ""}
                onChange={(e) => update({ role: e.target.value })}
                aria-label="Filter by role"
            >
                <option value="">All roles</option>
                {USER_FILTER_ROLES.map((r) => (
                    <option key={r} value={r}>
                        {ROLE_LABELS[r] || r}
                    </option>
                ))}
            </select>

            <select
                className={styles.select}
                value={value.status || ""}
                onChange={(e) => update({ status: e.target.value })}
                aria-label="Filter by status"
            >
                <option value="">All statuses</option>
                {USER_FILTER_STATUSES.map((s) => (
                    <option key={s} value={s}>
                        {s === "active" ? "Active" : "Inactive"}
                    </option>
                ))}
            </select>
        </div>
    );
}