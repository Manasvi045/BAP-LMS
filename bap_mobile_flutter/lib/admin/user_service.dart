// lib/admin/user_service.dart
// ============================================================================
// User service. Wraps the /api/users endpoints so screens don't have to
// know about ApiClient, JSON unwrapping, or model parsing.
//
// Endpoints:
//   GET    /api/users                    → list with filters + pagination
//   GET    /api/users/:id                → one user
//   PUT    /api/users/:id                → update name / email / role
//   PATCH  /api/users/:id/status         → activate / deactivate
//   PATCH  /api/users/:id/password       → reset password (returns temp)
//
// 401 is already handled inside ApiClient (session wiped + broadcast).
// Other failures throw ApiException with the server's message.
// ============================================================================

import '../api/api_client.dart';
import '../api/api_exception.dart';
import 'user_models.dart';

class UserService {
  final ApiClient _api;
  UserService({required ApiClient apiClient}) : _api = apiClient;

  /// List users. Returns a [UserPage] even if the backend wraps the
  /// array inside an envelope — ApiClient unwraps the `data` key first.
  Future<UserPage> listUsers(UserFilter filter) async {
    final dynamic raw = await _api.getJson(
      '/api/users',
      query: filter.toQuery(),
    );
    if (raw is List) {
      return UserPage.fromList(raw, limit: filter.limit);
    }
    if (raw is Map<String, dynamic>) {
      return UserPage.fromJson(raw);
    }
    throw const ApiException('Unexpected response from /api/users.');
  }

  /// Fetch a single user by id. Returns the parsed [AdminUser].
  Future<AdminUser> getUser(int id) async {
    final dynamic raw = await _api.getJson('/api/users/$id');
    if (raw is Map<String, dynamic>) {
      return AdminUser.fromJson(raw);
    }
    throw ApiException('Unexpected response from /api/users/$id.');
  }

  /// Update a user's name / email / optional role. Returns the
  /// refreshed [AdminUser] from the server.
  Future<AdminUser> updateUser(
    int id, {
    required String fullName,
    required String email,
    UserRole? role,
  }) async {
    final body = <String, Object>{
      'fullName': fullName,
      'email': email,
    };
    if (role != null) body['role'] = role.wire;
    final dynamic raw = await _api.putJson('/api/users/$id', body: body);
    if (raw is Map<String, dynamic>) {
      return AdminUser.fromJson(raw);
    }
    throw ApiException('Unexpected response from PUT /api/users/$id.');
  }

  /// Toggle activation. Returns the refreshed user.
  Future<AdminUser> setStatus(int id, {required bool isActive}) async {
    final dynamic raw = await _api.patchJson(
      '/api/users/$id/status',
      body: {'isActive': isActive},
    );
    if (raw is Map<String, dynamic>) {
      return AdminUser.fromJson(raw);
    }
    throw ApiException(
      'Unexpected response from PATCH /api/users/$id/status.',
    );
  }

  /// Reset a user's password. If [newPassword] is null the backend
  /// generates one and returns it in the response. The reset always
  /// forces `must_change_password = true` server-side.
  Future<ResetPasswordResult> resetPassword(int id, {String? newPassword}) async {
    final body = newPassword == null || newPassword.isEmpty
        ? <String, Object>{}
        : <String, Object>{'newPassword': newPassword};
    final dynamic raw = await _api.patchJson(
      '/api/users/$id/password',
      body: body,
    );
    if (raw is Map<String, dynamic>) {
      return ResetPasswordResult.fromJson(raw);
    }
    throw ApiException(
      'Unexpected response from PATCH /api/users/$id/password.',
    );
  }
}
