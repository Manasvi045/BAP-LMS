// features/dashboard/components/UserRoleBadge.jsx
// =====================================================================
// Colored pill for displaying a user's role. Tones map onto the
// status-color tokens already defined in tokens.css.
// =====================================================================

import { ROLES, ROLE_LABELS } from "../../../utils/constants";
import styles from "./UserRoleBadge.module.css";

const TONE_BY_ROLE = Object.freeze({
    [ROLES.ADMIN]: "danger",
    [ROLES.EDITOR]: "info",
    [ROLES.USER]: "neutral",
});

export function UserRoleBadge({ role }) {
    const tone = TONE_BY_ROLE[role] || "neutral";
    return (
        <span className={`${styles.badge} ${styles[tone]}`}>
            {ROLE_LABELS[role] || role || "—"}
        </span>
    );
}