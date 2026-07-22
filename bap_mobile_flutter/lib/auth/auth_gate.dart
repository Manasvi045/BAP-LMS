// lib/auth/auth_gate.dart
// ============================================================================
// Routing widget for the auth layer. Holds the current session in state
// and switches between the auth screens, the existing BapApp, and the
// AdminHome shell.
//
// State machine:
//
//                    ┌──────────┐
//                    │  splash  │  (initial — reads secure storage)
//                    └────┬─────┘
//                         │
//        ┌────────────────┼─────────────────┬─────────────────────┐
//        │                │                 │                     │
//   no session     mustChangePassword    role = user       role = admin/editor
//        │                │                 │                     │
//        ▼                ▼                 ▼                     ▼
//     ┌──────┐    ┌────────────────┐   ┌──────────┐      ┌────────────────┐
//     │login │    │change_password │   │  BapApp  │      │   AdminHome    │
//     └──┬───┘    └────────┬───────┘   └──────────┘      └────────┬───────┘
//        │ loggedIn        │ changed                              │ signOut
//        └────────────────►│◄─────────────────────────────────────┘
//                         ▼
//                     (re-evaluate)
//
// Session-expired events: when ApiClient receives a 401 it wipes the
// stored session and broadcasts via SessionEvents.expired. We listen
// here and route the user to the login screen with a toast that reads
// "Your session has expired. Please sign in again."
//
// Back-button guards: the login + change-password screens are wrapped
// in AuthBackGuard so the device back button can't pop back into the
// app shell after a sign-out.
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';

import '../admin/admin_home.dart';
import '../api/api_client.dart';
import '../app.dart';
import '../auth/auth_service.dart';
import '../theme/theme_builder.dart';
import '../theme/themes.dart';
import 'auth_models.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'splash_screen.dart';
import 'widgets/auth_back_guard.dart';

enum _GateState { splash, login, changePassword, learner, admin }

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _auth = AuthService();

  /// One ApiClient per session. Created when admin/editor lands in
  /// AdminHome and disposed on sign-out / gate tear-down.
  ApiClient? _api;

  _GateState _state = _GateState.splash;
  AuthSession? _session;

  /// One-shot message shown on the next login screen (e.g. when a 401
  /// forced a logout). Cleared as soon as the screen renders it.
  String? _pendingMessage;

  StreamSubscription<void>? _expiredSub;

  @override
  void initState() {
    super.initState();
    // Listen for session-expiry broadcasts from ApiClient.
    _expiredSub = SessionEvents.expired.listen(_onSessionExpired);
  }

  @override
  void dispose() {
    _expiredSub?.cancel();
    _api?.dispose();
    _auth.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Session-expired handler
  // ---------------------------------------------------------------------------

  void _onSessionExpired(void _) {
    if (!mounted) return;
    // AuthService has already wiped the JWT/user fields. Drop the
    // session in state, dispose any cached api client, and bounce
    // the user back to login with a friendly message.
    _api?.dispose();
    _api = null;
    setState(() {
      _session = null;
      _state = _GateState.login;
      _pendingMessage = 'Your session has expired. Please sign in again.';
    });
  }

  // ---------------------------------------------------------------------------
  // State transitions
  // ---------------------------------------------------------------------------

  void _onSplashResolved(AuthSession? session) {
    setState(() {
      _session = session;
      _state = _resolveState(session);
    });
  }

  void _onLoggedIn(AuthSession session) {
    setState(() {
      _session = session;
      _state = _resolveState(session);
      _pendingMessage = null;
    });
  }

  Future<void> _onPasswordChanged() async {
    final reloaded = await _auth.loadSession();
    if (!mounted) return;
    setState(() {
      _session = reloaded;
      _state = _resolveState(reloaded);
      _pendingMessage = null;
    });
  }

  Future<void> _onSignOut() async {
    await _auth.logout();
    if (!mounted) return;
    _api?.dispose();
    _api = null;
    setState(() {
      _session = null;
      _state = _GateState.login;
      _pendingMessage = null;
    });
  }

  _GateState _resolveState(AuthSession? s) {
    if (s == null) return _GateState.login;
    if (s.mustChangePassword) return _GateState.changePassword;
    if (s.user.isLearner) return _GateState.learner;
    return _GateState.admin;
  }

  /// Returns a live ApiClient, creating one on first use. Each fresh
  /// login creates a fresh client so it picks up the new bearer token.
  ApiClient _ensureApi() {
    return _api ??= ApiClient(authService: _auth);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _GateState.splash:
        return _AuthApp(
          child: SplashScreen(
            authService: _auth,
            onResolved: _onSplashResolved,
          ),
        );
      case _GateState.login:
        return _AuthApp(
          child: AuthBackGuard(
            child: LoginScreen(
              authService: _auth,
              onLoggedIn: _onLoggedIn,
              pendingMessage: _pendingMessage,
              onPendingMessageShown: () {
                if (!mounted) return;
                setState(() => _pendingMessage = null);
              },
            ),
          ),
        );
      case _GateState.changePassword:
        return _AuthApp(
          child: AuthBackGuard(
            child: ChangePasswordScreen(
              authService: _auth,
              onChanged: _onPasswordChanged,
            ),
          ),
        );
      case _GateState.learner:
        // Hand off to the existing app shell. The onSignOut callback
        // surfaces a Sign Out entry in the learner's header overflow
        // menu — the gate handles confirmation + AuthService.logout().
        return BapApp(onSignOut: _onSignOut);
      case _GateState.admin:
        // Wrap AdminHome in a MaterialApp so the AppThemeExt extension
        // is registered with the active ThemeData — without this, every
        // `context.t` access inside AdminHome and its descendants fires
        // "Null check operator used on a null value" on
        // Theme.of(this).extension<AppThemeExt>()!.
        return _AuthApp(
          child: AdminHome(
            session: _session!,
            authService: _auth,
            apiClient: _ensureApi(),
            onSignOut: _onSignOut,
          ),
        );
    }
  }
}

// ===========================================================================
// MaterialApp wrapper used by every screen that does NOT supply its own
// MaterialApp. Splash / login / change-password / AdminHome all flow
// through this so the AppThemeExt extension is registered with the
// active ThemeData — without it, `context.t` blows up with a
// "Null check operator used on a null value" at the very first build.
//
// BapApp owns its own MaterialApp internally, so the learner state of
// the gate does NOT pass through _AuthApp.
// ===========================================================================

class _AuthApp extends StatelessWidget {
  final Widget child;
  const _AuthApp({required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final t = brightness == Brightness.dark ? darkTheme : lightTheme;
    return MaterialApp(
      title: 'BAP',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(t),
      home: child,
    );
  }
}
