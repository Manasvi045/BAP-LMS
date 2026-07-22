// lib/admin/dashboard_screen.dart
// ============================================================================
// Admin dashboard. Hits GET /api/dashboard/stats via DashboardService and
// renders:
//   - Welcome header (admin's name + role)
//   - 6-tile overview grid (Total / Active / Inactive / Admins /
//     Editors / Learners) — same shape as the web panel's
//     OverviewGrid, narrowed to a 2-col layout for the phone form
//     factor.
//   - Recent Users list (latest 5 from the backend)
//
// Loading, error, and pull-to-refresh are first-class.
// ============================================================================

import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../theme/theme_builder.dart';
import 'dashboard_models.dart';
import 'dashboard_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  final DashboardService service;
  final String adminName;

  const AdminDashboardScreen({
    super.key,
    required this.service,
    required this.adminName,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  DashboardStats? _stats;
  Object? _error;
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _initialLoading = true;
        _error = null;
      });
    }
    try {
      final s = await widget.service.fetchStats();
      if (!mounted) return;
      setState(() {
        _stats = s;
        _initialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _initialLoading = false;
      });
    }
  }

  Future<void> _onRefresh() => _load();

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    if (_initialLoading) {
      return _LoadingState(textColor: t.textMid, spinnerColor: t.textMid);
    }

    if (_error != null) {
      return _ErrorState(
        error: _error!,
        onRetry: () => _load(),
      );
    }

    final stats = _stats!;
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: t.text,
      backgroundColor: t.surface,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _WelcomeHeader(
            adminName: widget.adminName,
            snapshotTime: stats.snapshotTime,
          ),
          const SizedBox(height: 16),
          _OverviewGrid(overview: stats.overview),
          const SizedBox(height: 16),
          _RecentUsersCard(users: stats.recentUsers),
        ],
      ),
    );
  }
}

// ===========================================================================
// Welcome header — admin's name + a friendly "Snapshot from …" footer.
// ===========================================================================

class _WelcomeHeader extends StatelessWidget {
  final String adminName;
  final DateTime? snapshotTime;

  const _WelcomeHeader({
    required this.adminName,
    required this.snapshotTime,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, ${adminName.isEmpty ? 'admin' : adminName}',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: t.text,
          ),
        ),
        if (snapshotTime != null) ...[
          const SizedBox(height: 4),
          Text(
            'Snapshot from ${_formatSnapshot(snapshotTime!)}',
            style: TextStyle(
              fontSize: 12,
              color: t.textMid,
            ),
          ),
        ],
      ],
    );
  }

  String _formatSnapshot(DateTime dt) {
    // Match the web panel's "medium date / short time" feel without
    // pulling in intl just for this one formatter.
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

// ===========================================================================
// 2-column overview grid. Six tiles, each rendered as a small card.
// ===========================================================================

class _OverviewGrid extends StatelessWidget {
  final DashboardOverview overview;
  const _OverviewGrid({required this.overview});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _StatTile(
        icon: Icons.people_outline,
        label: 'Total users',
        value: overview.totalUsers,
        hint: 'All accounts',
        tone: _StatTone.primary,
      ),
      _StatTile(
        icon: Icons.check_circle_outline,
        label: 'Active',
        value: overview.activeUsers,
        hint: 'Can sign in',
        tone: _StatTone.success,
      ),
      _StatTile(
        icon: Icons.block_outlined,
        label: 'Inactive',
        value: overview.inactiveUsers,
        hint: 'Deactivated',
        tone: _StatTone.warning,
      ),
      _StatTile(
        icon: Icons.shield_outlined,
        label: 'Administrators',
        value: overview.admins,
        hint: 'Full access',
        tone: _StatTone.danger,
      ),
      _StatTile(
        icon: Icons.edit_outlined,
        label: 'Editors',
        value: overview.editors,
        hint: 'Content mgmt',
        tone: _StatTone.info,
      ),
      _StatTile(
        icon: Icons.school_outlined,
        label: 'Learners',
        value: overview.learners,
        hint: 'Use the app',
        tone: _StatTone.primary,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.65,
      children: tiles,
    );
  }
}

