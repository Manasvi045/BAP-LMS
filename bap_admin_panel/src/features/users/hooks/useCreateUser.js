// features/users/hooks/useCreateUser.js
// =====================================================================
// Mutation: POST /api/admin/create-user. On success, refetches the
// paginated users list so the new row appears without manual reload.
// =====================================================================

import { useMutation, useQueryClient } from "@tanstack/react-query";
import { userApi } from "../../../api/userApi";
import { QUERY_KEYS } from "../../../utils/constants";

export function useCreateUser() {
    const qc = useQueryClient();
    return useMutation({
        mutationFn: (payload) => userApi.create(payload),
        onSuccess: () => {
            qc.invalidateQueries({ queryKey: QUERY_KEYS.USERS });
            qc.invalidateQueries({ queryKey: QUERY_KEYS.DASHBOARD_STATS });
        },
    });
}
