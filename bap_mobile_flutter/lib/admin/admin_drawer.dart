// lib/admin/admin_drawer.dart
// ============================================================================
// Admin drawer. Exposes every tab (incl. ones not in the bottom nav)
// plus a Sign Out entry. The user's name + role live in the header.
// ============================================================================

import 'package:flutter/material.dart';

import '../auth/auth_models.dart';
import '../auth/auth_service.dart';
import '../theme/theme_builder.dart';
import 'admin_nav.dart';

class AdminDrawer extends StatelessWidget {
  final AuthUser user;
  final AdminTab current;
  final ValueChanged<AdminTab> onSelect;
  final AuthService authService;
  final Future<void> Function() onSignOut;

  /// Optional callback wired by AdminHome to push the learner shell
  /// (BapShell) onto the navigator. Only rendered for users whose
  /// role is admin or editor — see [_showViewAsLearner].
  final VoidCallback? onViewAsLearner;

  const AdminDrawer({
    super.key,
    required this.user,
    required this.current,
    required this.onSelect,
    required this.authService,
    required this.onSignOut,
    this.onViewAsLearner,
  });

  bool get _showViewAsLearner =>
      onViewAsLearner != null && user.isAdminOrEditor;

  Future<void> _handleSignOut(BuildContext context) async {
    // Close the drawer first so the confirmation dialog lands cleanly.
    Navigator.of(context).maybePop();
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
    await onSignOut();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Drawer(
      backgroundColor: t.bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ----- Header -----
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                color: t.surface,
                border: Border(bottom: BorderSide(color: t.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: t.surfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: t.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'BAP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: t.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name.isEmpty ? '(admin)' : user.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: t.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Role: ${user.role}',
                    style: TextStyle(
                      fontSize: 12,
                      color: t.textMid,
                    ),
                  ),
                ],
              ),
            ),

            // ----- Sections -----
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (final tab in adminDrawerTabs)
                    _DrawerTile(
                      tab: tab,
                      active: tab == current,
                      onTap: () {
                        Navigator.of(context).maybePop();
                        onSelect(tab);
                      },
                    ),
                  // ----- Cross-surface: view as learner -----
                  // Only rendered for admin/editor users when the
                  // caller wired up [onViewAsLearner]. Visually
                  // separated by a divider so it reads as a different
                  // category of action (not another tab).
                  if (_showViewAsLearner) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: Divider(height: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                      child: Text(
                        'LEARNER SHELL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: t.textDim,
                        ),
                      ),
                    ),
                    _ViewAsLearnerTile(
                      onTap: () {
                        Navigator.of(context).maybePop();
                        onViewAsLearner!();
                      },
                    ),
                  ],
                ],
              ),
            ),

            // ----- Sign out -----
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: BoxDecoration(
                color: t.surface,
                border: Border(top: BorderSide(color: t.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () => _handleSignOut(context),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Sign out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: t.text,
                    side: BorderSide(color: t.borderStrong),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final AdminTab tab;
  final bool active;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final visual = visualForTab(tab);
    final fg = active ? t.text : t.textMid;
    final bg = active ? t.surfaceHover : Colors.transparent;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(active ? visual.activeIcon : visual.icon, size: 20, color: fg),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    labelForTab(tab),
                    style: TextStyle(
                      color: t.text,
                      fontSize: 14,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (active)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: t.text,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cross-surface tile used inside the admin drawer to push the learner
/// shell (BapShell). Visually distinct from the tab tiles — uses a
/// school icon and a "preview" badge to make it clear this is a
/// navigation to a different surface, not another tab in the admin
/// shell.
class _ViewAsLearnerTile extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewAsLearnerTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: t.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.school_outlined, size: 20, color: t.text),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'View as learner',
                        style: TextStyle(
                          color: t.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Preview the learner experience',
                        style: TextStyle(
                          color: t.textDim,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: t.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: t.border),
                  ),
                  child: Text(
                    'PREVIEW',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: t.textMid,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
