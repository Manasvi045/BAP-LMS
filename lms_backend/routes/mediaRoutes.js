// routes/mediaRoutes.js
// ============================================================================
// Phase 4.7 — Media library routes.
//
// RBAC:
//   list, get, create   -> admin and editor
//   delete              -> admin or owner (enforced in controller)
//
// Mounted at /api/media in server.js.
// ============================================================================

const express = require("express");
const router = express.Router();

const authenticate = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

const {
    listMedia,
    getMediaById,
    createMedia,
    deleteMedia
} = require("../controllers/mediaController");

router.get("/", authenticate, authorize("admin", "editor"), listMedia);
router.get("/:id", authenticate, authorize("admin", "editor"), getMediaById);

router.post("/", authenticate, authorize("admin", "editor"), createMedia);

router.delete("/:id", authenticate, authorize("admin", "editor"), deleteMedia);

module.exports = router;