// features/users/components/UsersTable.jsx
// =====================================================================
// Renders the users list. Per-row actions are provided as a function
// `(user) => Item[]` so the parent decides what each row can do
// (e.g. disable toggle on the last admin).
// =====================================================================

import {
    Pencil,
    Power,
    KeyRound,
} from "lucide-react";
import { UserRoleBadge } from "../../dashboard/components/UserRoleBadge";
import { UserActionsMenu } from "./UserActionsMenu";
import styles from "./UsersTable.module.css";

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

export function UsersTable({ users, loading, onAction, currentUserId }) {
    if (!loading && users.length === 0) {
        return (
            <div className={styles.empty}>
                <p>No users match your filters.</p>
            </div>
        );
    }
    return (
        <div className={styles.tableWrap}>
            <table className={styles.table}>
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Role</th>
                        <th>Joined</th>
                        <th>Status</th>
                        <th className={styles.actionsHead} aria-label="Actions" />
                    </tr>
                </thead>
                <tbody>
                    {loading
                        ? Array.from({ length: 5 }).map((_, i) => (
                              <tr key={i} className={styles.skeletonRow}>
                                  <td colSpan={5}>
                                      <div className={styles.skeleton} />
                                  </td>
                              </tr>
                          ))
                        : users.map((user) => {
                              const isSelf = currentUserId === user.id;
                              const items = [
                                  {
                                      icon: Pencil,
                                      label: "Edit",
                                      onClick: () => onAction("edit", user),
                                  },
                                  {
                                      icon: Power,
                                      label: user.isActive ? "Deactivate" : "Activate",
                                      onClick: () =>
                                          onAction("toggle-status", user),
                                      danger: user.isActive,
                                      disabled: isSelf,
                                  },
                                  {
                                      icon: KeyRound,
                                      label: "Reset password",
                                      onClick: () => onAction("reset-password", user),
                                  },
                              ];
                              return (
                                  <tr key={user.id}>
                                      <td>
                                          <div className={styles.userCell}>
                                              <span
                                                  className={styles.avatar}
                                                  aria-hidden="true"
                                              >
                                                  {initialsOf(user.name, user.email)}
                                              </span>
                                              <span className={styles.userText}>
                                                  <span className={styles.userName}>
                                                      {user.name || "—"}
                                                      {isSelf && (
                                                          <span className={styles.you}>
                                                              {" "}
                                                              (you)
                                                          </span>
                                                          )}
                                                  </span>
                                                  <span className={styles.userEmail}>
                                                      {user.email}
                                                  </span>
                                              </span>
                                          </div>
                                      </td>
                                      <td>
                                          <UserRoleBadge role={user.role} />
                                      </td>
                                      <td className={styles.muted}>
                                          {user.createdAt
                                              ? dateFormatter.format(user.createdAt)
                                              : "—"}
                                      </td>
                                      <td>
                                          <span
                                              className={`${styles.statusDot} ${
                                                  user.isActive
                                                      ? styles.statusActive
                                                      : styles.statusInactive
                                              }`}
                                          >
                                              <span className={styles.dot} />
                                              {user.isActive ? "Active" : "Inactive"}
                                          </span>
                                      </td>
                                      <td className={styles.actionsCell}>
                                          <UserActionsMenu
                                              label={`Actions for ${user.name || user.email}`}
                                              items={items}
                                          />
                                      </td>
                                  </tr>
                              );
                          })}
                </tbody>
            </table>
        </div>
    );
}