// pages/UnauthorizedPage.jsx
// =====================================================================
// Shown when a user is authenticated but lacks the role required for
// the route they tried to reach.
// =====================================================================

import { Link } from "react-router-dom";
import styles from "./NotFoundPage.module.css";

export function UnauthorizedPage() {
    return (
        <div className={styles.container}>
            <div className={styles.card}>
                <span className={styles.code}>403</span>
                <h1 className={styles.title}>Not authorized</h1>
                <p className={styles.message}>
                    You don't have permission to view this page.
                </p>
                <Link to="/" className={styles.link}>
                    Go to dashboard
                </Link>
            </div>
        </div>
    );
}