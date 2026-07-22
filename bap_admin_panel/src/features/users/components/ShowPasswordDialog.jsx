// features/users/components/ShowPasswordDialog.jsx
// =====================================================================
// Generic "shown-once" dialog for a temporary password. Copy button + a
// loud warning that the value will not be displayed again. Used after
// auto-generated user creation today; reusable for any future
// one-time-secret flow.
// =====================================================================

import { useState } from "react";
import { Copy, Check, AlertTriangle } from "lucide-react";
import { Modal } from "../../../components/ui/Modal";
import { Button } from "../../../components/ui/Button";
import styles from "./ShowPasswordDialog.module.css";

function CopyablePassword({ value }) {
    const [copied, setCopied] = useState(false);
    async function copy() {
        try {
            await navigator.clipboard.writeText(value);
            setCopied(true);
            setTimeout(() => setCopied(false), 1500);
        } catch {
            /* clipboard permission denied; user must copy manually */
        }
    }
    return (
        <div className={styles.passwordWrap}>
            <code className={styles.password}>{value}</code>
            <button
                type="button"
                className={styles.copy}
                onClick={copy}
                aria-label="Copy password"
            >
                {copied ? (
                    <Check className={styles.copyIcon} aria-hidden="true" />
                ) : (
                    <Copy className={styles.copyIcon} aria-hidden="true" />
                )}
                {copied ? "Copied" : "Copy password"}
            </button>
        </div>
    );
}

export function ShowPasswordDialog({
    open,
    title = "Save this password",
    subject,
    description,
    password,
    onClose,
    acknowledgeLabel = "I've saved it",
}) {
    return (
        <Modal open={open} onClose={onClose} title={title} size="sm">
            {description && <p className={styles.copy}>{description}</p>}
            {subject && (
                <p className={styles.subject}>
                    For <strong>{subject}</strong>
                </p>
            )}

            {password && <CopyablePassword value={password} />}

            <div className={styles.warn} role="alert">
                <AlertTriangle
                    className={styles.warnIcon}
                    aria-hidden="true"
                />
                <p className={styles.warnText}>
                    This password will not be shown again. Share it with the
                    user through a secure channel — they will be required to
                    change it on first login.
                </p>
            </div>

            <div className={styles.actions}>
                <Button onClick={onClose} fullWidth>
                    {acknowledgeLabel}
                </Button>
            </div>
        </Modal>
    );
}
