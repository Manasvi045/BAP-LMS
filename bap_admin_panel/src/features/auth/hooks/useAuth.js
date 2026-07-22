// features/auth/hooks/useAuth.js
// =====================================================================
// Convenience hook. Lives in features/auth/hooks/ per the project's
// "features self-contained" rule. The actual implementation lives in
// the AuthContext; this file just re-exports it so feature code has a
// stable import path.
// =====================================================================

export { useAuthContext as useAuth } from "../../../contexts/AuthContext";