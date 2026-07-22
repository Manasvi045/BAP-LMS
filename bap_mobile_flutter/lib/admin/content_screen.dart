// lib/admin/content_screen.dart
// ============================================================================
// Content overview — read-only. Mirrors the React ContentPage (which
// hosts the full editor) but on mobile we only show what's been
// authored and provide a deep-link to the web panel for editing.
//
// Layout:
//   ┌─────────────────────────────────────┐
//   │  [Verticals] [Modules] [Sections]  │  ← sub-tabs (segmented)
//   ├─────────────────────────────────────┤
//   │  Open the Web Admin Panel for full  │  ← banner
//   │  content management.   [Copy URL]   │
//   ├─────────────────────────────────────┤
//   │  Vertical card                      │
//   │  Vertical card                      │
//   │  ...                                │
//   └─────────────────────────────────────┘
//
// Each row is read-only — name + description + status badge +
// updated-at. No edit / create / delete actions live here.
//
// Why "Copy URL" instead of "Open in browser"? — the mobile shell does
// not pull in url_launcher to avoid an extra dependency for a single
// use. The URL is configured via AuthConfig.adminWebUrl and is
// overridable at build time with `--dart-define=ADMIN_WEB_URL=…`.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/api_exception.dart';
import '../auth/auth_config.dart';
import '../theme/theme_builder.dart';
import 'content_models.dart';
import 'content_service.dart';

enum _ContentSubTab { verticals, modules, sections }

class ContentScreen extends StatefulWidget {
  final ContentService service;

