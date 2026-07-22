-- ============================================================================
-- Phase 4 — Content Management schema
-- ----------------------------------------------------------------------------
-- Tables: verticals, modules, sections, content_blocks
-- Hierarchy: users -> verticals -> modules -> sections -> content_blocks
--
-- Conventions enforced here:
--   * All timestamps are TIMESTAMPTZ (timezone-aware, UTC on Neon).
--   * Soft delete via deleted_at IS NULL; all "active" queries filter on it.
--   * Uniqueness constraints are PARTIAL unique indexes on
--     (deleted_at IS NULL) so soft-deleted rows do not block reuse of
--     a name/slug.
--   * All audit FKs to users(id) use ON DELETE RESTRICT; soft-delete is
--     the intended removal path.
--   * No triggers. updated_at is bumped by the application on every write.
--   * No DB-level CHECK on content_blocks.type; the application validator
--     (utils/validators/blockType.js) is the single source of truth.
--
-- Prerequisites: the `users` table must already exist (created in Phase 1).
-- ============================================================================


-- ----------------------------------------------------------------------------
-- Table: verticals
-- ----------------------------------------------------------------------------
CREATE TABLE verticals (
    id              SERIAL          PRIMARY KEY,
    name            VARCHAR(255)    NOT NULL,
    slug            VARCHAR(150)    NOT NULL,
    description     TEXT,
    metadata        JSONB           NOT NULL DEFAULT '{}'::jsonb,
    display_order   INTEGER         NOT NULL DEFAULT 0,
    status          VARCHAR(20)     NOT NULL DEFAULT 'draft',
    created_by      INTEGER,
    updated_by      INTEGER,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT verticals_status_check
        CHECK (status IN ('draft', 'review', 'published', 'archived')),
    CONSTRAINT verticals_created_by_fk
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT verticals_updated_by_fk
        FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT
);

-- Partial unique index: soft-deleted verticals do not block slug reuse.
CREATE UNIQUE INDEX verticals_slug_unique_idx
    ON verticals (slug) WHERE deleted_at IS NULL;

CREATE INDEX verticals_status_active_idx
    ON verticals (status) WHERE deleted_at IS NULL;

CREATE INDEX verticals_display_order_active_idx
    ON verticals (display_order) WHERE deleted_at IS NULL;

CREATE INDEX verticals_metadata_gin_idx
    ON verticals USING GIN (metadata) WHERE deleted_at IS NULL;


-- ----------------------------------------------------------------------------
-- Table: modules
-- ----------------------------------------------------------------------------
CREATE TABLE modules (
    id              SERIAL          PRIMARY KEY,
    vertical_id     INTEGER         NOT NULL,
    name            VARCHAR(255)    NOT NULL,
    slug            VARCHAR(150)    NOT NULL,
    description     TEXT,
    metadata        JSONB           NOT NULL DEFAULT '{}'::jsonb,
    display_order   INTEGER         NOT NULL DEFAULT 0,
    status          VARCHAR(20)     NOT NULL DEFAULT 'draft',
    created_by      INTEGER,
    updated_by      INTEGER,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT modules_vertical_id_fk
        FOREIGN KEY (vertical_id) REFERENCES verticals(id) ON DELETE RESTRICT,
    CONSTRAINT modules_status_check
        CHECK (status IN ('draft', 'review', 'published', 'archived')),
    CONSTRAINT modules_created_by_fk
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT modules_updated_by_fk
        FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT
);

CREATE UNIQUE INDEX modules_vertical_slug_unique_idx
    ON modules (vertical_id, slug) WHERE deleted_at IS NULL;

CREATE INDEX modules_vertical_active_idx
    ON modules (vertical_id) WHERE deleted_at IS NULL;

CREATE INDEX modules_status_active_idx
    ON modules (status) WHERE deleted_at IS NULL;

CREATE INDEX modules_display_order_active_idx
    ON modules (display_order) WHERE deleted_at IS NULL;

CREATE INDEX modules_metadata_gin_idx
    ON modules USING GIN (metadata) WHERE deleted_at IS NULL;


-- ----------------------------------------------------------------------------
-- Table: sections
-- ----------------------------------------------------------------------------
CREATE TABLE sections (
    id              SERIAL          PRIMARY KEY,
    module_id       INTEGER         NOT NULL,
    name            VARCHAR(255)    NOT NULL,
    slug            VARCHAR(150)    NOT NULL,
    description     TEXT,
    metadata        JSONB           NOT NULL DEFAULT '{}'::jsonb,
    display_order   INTEGER         NOT NULL DEFAULT 0,
    status          VARCHAR(20)     NOT NULL DEFAULT 'draft',
    created_by      INTEGER,
    updated_by      INTEGER,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT sections_module_id_fk
        FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE RESTRICT,
    CONSTRAINT sections_status_check
        CHECK (status IN ('draft', 'review', 'published', 'archived')),
    CONSTRAINT sections_created_by_fk
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT sections_updated_by_fk
        FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT
);

CREATE UNIQUE INDEX sections_module_slug_unique_idx
    ON sections (module_id, slug) WHERE deleted_at IS NULL;

CREATE INDEX sections_module_active_idx
    ON sections (module_id) WHERE deleted_at IS NULL;

CREATE INDEX sections_status_active_idx
    ON sections (status) WHERE deleted_at IS NULL;

CREATE INDEX sections_display_order_active_idx
    ON sections (display_order) WHERE deleted_at IS NULL;

CREATE INDEX sections_metadata_gin_idx
    ON sections USING GIN (metadata) WHERE deleted_at IS NULL;


-- ----------------------------------------------------------------------------
-- Table: content_blocks
-- ----------------------------------------------------------------------------
CREATE TABLE content_blocks (
    id              SERIAL          PRIMARY KEY,
    section_id      INTEGER         NOT NULL,
    type            VARCHAR(50)     NOT NULL,
    content         JSONB           NOT NULL DEFAULT '{}'::jsonb,
    display_order   INTEGER         NOT NULL DEFAULT 0,
    created_by      INTEGER,
    updated_by      INTEGER,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT content_blocks_section_id_fk
        FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE RESTRICT,
    CONSTRAINT content_blocks_created_by_fk
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT content_blocks_updated_by_fk
        FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE RESTRICT
);

CREATE INDEX content_blocks_section_active_idx
    ON content_blocks (section_id) WHERE deleted_at IS NULL;

CREATE INDEX content_blocks_display_order_active_idx
    ON content_blocks (display_order) WHERE deleted_at IS NULL;

CREATE INDEX content_blocks_type_active_idx
    ON content_blocks (type) WHERE deleted_at IS NULL;

CREATE INDEX content_blocks_content_gin_idx
    ON content_blocks USING GIN (content) WHERE deleted_at IS NULL;