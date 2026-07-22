import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "node:path";

export default defineConfig({
    plugins: [react()],
    server: {
        port: 5173,
        strictPort: false,
        host: true,
    },
    preview: {
        port: 5173,
    },
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "src"),
        },
    },
    css: {
        modules: {
            localsConvention: "camelCase",
            generateScopedName: "[name]__[local]__[hash:base64:5]",
        },
    },
});
