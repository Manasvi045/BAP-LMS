// features/users/components/EditUserModal.jsx
// =====================================================================
// Edit modal: name, email, and role. Role uses a custom button group
// instead of a native <select> — native selects inside animated fixed-
// position modals hit a known browser quirk where the option layer is
// rendered but clicks don't register, so we use the same radio-button
// pattern we already use for password mode in CreateUserModal.
//
// When the admin changes a user's role, a confirmation step blocks the
// submit until the admin confirms the transition — so a stray click
// can't demote a user or promote one to admin by accident.
// =====================================================================

import { useEffect, useState } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import {
    ShieldCheck,
    PencilLine,
    GraduationCap,
    AlertTriangle,
} from "lucide-react";
import { Modal } from "../../../components/ui/Modal";
import { Input } from "../../../components/ui/Input";
import { Button } from "../../../components/ui/Button";
import { Spinner } from "../../../components/ui/Spinner";
import { useUser } from "../hooks/useUser";
import { useUpdateUser } from "../hooks/useUpdateUser";
import { editUserSchema, editUserDefaults } from "../schemas/userSchema";
import { ROLES, ROLE_LABELS, USER_FILTER_ROLES } from "../../../utils/constants";
import styles from "./EditUserModal.module.css";

const ROLE_ICONS = Object.freeze({
    [ROLES.ADMIN]: ShieldCheck,
    [ROLES.EDITOR]: PencilLine,
    [ROLES.USER]: GraduationCap,
});

const ROLE_DESCRIPTIONS = Object.freeze({
    [ROLES.ADMIN]: "Full access to users, content, and settings.",
    [ROLES.EDITOR]: "Manage content; cannot manage users.",
    [ROLES.USER]: "Learner — uses the Flutter app, not this panel.",
});

// Friendly descriptions of what each transition actually does, so the
// confirmation dialog can warn the admin about the impact.
const ROLE_TRANSITION_MESSAGES = Object.freeze({
    [`${ROLES.USER}->${ROLES.EDITOR}`]:
        "They'll be able to create and edit content in the admin panel.",
    [`${ROLES.USER}->${ROLES.ADMIN}`]:
        "They'll gain full access — including the ability to manage other users. This is a high-trust change.",
    [`${ROLES.EDITOR}->${ROLES.ADMIN}`]:
        "They'll gain full access — including the ability to manage other users. This is a high-trust change.",
    [`${ROLES.EDITOR}->${ROLES.USER}`]:
        "They'll lose access to the admin panel entirely and will only see the learner app.",
    [`${ROLES.ADMIN}->${ROLES.EDITOR}`]:
        "They'll lose the ability to manage users and will only be able to edit content.",
    [`${ROLES.ADMIN}->${ROLES.USER}`]:
        "They'll lose access to the admin panel entirely and will only see the learner app.",
});

function transitionMessage(from, to) {
    return (
        ROLE_TRANSITION_MESSAGES[`${from}->${to}`] ||
        "Their permissions will be updated to match the new role."
    );
}

