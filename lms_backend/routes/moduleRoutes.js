// routes/moduleRoutes.js
// ============================================================================
// Phase 4.3 — Module CRUD routes.
//
// RBAC:
//   list, get, create, update -> admin and editor (both can author content)
//   delete                     -> admin only (destructive)
//
// Mounted at /api/modules in server.js.
// ============================================================================

const express = require("express");
const router = express.Router();

const authenticate = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

const {
    listModules,
    getModuleById,
    createModule,
    updateModule,
    deleteModule
} = require("../controllers/moduleController");

router.get("/", authenticate, authorize("admin", "editor"), listModules);
router.get("/:id", authenticate, authorize("admin", "editor"), getModuleById);

router.post("/", authenticate, authorize("admin", "editor"), createModule);
router.put("/:id", authenticate, authorize("admin", "editor"), updateModule);

router.delete("/:id", authenticate, authorize("admin"), deleteModule);

module.exports = router;