// features/users/schemas/userSchema.js
// =====================================================================
// Zod schemas for the user-edit + user-create forms. Mirrors the
// backend validation for PUT /api/users/:id and POST /api/admin/create-user.
// =====================================================================

import { z } from "zod";
import { ROLES } from "../../../utils/constants";

export const editUserSchema = z.object({
    fullName: z
        .string()
        .trim()
        .min(2, "Name must be at least 2 characters.")
        .max(100, "Name is too long."),
    email: z
        .string()
        .trim()
        .min(1, "Email is required.")
        .email("Enter a valid email.")
        .max(255, "Email is too long."),
    role: z.enum([ROLES.ADMIN, ROLES.EDITOR, ROLES.USER], {
        errorMap: () => ({ message: "Pick a role." }),
    }),
});

export const editUserDefaults = Object.freeze({
    fullName: "",
    email: "",
    role: ROLES.USER,
});

export const PASSWORD_MODE = Object.freeze({
    AUTO: "auto",
    MANUAL: "manual",
});

export const createUserSchema = z
    .object({
        fullName: editUserSchema.shape.fullName,
        email: editUserSchema.shape.email,
        role: z.enum([ROLES.ADMIN, ROLES.EDITOR, ROLES.USER], {
            errorMap: () => ({ message: "Pick a role." }),
        }),
        passwordMode: z.enum([PASSWORD_MODE.AUTO, PASSWORD_MODE.MANUAL], {
            errorMap: () => ({ message: "Pick a password mode." }),
        }),
        password: z.string().optional().or(z.literal("")),
        confirmPassword: z.string().optional().or(z.literal("")),
    })
    .superRefine((data, ctx) => {
        if (data.passwordMode !== PASSWORD_MODE.MANUAL) return;
        const pw = data.password || "";
        if (pw.length < 8) {
            ctx.addIssue({
                code: "custom",
                path: ["password"],
                message: "Password must be at least 8 characters.",
            });
        }
        if (pw !== (data.confirmPassword || "")) {
            ctx.addIssue({
                code: "custom",
                path: ["confirmPassword"],
                message: "Passwords do not match.",
            });
        }
    });

export const createUserDefaults = Object.freeze({
    fullName: "",
    email: "",
    role: ROLES.USER,
    passwordMode: PASSWORD_MODE.AUTO,
    password: "",
    confirmPassword: "",
});

