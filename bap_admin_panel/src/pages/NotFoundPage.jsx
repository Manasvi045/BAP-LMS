// pages/NotFoundPage.jsx
// =====================================================================
// 404 fallback for unmatched routes.
// =====================================================================

import { Link } from "react-router-dom";
import styles from "./NotFoundPage.module.css";

export function NotFoundPage() {
    return (
        <div className={styles.container}>
            <div className={styles.card}>
                <span className={styles.code}>404</span>
                <h1 className={styles.title}>Page not found</h1>
                <p className={styles.message}>
                    We couldn't find what you were looking for.
                </p>
                <Link to="/" className={styles.link}>
                    Go to dashboard
                </Link>
            </div>
        </div>
    );
}