// features/users/components/ConfirmDialog.jsx
// =====================================================================
// Generic confirm dialog with a danger flag. Uses the Modal primitive.
// =====================================================================

import { Modal } from "../../../components/ui/Modal";
import { Button } from "../../../components/ui/Button";
import styles from "./ConfirmDialog.module.css";

export function ConfirmDialog({
    open,
    title,
    description,
    confirmLabel = "Confirm",
    cancelLabel = "Cancel",
    danger = false,
    loading = false,
    onConfirm,
    onClose,
    children,
}) {
    return (
        <Modal
            open={open}
            onClose={loading ? undefined : onClose}
            title={title}
            size="sm"
            closeOnOverlay={!loading}
        >
            {description && (
                <p className={styles.description}>{description}</p>
            )}
            {children}
            <div className={styles.actions}>
                <Button variant="secondary" onClick={onClose} disabled={loading}>
                    {cancelLabel}
                </Button>
                <Button
                    variant={danger ? "danger" : "primary"}
                    onClick={onConfirm}
                    loading={loading}
                >
                    {confirmLabel}
                </Button>
            </div>
        </Modal>
    );
}