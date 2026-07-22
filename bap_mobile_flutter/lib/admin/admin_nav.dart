// lib/admin/admin_nav.dart
// ============================================================================
// Admin navigation. Mirrors the learner app's sealed-class NavController
// pattern (see lib/state/nav.dart) but simplified for the admin shell —
// a flat set of root tabs with no deep back-stack history.
//
// Destinations:
//   - dashboard  → GET /api/dashboard/stats
//   - users      → /api/users (list, search, detail, status, reset pwd)
//   - content    → /api/verticals, /api/modules, /api/sections (read-only)
//   - activity   → recent events (Phase 5 stub for now)
//   - profile    → admin self-service profile + sign out
//
// The drawer exposes every destination (incl. ones not in the bottom
// nav — activity, notifications, profile), plus the sign-out entry.
// ============================================================================

import 'package:flutter/material.dart';

/// Root destinations the admin shell can render.
enum AdminTab { dashboard, users, content, activity, profile }

/// Sealed target. Each tab is its own subtype so call sites can pattern
/// match exhaustively. (Future-proofs nested routes — e.g. a user
/// detail screen could become `AdminUserDetail(id)`.)
@immutable
sealed class AdminNavTarget {
  const AdminNavTarget();
}

@immutable
class AdminDashboardTab extends AdminNavTarget {
  const AdminDashboardTab();
}

@immutable
class AdminUsersTab extends AdminNavTarget {
  const AdminUsersTab();
}

@immutable
class AdminContentTab extends AdminNavTarget {
  const AdminContentTab();
}

@immutable
class AdminActivityTab extends AdminNavTarget {
  const AdminActivityTab();
}

@immutable
class AdminProfileTab extends AdminNavTarget {
  const AdminProfileTab();
}

/// Maps each tab to its sealed target. The drawer's profile entry and
/// the bottom nav's profile entry both produce `AdminProfileTab()`.
AdminNavTarget targetForTab(AdminTab tab) {
  switch (tab) {
    case AdminTab.dashboard:
      return const AdminDashboardTab();
    case AdminTab.users:
      return const AdminUsersTab();
    case AdminTab.content:
      return const AdminContentTab();
    case AdminTab.activity:
      return const AdminActivityTab();
    case AdminTab.profile:
      return const AdminProfileTab();
  }
}

/// Which tabs live in the bottom nav. Activity + Profile are reachable
/// via the drawer; the bottom nav carries the four highest-frequency
/// sections (dashboard, users, content, profile).
const Set<AdminTab> adminBottomNavTabs = {
  AdminTab.dashboard,
  AdminTab.users,
  AdminTab.content,
  AdminTab.profile,
};

/// All tabs the drawer exposes. Order is the order they appear.
const List<AdminTab> adminDrawerTabs = [
  AdminTab.dashboard,
  AdminTab.users,
  AdminTab.content,
  AdminTab.activity,
  AdminTab.profile,
];

/// Human-readable label for each tab.
String labelForTab(AdminTab tab) {
  switch (tab) {
    case AdminTab.dashboard:
      return 'Dashboard';
    case AdminTab.users:
      return 'User Management';
    case AdminTab.content:
      return 'Content';
    case AdminTab.activity:
      return 'Recent Activity';
    case AdminTab.profile:
      return 'Profile';
  }
}

/// Tab icon for the bottom nav / drawer.
@immutable
class AdminTabVisual {
  final IconData icon;
  final IconData activeIcon;
  const AdminTabVisual({required this.icon, required this.activeIcon});
}

AdminTabVisual visualForTab(AdminTab tab) {
  switch (tab) {
    case AdminTab.dashboard:
      return const AdminTabVisual(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
      );
    case AdminTab.users:
      return const AdminTabVisual(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
      );
    case AdminTab.content:
      return const AdminTabVisual(
        icon: Icons.article_outlined,
        activeIcon: Icons.article,
      );
    case AdminTab.activity:
      return const AdminTabVisual(
        icon: Icons.history,
        activeIcon: Icons.history,
      );
    case AdminTab.profile:
      return const AdminTabVisual(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
      );
  }
}

/// Simple value-notifier style controller. Admin has no back-stack
/// because every tab is a root — the back button is consumed by
/// "press again to exit" (Phase 9 polish), not by tab history.
class AdminNavController extends ChangeNotifier {
  AdminTab _current = AdminTab.dashboard;
  AdminTab get current => _current;

  /// Tracks whether the admin opened the drawer at least once, so we
  /// can hint at it the first time. Cosmetic only.
  bool _hasOpenedDrawer = false;
  bool get hasOpenedDrawer => _hasOpenedDrawer;

  void go(AdminTab tab) {
    if (_current == tab) return;
    _current = tab;
    notifyListeners();
  }

  void markDrawerOpened() {
    if (_hasOpenedDrawer) return;
    _hasOpenedDrawer = true;
    notifyListeners();
  }
}
