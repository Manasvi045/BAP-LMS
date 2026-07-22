// lib/admin/user_list_screen.dart
// ============================================================================
// User Management — list screen.
//
// Layout:
//   ┌─────────────────────────────────────┐
//   │ Search field                        │
//   │ [All] [Admin] [Editor] [Learner]    │  ← role filter chips
//   │ [All] [Active] [Inactive]           │  ← status filter chips
//   ├─────────────────────────────────────┤
//   │ User row                            │
//   │ User row                            │
//   │ ...                                 │
//   ├─────────────────────────────────────┤
//   │ ◀ Page 1 of N ▶                     │  ← pagination footer
//   └─────────────────────────────────────┘
//
// Tapping a row pushes the detail screen. The list re-fetches on
// filter changes and supports pull-to-refresh.
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../theme/theme_builder.dart';
import 'user_detail_screen.dart';
import 'user_models.dart';
import 'user_service.dart';

class UserListScreen extends StatefulWidget {
  final UserService service;

  /// Called when a row is tapped. Useful for tests; in production the
  /// screen pushes [UserDetailScreen] itself.
  final void Function(AdminUser user)? onUserTap;

  const UserListScreen({super.key, required this.service, this.onUserTap});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchCtl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  UserFilter _filter = const UserFilter();
  UserPage? _page;
  Object? _error;
  bool _initialLoading = true;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _load(isInitial: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------

  Future<void> _load({bool isInitial = false, int? overridePage}) async {
    final effectiveFilter = overridePage == null
        ? _filter
        : _filter.copyWith(page: overridePage);

    if (mounted) {
      setState(() {
        _error = null;
        if (isInitial) _initialLoading = true;
      });
    }

    try {
      final page = await widget.service.listUsers(effectiveFilter);
      if (!mounted) return;
      setState(() {
        _page = page;
        _filter = effectiveFilter;
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

  Future<void> _onRefresh() => _load(isInitial: true);

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final next = _filter.copyWith(search: value).resetPage();
      if (next.search == _filter.search &&
          next.page == _filter.page) {
        return;
      }
      setState(() => _filter = next);
      _load();
    });
  }

  void _onRoleFilter(UserRole? role) {
    final next = _filter.copyWith(role: role).resetPage();
    setState(() => _filter = next);
    _load();
  }

  void _onStatusFilter(UserStatusFilter? status) {
    final next = _filter.copyWith(status: status).resetPage();
    setState(() => _filter = next);
    _load();
  }

  void _goToPage(int newPage) {
    if (_page == null) return;
    if (newPage < 1 || newPage > _page!.totalPages) return;
    if (newPage == _filter.page) return;
    _load(overridePage: newPage);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    if (_initialLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(t.textMid),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Loading users…',
              style: TextStyle(fontSize: 13, color: t.textMid),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _FiltersBar(
          searchCtl: _searchCtl,
          searchFocus: _searchFocus,
          currentFilter: _filter,
          onSearchChanged: _onSearchChanged,
          onRoleFilter: _onRoleFilter,
          onStatusFilter: _onStatusFilter,
        ),
        if (_error != null)
          _ErrorBanner(error: _error!, onRetry: _load)
        else
          Expanded(
            child: RefreshIndicator(
              color: t.text,
              backgroundColor: t.surface,
              onRefresh: _onRefresh,
              child: _UsersList(
                page: _page,
                onTap: _openDetail,
              ),
            ),
          ),
        if (_page != null && _error == null)
          _PaginationFooter(
            page: _page!,
            onPrev: () => _goToPage(_filter.page - 1),
            onNext: () => _goToPage(_filter.page + 1),
          ),
      ],
    );
  }

  Future<void> _openDetail(AdminUser user) async {
    if (widget.onUserTap != null) {
      widget.onUserTap!(user);
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserDetailScreen(
          service: widget.service,
          user: user,
        ),
      ),
    );
    // Re-fetch the list when we come back so status / role changes
    // are reflected.
    if (mounted) _load();
  }
}

// ===========================================================================
// Filters bar
// ===========================================================================

class _FiltersBar extends StatelessWidget {
  final TextEditingController searchCtl;
  final FocusNode searchFocus;
  final UserFilter currentFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<UserRole?> onRoleFilter;
  final ValueChanged<UserStatusFilter?> onStatusFilter;

