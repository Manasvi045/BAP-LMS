// features/dashboard/components/EditorLanding.jsx
// =====================================================================
// Soft landing page shown to non-admin users (editor). They don't have
// access to the admin-only /api/dashboard/stats endpoint, so this
// gives them clear navigation into the parts of the panel they can use
// without making any network calls that will 403.
// =====================================================================

import { Link } from "react-router-dom";
import { BookOpen, ArrowRight } from "lucide-react";
import styles from "./EditorLanding.module.css";

const QUICK_LINKS = Object.freeze([
    {
        to: "/verticals",
        title: "Browse verticals",
        description:
            "Explore the verticals you can contribute to and open one to start editing.",
        icon: BookOpen,
    },
]);

export function EditorLanding({ user }) {
    return (
        <div className={styles.page}>
            <section className={styles.hero}>
                <h2 className={styles.heroTitle}>
                    Welcome, {user?.name || "editor"}.
                </h2>
                <p className={styles.heroText}>
                    You can manage content here — create and edit verticals,
                    modules, sections, and content blocks, then move them
                    through draft, review, and publish.
                </p>
            </section>

            <section className={styles.links}>
                {QUICK_LINKS.map((link) => {
                    const Icon = link.icon;
                    return (
                        <Link key={link.to} to={link.to} className={styles.linkCard}>
                            <span className={styles.linkIcon} aria-hidden="true">
                                <Icon className={styles.linkIconSvg} />
                            </span>
                            <span className={styles.linkBody}>
                                <span className={styles.linkTitle}>{link.title}</span>
                                <span className={styles.linkDescription}>
                                    {link.description}
                                </span>
                            </span>
                            <ArrowRight className={styles.linkArrow} aria-hidden="true" />
                        </Link>
                    );
                })}
            </section>
        </div>
    );
}