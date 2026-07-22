// lib/admin/admin_bottom_nav.dart
// ============================================================================
// Admin bottom-nav — 4 tabs (Dashboard / Users / Content / Profile).
// Mirrors the visual language of the learner BottomNav (blurred
// backdrop + flat NavTab-style icons) but uses its own widget because
// the admin has a different tab set.
// ============================================================================

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/theme_builder.dart';
import 'admin_nav.dart';

class AdminBottomNav extends StatelessWidget {
  final AdminTab current;
  final ValueChanged<AdminTab> onChanged;

  const AdminBottomNav({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: t.navBar,
            border: Border(top: BorderSide(color: t.border)),
          ),
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
          child: Row(
            children: [
              for (final tab in adminBottomNavTabs)
                Expanded(
                  child: _AdminNavTab(
                    tab: tab,
                    active: tab == current,
                    onTap: () => onChanged(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminNavTab extends StatelessWidget {
  final AdminTab tab;
  final bool active;
  final VoidCallback onTap;

  const _AdminNavTab({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final visual = visualForTab(tab);
    final c = active ? t.text : t.textDim;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(active ? visual.activeIcon : visual.icon,
                  size: 21, color: c),
              const SizedBox(height: 3),
              Text(
                _shortLabel(tab),
                style: TextStyle(
                  color: c,
                  fontSize: 10.5,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom-nav labels are tighter than the drawer labels.
  String _shortLabel(AdminTab tab) {
    switch (tab) {
      case AdminTab.dashboard:
        return 'Dashboard';
      case AdminTab.users:
        return 'Users';
      case AdminTab.content:
        return 'Content';
      case AdminTab.activity:
        return 'Activity';
      case AdminTab.profile:
        return 'Profile';
    }
  }
}
