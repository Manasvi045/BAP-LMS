// features/auth/schemas/loginSchema.js
// =====================================================================
// Zod schema for the login form. Mirrors the backend's expectations for
// the POST /api/auth/login body (email + password).
// =====================================================================

import { z } from "zod";

export const loginSchema = z.object({
    email: z
        .string()
        .trim()
        .min(1, "Email is required.")
        .email("Enter a valid email."),
    password: z
        .string()
        .min(1, "Password is required."),
});

export const loginDefaultValues = Object.freeze({
    email: "",
    password: "",
});
