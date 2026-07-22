// lib/admin/content_service.dart
// ============================================================================
// Read-only content service. Wraps /api/verticals, /api/modules, and
// /api/sections. The mobile admin app intentionally does NOT support
// content editing — that lives in the React web admin panel.
// ============================================================================

import '../api/api_client.dart';
import '../api/api_exception.dart';
import 'content_models.dart';

class ContentService {
  final ApiClient _api;
  ContentService({required ApiClient apiClient}) : _api = apiClient;

  Future<ContentPage<Vertical>> listVerticals({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
  }) =>
      _list<Vertical>(
        '/api/verticals',
        query: _buildQuery(page: page, limit: limit, search: search, status: status),
        build: Vertical.fromJson,
      );

  Future<ContentPage<ContentModule>> listModules({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
  }) =>
      _list<ContentModule>(
        '/api/modules',
        query: _buildQuery(page: page, limit: limit, search: search, status: status),
        build: ContentModule.fromJson,
      );

  Future<ContentPage<ContentSection>> listSections({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
  }) =>
      _list<ContentSection>(
        '/api/sections',
        query: _buildQuery(page: page, limit: limit, search: search, status: status),
        build: ContentSection.fromJson,
      );

  Future<ContentPage<T>> _list<T>(
    String path, {
    required Map<String, String> query,
    required T Function(Map<String, dynamic>) build,
  }) async {
    final dynamic raw = await _api.getJson(path, query: query);
    if (raw is Map<String, dynamic>) {
      return ContentPage.fromJson(raw, build);
    }
    throw ApiException('Unexpected response from GET $path.');
  }

  Map<String, String> _buildQuery({
    required int page,
    required int limit,
    String? search,
    String? status,
  }) {
    final out = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) out['search'] = search;
    if (status != null && status.isNotEmpty) out['status'] = status;
    return out;
  }
}
