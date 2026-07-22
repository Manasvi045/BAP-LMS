// lib/admin/dashboard_service.dart
// ============================================================================
// Dashboard service. Wraps the /api/dashboard/stats call so screens don't
// have to know about ApiClient, JSON unwrapping, or the typed model.
// ============================================================================

import '../api/api_client.dart';
import '../api/api_exception.dart';
import 'dashboard_models.dart';

class DashboardService {
  final ApiClient _api;
  DashboardService({required ApiClient apiClient}) : _api = apiClient;

  /// Fetches the latest snapshot from the backend.
  ///
  /// Throws [ApiException] on transport / server errors. The 401 path is
  /// already handled inside ApiClient (session wiped, broadcast).
  Future<DashboardStats> fetchStats() async {
    final dynamic raw = await _api.getJson('/api/dashboard/stats');
    if (raw is Map<String, dynamic>) {
      return DashboardStats.fromJson(raw);
    }
    // Backend returned something unexpected — surface as a parse error.
    throw const ApiException(
      'Unexpected response from /api/dashboard/stats.',
    );
  }
}
