// features/dashboard/hooks/useDashboardStats.js
// =====================================================================
// TanStack Query wrapper for the dashboard stats endpoint. Stale after
// 30 seconds — the dashboard is meant to feel live without spamming
// the backend.
// =====================================================================

import { useQuery } from "@tanstack/react-query";
import { dashboardApi } from "../../../api/dashboardApi";
import { QUERY_KEYS } from "../../../utils/constants";

export function useDashboardStats({ enabled = true } = {}) {
    return useQuery({
        queryKey: QUERY_KEYS.DASHBOARD_STATS,
        queryFn: () => dashboardApi.getStats(),
        enabled,
        staleTime: 30_000,
        refetchOnWindowFocus: false,
        retry: 1,
    });
}
