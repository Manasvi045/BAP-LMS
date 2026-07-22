// components/ui/Button.jsx
// =====================================================================
// Button primitive. Variants: primary | secondary | ghost | danger.
// Sizes: sm | md | lg. Supports `loading` (shows spinner + disables) and
// `iconLeft` / `iconRight` (Lucide icons).
// =====================================================================

import styles from "./Button.module.css";

export function Button({
    children,
    variant = "primary",
    size = "md",
    type = "button",
    fullWidth = false,
    loading = false,
    disabled = false,
    iconLeft: IconLeft,
    iconRight: IconRight,
    className = "",
    ...rest
}) {
    const variantClass = styles[`variant_${variant}`] || styles.variant_primary;
    const sizeClass = styles[`size_${size}`] || styles.size_md;
    const cls = [
        styles.button,
        variantClass,
        sizeClass,
        fullWidth ? styles.fullWidth : "",
        loading ? styles.loading : "",
        className,
    ]
        .filter(Boolean)
        .join(" ");

    return (
        <button
            type={type}
            disabled={disabled || loading}
            className={cls}
            {...rest}
        >
            {loading && <span className={styles.spinner} aria-hidden="true" />}
            {!loading && IconLeft && (
                <IconLeft className={styles.iconLeft} aria-hidden="true" />
            )}
            <span className={styles.label}>{children}</span>
            {!loading && IconRight && (
                <IconRight className={styles.iconRight} aria-hidden="true" />
            )}
        </button>
    );
}