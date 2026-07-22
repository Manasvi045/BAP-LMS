// features/auth/pages/LoginPage.jsx
// =====================================================================
// The login form. Uses React Hook Form + Zod resolver. On submit, calls
// the auth context's `login` and routes to the dashboard on success.
// =====================================================================

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useNavigate, useLocation } from "react-router-dom";
import { Mail, Lock, LogIn } from "lucide-react";
import { Button } from "../../../components/ui/Button";
import { Input } from "../../../components/ui/Input";
import { useAuth } from "../hooks/useAuth";
import { useToast } from "../../../hooks/useToast";
import { loginSchema, loginDefaultValues } from "../schemas/loginSchema";
import styles from "./LoginPage.module.css";

export function LoginPage() {
    const { login } = useAuth();
    const navigate = useNavigate();
    const location = useLocation();
    const toast = useToast();
    const [submitting, setSubmitting] = useState(false);

    const {
        register,
        handleSubmit,
        formState: { errors },
    } = useForm({
        resolver: zodResolver(loginSchema),
        defaultValues: loginDefaultValues,
        mode: "onTouched",
    });

    const redirectTo = location.state?.from?.pathname || "/dashboard";

    async function onSubmit(values) {
        setSubmitting(true);
        try {
            const user = await login(values);
            toast.success(`Signed in as ${user.name || user.email}`);
            navigate(redirectTo, { replace: true });
        } catch (error) {
            const message =
                error?.response?.data?.message ||
                error?.message ||
                "Sign in failed. Check your credentials.";
            toast.error(message);
        } finally {
            setSubmitting(false);
        }
    }

    return (
        <div className={styles.page}>
            <h1 className={styles.title}>Sign in</h1>
            <p className={styles.subtitle}>
                Use your admin or editor credentials.
            </p>

            <form
                className={styles.form}
                onSubmit={handleSubmit(onSubmit)}
                noValidate
            >
                <Input
                    label="Email"
                    type="email"
                    autoComplete="email"
                    placeholder="you@example.com"
                    required
                    iconLeft={Mail}
                    error={errors.email?.message}
                    {...register("email")}
                />
                <Input
                    label="Password"
                    type="password"
                    autoComplete="current-password"
                    placeholder="••••••••"
                    required
                    iconLeft={Lock}
                    error={errors.password?.message}
                    {...register("password")}
                />
                <Button
                    type="submit"
                    variant="primary"
                    size="lg"
                    fullWidth
                    loading={submitting}
                    iconLeft={LogIn}
                >
                    Sign in
                </Button>
            </form>

            <p className={styles.hint}>
                Need access? Contact a workspace administrator.
            </p>
        </div>
    );
}