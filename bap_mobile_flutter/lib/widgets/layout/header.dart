// lib/widgets/layout/header.dart — the top bar: BAP logo, name, subtitle,
// ThemeToggle, and (when wired) a visible "Sign out" entry.
//
// 1:1 port of src/components/layout/Header.tsx, plus the explicit
// sign-out surface for the learner AuthGate state.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/accents.dart';
import '../../theme/theme_builder.dart';
import 'theme_toggle.dart';

class Header extends StatelessWidget {
  final String themeName;
  final ValueChanged<String> setThemeName;
  final VoidCallback onHome;

  /// Optional callback for a Sign Out entry. When provided, a visible
  /// "Sign out" button appears next to the theme toggle. A confirmation
  /// dialog is shown before invoking [onSignOut]. The actual auth-service
  /// call is handled by the caller (see AuthGate → BapApp → Header).
  final Future<void> Function()? onSignOut;

  const Header({
    super.key,
    required this.themeName,
    required this.setThemeName,
    required this.onHome,
    this.onSignOut,
  });

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to sign in again to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (shouldSignOut == true && onSignOut != null) {
      await onSignOut!();
    }
  }

  Widget _buildLogo(BuildContext context) {
    final t = context.t;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onHome,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Accents.ortho.color, Accents.exam.gradient],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Center(
                  child: Text(
                    'B',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'BAP',
                    style: TextStyle(
                      color: t.text,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.1,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Business Acceleration Platform',
                    style: TextStyle(
                      color: t.textDim,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    final t = context.t;
    return TextButton.icon(
      onPressed: () => _confirmAndSignOut(context),
      icon: Icon(Icons.logout, size: 14, color: t.textMid),
      label: Text(
        'Sign out',
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: t.textMid,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: t.border),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final children = <Widget>[
      // Logo column — wrapped in Flexible so a long subtitle can't push
      // the right-side controls (theme + sign-out) off-screen.
      Flexible(flex: 5, fit: FlexFit.loose, child: _buildLogo(context)),
      const SizedBox(width: 8),
      ThemeToggle(themeName: themeName, setThemeName: setThemeName),
    ];
    if (onSignOut != null) {
      children.addAll(<Widget>[
        const SizedBox(width: 6),
        _buildSignOutButton(context),
      ]);
    }

    // SafeArea keeps the header chrome below the iOS status bar /
    // Dynamic Island so taps actually reach the buttons instead of
    // being intercepted as system gestures. Bottom is handled by
    // the BottomNav, so we leave it alone.
    return SafeArea(
      top: true,
      bottom: false,
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: t.navBar,
              border: Border(bottom: BorderSide(color: t.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
