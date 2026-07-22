// db/migrate.js
// ============================================================================
// Lightweight, idempotent SQL migration runner.
// ----------------------------------------------------------------------------
// Reads db/schema/*.sql in alphabetical order. For each file not yet recorded
// in `schema_migrations`, runs the SQL inside a single transaction and then
// records the filename. Already-applied files are skipped.
//
// Usage:
//     node db/migrate.js
// ============================================================================

require("dotenv").config();
const fs = require("fs");
const path = require("path");
const pool = require("../config/db");

const SCHEMA_DIR = path.join(__dirname, "schema");

async function ensureMigrationsTable(client) {
    await client.query(`
        CREATE TABLE IF NOT EXISTS schema_migrations (
            name        VARCHAR(255) PRIMARY KEY,
            applied_at  TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
    `);
}

async function getApplied(client) {
    const result = await client.query(
        "SELECT name FROM schema_migrations ORDER BY name"
    );
    return new Set(result.rows.map((r) => r.name));
}

async function applyOne(client, filename, sql) {
    await client.query("BEGIN");
    try {
        await client.query(sql);
        await client.query(
            "INSERT INTO schema_migrations (name) VALUES ($1) ON CONFLICT (name) DO NOTHING",
            [filename]
        );
        await client.query("COMMIT");
    } catch (err) {
        await client.query("ROLLBACK");
        throw err;
    }
}

async function main() {
    const client = await pool.connect();
    try {
        await ensureMigrationsTable(client);
        const applied = await getApplied(client);

        const files = fs
            .readdirSync(SCHEMA_DIR)
            .filter((f) => f.endsWith(".sql"))
            .sort();

        if (files.length === 0) {
            console.log("No .sql files found in db/schema. Nothing to do.");
            return;
        }

        let newlyApplied = 0;
        for (const file of files) {
            if (applied.has(file)) {
                console.log(`  skip   ${file} (already applied)`);
                continue;
            }
            console.log(`  apply  ${file}`);
            const sql = fs.readFileSync(path.join(SCHEMA_DIR, file), "utf8");
            await applyOne(client, file, sql);
            newlyApplied++;
        }

        const skipped = files.length - newlyApplied;
        console.log(
            `\nDone. ${newlyApplied} applied, ${skipped} already up-to-date.`
        );
    } catch (err) {
        console.error("Migration failed:", err);
        process.exit(1);
    } finally {
        client.release();
        await pool.end();
    }
}

main();