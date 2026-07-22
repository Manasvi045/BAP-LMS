// routes/learnRoutes.js
// ============================================================================
// Phase 5 — Learner-facing read routes.
// Phase 6 — User-scoped enrollment + progress routes.
//
// All endpoints require authentication (any role: admin / editor / learner).
// No role check — JWT validity is enough. See controllers/learnController.js
// and learnEnrollmentController.js / learnProgressController.js for the
// per-endpoint visibility rules and user-scoping rules.
//
// Mounted at /api/learn in server.js.
// ============================================================================

const express = require("express");
const router = express.Router();

const authenticate = require("../middleware/authMiddleware");

const {
    listVerticalsLearn,
    getVerticalLearn,
    getVerticalTreeLearn,
    listModulesForVerticalLearn,
    getModuleLearn,
    listSectionsForModuleLearn,
    getSectionLearn,
    listBlocksForSectionLearn,
    getBlockLearn
} = require("../controllers/learnController");

const {
    listMyEnrollments,
    getMyEnrollment,
    enrollInVertical,
    dropEnrollment,
    getMyVerticalProgress
} = require("../controllers/learnEnrollmentController");

const {
    getMyBlockProgress,
    markBlockStarted,
    markBlockCompleted,
    getMySectionProgress
} = require("../controllers/learnProgressController");

// ----------------------------------------------------------------------------
// Phase 5 — Read-only catalog endpoints.
// ----------------------------------------------------------------------------

// Vertical routes — declared in order of specificity to avoid /:id swallowing
// /:id/tree, /:id/modules, etc. (Express matches by segment count, so the
// ordering here is for readability, not correctness).
router.get("/verticals", authenticate, listVerticalsLearn);
router.get("/verticals/:id/tree", authenticate, getVerticalTreeLearn);
router.get("/verticals/:id/modules", authenticate, listModulesForVerticalLearn);
router.get("/verticals/:id", authenticate, getVerticalLearn);

// Module routes.
router.get("/modules/:id/sections", authenticate, listSectionsForModuleLearn);
router.get("/modules/:id", authenticate, getModuleLearn);

// Section routes.
router.get("/sections/:id/blocks", authenticate, listBlocksForSectionLearn);
router.get("/sections/:id", authenticate, getSectionLearn);

// Block routes.
router.get("/blocks/:id", authenticate, getBlockLearn);

// ----------------------------------------------------------------------------
// Phase 6 — User-scoped enrollment + progress endpoints.
// ----------------------------------------------------------------------------

// Enrollments — list mine, enroll in / drop a vertical.
router.get("/enrollments", authenticate, listMyEnrollments);
router.get("/verticals/:id/enroll", authenticate, getMyEnrollment);
router.post("/verticals/:id/enroll", authenticate, enrollInVertical);
router.delete("/verticals/:id/enroll", authenticate, dropEnrollment);

// Vertical progress rollup.
router.get("/verticals/:id/progress", authenticate, getMyVerticalProgress);

// Section progress rollup.
router.get("/sections/:id/progress", authenticate, getMySectionProgress);

// Block progress.
router.get("/blocks/:id/progress", authenticate, getMyBlockProgress);
router.post("/blocks/:id/start", authenticate, markBlockStarted);
router.post("/blocks/:id/complete", authenticate, markBlockCompleted);

module.exports = router;