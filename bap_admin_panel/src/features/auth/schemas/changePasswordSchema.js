// features/auth/schemas/changePasswordSchema.js
// =====================================================================
// Zod schema for the self-service "Change password" form. Mirrors the
// backend rules for POST /api/auth/change-password:
//
//   - currentPassword: required string (verified server-side)
//   - newPassword:     8-255 chars (matches validatePassword in
//                      lms_backend/utils/validation.js)
//   - confirmPassword: must equal newPassword
// =====================================================================

import { z } from "zod";

export const changePasswordSchema = z
    .object({
        currentPassword: z.string().min(1, "Enter your current password."),
        newPassword: z
            .string()
            .min(8, "New password must be at least 8 characters.")
            .max(255, "New password must be 255 characters or fewer."),
        confirmPassword: z
            .string()
            .min(1, "Re-enter your new password."),
    })
    .superRefine((data, ctx) => {
        if (data.newPassword !== data.confirmPassword) {
            ctx.addIssue({
                code: "custom",
                path: ["confirmPassword"],
                message: "Passwords do not match.",
            });
        }
        if (
            data.currentPassword &&
            data.newPassword &&
            data.currentPassword === data.newPassword
        ) {
            ctx.addIssue({
                code: "custom",
                path: ["newPassword"],
                message: "New password must be different from the current one.",
            });
        }
    });

export const changePasswordDefaults = Object.freeze({
    currentPassword: "",
    newPassword: "",
    confirmPassword: "",
});