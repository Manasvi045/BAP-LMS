// features/users/hooks/useUsers.js
// =====================================================================
// Paginated list of users. Filters are passed as a single object so
// the cache key changes when any of them changes.
// =====================================================================

import { useQuery } from "@tanstack/react-query";
import { userApi } from "../../../api/userApi";
import { QUERY_KEYS } from "../../../utils/constants";

export function useUsers(filters) {
    const { search, role, status, page, limit } = filters;
    return useQuery({
        queryKey: [
            ...QUERY_KEYS.USERS,
            { search: search || "", role: role || "", status: status || "", page, limit },
        ],
        queryFn: () => userApi.list({ search, role, status, page, limit }),
        keepPreviousData: true,
        refetchOnWindowFocus: false,
        staleTime: 30_000,
    });
}
