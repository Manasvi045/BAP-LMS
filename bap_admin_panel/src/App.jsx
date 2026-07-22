// App.jsx
// =====================================================================
// Top-level composition: providers (Query, Auth, Theme) + the global
// toast surface + the router. Wrapped in ErrorBoundary inside main.jsx.
// =====================================================================

import { BrowserRouter } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "react-hot-toast";
import { AuthProvider } from "./contexts/AuthContext";
import { ThemeProvider } from "./contexts/ThemeContext";
import { AppRoutes } from "./routes/AppRoutes";

const queryClient = new QueryClient({
    defaultOptions: {
        queries: {
            refetchOnWindowFocus: false,
            retry: 1,
            staleTime: 30_000,
        },
    },
});

export function App() {
    return (
        <QueryClientProvider client={queryClient}>
            <ThemeProvider>
                <AuthProvider>
                    <BrowserRouter>
                        <AppRoutes />
                    </BrowserRouter>
                    <Toaster
                        position="top-right"
                        toastOptions={{
                            duration: 4000,
                            style: {
                                fontSize: "0.875rem",
                                borderRadius: "0.5rem",
                                background: "var(--color-bg-elevated)",
                                color: "var(--color-text)",
                                border: "1px solid var(--color-border)",
                            },
                        }}
                    />
                </AuthProvider>
            </ThemeProvider>
        </QueryClientProvider>
    );
}