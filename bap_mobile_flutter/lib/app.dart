// lib/app.dart
// ============================================================================
// App shell — Phase 1 refactor.
//
// Two widgets now:
//
//   BapApp   — thin top-level wrapper. Owns the MaterialApp only.
//              Used by AuthGate for a learner session.
//
//   BapShell — the actual phone-frame shell. Owns all the runtime state
//              (theme, NavController, ProgressNotifier, ChatNotifier,
//              key-setup, back-toast). Embeddable inside ANY MaterialApp
//              ancestor so it can be pushed as a route from AdminHome in
//              Phase 2 (admin "View as learner"). For the learner flow
//              today, BapShell is hosted by BapApp's MaterialApp.
//
// Theme plumbing:
//   BapShell owns _themeName. Its build wraps the content in a Theme
//   widget using the same themeData it used to feed into MaterialApp.
//   Every `ctx.t` lookup inside the shell still resolves to BapShell's
//   theme, so toggling dark mode inside the shell looks identical to
//   before. The host MaterialApp.theme is set to a static light theme —
//   it is only seen by Material widgets OUTSIDE BapShell (none in the
//   learner flow today).
//
// Behavior is intentionally identical for learners; the structure now
// supports hosting the shell from any MaterialApp ancestor.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/chat_screen.dart';
import 'screens/key_setup_screen.dart';
import 'screens/learning_path.dart';
import 'screens/progress_dashboard.dart';
import 'screens/topic_select.dart';
import 'screens/vertical_select.dart';
import 'services/assistant/key_store.dart';
import 'state/chat.dart';
import 'state/nav.dart';
import 'state/progress.dart';
import 'theme/theme_builder.dart';
import 'theme/themes.dart';
import 'widgets/layout/back_toast.dart';
import 'widgets/layout/bottom_nav.dart';
import 'widgets/layout/header.dart';

// ===========================================================================
// BapApp — top-level entry used by AuthGate for learner sessions.
//
// Thin wrapper. Provides a MaterialApp so the route can launch on its
// own (no external MaterialApp required). All real state lives in
// BapShell.
// ===========================================================================

class BapApp extends StatelessWidget {
  /// Optional callback wired from AuthGate so the learner can sign out
  /// from the overflow menu in the header. The AuthGate handles the
  /// confirmation dialog + AuthService.logout() + route flip — Header
  /// only knows "user tapped Sign out".
  final Future<void> Function()? onSignOut;

  /// Stable user id used to namespace the local progress store so that
  /// admins/editors previewing the learner shell don't pollute a real
  /// learner's SharedPreferences on the same device. Empty falls back
  /// to the legacy un-namespaced key.
  final String userId;

  const BapApp({super.key, this.onSignOut, this.userId = ''});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BAP',
      debugShowCheckedModeBanner: false,
      // Static fallback theme at the MaterialApp layer. BapShell wraps
      // its content in a Theme widget using its own internal themeName,
      // so every `ctx.t` lookup inside the shell resolves to BapShell's
      // theme (the same as before this refactor).
      theme: buildThemeData(lightTheme),
      home: BapShell(onSignOut: onSignOut, userId: userId),
    );
  }
}

// ===========================================================================
// BapShell — the actual app shell: phone-frame chrome, header, body,
// bottom nav, back toast. Owns all runtime state. Embeddable inside any
// MaterialApp ancestor.
// ===========================================================================

class BapShell extends StatefulWidget {
  /// Optional callback wired from AuthGate so the learner can sign out
  /// from the overflow menu in the header. The AuthGate handles the
  /// confirmation dialog + AuthService.logout() + route flip — Header
  /// only knows "user tapped Sign out".
  final Future<void> Function()? onSignOut;

  /// Stable user id used to namespace the local progress store. See
  /// [BapApp.userId] — the same value is forwarded here.
  final String userId;

  const BapShell({super.key, this.onSignOut, this.userId = ''});

  @override
  State<BapShell> createState() => _BapShellState();
}

class _BapShellState extends State<BapShell> {
  /// The single source of truth for the active theme name. Lives here
  /// so `setState` triggers a theme rebuild for every `ctx.t` inside
  /// the shell.
  String _themeName = 'light';

  final NavController _nav = NavController();

  /// `late` because [ProgressNotifier] needs `widget.userId`, which is
  /// only available after the State is mounted. First access happens
  /// in initState / build, by which time `widget` is wired up.
  late final ProgressNotifier _progress = ProgressNotifier(
    store: SharedPrefsProgressStore(userId: widget.userId),
  );
  final ChatNotifier _chat = ChatNotifier(
    currentScreen: () => const NavVerticalSelect(),
    keyStore: const SharedPrefsKeyStore(),
  );
  bool? _hasKey;
  bool _keySetupOpen = false;
  bool _toastVisible = false;
  NavTarget _lastNonAssistant = const NavVerticalSelect();

  @override
  void initState() {
    super.initState();
    _nav.addListener(_onNavChange);
    keyStore.has().then((v) {
      if (!mounted) return;
      setState(() {
        _hasKey = v;
        if (!v) _keySetupOpen = true;
      });
    });
  }

  @override
  void dispose() {
    _nav.removeListener(_onNavChange);
    _progress.dispose();
    _chat.dispose();
    super.dispose();
  }

  void _onNavChange() {
    final cur = _nav.state.current;
    if (cur.screen != NavScreen.assistant) {
      _lastNonAssistant = cur;
    }
    setState(() {});
  }

