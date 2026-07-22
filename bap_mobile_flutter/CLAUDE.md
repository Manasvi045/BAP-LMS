# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Scope

This repository is the BAP mobile Flutter application (`bap_mobile`). It is a native Flutter port of the BAP learning experience, with a learner shell and authenticated admin/read-only management surfaces. The backend and React web admin are separate projects; this repository consumes their HTTP APIs but does not contain them.

## Commands

Run these from the repository root:

```bash
flutter pub get                 # resolve dependencies
flutter analyze                 # static analysis using flutter_lints
flutter test                    # run the complete test suite
flutter test test/widget_test.dart
flutter test test/assistant_api_test.dart # run one test file
flutter test --plain-name "content parity vs React source" # run one named test
flutter run                     # launch on the selected device
flutter run --dart-define=API_BASE_URL=http://localhost:5000
flutter build apk               # Android release build
```

The app's default API URL is platform-dependent: `http://localhost:5000` on web/desktop/iOS simulator and `http://10.0.2.2:5000` on an Android emulator. Override it with `API_BASE_URL`; the admin web URL can similarly be overridden with `ADMIN_WEB_URL` (default port 3000). Use an accessible host address rather than `localhost` when running against a backend on a physical device.

## Architecture

### Startup and role routing

`lib/main.dart` starts `AuthGate`, not the learner app directly. `lib/auth/auth_gate.dart` loads a persisted JWT-backed session and routes through splash, login, forced password change, learner, or admin states. Learners enter `BapApp`; admin/editor users enter `AdminHome`. Auth state is persisted with `flutter_secure_storage`. `AuthService` owns login, password change, session loading/expiry checks, and logout.

`lib/api/api_client.dart` is the authenticated HTTP boundary for admin/management calls. It reads the bearer token, normalizes backend response envelopes (`data`/`user`), maps errors to `ApiException`, and treats HTTP 401 specially: it clears the session and broadcasts through `SessionEvents`, which `AuthGate` uses to return to login. Auth endpoints themselves go through `AuthService` rather than `ApiClient`.

### Learner shell

`lib/app.dart` owns the learner MaterialApp, theme selection, phone-width frame, header, bottom navigation, back handling, progress notifier, and chat notifier. Screen selection is explicit and exhaustive through the sealed `NavTarget` hierarchy in `lib/state/nav.dart` (`verticals`, `topics`, `path`, `assistant`, and `progress`). Keep navigation state in `NavController`; screens receive callbacks and state rather than introducing a second router.

Learner flow is vertical selection → topic selection → learning path → section players/exam. Progress is held by `ProgressNotifier` in `lib/state/progress.dart`, keyed by `vId.tId`, and persisted to `shared_preferences` through the `ProgressStore` abstraction. Tests can inject an in-memory store.

### Content model and renderers

The course is compile-time Dart data, assembled by `lib/data/registry.dart` from the four vertical indexes under `lib/data/verticals/`. The immutable model in `lib/models/content.dart` represents the hierarchy `DataRegistry → Vertical → Topic → Section → Page`; `Page` is a sealed union with read, video, table, cards, decision, anatomy, carousel, and placeholder variants. New page variants require updating exhaustive renderer switches, especially `lib/widgets/blocks/page_view.dart`, and any assistant/context handling that deliberately filters page types.

`lib/data/page_builders.dart` and the vertical data files are the content authoring layer. `lib/data/lookup.dart` provides IDs/titles used by navigation and progress. Block widgets under `lib/widgets/blocks/`, player widgets under `lib/widgets/players/`, and screens under `lib/screens/` render the model. `test/parity_test.dart` guards parity with the source content totals (4 verticals, 10 topics, 56 sections, 224 pages).

### Assistant

`lib/state/chat.dart` owns chat messages, placeholder mode, streaming state, cancellation, and errors. `lib/services/assistant/context.dart` builds a bounded RAG-style system prompt from the local content registry and omits quiz/exam answers and video bodies. `lib/services/assistant/api.dart` is an OpenRouter-compatible OpenAI chat-completions SSE client; it supports injected `http.Client`s for tests and maps common HTTP failures to `AssistantError`. The user key is stored through `lib/services/assistant/key_store.dart` (secure storage), with setup handled by `KeySetupScreen`.

### Admin surface

`lib/admin/admin_home.dart` is a second shell with its own `AdminNavController`, drawer, bottom navigation, and tab router. Dashboard, users, content, activity placeholder, and profile tabs are wired there. Admin services (`dashboard_service.dart`, `user_service.dart`, `content_service.dart`) are thin typed wrappers over `ApiClient`. Mobile admin content is intentionally read-only; content editing belongs in the separate React web admin.

### Theme and UI conventions

Theme definitions live in `lib/theme/themes.dart`, built into Material themes by `theme_builder.dart`, with the project-specific `AppThemeExt` accessed through `context.t`. Reusable primitives are in `lib/widgets/primitives/`; layout chrome is in `lib/widgets/layout/`. Preserve the existing sealed-class/pattern-switch style and pure notifier/service boundaries when extending behavior.

## Tests

The suite contains widget smoke coverage, content parity, learning-path unlock behavior, progress persistence, assistant context generation, and mocked assistant SSE/API behavior. Tests are under `test/` and use `flutter_test`; network tests use injected/mock HTTP clients and should not contact OpenRouter or the backend.

## Repository notes

`README.md` is still the stock Flutter template and does not describe the application architecture; this file is the authoritative repository-specific guide. No Cursor rules or GitHub Copilot instruction file were found during initialization.
