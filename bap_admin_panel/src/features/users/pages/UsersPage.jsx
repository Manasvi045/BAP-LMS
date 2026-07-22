// features/users/pages/UsersPage.jsx
// =====================================================================
// Admin-only user management. Owns the filter+page state, dispatches
// actions on table rows (edit, toggle status, reset password), and
// shows toasts for mutation feedback.
// =====================================================================

import { useState } from "react";
import { AlertTriangle, UserPlus } from "lucide-react";
import { useAuth } from "../../auth/hooks/useAuth";
import { useToast } from "../../../hooks/useToast";
import { Button } from "../../../components/ui/Button";
import { UsersFilters } from "../components/UsersFilters";
import { UsersTable } from "../components/UsersTable";
import { UsersPagination } from "../components/UsersPagination";
import { EditUserModal } from "../components/EditUserModal";
import { ConfirmDialog } from "../components/ConfirmDialog";
import { ResetPasswordDialog } from "../components/ResetPasswordDialog";
import { CreateUserModal } from "../components/CreateUserModal";
import { ShowPasswordDialog } from "../components/ShowPasswordDialog";
import { useUsers } from "../hooks/useUsers";
import { useUpdateUserStatus } from "../hooks/useUpdateUserStatus";
import { USER_PAGE_SIZE } from "../../../utils/constants";
import styles from "./UsersPage.module.css";

const INITIAL_FILTERS = Object.freeze({
    search: "",
    role: "",
    status: "",
    page: 1,
    limit: USER_PAGE_SIZE,
});

export function UsersPage() {
    const { user: currentUser } = useAuth();
    const toast = useToast();
    const [filters, setFilters] = useState(INITIAL_FILTERS);

    const query = useUsers(filters);
    const toggleStatus = useUpdateUserStatus();

    const [editingUserId, setEditingUserId] = useState(null);
    const [toggleTarget, setToggleTarget] = useState(null);
    const [resetTarget, setResetTarget] = useState(null);
    const [creating, setCreating] = useState(false);
    const [generated, setGenerated] = useState(null); // { user, temporaryPassword } | null

    function handleAction(kind, user) {
        if (kind === "edit") setEditingUserId(user.id);
        if (kind === "toggle-status") setToggleTarget(user);
        if (kind === "reset-password") setResetTarget(user);
    }

    async function confirmToggleStatus() {
        if (!toggleTarget) return;
        try {
            await toggleStatus.mutateAsync({
                id: toggleTarget.id,
                isActive: !toggleTarget.isActive,
            });
            toast.success(
                toggleTarget.isActive
                    ? `${toggleTarget.name || toggleTarget.email} deactivated.`
                    : `${toggleTarget.name || toggleTarget.email} activated.`
            );
            setToggleTarget(null);
        } catch (err) {
            toast.error(err?.message || "Couldn't change status.");
        }
    }

    return (
        <div className={styles.page}>
            <header className={styles.header}>
                <div>
                    <h1 className={styles.title}>Users</h1>
                    <p className={styles.subtitle}>
                        Manage all accounts on the platform.
                    </p>
                </div>
                <Button
                    iconLeft={UserPlus}
                    onClick={() => setCreating(true)}
                >
                    Create user
                </Button>
            </header>

            <UsersFilters value={filters} onChange={setFilters} />

            {query.isError ? (
                <div className={styles.errorCard} role="alert">
                    <AlertTriangle className={styles.errorIcon} aria-hidden="true" />
                    <div>
                        <h2 className={styles.errorTitle}>
                            Couldn't load users
                        </h2>
                        <p className={styles.errorText}>
                            {query.error?.message || "Network error. Try again."}
                        </p>
                    </div>
                </div>
            ) : (
                <>
                    <UsersTable
                        users={query.data?.data || []}
                        loading={query.isLoading || query.isFetching}
                        onAction={handleAction}
                        currentUserId={currentUser?.id}
                    />
                    <UsersPagination
                        pagination={query.data?.pagination}
                        onPageChange={(page) =>
                            setFilters((f) => ({ ...f, page }))
                        }
                    />
                </>
            )}

            <EditUserModal
                userId={editingUserId}
                open={Boolean(editingUserId)}
                onClose={() => setEditingUserId(null)}
            />

            <ConfirmDialog
                open={Boolean(toggleTarget)}
                title={
                    toggleTarget?.isActive
                        ? "Deactivate user"
                        : "Activate user"
                }
                description={
                    toggleTarget
                        ? toggleTarget.isActive
                            ? `${toggleTarget.name || toggleTarget.email} will lose access immediately and won't be able to sign in until reactivated.`
                            : `${toggleTarget.name || toggleTarget.email} will be allowed to sign in again.`
                        : ""
                }
                confirmLabel={toggleTarget?.isActive ? "Deactivate" : "Activate"}
                danger={toggleTarget?.isActive}
                loading={toggleStatus.isPending}
                onConfirm={confirmToggleStatus}
                onClose={() => setToggleTarget(null)}
            />

            <ResetPasswordDialog
                open={Boolean(resetTarget)}
                user={resetTarget}
                onClose={() => setResetTarget(null)}
            />

            <CreateUserModal
                open={creating}
                onClose={() => setCreating(false)}
                onCreated={(result) => {
                    if (result?.temporaryPassword) {
                        setGenerated({
                            user: result.user,
                            temporaryPassword: result.temporaryPassword,
                        });
                    } else {
                        toast.success(
                            `${result?.user?.name || result?.user?.email} created.`
                        );
                    }
                }}
            />

            <ShowPasswordDialog
                open={Boolean(generated)}
                title="Save this password"
                subject={generated?.user?.name || generated?.user?.email}
                description="A temporary password has been generated for this account."
                password={generated?.temporaryPassword}
                onClose={() => {
                    if (generated?.user) {
                        toast.success(
                            `${generated.user.name || generated.user.email} created.`
                        );
                    }
                    setGenerated(null);
                }}
            />
        </div>
    );
}
