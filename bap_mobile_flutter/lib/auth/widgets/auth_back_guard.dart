// lib/auth/widgets/auth_back_guard.dart
// ============================================================================
// Wraps an auth screen so the device back button can't navigate back
// into a protected screen once the user has signed out. On Android this
// intercepts the system back; on iOS the gesture is naturally disabled
// because there is nothing to pop to.
// ============================================================================

import 'package:flutter/material.dart';

class AuthBackGuard extends StatelessWidget {
  final Widget child;
  const AuthBackGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: child,
    );
  }
}