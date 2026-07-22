// components/ui/ErrorBoundary.jsx
// =====================================================================
// Top-level catch-all. Logs the error and shows a recovery panel.
// Wraps the entire app from main.jsx.
// =====================================================================

import { Component } from "react";
import styles from "./ErrorBoundary.module.css";

export class ErrorBoundary extends Component {
    constructor(props) {
        super(props);
        this.state = { error: null };
    }

    static getDerivedStateFromError(error) {
        return { error };
    }

    componentDidCatch(error, info) {
        // eslint-disable-next-line no-console
        console.error("ErrorBoundary caught:", error, info);
    }

    handleReset = () => {
        this.setState({ error: null });
        window.location.href = "/";
    };

    render() {
        if (this.state.error) {
            return (
                <div className={styles.container} role="alert">
                    <h1 className={styles.title}>Something went wrong.</h1>
                    <p className={styles.message}>
                        {this.state.error?.message || "Unexpected error"}
                    </p>
                    <button
                        type="button"
                        className={styles.button}
                        onClick={this.handleReset}
                    >
                        Go to home
                    </button>
                </div>
            );
        }
        return this.props.children;
    }
}