-- Phase 6 — Enrollment + progress tracking.
--
-- Adds two user-scoped tables:
--   enrollments       — user ↔ vertical, with status (active / completed / dropped)
--   content_progress  — user ↔ content_block, with status (started / completed)
--
-- These tables are user-private — there's no "view another user's progress" surface
-- in v1 except admin analytics endpoints (separate, out of scope here).
--
-- Visibility / cascading:
--   * ON DELETE CASCADE from users.id and from verticals.id / content_blocks.id —
--     hard-deleting a user or content row purges their enrollment / progress.
--   * Soft-deletes (deleted_at IS NOT NULL) are NOT cascaded at the DB level; the
--     application filters them out via JOINs. Soft-deleting a vertical leaves
--     enrollments pointing at a now-invisible vertical — those return 404 on
--     read, same as the visibility rules in Phase 5.

-- ============================================================================
-- enrollments
-- ============================================================================
-- One row per (user, vertical). v1 enrollment scope is the vertical — finer
-- scopes (module, section) are future work.

CREATE TABLE enrollments (
    id                SERIAL          PRIMARY KEY,
    user_id           INTEGER         NOT NULL REFERENCES users(id)        ON DELETE CASCADE,
    vertical_id       INTEGER         NOT NULL REFERENCES verticals(id)    ON DELETE CASCADE,
    status            VARCHAR(20)     NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'completed', 'dropped')),
    created_at        TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at      TIMESTAMPTZ     NULL,
    last_accessed_at  TIMESTAMPTZ     NULL
);

-- One row per (user, vertical). Re-enrollment is handled by app logic — the
-- row is updated, not duplicated.
CREATE UNIQUE INDEX idx_enrollments_user_vertical ON enrollments (user_id, vertical_id);

-- Hot reads: "is user X enrolled in vertical Y?" / "list my enrollments".
CREATE INDEX idx_enrollments_user_active ON enrollments (user_id) WHERE status = 'active';
CREATE INDEX idx_enrollments_vertical   ON enrollments (vertical_id);

-- ============================================================================
-- content_progress
-- ============================================================================
-- One row per (user, content_block). Section / vertical completion is derived
-- by aggregation — no separate section_progress / vertical_progress tables.

CREATE TABLE content_progress (
    id            SERIAL          PRIMARY KEY,
    user_id       INTEGER         NOT NULL REFERENCES users(id)           ON DELETE CASCADE,
    block_id      INTEGER         NOT NULL REFERENCES content_blocks(id)  ON DELETE CASCADE,
    status        VARCHAR(20)     NOT NULL DEFAULT 'started'
        CHECK (status IN ('started', 'completed')),
    created_at    TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at  TIMESTAMPTZ     NULL
);

-- One row per (user, block). Re-marking is handled by app logic — UPDATE, not
-- INSERT, on conflict.
CREATE UNIQUE INDEX idx_progress_user_block ON content_progress (user_id, block_id);

-- Hot reads for rollups: "count my completed blocks in this section".
CREATE INDEX idx_progress_user_status ON content_progress (user_id, status);
CREATE INDEX idx_progress_block       ON content_progress (block_id);