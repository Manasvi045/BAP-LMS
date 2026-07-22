// components/ui/Input.jsx
// =====================================================================
// Form input primitive wired for React Hook Form. Pass `error` from RHF's
// fieldState (or a Zod message string) to display the validation error.
// Optional `iconLeft` (Lucide icon) renders inside the field.
// =====================================================================

import { forwardRef } from "react";
import styles from "./Input.module.css";

export const Input = forwardRef(function Input(
    {
        label,
        error,
        hint,
        iconLeft: IconLeft,
        suffix,
        type = "text",
        id,
        className = "",
        containerClassName = "",
        required = false,
        autoComplete,
        ...rest
    },
    ref
) {
    const generatedId = id || `inp-${rest.name || Math.random().toString(36).slice(2)}`;
    const hasError = Boolean(error);
    const fieldCls = [
        styles.field,
        hasError ? styles.fieldError : "",
        IconLeft ? styles.fieldWithIcon : "",
        suffix ? styles.fieldWithSuffix : "",
    ]
        .filter(Boolean)
        .join(" ");

    return (
        <div className={`${styles.container} ${containerClassName}`}>
            {label && (
                <label htmlFor={generatedId} className={styles.label}>
                    {label}
                    {required && <span className={styles.required}> *</span>}
                </label>
            )}
            <div className={fieldCls}>
                {IconLeft && (
                    <IconLeft className={styles.iconLeft} aria-hidden="true" />
                )}
                <input
                    ref={ref}
                    id={generatedId}
                    type={type}
                    autoComplete={autoComplete}
                    aria-invalid={hasError || undefined}
                    className={`${styles.input} ${className}`}
                    {...rest}
                />
                {suffix && (
                    <div className={styles.suffix}>{suffix}</div>
                )}
            </div>
            {hint && !hasError && <p className={styles.hint}>{hint}</p>}
            {hasError && (
                <p className={styles.error} role="alert">
                    {error}
                </p>
            )}
        </div>
    );
});