  const _FiltersBar({
    required this.searchCtl,
    required this.searchFocus,
    required this.currentFilter,
    required this.onSearchChanged,
    required this.onRoleFilter,
    required this.onStatusFilter,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(bottom: BorderSide(color: t.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ----- Search -----
          Container(
            decoration: BoxDecoration(
              color: t.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: t.border),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.search, size: 18, color: t.textMid),
                ),
                Expanded(
                  child: TextField(
                    controller: searchCtl,
                    focusNode: searchFocus,
                    onChanged: onSearchChanged,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(fontSize: 14, color: t.text),
                    decoration: InputDecoration(
                      hintText: 'Search by name or email',
                      hintStyle: TextStyle(
                        fontSize: 13.5,
                        color: t.textDim,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (searchCtl.text.isNotEmpty)
                  IconButton(
                    splashRadius: 18,
                    icon: Icon(Icons.close, size: 16, color: t.textMid),
                    onPressed: () {
                      searchCtl.clear();
                      onSearchChanged('');
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ----- Role chips -----
          _ChipRow(
            label: 'Role',
            children: [
              _ChipBtn(
                label: 'All',
                active: currentFilter.role == null,
                onTap: () => onRoleFilter(null),
              ),
              _ChipBtn(
                label: 'Admin',
                active: currentFilter.role == UserRole.admin,
                onTap: () => onRoleFilter(UserRole.admin),
              ),
              _ChipBtn(
                label: 'Editor',
                active: currentFilter.role == UserRole.editor,
                onTap: () => onRoleFilter(UserRole.editor),
              ),
              _ChipBtn(
                label: 'Learner',
                active: currentFilter.role == UserRole.learner,
                onTap: () => onRoleFilter(UserRole.learner),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ----- Status chips -----
          _ChipRow(
            label: 'Status',
            children: [
              _ChipBtn(
                label: 'All',
                active: currentFilter.status == null,
                onTap: () => onStatusFilter(null),
              ),
              _ChipBtn(
                label: 'Active',
                active: currentFilter.status == UserStatusFilter.active,
                onTap: () => onStatusFilter(UserStatusFilter.active),
              ),
              _ChipBtn(
                label: 'Inactive',
                active: currentFilter.status == UserStatusFilter.inactive,
                onTap: () => onStatusFilter(UserStatusFilter.inactive),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const _ChipRow({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: t.textMid,
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ChipBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ChipBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Material(
      color: active ? t.text : t.surfaceAlt,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active ? t.text : t.border,
              width: active ? 1 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: active ? t.bg : t.textMid,
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Users list
// ===========================================================================

class _UsersList extends StatelessWidget {
  final UserPage? page;
  final void Function(AdminUser user) onTap;

  const _UsersList({required this.page, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final users = page?.users ?? const <AdminUser>[];
    if (users.isEmpty) {
      return _EmptyState(
        onClear: () {
          // Caller will clear via the chip taps; we just render the hint.
        },
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemBuilder: (ctx, i) => _UserRow(user: users[i], onTap: () => onTap(users[i])),
      separatorBuilder: (ctx, _) => Divider(
        height: 1,
        thickness: 1,
        color: ctx.t.border,
        indent: 60,
      ),
      itemCount: users.length,
    );
  }
}

class _UserRow extends StatelessWidget {
  final AdminUser user;
  final VoidCallback onTap;
  const _UserRow({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Material(
      color: t.bg,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Row(
            children: [
              _Avatar(user: user, active: user.isActive),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName.isEmpty ? user.email : user.fullName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: t.text,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12,
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
              _ActiveBadge(active: user.isActive),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18, color: t.textDim),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final AdminUser user;
  final bool active;
  const _Avatar({required this.user, required this.active});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Stack(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: t.surfaceAlt,
          child: Text(
            user.initial,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: t.text,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF10b981)
                  : const Color(0xFFaeb4c5),
              shape: BoxShape.circle,
              border: Border.all(color: t.bg, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  final UserRole role;
  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
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
        bg = t.surfaceAlt;
        fg = t.textMid;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        role.label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  final bool active;
  const _ActiveBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active
        ? const Color(0xFF10b981)
        : const Color(0xFFaeb4c5);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 60),
        Icon(Icons.people_outline, size: 40, color: t.textDim),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'No users match these filters.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: t.textMid,
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// Pagination footer
// ===========================================================================

class _PaginationFooter extends StatelessWidget {
  final UserPage page;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  const _PaginationFooter({
    required this.page,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final canPrev = page.hasPrevPage;
    final canNext = page.hasNextPage;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: canPrev ? onPrev : null,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous page',
            color: t.text,
            disabledColor: t.textFaint,
          ),
          Expanded(
            child: Text(
              'Page ${page.page} of ${page.totalPages} '
              '(${page.totalRecords} total)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: t.textMid,
              ),
            ),
          ),
          IconButton(
            onPressed: canNext ? onNext : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next page',
            color: t.text,
            disabledColor: t.textFaint,
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Error banner (inline, above the list)
// ===========================================================================

class _ErrorBanner extends StatelessWidget {
  final Object error;
  final Future<void> Function() onRetry;
  const _ErrorBanner({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isUnauth =
        error is ApiException && (error as ApiException).isUnauthorized;
    final message = isUnauth
        ? 'Your session has expired.'
        : error is ApiException
            ? (error as ApiException).message
            : 'Network error.';
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isUnauth ? Icons.lock_outline : Icons.error_outline,
                size: 32,
                color: const Color(0xFFef4444),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: t.textDim,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: isUnauth ? null : onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
