// features/users/components/UsersPagination.jsx
// =====================================================================
// Page nav. Shows current page, total pages, and Previous/Next.
// Previous/Next are disabled at the boundaries. Re-renders only when
// pagination changes (parent controls it).
// =====================================================================

import { ChevronLeft, ChevronRight } from "lucide-react";
import styles from "./UsersPagination.module.css";

export function UsersPagination({ pagination, onPageChange }) {
    if (!pagination || pagination.totalPages <= 1) return null;
    const { page, totalPages, totalRecords, hasPrevPage, hasNextPage } = pagination;

    return (
        <div className={styles.bar}>
            <span className={styles.summary}>
                Page <strong>{page}</strong> of {totalPages} · {totalRecords}{" "}
                {totalRecords === 1 ? "user" : "users"}
            </span>
            <div className={styles.buttons}>
                <button
                    type="button"
                    className={styles.button}
                    disabled={!hasPrevPage}
                    onClick={() => onPageChange(page - 1)}
                >
                    <ChevronLeft className={styles.icon} aria-hidden="true" />
                    Previous
                </button>
                <button
                    type="button"
                    className={styles.button}
                    disabled={!hasNextPage}
                    onClick={() => onPageChange(page + 1)}
                >
                    Next
                    <ChevronRight className={styles.icon} aria-hidden="true" />
                </button>
            </div>
        </div>
    );
}
