// features/dashboard/components/MetricsPlaceholderCard.jsx
// =====================================================================
// Side panel that displays content/media/learning counters, all of
// which the backend currently returns as 0 placeholders. As Phase 4+
// adds these modules, swap the placeholders for real values without
// changing layout.
// =====================================================================

import { BookOpen, Image, Award } from "lucide-react";
import styles from "./MetricsPlaceholderCard.module.css";

function MetricRow({ label, value, hint }) {
    return (
        <div className={styles.row}>
            <span className={styles.rowLabel}>{label}</span>
            <span className={styles.rowValue}>{value}</span>
            {hint && <span className={styles.rowHint}>{hint}</span>}
        </div>
    );
}

export function MetricsPlaceholderCard({ content, media, learning }) {
    return (
        <section className={styles.card}>
            <header className={styles.header}>
                <h2 className={styles.title}>Content & learning</h2>
                <p className={styles.subtitle}>
                    Available in upcoming phases
                </p>
            </header>

            <div className={styles.group}>
                <div className={styles.groupHead}>
                    <BookOpen className={styles.groupIcon} aria-hidden="true" />
                    <span className={styles.groupLabel}>Content</span>
                </div>
                <MetricRow label="Verticals" value={content?.verticals ?? 0} />
                <MetricRow label="Modules" value={content?.modules ?? 0} />
                <MetricRow label="Sections" value={content?.sections ?? 0} />
                <MetricRow
                    label="Published"
                    value={content?.publishedContent ?? 0}
                    hint="Drafts + reviews"
                />
            </div>

            <div className={styles.group}>
                <div className={styles.groupHead}>
                    <Image className={styles.groupIcon} aria-hidden="true" />
                    <span className={styles.groupLabel}>Media library</span>
                </div>
                <MetricRow label="Images" value={media?.images ?? 0} />
                <MetricRow label="Videos" value={media?.videos ?? 0} />
            </div>

            <div className={styles.group}>
                <div className={styles.groupHead}>
                    <Award className={styles.groupIcon} aria-hidden="true" />
                    <span className={styles.groupLabel}>Learning</span>
                </div>
                <MetricRow label="Quizzes" value={learning?.quizzes ?? 0} />
                <MetricRow
                    label="Completed attempts"
                    value={learning?.completedAttempts ?? 0}
                />
                <MetricRow
                    label="Certificates"
                    value={learning?.certificatesIssued ?? 0}
                />
            </div>
        </section>
    );
}