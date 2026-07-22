-- Phase 4.6 — Publishing audit fields
-- ============================================================================
-- Adds published_at and published_by to verticals, modules, sections.
-- Populated by the publishing state machine (utils/validators/status.js)
-- whenever a row transitions INTO 'published'. Preserved across subsequent
-- unpublish / archive cycles; updated on re-publish.
--
-- Locked decision #20 (phase4_design.md §1).
-- ============================================================================

ALTER TABLE verticals
    ADD COLUMN published_at TIMESTAMPTZ NULL,
    ADD COLUMN published_by INTEGER NULL;

ALTER TABLE verticals
    ADD CONSTRAINT verticals_published_by_fkey
        FOREIGN KEY (published_by) REFERENCES users(id) ON DELETE RESTRICT;

ALTER TABLE modules
    ADD COLUMN published_at TIMESTAMPTZ NULL,
    ADD COLUMN published_by INTEGER NULL;

ALTER TABLE modules
    ADD CONSTRAINT modules_published_by_fkey
        FOREIGN KEY (published_by) REFERENCES users(id) ON DELETE RESTRICT;

ALTER TABLE sections
    ADD COLUMN published_at TIMESTAMPTZ NULL,
    ADD COLUMN published_by INTEGER NULL;

ALTER TABLE sections
    ADD CONSTRAINT sections_published_by_fkey
        FOREIGN KEY (published_by) REFERENCES users(id) ON DELETE RESTRICT;
