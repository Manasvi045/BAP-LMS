// contexts/ThemeContext.jsx
// =====================================================================
// Light/dark theme via the `data-theme` attribute on <html>. The actual
// colors come from CSS variables in styles/tokens.css — toggling the
// attribute swaps the entire palette atomically.
// =====================================================================

import { createContext, useContext, useEffect, useState, useCallback } from "react";
import { storage } from "../utils/storage";

const THEMES = Object.freeze({
    LIGHT: "light",
    DARK: "dark",
});

const ThemeContext = createContext(null);

function applyTheme(theme) {
    if (theme === THEMES.DARK) {
        document.documentElement.setAttribute("data-theme", "dark");
    } else {
        document.documentElement.removeAttribute("data-theme");
    }
}

export function ThemeProvider({ children }) {
    const [theme, setThemeState] = useState(() => storage.getTheme() || THEMES.LIGHT);

    useEffect(() => {
        applyTheme(theme);
        storage.setTheme(theme);
    }, [theme]);

    const setTheme = useCallback((next) => {
        setThemeState(next === THEMES.DARK ? THEMES.DARK : THEMES.LIGHT);
    }, []);

    const toggleTheme = useCallback(() => {
        setThemeState((prev) =>
            prev === THEMES.DARK ? THEMES.LIGHT : THEMES.DARK
        );
    }, []);

    return (
        <ThemeContext.Provider value={{ theme, setTheme, toggleTheme }}>
            {children}
        </ThemeContext.Provider>
    );
}

export function useTheme() {
    const ctx = useContext(ThemeContext);
    if (!ctx) {
        throw new Error("useTheme must be used within <ThemeProvider>");
    }
    return ctx;
}

export const THEME_VALUES = THEMES;