  const ContentScreen({super.key, required this.service});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _ContentSubTab.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      children: [
        // ----- Banner pointing to the web panel -----
        _WebPanelBanner(),
        // ----- Sub-tabs -----
        Container(
          decoration: BoxDecoration(
            color: t.surface,
            border: Border(bottom: BorderSide(color: t.border)),
          ),
          child: TabBar(
            controller: _tabs,
            labelColor: t.text,
            unselectedLabelColor: t.textMid,
            indicatorColor: t.text,
            labelStyle: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Verticals'),
              Tab(text: 'Modules'),
              Tab(text: 'Sections'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              _ContentList<Vertical>(
                service: widget.service,
                fetch: widget.service.listVerticals,
                titleOf: (v) => v.name,
                subtitleOf: (v) => v.slug,
                descriptionOf: (v) => v.description,
                statusOf: (v) => v.status,
                updatedAtOf: (v) => v.updatedAt,
                parentLabelOf: (v) => 'Vertical #${v.id}',
                parentIcon: Icons.account_tree_outlined,
              ),
              _ContentList<ContentModule>(
                service: widget.service,
                fetch: widget.service.listModules,
                titleOf: (m) => m.name,
                subtitleOf: (m) => m.slug,
                descriptionOf: (m) => m.description,
                statusOf: (m) => m.status,
                updatedAtOf: (m) => m.updatedAt,
                parentLabelOf: (m) => 'Vertical #${m.verticalId}',
                parentIcon: Icons.view_module_outlined,
              ),
              _ContentList<ContentSection>(
                service: widget.service,
                fetch: widget.service.listSections,
                titleOf: (s) => s.name,
                subtitleOf: (s) => s.slug,
                descriptionOf: (s) => s.description,
                statusOf: (s) => s.status,
                updatedAtOf: (s) => s.updatedAt,
                parentLabelOf: (s) => 'Module #${s.moduleId}',
                parentIcon: Icons.layers_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// Banner: "Open Web Admin Panel for full content management"
// ===========================================================================

class _WebPanelBanner extends StatelessWidget {
  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: AuthConfig.adminWebUrl));
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Web panel URL copied'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: t.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: t.border),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.open_in_new, size: 16, color: t.textMid),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Open the Web Admin Panel',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'For full content management — create, edit, publish.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: t.textDim,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        AuthConfig.adminWebUrl,
                        style: TextStyle(
                          fontSize: 11,
                          color: t.textMid,
                          fontFamily: 'monospace',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => _copy(context),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.copy,
                          size: 12,
                          color: t.textDim,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 34,
            child: FilledButton(
              onPressed: () => _copy(context),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, size: 13),
                  SizedBox(width: 4),
                  Text('Copy URL', style: TextStyle(fontSize: 12.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Generic content list (used for Verticals / Modules / Sections)
// ===========================================================================

class _ContentList<T> extends StatefulWidget {
  final ContentService service;
  final Future<ContentPage<T>> Function({
    int page,
    int limit,
    String? search,
    String? status,
  }) fetch;
  final String Function(T) titleOf;
  final String Function(T) subtitleOf;
  final String Function(T) descriptionOf;
  final ContentStatus Function(T) statusOf;
  final DateTime? Function(T) updatedAtOf;
  final String Function(T) parentLabelOf;
  final IconData parentIcon;

  const _ContentList({
    required this.service,
    required this.fetch,
    required this.titleOf,
    required this.subtitleOf,
    required this.descriptionOf,
    required this.statusOf,
    required this.updatedAtOf,
    required this.parentLabelOf,
    required this.parentIcon,
  });

  @override
  State<_ContentList<T>> createState() => _ContentListState<T>();
}

class _ContentListState<T> extends State<_ContentList<T>> {
  ContentPage<T>? _page;
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
      final page = await widget.fetch(page: 1, limit: 50);
      if (!mounted) return;
      setState(() {
        _page = page;
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

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    if (_initialLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(t.textMid),
              ),
            ),
            const SizedBox(height: 10),
            Text('Loading…',
                style: TextStyle(fontSize: 12, color: t.textMid)),
          ],
        ),
      );
    }

    if (_error != null) {
      final isUnauth =
          _error is ApiException && (_error as ApiException).isUnauthorized;
      final msg = isUnauth
          ? 'Your session has expired.'
          : _error is ApiException
              ? (_error as ApiException).message
              : 'Network error.';
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isUnauth ? Icons.lock_outline : Icons.error_outline,
                size: 28,
                color: const Color(0xFFef4444),
              ),
              const SizedBox(height: 8),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: t.textDim, height: 1.4),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: isUnauth ? null : _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final items = _page?.items ?? const [];
    return RefreshIndicator(
      color: t.text,
      backgroundColor: t.surface,
      onRefresh: _load,
      child: items.isEmpty
          ? _EmptyState(parentIcon: widget.parentIcon)
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemBuilder: (ctx, i) => _ContentCard<T>(
                item: items[i],
                titleOf: widget.titleOf,
                subtitleOf: widget.subtitleOf,
                descriptionOf: widget.descriptionOf,
                statusOf: widget.statusOf,
                updatedAtOf: widget.updatedAtOf,
                parentLabelOf: widget.parentLabelOf,
                parentIcon: widget.parentIcon,
              ),
              separatorBuilder: (ctx, _) => const SizedBox(height: 10),
              itemCount: items.length,
            ),
    );
  }
}

class _ContentCard<T> extends StatelessWidget {
  final T item;
  final String Function(T) titleOf;
  final String Function(T) subtitleOf;
  final String Function(T) descriptionOf;
  final ContentStatus Function(T) statusOf;
  final DateTime? Function(T) updatedAtOf;
  final String Function(T) parentLabelOf;
  final IconData parentIcon;

  const _ContentCard({
    required this.item,
    required this.titleOf,
    required this.subtitleOf,
    required this.descriptionOf,
    required this.statusOf,
    required this.updatedAtOf,
    required this.parentLabelOf,
    required this.parentIcon,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final name = titleOf(item);
    final slug = subtitleOf(item);
    final desc = descriptionOf(item);
    final status = statusOf(item);
    final updated = updatedAtOf(item);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name.isEmpty ? '(untitled)' : name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: status),
            ],
          ),
          if (slug.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              '/$slug',
              style: TextStyle(
                fontSize: 11.5,
                color: t.textMid,
                fontFamily: 'monospace',
              ),
            ),
          ],
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              desc,
              style: TextStyle(
                fontSize: 12.5,
                color: t.textDim,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(parentIcon, size: 12, color: t.textDim),
              const SizedBox(width: 4),
              Text(
                parentLabelOf(item),
                style: TextStyle(fontSize: 11.5, color: t.textMid),
              ),
              const Spacer(),
              if (updated != null)
                Text(
                  'Updated ${_shortDate(updated)}',
                  style: TextStyle(fontSize: 11, color: t.textDim),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _shortDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final ContentStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case ContentStatus.published:
        bg = const Color(0xFFdcfce7);
        fg = const Color(0xFF166534);
        break;
      case ContentStatus.draft:
        bg = const Color(0xFFfef3c7);
        fg = const Color(0xFF92400e);
        break;
      case ContentStatus.archived:
        bg = const Color(0xFFf3f4f6);
        fg = const Color(0xFF4b5563);
        break;
      case ContentStatus.unknown:
        bg = const Color(0xFFf3f4f6);
        fg = const Color(0xFF6b7280);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData parentIcon;
  const _EmptyState({required this.parentIcon});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 60),
        Icon(parentIcon, size: 36, color: t.textDim),
        const SizedBox(height: 10),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Nothing here yet. Use the Web Admin Panel to create the '
              'first entry — it will appear here once published.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: t.textMid,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
