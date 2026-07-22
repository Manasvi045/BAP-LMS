// lib/services/assistant/provider.dart — 1-line flip between placeholder and OpenRouter.
// 1:1 port of src/lib/assistant/provider.ts.

/// The assistant can be either the canned placeholder (Phase 3) or the real
/// OpenRouter stream (Phase 5).
enum AssistantProvider { placeholder, openrouter }

/// Active provider. Flip back to `placeholder` to disable the live stream
/// (e.g. for demo runs without a key, or if OpenRouter is unreachable).
const AssistantProvider activeProvider = AssistantProvider.openrouter;