// lib/auth/splash_screen.dart
// ============================================================================
// Splash screen shown for the brief moment between app launch and the
// first frame of `BapApp`. Reads the persisted session and hands the
// result to the parent (`AuthGate`) via `onResolved`:
//
//   * null               → no stored session, route to LoginScreen
//   * mustChangePassword → route to ChangePasswordScreen
//   * learner role       → route to BapApp (the existing learner app)
//   * admin/editor role  → route to the "use the web admin" notice
//
// The screen itself is intentionally minimal — its only job is to
// resolve a session and tell the gate which screen to show next.
// ============================================================================

import 'package:flutter/material.dart';

import '../theme/theme_builder.dart';
import 'auth_models.dart';
import 'auth_service.dart';

class SplashScreen extends StatefulWidget {
  final AuthService authService;
  final void Function(AuthSession? session) onResolved;

  const SplashScreen({
    super.key,
    required this.authService,
    required this.onResolved,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    try {
      final session = await widget.authService.loadSession();
      if (!mounted) return;
      widget.onResolved(session);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Failed to read saved session.');
      // Even on a read error we want to fall through to the login
      // screen — the gate will handle the routing. Surface the error
      // briefly so users aren't confused if storage is broken.
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        widget.onResolved(null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      backgroundColor: t.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: t.border),
                boxShadow: t.shadow,
              ),
              alignment: Alignment.center,
              child: Text(
                'BAP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: t.text,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'BAP',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: t.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _error ?? 'Loading…',
              style: TextStyle(
                fontSize: 13,
                color: _error != null
                    ? const Color(0xFFef4444)
                    : t.textDim,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(t.textMid),
              ),
            ),
          ],
        ),
      ),
    );
  }
}