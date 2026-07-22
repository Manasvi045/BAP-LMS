// features/auth/components/ChangePasswordModal.jsx
// =====================================================================
// Self-service password change. Three fields: current password (so we
// know it's really the owner), new password, and a confirmation field.
// On success, the server clears any "must change on next login" flag
// attached to the user — useful when an admin was bootstrapped with a
// generated temp password and wants to set a real one.
// =====================================================================

import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Eye, EyeOff, KeyRound } from "lucide-react";
import toast from "react-hot-toast";
import { Modal } from "../../../components/ui/Modal";
import { Input } from "../../../components/ui/Input";
import { Button } from "../../../components/ui/Button";
import { useChangePassword } from "../hooks/useChangePassword";
import {
    changePasswordSchema,
    changePasswordDefaults,
} from "../schemas/changePasswordSchema";
import styles from "./ChangePasswordModal.module.css";

export function ChangePasswordModal({ open, onClose }) {
    const change = useChangePassword();
    const [showCurrent, setShowCurrent] = useState(false);
    const [showNew, setShowNew] = useState(false);
    const [showConfirm, setShowConfirm] = useState(false);

    const {
        register,
        handleSubmit,
        reset,
        formState: { errors, isSubmitting },
    } = useForm({
        resolver: zodResolver(changePasswordSchema),
        defaultValues: changePasswordDefaults,
        mode: "onTouched",
    });

    useEffect(() => {
        if (!open) {
            reset(changePasswordDefaults);
            change.reset();
            setShowCurrent(false);
            setShowNew(false);
            setShowConfirm(false);
        }
    }, [open, reset, change]);

    async function onSubmit(values) {
        try {
            const result = await change.mutateAsync({
                currentPassword: values.currentPassword,
                newPassword: values.newPassword,
                confirmPassword: values.confirmPassword,
            });
            toast.success(result.message || "Password updated.");
            onClose?.();
        } catch {
            // Error surfaced via `change.error` below the form.
        }
    }

    const serverError =
        change.error?.response?.data?.message ||
        change.error?.message ||
        null;

    return (
        <Modal
            open={open}
            onClose={onClose}
            title="Change your password"
            size="sm"
        >
            <form
                className={styles.form}
                onSubmit={handleSubmit(onSubmit)}
                noValidate
            >
                <p className={styles.intro}>
                    Choose something at least 8 characters long. You'll use
                    this password the next time you sign in.
                </p>

                <Input
                    label="Current password"
                    type={showCurrent ? "text" : "password"}
                    autoComplete="current-password"
                    required
                    iconLeft={KeyRound}
                    error={errors.currentPassword?.message}
                    {...register("currentPassword")}
                    containerClassName={styles.inputContainer}
                    suffix={
                        <button
                            type="button"
                            className={styles.toggle}
                            onClick={() => setShowCurrent((v) => !v)}
                            aria-label={
                                showCurrent ? "Hide password" : "Show password"
                            }
                        >
                            {showCurrent ? (
                                <EyeOff aria-hidden="true" />
                            ) : (
                                <Eye aria-hidden="true" />
                            )}
                        </button>
                    }
                />

                <Input
                    label="New password"
                    type={showNew ? "text" : "password"}
                    autoComplete="new-password"
                    required
                    iconLeft={KeyRound}
                    hint="At least 8 characters."
                    error={errors.newPassword?.message}
                    {...register("newPassword")}
                    containerClassName={styles.inputContainer}
                    suffix={
                        <button
                            type="button"
                            className={styles.toggle}
                            onClick={() => setShowNew((v) => !v)}
                            aria-label={
                                showNew ? "Hide password" : "Show password"
                            }
                        >
                            {showNew ? (
                                <EyeOff aria-hidden="true" />
                            ) : (
                                <Eye aria-hidden="true" />
                            )}
                        </button>
                    }
                />

                <Input
                    label="Confirm new password"
                    type={showConfirm ? "text" : "password"}
                    autoComplete="new-password"
                    required
                    iconLeft={KeyRound}
                    error={errors.confirmPassword?.message}
                    {...register("confirmPassword")}
                    containerClassName={styles.inputContainer}
                    suffix={
                        <button
                            type="button"
                            className={styles.toggle}
                            onClick={() => setShowConfirm((v) => !v)}
                            aria-label={
                                showConfirm
                                    ? "Hide password"
                                    : "Show password"
                            }
                        >
                            {showConfirm ? (
                                <EyeOff aria-hidden="true" />
                            ) : (
                                <Eye aria-hidden="true" />
                            )}
                        </button>
                    }
                />

                {change.isError && serverError && (
                    <p className={styles.error} role="alert">
                        {serverError}
                    </p>
                )}

                <div className={styles.actions}>
                    <Button
                        variant="secondary"
                        type="button"
                        onClick={onClose}
                        disabled={isSubmitting}
                    >
                        Cancel
                    </Button>
                    <Button type="submit" loading={isSubmitting}>
                        Update password
                    </Button>
                </div>
            </form>
        </Modal>
    );
}