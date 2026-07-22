// components/ui/Modal.jsx
// =====================================================================
// Generic modal primitive. Renders via a React portal so it escapes
// parent stacking contexts. Closes on ESC, click on the overlay, or
// an explicit `onClose` from the titlebar close button.
// =====================================================================

import { useEffect, useRef } from "react";
import { createPortal } from "react-dom";
import { X } from "lucide-react";
import styles from "./Modal.module.css";

export function Modal({
    open,
    title,
    description,
    onClose,
    children,
    size = "md",
    closeOnOverlay = true,
    hideCloseButton = false,
}) {
    const dialogRef = useRef(null);

    useEffect(() => {
        if (!open) return undefined;
        function onKey(e) {
            if (e.key === "Escape") onClose?.();
        }
        document.addEventListener("keydown", onKey);
        const previousOverflow = document.body.style.overflow;
        document.body.style.overflow = "hidden";
        // Move focus into the dialog for keyboard users.
        dialogRef.current?.focus();
        return () => {
            document.removeEventListener("keydown", onKey);
            document.body.style.overflow = previousOverflow;
        };
    }, [open, onClose]);

    if (!open) return null;

    const sizeCls = styles[`size_${size}`] || styles.size_md;

    return createPortal(
        <div
            className={styles.overlay}
            onMouseDown={(e) => {
                if (closeOnOverlay && e.target === e.currentTarget) {
                    onClose?.();
                }
            }}
        >
            <div
                ref={dialogRef}
                tabIndex={-1}
                role="dialog"
                aria-modal="true"
                aria-labelledby={title ? "modal-title" : undefined}
                className={`${styles.dialog} ${sizeCls}`}
            >
                {(title || !hideCloseButton) && (
                    <header className={styles.header}>
                        <div className={styles.titles}>
                            {title && (
                                <h2 id="modal-title" className={styles.title}>
                                    {title}
                                </h2>
                            )}
                            {description && (
                                <p className={styles.description}>{description}</p>
                            )}
                        </div>
                        {!hideCloseButton && (
                            <button
                                type="button"
                                className={styles.close}
                                aria-label="Close"
                                onClick={onClose}
                            >
                                <X className={styles.closeIcon} aria-hidden="true" />
                            </button>
                        )}
                    </header>
                )}
                <div className={styles.body}>{children}</div>
            </div>
        </div>,
        document.body
    );
}