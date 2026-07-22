// features/users/components/ResetPasswordDialog.jsx
// =====================================================================
// Two-step dialog for resetting a user's password.
//   Step 1: confirm the action ("user will be required to change it on
//           next login").
//   Step 2: show the temporary password with a copy-to-clipboard button.
// =====================================================================

import { useState } from "react";
import { Copy, Check } from "lucide-react";
import { ConfirmDialog } from "./ConfirmDialog";
import { Modal } from "../../../components/ui/Modal";
import { Button } from "../../../components/ui/Button";
import { useResetUserPassword } from "../hooks/useResetUserPassword";
import styles from "./ResetPasswordDialog.module.css";

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
                aria-label="Copy temporary password"
            >
                {copied ? (
                    <Check className={styles.copyIcon} aria-hidden="true" />
                ) : (
                    <Copy className={styles.copyIcon} aria-hidden="true" />
                )}
                {copied ? "Copied" : "Copy"}
            </button>
        </div>
    );
}

export function ResetPasswordDialog({ open, user, onClose }) {
    const reset = useResetUserPassword();
    const [generated, setGenerated] = useState(null);

    function handleClose() {
        setGenerated(null);
        reset.reset();
        onClose();
    }

    async function handleConfirm() {
        try {
            const result = await reset.mutateAsync({ id: user.id });
            setGenerated(result.temporaryPassword || null);
        } catch {
            /* surface via reset.error in the dialog */
        }
    }

    if (!user) return null;

    return (
        <Modal
            open={open}
            onClose={handleClose}
            title="Reset password"
            size="sm"
        >
            {!generated ? (
                <>
                    <p className={styles.copy}>
                        Reset the password for{" "}
                        <strong>{user.name || user.email}</strong>? They will
                        need to set a new password on next login.
                    </p>
                    {reset.isError && (
                        <p className={styles.error} role="alert">
                            {reset.error?.message || "Couldn't reset password."}
                        </p>
                    )}
                    <div className={styles.actions}>
                        <Button variant="secondary" onClick={handleClose}>
                            Cancel
                        </Button>
                        <Button
                            onClick={handleConfirm}
                            loading={reset.isLoading}
                        >
                            Reset password
                        </Button>
                    </div>
                </>
            ) : (
                <>
                    <p className={styles.copy}>
                        A temporary password has been generated for{" "}
                        <strong>{user.name || user.email}</strong>. Share it
                        with the user; they will be asked to change it on
                        next login.
                    </p>
                    <CopyablePassword value={generated} />
                    <div className={styles.actions}>
                        <Button onClick={handleClose} fullWidth>
                            Done
                        </Button>
                    </div>
                </>
            )}
        </Modal>
    );
}