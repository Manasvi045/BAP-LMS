// lib/admin/admin_profile_screen.dart
// ============================================================================
// Admin Profile. Self-service surface for the signed-in admin.
//
// Layout:
//   ┌─────────────────────────────────────┐
//   │  ← Profile                          │  ← app bar (back to AdminHome)
//   ├─────────────────────────────────────┤
//   │  [Avatar]  John Doe                 │
//   │            john@example.com         │
//   │            [Admin]  ● Active        │
//   ├─────────────────────────────────────┤
//   │  Account details                    │
//   │  • User ID: #5                      │
//   │  • Email:   john@example.com        │
//   │  • Role:    Admin                   │
//   │  • Status:  Active                  │
//   ├─────────────────────────────────────┤
//   │  Actions                            │
//   │  [Change password]                  │
//   │  [Sign out]                         │
//   └─────────────────────────────────────┘
//
// The screen reads the current session from AuthService (so it stays
// fresh after a self-service password change). Change-password pushes
// the standalone ChangePasswordScreen; Sign Out goes through the
// shared confirmation dialog.
// ============================================================================

import 'package:flutter/material.dart';

import '../auth/auth_models.dart';
import '../auth/auth_service.dart';
import '../auth/change_password_screen.dart';
import '../auth/widgets/sign_out_button.dart';
import '../theme/theme_builder.dart';

class AdminProfileScreen extends StatefulWidget {
  final AuthService authService;
  final AuthUser initialUser;
  final Future<void> Function() onSignOut;

  const AdminProfileScreen({
    super.key,
    required this.authService,
    required this.initialUser,
    required this.onSignOut,
  });

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late AuthUser _user;

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
  }

  Future<void> _refresh() async {
    final reloaded = await widget.authService.loadSession();
    if (!mounted || reloaded == null) return;
    setState(() => _user = reloaded.user);
  }

  Future<void> _openChangePassword() async {
    // No-op `onChanged` because we don't want the auth gate to
    // re-resolve on a self-service change.
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangePasswordScreen(
          authService: widget.authService,
          onChanged: () {},
          standalone: true,
        ),
      ),
    );
    if (changed == true) {
      await _refresh();
    }
  }

  String get _initial =>
      _user.name.isNotEmpty ? _user.name[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.surface,
        foregroundColor: t.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _Header(user: _user, initial: _initial),
          const SizedBox(height: 16),
          _AccountDetailsCard(user: _user),
          const SizedBox(height: 16),
          _ActionsCard(
            onChangePassword: _openChangePassword,
            onSignOut: () => _confirmAndSignOut(context),
            authService: widget.authService,
            onSignOutCallback: widget.onSignOut,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
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
    await widget.authService.logout();
    await widget.onSignOut();
  }
}

// ===========================================================================
// Header
// ===========================================================================

class _Header extends StatelessWidget {
  final AuthUser user;
  final String initial;
  const _Header({required this.user, required this.initial});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: t.surfaceAlt,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: t.text,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isEmpty ? '(admin)' : user.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  user.email.isEmpty ? '—' : user.email,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: t.textMid,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _RolePill(role: user.role),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  final String role;
  const _RolePill({required this.role});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (role) {
      case 'admin':
        bg = const Color(0xFFfef2f2);
        fg = const Color(0xFFb91c1c);
        break;
      case 'editor':
        bg = const Color(0xFFeef2ff);
        fg = const Color(0xFF4338ca);
        break;
      default:
        bg = const Color(0xFFf3f4f6);
        fg = const Color(0xFF4b5563);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _roleLabel(role),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  String _roleLabel(String r) {
    switch (r) {
      case 'admin':
        return 'Admin';
      case 'editor':
        return 'Editor';
      default:
        return 'Learner';
    }
  }
}

// ===========================================================================
// Account details card
// ===========================================================================

class _AccountDetailsCard extends StatelessWidget {
  final AuthUser user;
  const _AccountDetailsCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: t.textMid),
                const SizedBox(width: 8),
                Text(
                  'Account details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: t.border,
          ),
          _DetailRow(label: 'User ID', value: '#${user.id}'),
          _DetailRow(label: 'Email', value: user.email.isEmpty ? '—' : user.email),
          _DetailRow(label: 'Role', value: _roleLabelFull(user.role)),
        ],
      ),
    );
  }

  String _roleLabelFull(String r) {
    switch (r) {
      case 'admin':
        return 'Administrator';
      case 'editor':
        return 'Editor';
      default:
        return 'Learner';
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                color: t.textMid,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: t.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Actions card
// ===========================================================================

class _ActionsCard extends StatelessWidget {
  final VoidCallback onChangePassword;
  final Future<void> Function() onSignOut;
  final AuthService authService;
  final Future<void> Function() onSignOutCallback;

  const _ActionsCard({
    required this.onChangePassword,
    required this.onSignOut,
    required this.authService,
    required this.onSignOutCallback,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                Icon(Icons.bolt_outlined, size: 16, color: t.textMid),
                const SizedBox(width: 8),
                Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: t.border,
          ),

          // Change password
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change password',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update the password you use to sign in.',
                  style: TextStyle(
                    fontSize: 12,
                    color: t.textDim,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onChangePassword,
                    icon: const Icon(Icons.lock_reset, size: 16),
                    label: const Text('Change password'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sign out (uses the shared SignOutButton for visual + flow parity)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'End this session. You will need to sign in again.',
                  style: TextStyle(
                    fontSize: 12,
                    color: t.textDim,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: SignOutButton(
                    authService: authService,
                    onSignedOut: onSignOutCallback,
                    variant: SignOutButtonVariant.outlined,
                    label: 'Sign out',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
