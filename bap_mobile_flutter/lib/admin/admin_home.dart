// lib/admin/admin_home.dart
// ============================================================================
// Admin experience shell. Holds:
//   - the AdminNavController (current tab state)
//   - the phone-frame chrome (matches the learner BapApp)
//   - the AppBar (with menu → drawer)
//   - the body router (tab → real screen)
//   - the bottom nav
//   - the drawer
//
// ApiClient lifetime: one per AdminHome, disposed on widget tear-down.
//
// Body router maps each tab to its real screen:
//   dashboard → AdminDashboardScreen        (GET /api/dashboard/stats)
//   users     → UserListScreen              (GET /api/users)
//   content   → ContentScreen               (GET /api/{verticals,modules,sections})
//   activity  → AdminActivityPlaceholder    (no backend endpoint yet)
//   profile   → AdminProfileScreen          (self-service + sign out)
// ============================================================================

import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../auth/auth_models.dart';
import '../auth/auth_service.dart';
import '../auth/widgets/sign_out_button.dart';
import '../theme/theme_builder.dart';
import 'admin_bottom_nav.dart';
import 'admin_drawer.dart';
import 'admin_nav.dart';
import 'admin_placeholder_screens.dart';
import 'admin_profile_screen.dart';
import 'content_screen.dart';
import 'content_service.dart';
import 'dashboard_screen.dart';
import 'dashboard_service.dart';
import 'user_detail_screen.dart';
import 'user_list_screen.dart';
import 'user_models.dart';
import 'user_service.dart';

class AdminHome extends StatefulWidget {
  final AuthSession session;
  final AuthService authService;
  final ApiClient apiClient;
  final Future<void> Function() onSignOut;

  const AdminHome({
    super.key,
    required this.session,
    required this.authService,
    required this.apiClient,
    required this.onSignOut,
  });

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late final AdminNavController _nav;

  @override
  void initState() {
    super.initState();
    _nav = AdminNavController();
    _nav.addListener(_onNavChange);
  }

  void _onNavChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nav.removeListener(_onNavChange);
    _nav.dispose();
    widget.apiClient.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Body router
  // ---------------------------------------------------------------------------

  Widget _buildBody(AdminTab tab) {
    switch (tab) {
      case AdminTab.dashboard:
        return AdminDashboardScreen(
          service: DashboardService(apiClient: widget.apiClient),
          adminName: widget.session.user.name,
        );
      case AdminTab.users:
        return UserListScreen(
          service: UserService(apiClient: widget.apiClient),
          onUserTap: (u) => _openUserDetail(u),
        );
      case AdminTab.content:
        return ContentScreen(
          service: ContentService(apiClient: widget.apiClient),
        );
      case AdminTab.activity:
        return const AdminActivityPlaceholder();
      case AdminTab.profile:
        return AdminProfileScreen(
          authService: widget.authService,
          initialUser: widget.session.user,
          onSignOut: widget.onSignOut,
        );
    }
  }

  Future<void> _openUserDetail(AdminUser user) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserDetailScreen(
          service: UserService(apiClient: widget.apiClient),
          user: user,
          currentAdminId: widget.session.user.id,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // AppBar menu (sign out + quick actions)
  // ---------------------------------------------------------------------------

  PopupMenuButton<String> _buildAppBarMenu() {
    return PopupMenuButton<String>(
      tooltip: 'Account',
      onSelected: (value) async {
        if (value == 'signout') {
          await widget.authService.logout();
          await widget.onSignOut();
        } else if (value == 'profile') {
          _nav.go(AdminTab.profile);
        }
      },
      itemBuilder: (ctx) => const [
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 18),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'signout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 8),
              Text('Sign out'),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final user = widget.session.user;

    return Container(
      color: t.name == 'dark'
          ? const Color(0xFF05060a)
          : const Color(0xFFe7e9f1),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Material(
            color: t.bg,
            child: Scaffold(
              backgroundColor: t.bg,
              drawer: AdminDrawer(
                user: user,
                current: _nav.current,
                onSelect: _nav.go,
                authService: widget.authService,
                onSignOut: widget.onSignOut,
              ),
              appBar: AppBar(
                backgroundColor: t.surface,
                foregroundColor: t.text,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                title: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: t.surfaceAlt,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: t.border),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'BAP',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: t.text,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      labelForTab(_nav.current),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: t.text,
                      ),
                    ),
                  ],
                ),
                actions: [
                  _buildAppBarMenu(),
                  const SizedBox(width: 4),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ClipRect(
                      child: _buildBody(_nav.current),
                    ),
                  ),
                  AdminBottomNav(
                    current: _nav.current,
                    onChanged: _nav.go,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Stand-alone helper exported so other admin screens (and tests) can use
// the same sign-out confirmation flow without re-creating it.
// ===========================================================================

/// Convenience wrapper. Equivalent to `SignOutButton(outlined)` but
/// documents intent for admin-only contexts.
class AdminSignOutButton extends StatelessWidget {
  final AuthService authService;
  final Future<void> Function() onSignOut;

  const AdminSignOutButton({
    super.key,
    required this.authService,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return SignOutButton(
      authService: authService,
      onSignedOut: onSignOut,
    );
  }
}