export function EditUserModal({ userId, open, onClose }) {
    const userQuery = useUser(userId, { enabled: open });
    const update = useUpdateUser();

    // Pending submit values — when the admin changes role, we stash the
    // submitted values here and block until they confirm.
    const [pendingValues, setPendingValues] = useState(null);
    const pendingRoleChange =
        pendingValues && pendingValues.role !== (userQuery.data?.role || ROLES.USER);

    const {
        register,
        handleSubmit,
        reset,
        control,
        watch,
        formState: { errors, isSubmitting },
    } = useForm({
        resolver: zodResolver(editUserSchema),
        defaultValues: editUserDefaults,
        mode: "onTouched",
    });

    const currentRole = watch("role");
    const loading = userQuery.isLoading && !userQuery.data;

    // Reset the form when the modal opens and we have user data.
    // Deps are intentionally narrow: `open` and `userQuery.data`. The
    // `update` mutation result is a new object reference on every render,
    // so depending on it would re-fire this effect on every render and
    // call `reset(...)`, which silently snaps the form back to the
    // user's original values the moment the admin tries to edit
    // anything.
    useEffect(() => {
        if (open && userQuery.data) {
            reset({
                fullName: userQuery.data.name || "",
                email: userQuery.data.email || "",
                role: userQuery.data.role || ROLES.USER,
            });
        }
    }, [open, userQuery.data, reset]);

    // Reset transient state when the modal closes. `update.reset` is a
    // stable callback from TanStack Query, so it's safe in deps.
    const resetMutation = update.reset;
    useEffect(() => {
        if (!open) {
            reset(editUserDefaults);
            resetMutation();
            setPendingValues(null);
        }
    }, [open, reset, resetMutation]);

    async function performSubmit(values) {
        try {
            await update.mutateAsync({
                id: userId,
                fullName: values.fullName.trim(),
                email: values.email.trim().toLowerCase(),
                role: values.role,
            });
            setPendingValues(null);
            onClose();
        } catch {
            // Mutation error is surfaced via `update.error`. The form
            // doesn't render that here — the caller shows a toast.
        }
    }

    async function onSubmit(values) {
        const originalRole = userQuery.data?.role || ROLES.USER;
        if (values.role !== originalRole) {
            // Stash and wait for explicit confirmation.
            setPendingValues(values);
            return;
        }
        await performSubmit(values);
    }

    const fromRole = userQuery.data?.role || ROLES.USER;
    const toRole = pendingValues?.role;

    function onConfirmRoleChange() {
        if (pendingValues) {
            performSubmit(pendingValues);
        }
    }

    function onCancelRoleChange() {
        setPendingValues(null);
    }

    return (
        <>
            <Modal open={open} onClose={onClose} title="Edit user" size="md">
                {loading ? (
                    <div className={styles.loading}>
                        <Spinner />
                        <span>Loading user…</span>
                    </div>
                ) : (
                    <form
                        className={styles.form}
                        onSubmit={handleSubmit(onSubmit)}
                        noValidate
                    >
                        <Input
                            label="Name"
                            autoComplete="name"
                            required
                            error={errors.fullName?.message}
                            {...register("fullName")}
                        />
                        <Input
                            label="Email"
                            type="email"
                            autoComplete="email"
                            required
                            error={errors.email?.message}
                            {...register("email")}
                        />

                        <Controller
                            name="role"
                            control={control}
                            render={({ field }) => (
                                <div className={styles.field}>
                                    <span className={styles.fieldLabel}>
                                        Role <span className={styles.required}>*</span>
                                    </span>
                                    <div
                                        className={styles.radioGroup}
                                        role="radiogroup"
                                        aria-label="Role"
                                    >
                                        {USER_FILTER_ROLES.map((r) => {
                                            const Icon = ROLE_ICONS[r];
                                            const active = field.value === r;
                                            return (
                                                <button
                                                    key={r}
                                                    type="button"
                                                    role="radio"
                                                    aria-checked={active}
                                                    className={`${styles.radio} ${
                                                        active ? styles.radioActive : ""
                                                    }`}
                                                    onClick={() =>
                                                        field.onChange(r)
                                                    }
                                                >
                                                    <Icon
                                                        className={styles.radioIcon}
                                                        aria-hidden="true"
                                                    />
                                                    <span
                                                        className={styles.radioText}
                                                    >
                                                        <span
                                                            className={
                                                                styles.radioTitle
                                                            }
                                                        >
                                                            {ROLE_LABELS[r] || r}
                                                        </span>
                                                        <span
                                                            className={
                                                                styles.radioHint
                                                            }
                                                        >
                                                            {ROLE_DESCRIPTIONS[r]}
                                                        </span>
                                                    </span>
                                                </button>
                                            );
                                        })}
                                    </div>
                                    {field.value === ROLES.ADMIN && (
                                        <p className={styles.hint}>
                                            Demoting an admin will be blocked if
                                            they're the last active admin on the
                                            system.
                                        </p>
                                    )}
                                    {errors.role && (
                                        <p
                                            className={styles.errorMsg}
                                            role="alert"
                                        >
                                            {errors.role.message}
                                        </p>
                                    )}
                                </div>
                            )}
                        />

                        {update.isError && (
                            <p className={styles.error} role="alert">
                                {update.error?.message || "Couldn't save changes."}
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
                                Save changes
                            </Button>
                        </div>
                    </form>
                )}
            </Modal>

            <Modal
                open={!!pendingRoleChange}
                onClose={onCancelRoleChange}
                title="Confirm role change"
                size="sm"
                hideCloseButton
                closeOnOverlay={false}
            >
                <div className={styles.confirmBody}>
                    <div className={styles.confirmIconWrap}>
                        <AlertTriangle
                            className={styles.confirmIcon}
                            aria-hidden="true"
                        />
                    </div>
                    <p className={styles.confirmText}>
                        Change{" "}
                        <strong>
                            {userQuery.data?.name || userQuery.data?.email}
                        </strong>
                        's role from{" "}
                        <strong>{ROLE_LABELS[fromRole]}</strong> (current) to{" "}
                        <strong>{ROLE_LABELS[toRole]}</strong>?
                    </p>
                    <p className={styles.confirmDetail}>
                        {transitionMessage(fromRole, toRole)}
                    </p>
                    {update.isError && (
                        <p className={styles.error} role="alert">
                            {update.error?.message || "Couldn't save changes."}
                        </p>
                    )}
                    <div className={styles.actions}>
                        <Button
                            variant="secondary"
                            type="button"
                            onClick={onCancelRoleChange}
                            disabled={isSubmitting}
                        >
                            Cancel
                        </Button>
                        <Button
                            type="button"
                            onClick={onConfirmRoleChange}
                            loading={isSubmitting}
                        >
                            Confirm change
                        </Button>
                    </div>
                </div>
            </Modal>
        </>
    );
}