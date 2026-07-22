// features/users/hooks/useUser.js
// =====================================================================
// Single-user fetch. Used by the edit modal to populate the form.
// =====================================================================

import { useQuery } from "@tanstack/react-query";
import { userApi } from "../../../api/userApi";
import { QUERY_KEYS } from "../../../utils/constants";

export function useUser(id, { enabled = true } = {}) {
    return useQuery({
        queryKey: QUERY_KEYS.USER(id),
        queryFn: () => userApi.getById(id),
        enabled: Boolean(id) && enabled,
        refetchOnWindowFocus: false,
        staleTime: 60_000,
    });
}
