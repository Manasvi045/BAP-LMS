// lib/auth/widgets/sign_out_button.dart
// ============================================================================
// Shared Sign Out button. Single source of truth for the confirmation
// dialog and the logout call — used by both the learner (Profile) and
// the admin (drawer / dashboard) experiences.
//
// Flow on tap:
//   1. Show AlertDialog: "Are you sure you want to sign out?"
//   2. On confirm → AuthService.logout() (wipes token + user fields)
//   3. Call onSignedOut() so the caller (AuthGate) can transition state
// ============================================================================

import 'package:flutter/material.dart';

import '../auth_service.dart';

/// A reusable Sign Out button with the standard confirmation flow.
///
/// Variants: `filled` (default — solid dark) or `outlined` (used inside
/// card layouts where a low-emphasis button reads better).
class SignOutButton extends StatelessWidget {
  final AuthService authService;
  final Future<void> Function() onSignedOut;

  /// Visual variant. `filled` for primary CTAs, `outlined` for
  /// secondary/destructive placement.
  final SignOutButtonVariant variant;

  /// Optional label override (defaults to "Sign out").
  final String label;

  /// Optional icon override (defaults to a logout icon).
  final IconData icon;

  const SignOutButton({
    super.key,
    required this.authService,
    required this.onSignedOut,
    this.variant = SignOutButtonVariant.filled,
    this.label = 'Sign out',
    this.icon = Icons.logout,
  });

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await authService.logout();
    await onSignedOut();
  }

  @override
  Widget build(BuildContext context) {
    if (variant == SignOutButtonVariant.outlined) {
      return OutlinedButton.icon(
        onPressed: () => _confirmAndSignOut(context),
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
    return FilledButton.icon(
      onPressed: () => _confirmAndSignOut(context),
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

enum SignOutButtonVariant { filled, outlined }