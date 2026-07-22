// lib/admin/user_detail_screen.dart
// ============================================================================
// User Management — detail screen.
//
// Layout:
//   ┌─────────────────────────────────────┐
//   │  ← User detail                      │  ← app bar
//   ├─────────────────────────────────────┤
//   │  [Avatar]  John Doe                 │
//   │            john@example.com         │
//   │            [Admin]  ● Active        │
//   ├─────────────────────────────────────┤
//   │  Account                            │
//   │  • Role: Admin                      │
//   │  • Status: Active                   │
//   │  • Created: …                       │
//   │  • Updated: …                       │
//   │  • Must change password: yes/no     │
//   ├─────────────────────────────────────┤
//   │  Actions                            │
//   │  [Activate/Deactivate]              │
//   │  [Reset password]                   │
//   └─────────────────────────────────────┘
//
// Mutations call the service and update local state on success. The
// parent screen is expected to re-fetch when this screen pops.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/api_exception.dart';
import '../theme/theme_builder.dart';
import 'user_models.dart';
import 'user_service.dart';

class UserDetailScreen extends StatefulWidget {
  final UserService service;
  final AdminUser user;
  final int? currentAdminId; // for self-protection guard

  const UserDetailScreen({
    super.key,
    required this.service,
    required this.user,
    this.currentAdminId,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late AdminUser _user;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------

  Future<void> _toggleStatus() async {
    final next = !_user.isActive;
    final action = next ? 'activate' : 'deactivate';
    final isSelf =
        widget.currentAdminId != null && widget.currentAdminId == _user.id;

    if (!next && isSelf) {
      _showSnack('You cannot deactivate your own account.');
      return;
    }

    final confirmed = await _confirm(
      title: next ? 'Activate user?' : 'Deactivate user?',
      body:
          'Are you sure you want to $action ${_user.fullName.isEmpty ? _user.email : _user.fullName}?',
      confirmLabel: next ? 'Activate' : 'Deactivate',
      destructive: !next,
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      final updated = await widget.service.setStatus(
        _user.id,
        isActive: next,
      );
      if (!mounted) return;
      setState(() => _user = updated);
      _showSnack(next ? 'User activated.' : 'User deactivated.');
    } on ApiException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Network error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    final confirmed = await _confirm(
      title: 'Reset password?',
      body:
          'A new temporary password will be generated for ${_user.fullName.isEmpty ? _user.email : _user.fullName}. '
          'They will be required to change it on next sign-in.',
      confirmLabel: 'Reset password',
      destructive: true,
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      final result = await widget.service.resetPassword(_user.id);
      if (!mounted) return;
      setState(() {
        _user = AdminUser(
          id: _user.id,
          fullName: _user.fullName,
          email: _user.email,
          role: _user.role,
          mustChangePassword: true,
          isActive: _user.isActive,
          createdAt: _user.createdAt,
          updatedAt: _user.updatedAt,
        );
      });
      await _showTempPasswordDialog(result.temporaryPassword);
    } on ApiException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Network error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------------------------------------------------------------------------
  // UI helpers
  // ---------------------------------------------------------------------------

  Future<bool?> _confirm({
    required String title,
    required String body,
    required String confirmLabel,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFef4444),
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showTempPasswordDialog(String tempPassword) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        final t = ctx.t;
        return AlertDialog(
          title: const Text('Password reset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Share this temporary password securely with the user. '
                'They will be required to change it on next sign-in.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: t.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: t.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        tempPassword,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                          color: t.text,
                        ),
                      ),
                    ),
                    IconButton(
                      splashRadius: 18,
                      tooltip: 'Copy',
                      icon: const Icon(Icons.copy, size: 16),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: tempPassword),
                        );
                        if (!ctx.mounted) return;
                        ScaffoldMessenger.maybeOf(ctx)?.showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isSelf = widget.currentAdminId == _user.id;

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.surface,
        foregroundColor: t.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'User detail',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _Header(user: _user),
                const SizedBox(height: 16),
                _AccountCard(user: _user),
                const SizedBox(height: 16),
                _ActionsCard(
                  user: _user,
                  isSelf: isSelf,
                  onToggleStatus: _toggleStatus,
                  onResetPassword: _resetPassword,
                ),
              ],
            ),
            if (_busy)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(t.text),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Header
// ===========================================================================

class _Header extends StatelessWidget {
  final AdminUser user;
  const _Header({required this.user});

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
            radius: 26,
            backgroundColor: t.surfaceAlt,
            child: Text(
              user.initial,
              style: TextStyle(
                fontSize: 22,
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
                  user.fullName.isEmpty ? user.email : user.fullName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (user.fullName.isNotEmpty)
                  Text(
                    user.email,
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
                    _StatusPill(active: user.isActive),
                    if (user.mustChangePassword)
                      const _MetaPill(
                        icon: Icons.lock_outline,
                        label: 'Must change password',
                      ),
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
  final UserRole role;
  const _RolePill({required this.role});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (role) {
      case UserRole.admin:
        bg = const Color(0xFFfef2f2);
        fg = const Color(0xFFb91c1c);
        break;
      case UserRole.editor:
        bg = const Color(0xFFeef2ff);
        fg = const Color(0xFF4338ca);
        break;
      case UserRole.learner:
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
        role.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool active;
  const _StatusPill({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active
        ? const Color(0xFFdcfce7)
        : const Color(0xFFfef3c7);
    final fg = active
        ? const Color(0xFF166534)
        : const Color(0xFF92400e);
    final dot = active
        ? const Color(0xFF10b981)
        : const Color(0xFFf59e0b);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            active ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: t.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: t.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: t.textMid),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: t.textMid,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Account card
// ===========================================================================

class _AccountCard extends StatelessWidget {
  final AdminUser user;
  const _AccountCard({required this.user});

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
                  'Account',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 14), color: t.border),
          _DetailRow(label: 'User ID', value: '#${user.id}'),
          _DetailRow(label: 'Email', value: user.email),
          _DetailRow(label: 'Role', value: user.role.label),
          _DetailRow(
            label: 'Status',
            value: user.isActive ? 'Active' : 'Inactive',
          ),
          _DetailRow(
            label: 'Must change password',
            value: user.mustChangePassword ? 'Yes' : 'No',
          ),
          if (user.createdAt != null)
            _DetailRow(label: 'Created', value: _formatDate(user.createdAt!)),
          if (user.updatedAt != null)
            _DetailRow(label: 'Updated', value: _formatDate(user.updatedAt!)),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final m = months[dt.month - 1];
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$m ${dt.day}, ${dt.year} • $hh:$mm';
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
  final AdminUser user;
  final bool isSelf;
  final VoidCallback onToggleStatus;
  final VoidCallback onResetPassword;

  const _ActionsCard({
    required this.user,
    required this.isSelf,
    required this.onToggleStatus,
    required this.onResetPassword,
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
          Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 14), color: t.border),

          // Activate / Deactivate
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.isActive ? 'Deactivate account' : 'Activate account',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.isActive
                      ? isSelf
                          ? 'You cannot deactivate your own account.'
                          : 'User will not be able to sign in until reactivated.'
                      : 'User will be able to sign in again.',
                  style: TextStyle(
                    fontSize: 12,
                    color: t.textDim,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: (user.isActive && isSelf) ? null : onToggleStatus,
                    icon: Icon(
                      user.isActive ? Icons.block : Icons.check_circle_outline,
                      size: 16,
                    ),
                    label: Text(user.isActive ? 'Deactivate' : 'Activate'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          user.isActive ? const Color(0xFFef4444) : t.text,
                      side: BorderSide(
                        color: user.isActive
                            ? const Color(0xFFef4444)
                            : t.borderStrong,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Reset password
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset password',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Generate a new temporary password. The user will be '
                  'required to change it on next sign-in.',
                  style: TextStyle(
                    fontSize: 12,
                    color: t.textDim,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onResetPassword,
                    icon: const Icon(Icons.lock_reset, size: 16),
                    label: const Text('Reset password'),
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
        ],
      ),
    );
  }
}
