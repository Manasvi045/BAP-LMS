// routes/sectionRoutes.js
// ============================================================================
// Phase 4.4 — Section CRUD routes.
//
// RBAC:
//   list, get, create, update -> admin and editor (both can author content)
//   delete                     -> admin only (destructive)
//
// Mounted at /api/sections in server.js.
// ============================================================================

const express = require("express");
const router = express.Router();

const authenticate = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

const {
    listSections,
    getSectionById,
    createSection,
    updateSection,
    deleteSection
} = require("../controllers/sectionController");

router.get("/", authenticate, authorize("admin", "editor"), listSections);
router.get("/:id", authenticate, authorize("admin", "editor"), getSectionById);

router.post("/", authenticate, authorize("admin", "editor"), createSection);
router.put("/:id", authenticate, authorize("admin", "editor"), updateSection);

router.delete("/:id", authenticate, authorize("admin"), deleteSection);

module.exports = router;