enum _StatTone { primary, success, warning, danger, info }

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final String hint;
  final _StatTone tone;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.tone,
  });

  Color _accentColor() {
    switch (tone) {
      case _StatTone.primary:
        return const Color(0xFF3b82f6);
      case _StatTone.success:
        return const Color(0xFF10b981);
      case _StatTone.warning:
        return const Color(0xFFf59e0b);
      case _StatTone.danger:
        return const Color(0xFFef4444);
      case _StatTone.info:
        return const Color(0xFF6366f1);
    }
  }

  Color _tint(Color c) => Color.alphaBlend(c.withValues(alpha: 0.10), Colors.transparent);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accent = _accentColor();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _tint(accent),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 16, color: accent),
              ),
              Icon(Icons.trending_up, size: 14, color: t.textFaint),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: t.text,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: t.text,
            ),
          ),
          Text(
            hint,
            style: TextStyle(
              fontSize: 10.5,
              color: t.textMid,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Recent Users card — up to 5 of the most-recent sign-ups.
// ===========================================================================

class _RecentUsersCard extends StatelessWidget {
  final List<RecentUser> users;
  const _RecentUsersCard({required this.users});

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
                Icon(Icons.history, size: 16, color: t.textMid),
                const SizedBox(width: 8),
                Text(
                  'Recent users',
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
          if (users.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
              child: Text(
                'No users yet.',
                style: TextStyle(
                  fontSize: 13,
                  color: t.textMid,
                ),
              ),
            )
          else
            ...users.map((u) => _RecentUserRow(user: u)),
        ],
      ),
    );
  }
}

class _RecentUserRow extends StatelessWidget {
  final RecentUser user;
  const _RecentUserRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: t.surfaceAlt,
            child: Text(
              user.initial,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: t.text,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName.isEmpty ? user.email : user.fullName,
                  style: TextStyle(
                    fontSize: 13.5,
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
                      fontSize: 11.5,
                      color: t.textMid,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _RoleChip(role: user.role),
          const SizedBox(width: 8),
          _StatusDot(active: user.isActive),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    Color bg;
    Color fg;
    String label;
    switch (role) {
      case 'admin':
        bg = const Color(0xFFfef2f2);
        fg = const Color(0xFFb91c1c);
        label = 'Admin';
        break;
      case 'editor':
        bg = const Color(0xFFeef2ff);
        fg = const Color(0xFF4338ca);
        label = 'Editor';
        break;
      default:
        bg = t.surfaceAlt;
        fg = t.textMid;
        label = 'Learner';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool active;
  const _StatusDot({required this.active});

  @override
  Widget build(BuildContext context) {
    final color =
        active ? const Color(0xFF10b981) : const Color(0xFFf59e0b);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ===========================================================================
// Loading + Error states
// ===========================================================================

class _LoadingState extends StatelessWidget {
  final Color textColor;
  final Color spinnerColor;
  const _LoadingState({required this.textColor, required this.spinnerColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(spinnerColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Loading dashboard…',
            style: TextStyle(fontSize: 13, color: textColor),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isUnauth = error is ApiException && (error as ApiException).isUnauthorized;
    // 401 is handled by ApiClient + AuthGate — show a softer message.
    final title = isUnauth
        ? 'Session ended'
        : "Couldn't load dashboard";
    final message = isUnauth
        ? 'Your session has expired. Please sign in again.'
        : (error is ApiException
            ? (error as ApiException).message
            : 'Network error. Try again.');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUnauth ? Icons.lock_outline : Icons.error_outline,
              size: 36,
              color: const Color(0xFFef4444),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: t.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: t.textDim,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: isUnauth ? null : onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
