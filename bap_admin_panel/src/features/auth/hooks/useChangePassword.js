// features/auth/hooks/useChangePassword.js
// =====================================================================
// Mutation: POST /api/auth/change-password (self-service). The caller
// is the only person whose password can be changed through this hook,
// because the backend derives the user id from the JWT — even if a
// client tampers with the request body, no other user's hash is
// reachable from this endpoint.
// =====================================================================

import { useMutation } from "@tanstack/react-query";
import { authApi } from "../../../api/authApi";

export function useChangePassword() {
    return useMutation({
        mutationFn: ({ currentPassword, newPassword, confirmPassword }) =>
            authApi.changePassword({ currentPassword, newPassword, confirmPassword }),
    });
}