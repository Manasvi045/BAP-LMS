// features/users/hooks/useUpdateUser.js
// =====================================================================
// Mutation: PUT /api/users/:id. On success, replace the matching entry
// in the users list cache and the single-user cache.
// =====================================================================

import { useMutation, useQueryClient } from "@tanstack/react-query";
import { userApi } from "../../../api/userApi";
import { QUERY_KEYS } from "../../../utils/constants";

export function useUpdateUser() {
    const qc = useQueryClient();
    return useMutation({
        mutationFn: ({ id, fullName, email, role }) =>
            userApi.update(id, { fullName, email, role }),
        onSuccess: (user) => {
            if (!user) return;
            qc.setQueryData(QUERY_KEYS.USER(user.id), user);
            qc.invalidateQueries({ queryKey: QUERY_KEYS.USERS });
        },
    });
}