  void _go(NavTarget next) => _nav.go(next);

  void _performBack() {
    final action = _nav.back();
    switch (action) {
      case BackPop(:final target):
        _nav.applyPop(target);
        setState(() {});
        break;
      case BackExit():
        SystemNavigator.pop();
        break;
      case BackShowToast():
        setState(() => _toastVisible = true);
        break;
      case BackNavigateVerticals():
        _nav.applyNavigateVerticals();
        setState(() {});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = _themeName == 'dark' ? darkTheme : lightTheme;
    final themeData = buildThemeData(t);
    final nav = _nav.state;
    final onLearn = nav.current.screen == NavScreen.verticals ||
        nav.current.screen == NavScreen.topics ||
        nav.current.screen == NavScreen.path;
    final isAssistant = nav.current.screen == NavScreen.assistant;
    final isProgress = nav.current.screen == NavScreen.progress;

    return Theme(
      data: themeData,
      child: PopScope(
        // canPop is dynamic: false when BapShell is the root route
        // (learner flow — back is owned by the in-shell NavController),
        // true when BapShell has been pushed on top of AdminHome via
        // "View as learner" — system back then pops to AdminHome.
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _performBack();
        },
        child: Builder(
          builder: (ctx) {
            final tCtx = ctx.t;
            return Container(
              color: tCtx.name == 'dark'
                  ? const Color(0xFF05060a)
                  : const Color(0xFFe7e9f1),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    decoration: BoxDecoration(
                      color: tCtx.bg,
                      boxShadow: tCtx.name == 'dark'
                          ? const [
                              BoxShadow(color: Color(0xFF1c2030), blurRadius: 0),
                            ]
                          : const [
                              BoxShadow(
                                color: Color(0x1F171A23),
                                blurRadius: 40,
                                offset: Offset(0, 0),
                              ),
                            ],
                    ),
                    child: Column(
                      children: [
                        Header(
                          themeName: _themeName,
                          setThemeName: (n) => setState(() => _themeName = n),
                          onHome: () => _go(const NavVerticalSelect()),
                          onSignOut: widget.onSignOut,
                        ),
                        Expanded(
                          child: ClipRect(
                            child: _ScreenArea(
                              nav: nav.current,
                              go: _go,
                              back: _performBack,
                              progress: _progress,
                              chat: _chat,
                              from: _lastNonAssistant,
                              keySetupOpen: _keySetupOpen,
                              hasKey: _hasKey,
                              onKeySaved: () => setState(() {
                                _hasKey = true;
                                _keySetupOpen = false;
                              }),
                              onKeySkipped: () =>
                                  setState(() => _keySetupOpen = false),
                              onClearKey: () async {
                                await keyStore.clear();
                                if (!mounted) return;
                                setState(() {
                                  _hasKey = false;
                                  _keySetupOpen = true;
                                });
                              },
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            BottomNav(
                              onLearn: onLearn,
                              isAssistant: isAssistant,
                              isProgress: isProgress,
                              onLearnClick: () => _go(const NavVerticalSelect()),
                              onAssistantClick: () => _go(const NavAssistant()),
                              onProgressClick: () => _go(const NavProgress()),
                            ),
                            BackToast(
                              show: _toastVisible,
                              onHide: () => setState(() => _toastVisible = false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScreenArea extends StatelessWidget {
  final NavTarget nav;
  final void Function(NavTarget) go;
  final VoidCallback back;
  final ProgressNotifier progress;
  final ChatNotifier chat;
  final NavTarget from;
  final bool keySetupOpen;
  final bool? hasKey;
  final VoidCallback onKeySaved;
  final VoidCallback onKeySkipped;
  final VoidCallback onClearKey;

  const _ScreenArea({
    required this.nav,
    required this.go,
    required this.back,
    required this.progress,
    required this.chat,
    required this.from,
    required this.keySetupOpen,
    required this.hasKey,
    required this.onKeySaved,
    required this.onKeySkipped,
    required this.onClearKey,
  });

  @override
  Widget build(BuildContext context) {
    final Widget body;
    switch (nav) {
      case NavVerticalSelect():
        body = VerticalSelectScreen(go: go);
        break;
      case NavTopicSelect(:final vId):
        body = TopicSelectScreen(
          vId: vId,
          back: back,
          go: go,
          get: (vId, tId) => progress.get(vId, tId),
        );
        break;
      case NavLearningPath(:final vId, :final tId):
        body = LearningPathScreen(
          vId: vId,
          tId: tId,
          back: back,
          get: (vid, tid) => progress.get(vid, tid),
          recordSection: (sec, score, pass) async {
            await progress.recordSection(vId, tId, sec, score, pass);
          },
          recordExam: (score, pass) async {
            await progress.recordExam(vId, tId, score, pass);
          },
        );
        break;
      case NavProgress():
        body = ProgressDashboardScreen(
          prog: progress.prog,
          get: progress.get,
          streak: progress.streak,
          go: go,
        );
        break;
      case NavAssistant():
        if (keySetupOpen) {
          body = KeySetupScreen(onSaved: onKeySaved, onSkip: onKeySkipped);
        } else {
          body = ChatScreen(
            key: ValueKey(hasKey ?? false),
            chat: chat,
            from: from,
            onOpenKeySetup: onClearKey,
          );
        }
        break;
    }
    return body;
  }
}