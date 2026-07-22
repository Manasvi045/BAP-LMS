-- Phase 4.7 — Media library
-- ============================================================================
-- The media table is a metadata library for URLs pointing at externally-hosted
-- assets (Cloudflare R2 in production; CDN, third-party hosts in dev/test).
-- v1 registers URLs only; actual file upload (R2 presigned PUT, local multipart)
-- is a follow-up phase.
--
-- URLs flow into content_blocks.content.image.url / video.url and into
-- verticals / modules / sections metadata — no FK constraint on those string
-- fields. The media table is the lookup library keyed by the unique URL.
--
-- Locked decisions:
--   #22 — Storage backend is the caller's choice (URL registration, no
--         backend-side upload in v1).
--   #23 — Editors see/delete their own media; admins see/delete all.
--   #24 — Soft delete only; hard delete / recycle-bin purge is a future
--         admin action.
-- ============================================================================

CREATE TABLE media (
    id                SERIAL          PRIMARY KEY,
    owner_id          INTEGER         NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    url               TEXT            NOT NULL,
    original_filename VARCHAR(255)    NOT NULL,
    content_type      VARCHAR(100)    NOT NULL,
    size_bytes        BIGINT          NOT NULL,
    kind              VARCHAR(20)     NOT NULL
        CHECK (kind IN ('image', 'video', 'audio', 'document', 'other')),
    width             INTEGER         NULL,
    height            INTEGER         NULL,
    duration_seconds  INTEGER         NULL,
    deleted_at        TIMESTAMPTZ     NULL,
    created_by        INTEGER         NULL REFERENCES users(id) ON DELETE RESTRICT,
    updated_by        INTEGER         NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at        TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Active rows only — partial indexes keep the indexes small as soft-deleted
-- rows accumulate, but the unique constraint still scopes to active rows so
-- a URL can be re-registered after soft delete.
CREATE UNIQUE INDEX idx_media_url_unique
    ON media (url) WHERE deleted_at IS NULL;
CREATE INDEX idx_media_owner
    ON media (owner_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_media_kind
    ON media (kind) WHERE deleted_at IS NULL;
CREATE INDEX idx_media_created_at
    ON media (created_at DESC) WHERE deleted_at IS NULL;
