// routes/contentBlockRoutes.js
// ============================================================================
// Phase 4.5 — Content Block CRUD routes.
//
// RBAC:
//   list, get, create, update -> admin and editor (both can author content)
//   delete                     -> admin only (destructive)
//
// Mounted at /api/content-blocks in server.js.
// ============================================================================

const express = require("express");
const router = express.Router();

const authenticate = require("../middleware/authMiddleware");
const authorize = require("../middleware/roleMiddleware");

const {
    listContentBlocks,
    getContentBlockById,
    createContentBlock,
    updateContentBlock,
    deleteContentBlock
} = require("../controllers/contentBlockController");

router.get("/", authenticate, authorize("admin", "editor"), listContentBlocks);
router.get("/:id", authenticate, authorize("admin", "editor"), getContentBlockById);

router.post("/", authenticate, authorize("admin", "editor"), createContentBlock);
router.put("/:id", authenticate, authorize("admin", "editor"), updateContentBlock);

router.delete("/:id", authenticate, authorize("admin"), deleteContentBlock);

module.exports = router;