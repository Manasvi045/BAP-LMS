// tools/reset-password.js
// ============================================================================
// Ops CLI: reset a user's password by talking to the database directly.
//
// Use this when a user (typically the only admin) has forgotten their
// password and cannot use the self-service /api/auth/change-password
// flow. It does not require the caller to be logged in — it only needs
// DATABASE_URL from .env to be reachable.
//
// Usage:
//     node tools/reset-password.js --list
//     node tools/reset-password.js --email <addr>            # auto-generates
//     node tools/reset-password.js --email <addr> --password "NewP@ss123"
//     node tools/reset-password.js --id <user_id> --password "NewP@ss123"
//
// In auto-generate mode the new password is printed once on stdout. It
// is not stored anywhere — copy it to the user through a side channel
// (in person, secure chat, etc.) and ask them to change it on first
// login via the new "Change password" item in the profile menu.
// ============================================================================

require("dotenv").config({ quiet: true });
const bcrypt = require("bcrypt");
const pool = require("../config/db");
const generatePassword = require("../utils/generatePassword");

// Quiet the noisy pg SSL warning that fires on every TLS connection.
const origEmit = process.emitWarning;
process.emitWarning = function (warning, ...args) {
    if (typeof warning === "string" && warning.includes("SSL modes")) return;
    return origEmit.call(this, warning, ...args);
};

function parseArgs(argv) {
    const out = { _: [] };
    for (let i = 2; i < argv.length; i += 1) {
        const tok = argv[i];
        if (!tok || !tok.startsWith("--")) {
            out._.push(tok);
            continue;
        }
        const key = tok.slice(2);
        const next = argv[i + 1];
        // Flag-only (next is another --flag or end-of-argv) → boolean true.
        if (next === undefined || next.startsWith("--")) {
            out[key] = true;
        } else {
            out[key] = next;
            i += 1;
        }
    }
    return out;
}

function usage() {
    process.stdout.write(
        [
            "Usage:",
            "  node tools/reset-password.js --list",
            '  node tools/reset-password.js --email <addr> [--password "<new>"]',
            '  node tools/reset-password.js --id <user_id>   [--password "<new>"]',
            "",
            "If --password is omitted, a 16-character random password is",
            "generated, hashed with bcrypt, written to the DB, and printed",
            "once on stdout. --password must be at least 8 characters.",
            "",
        ].join("\n")
    );
}

async function listUsers() {
    const r = await pool.query(
        `SELECT id, full_name, email, role, is_active, must_change_password,
                created_at, updated_at
         FROM users
         ORDER BY id`
    );
    if (r.rows.length === 0) {
        console.log("(no users in the database yet)");
        return;
    }
    const rows = r.rows.map((u) => ({
        id: u.id,
        name: u.full_name,
        email: u.email,
        role: u.role,
        active: u.is_active,
        mustChange: u.must_change_password,
        createdAt: u.created_at?.toISOString?.() ?? u.created_at,
    }));
    console.table(rows);
}

async function findUser({ id, email }) {
    if (id) {
        const r = await pool.query(
            "SELECT id, email, role, is_active FROM users WHERE id = $1",
            [Number(id)]
        );
        if (r.rows.length === 0) {
            throw new Error(`No user with id=${id}`);
        }
        return r.rows[0];
    }
    if (email) {
        const r = await pool.query(
            "SELECT id, email, role, is_active FROM users WHERE LOWER(email) = LOWER($1)",
            [email]
        );
        if (r.rows.length === 0) {
            throw new Error(`No user with email=${email}`);
        }
        return r.rows[0];
    }
    throw new Error("Specify --id or --email (or use --list to inspect).");
}

async function resetPassword({ user, newPassword }) {
    if (typeof newPassword !== "string" || newPassword.length < 8) {
        throw new Error("Password must be a string of at least 8 characters.");
    }
    const hash = await bcrypt.hash(newPassword, 10);
    const r = await pool.query(
        `UPDATE users
            SET password = $1,
                must_change_password = TRUE,
                updated_at = CURRENT_TIMESTAMP
          WHERE id = $2
          RETURNING id, email`,
        [hash, user.id]
    );
    if (r.rows.length === 0) {
        throw new Error("Update affected 0 rows.");
    }
}

async function main() {
    const args = parseArgs(process.argv);

    if (args.help || args.h) {
        usage();
        process.exit(0);
    }

    if (args.list) {
        await listUsers();
        process.exit(0);
    }

    const user = await findUser({ id: args.id, email: args.email });

    const supplied = args.password;
    const generated = !supplied;
    const newPassword = supplied || generatePassword(16);

    await resetPassword({ user, newPassword });

    console.log(`✔ Password reset for user id=${user.id} email=${user.email}`);
    console.log(`  role=${user.role}  active=${user.is_active}`);
    console.log(`  must_change_password set TRUE — they'll be prompted to`);
    console.log(`  rotate it on next sign-in via the profile menu.`);
    if (generated) {
        console.log("");
        console.log(`  New password (auto-generated, shown once):`);
        console.log(`    ${newPassword}`);
        console.log("");
        console.log(`  → Communicate this securely. It is not stored anywhere.`);
    }
}

main()
    .catch((err) => {
        console.error("✘", err.message || err);
        process.exitCode = 1;
    })
    .finally(() => pool.end());