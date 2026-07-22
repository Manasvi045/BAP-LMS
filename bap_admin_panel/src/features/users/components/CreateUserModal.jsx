// features/users/components/CreateUserModal.jsx
// =====================================================================
// Create user modal with two password modes:
//
//   * AUTO    — backend generates a cryptographically secure password
//               and returns it once. Password fields are hidden.
//   * MANUAL  — admin supplies a password. Password fields are shown
//               and validated against the backend rules (min 8 chars).
//
// On success the parent receives `{ user, temporaryPassword }` so it
// can show a "shown-once" dialog when a temp password was generated.
// =====================================================================

import { useEffect } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { AlertTriangle, KeyRound, Wand2 } from "lucide-react";
import { Modal } from "../../../components/ui/Modal";
import { Input } from "../../../components/ui/Input";
import { Button } from "../../../components/ui/Button";
import { useCreateUser } from "../hooks/useCreateUser";
import {
    createUserSchema,
    createUserDefaults,
    PASSWORD_MODE,
} from "../schemas/userSchema";
import { ROLES, ROLE_LABELS, USER_FILTER_ROLES } from "../../../utils/constants";
import styles from "./CreateUserModal.module.css";

export function CreateUserModal({ open, onClose, onCreated }) {
    const create = useCreateUser();

    const {
        register,
        handleSubmit,
        control,
        watch,
        reset,
        formState: { errors, isSubmitting },
    } = useForm({
        resolver: zodResolver(createUserSchema),
        defaultValues: createUserDefaults,
        mode: "onTouched",
    });

    const passwordMode = watch("passwordMode");
    const isManual = passwordMode === PASSWORD_MODE.MANUAL;

    useEffect(() => {
        if (!open) {
            reset(createUserDefaults);
            create.reset();
        }
    }, [open, reset, create]);

    async function onSubmit(values) {
        try {
            const payload = {
                fullName: values.fullName.trim(),
                email: values.email.trim().toLowerCase(),
                role: values.role,
            };
            if (values.passwordMode === PASSWORD_MODE.MANUAL) {
                payload.password = values.password;
            }
            const result = await create.mutateAsync(payload);
            onCreated?.(result);
            onClose();
        } catch {
            // error surfaced via create.error below
        }
    }

    return (
        <Modal open={open} onClose={onClose} title="Create user" size="md">
            <form
                className={styles.form}
                onSubmit={handleSubmit(onSubmit)}
                noValidate
            >
                <Input
                    label="Full name"
                    autoComplete="name"
                    required
                    placeholder="Jane Doe"
                    error={errors.fullName?.message}
                    {...register("fullName")}
                />
                <Input
                    label="Email"
                    type="email"
                    autoComplete="email"
                    required
                    placeholder="jane.doe@example.com"
                    error={errors.email?.message}
                    {...register("email")}
                />

                <div className={styles.field}>
                    <label htmlFor="create-role" className={styles.fieldLabel}>
                        Role <span className={styles.required}>*</span>
                    </label>
                    <select
                        id="create-role"
                        className={`${styles.select} ${
                            errors.role ? styles.selectError : ""
                        }`}
                        {...register("role")}
                    >
                        {USER_FILTER_ROLES.map((r) => (
                            <option key={r} value={r}>
                                {ROLE_LABELS[r] || r}
                            </option>
                        ))}
                    </select>
                    {errors.role && (
                        <p className={styles.errorMsg} role="alert">
                            {errors.role.message}
                        </p>
                    )}
                </div>

                <Controller
                    name="passwordMode"
                    control={control}
                    render={({ field }) => (
                        <div className={styles.field}>
                            <span className={styles.fieldLabel}>Password</span>
                            <div
                                className={styles.radioGroup}
                                role="radiogroup"
                                aria-label="Password mode"
                            >
                                <label
                                    className={`${styles.radio} ${
                                        field.value === PASSWORD_MODE.AUTO
                                            ? styles.radioActive
                                            : ""
                                    }`}
                                >
                                    <input
                                        type="radio"
                                        name="passwordMode"
                                        value={PASSWORD_MODE.AUTO}
                                        checked={
                                            field.value === PASSWORD_MODE.AUTO
                                        }
                                        onChange={() =>
                                            field.onChange(PASSWORD_MODE.AUTO)
                                        }
                                    />
                                    <Wand2
                                        className={styles.radioIcon}
                                        aria-hidden="true"
                                    />
                                    <span className={styles.radioText}>
                                        <span className={styles.radioTitle}>
                                            Auto-generate password
                                        </span>
                                        <span className={styles.radioHint}>
                                            A secure temporary password will be
                                            generated and shown once.
                                        </span>
                                    </span>
                                </label>
                                <label
                                    className={`${styles.radio} ${
                                        field.value === PASSWORD_MODE.MANUAL
                                            ? styles.radioActive
                                            : ""
                                    }`}
                                >
                                    <input
                                        type="radio"
                                        name="passwordMode"
                                        value={PASSWORD_MODE.MANUAL}
                                        checked={
                                            field.value ===
                                            PASSWORD_MODE.MANUAL
                                        }
                                        onChange={() =>
                                            field.onChange(
                                                PASSWORD_MODE.MANUAL
                                            )
                                        }
                                    />
                                    <KeyRound
                                        className={styles.radioIcon}
                                        aria-hidden="true"
                                    />
                                    <span className={styles.radioText}>
                                        <span className={styles.radioTitle}>
                                            Enter password manually
                                        </span>
                                        <span className={styles.radioHint}>
                                            You'll set the password; the user
                                            must change it on first login.
                                        </span>
                                    </span>
                                </label>
                            </div>
                        </div>
                    )}
                />

                {isManual && (
                    <>
                        <Input
                            label="Password"
                            type="password"
                            autoComplete="new-password"
                            required
                            placeholder="At least 8 characters"
                            error={errors.password?.message}
                            {...register("password")}
                        />
                        <Input
                            label="Confirm password"
                            type="password"
                            autoComplete="new-password"
                            required
                            error={errors.confirmPassword?.message}
                            {...register("confirmPassword")}
                        />
                    </>
                )}

                <div className={styles.notice} role="note">
                    <AlertTriangle
                        className={styles.noticeIcon}
                        aria-hidden="true"
                    />
                    <p className={styles.noticeText}>
                        The new user will be required to set their own
                        password on first login.
                    </p>
                </div>

                {create.isError && (
                    <p className={styles.serverError} role="alert">
                        {create.error?.message || "Couldn't create user."}
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
                        Create user
                    </Button>
                </div>
            </form>
        </Modal>
    );
}