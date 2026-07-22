// routes/verticalRoutes.js
// ============================================================================
// Phase 4.2 — Vertical CRUD routes.
//
// RBAC:
//   list, get, create, update -> admin and editor (both can author content)
//   delete                     -> admin only (destructive)
//
// Mounted at /api/verticals in server.js.
// ============================================================================

const express = require("express");
const router = express.Router();

const authenticate = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

const {
    listVerticals,
    getVerticalById,
    createVertical,
    updateVertical,
    deleteVertical
} = require("../controllers/verticalController");

router.get("/", authenticate, authorize("admin", "editor"), listVerticals);
router.get("/:id", authenticate, authorize("admin", "editor"), getVerticalById);

router.post("/", authenticate, authorize("admin", "editor"), createVertical);
router.put("/:id", authenticate, authorize("admin", "editor"), updateVertical);

router.delete("/:id", authenticate, authorize("admin"), deleteVertical);

module.exports = router;