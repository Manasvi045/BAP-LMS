// hooks/useToast.js
// =====================================================================
// Thin wrapper around react-hot-toast. Centralizes the options so the
// rest of the app doesn't need to know the toast library's API.
// =====================================================================

import toast from "react-hot-toast";

const baseOptions = {
    duration: 4000,
    position: "top-right",
};

export function useToast() {
    return {
        success: (message, opts = {}) =>
            toast.success(message, { ...baseOptions, ...opts }),
        error: (message, opts = {}) =>
            toast.error(message, { ...baseOptions, ...opts }),
        info: (message, opts = {}) =>
            toast(message, { ...baseOptions, ...opts, icon: "ℹ️" }),
        warning: (message, opts = {}) =>
            toast(message, { ...baseOptions, ...opts, icon: "⚠️" }),
        dismiss: (id) => toast.dismiss(id),
        dismissAll: () => toast.dismiss(),
        loading: (message, opts = {}) =>
            toast.loading(message, { ...baseOptions, ...opts }),
    };
}