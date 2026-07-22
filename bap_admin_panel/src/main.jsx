// main.jsx
// =====================================================================
// Entry point. Imports global styles (reset → tokens → globals) so the
// CSS variable palette is in scope before React mounts. ErrorBoundary
// wraps the entire tree so the UI never blanks out silently.
// =====================================================================

import React from "react";
import ReactDOM from "react-dom/client";
import { App } from "./App";
import { ErrorBoundary } from "./components/ui/ErrorBoundary";

import "./styles/reset.css";
import "./styles/tokens.css";
import "./styles/globals.css";

ReactDOM.createRoot(document.getElementById("root")).render(
    <React.StrictMode>
        <ErrorBoundary>
            <App />
        </ErrorBoundary>
    </React.StrictMode>
);