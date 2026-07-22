// features/users/hooks/useUpdateUserStatus.js
// =====================================================================
// Mutation: PATCH /api/users/:id/status. Invalidates both the user
// detail cache and the list cache; the dashboard stats query also
// invalidates because active/inactive counts shift.
// =====================================================================

import { useMutation, useQueryClient } from "@tanstack/react-query";
import { userApi } from "../../../api/userApi";
import { QUERY_KEYS } from "../../../utils/constants";

export function useUpdateUserStatus() {
    const qc = useQueryClient();
    return useMutation({
        mutationFn: ({ id, isActive }) => userApi.updateStatus(id, isActive),
        onSuccess: (user) => {
            if (user) qc.setQueryData(QUERY_KEYS.USER(user.id), user);
            qc.invalidateQueries({ queryKey: QUERY_KEYS.USERS });
            qc.invalidateQueries({ queryKey: QUERY_KEYS.DASHBOARD_STATS });
        },
    });
}
