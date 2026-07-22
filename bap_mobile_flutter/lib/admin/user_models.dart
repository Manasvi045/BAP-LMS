// lib/admin/user_models.dart
// ============================================================================
// Typed view of the /api/users endpoints. Mirrors the backend contract
// from lms_backend/controllers/userController.js — when the backend
// shape changes, this file is the only one that has to move.
// ============================================================================

import 'package:flutter/foundation.dart';

/// The three roles the backend understands.
enum UserRole { admin, editor, learner }

extension UserRoleLabel on UserRole {
  String get wire => switch (this) {
        UserRole.admin => 'admin',
        UserRole.editor => 'editor',
        UserRole.learner => 'user',
      };
  String get label => switch (this) {
        UserRole.admin => 'Admin',
        UserRole.editor => 'Editor',
        UserRole.learner => 'Learner',
      };
  static UserRole fromWire(String? raw) {
    switch (raw) {
      case 'admin':
        return UserRole.admin;
      case 'editor':
        return UserRole.editor;
      default:
        return UserRole.learner;
    }
  }
}

/// Status filter for list queries. `null` = no filter.
enum UserStatusFilter { active, inactive }

extension UserStatusFilterWire on UserStatusFilter {
  String get wire => switch (this) {
        UserStatusFilter.active => 'active',
        UserStatusFilter.inactive => 'inactive',
      };
  String get label => switch (this) {
        UserStatusFilter.active => 'Active',
        UserStatusFilter.inactive => 'Inactive',
      };
}

/// One row in the users list. Backend columns:
///   id, full_name, email, role, must_change_password, is_active,
///   created_at, updated_at
@immutable
class AdminUser {
  final int id;
  final String fullName;
  final String email;
  final UserRole role;
  final bool mustChangePassword;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.mustChangePassword,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Letter shown in the avatar tile.
  String get initial =>
      fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    final active = json['is_active'];
    final mcp = json['must_change_password'];
    return AdminUser(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id'] ?? ''}') ?? 0,
      fullName: (json['full_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: UserRoleLabel.fromWire((json['role'] ?? '').toString()),
      mustChangePassword: mcp == true || mcp == 't' || mcp == 'true',
      isActive: active == true || active == 't' || active == 'true',
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

/// Paginated list response.
@immutable
class UserPage {
  final List<AdminUser> users;
  final int page;
  final int limit;
  final int totalRecords;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const UserPage({
    required this.users,
    required this.page,
    required this.limit,
    required this.totalRecords,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  /// When the backend returns the unwrapped `data` array (ApiClient
  /// strips `{ success, data, pagination }`), we lose the pagination
  /// metadata on the wire. We rebuild a sensible default so the UI
  /// still works.
  factory UserPage.fromList(List<dynamic> raw, {int limit = 10}) {
    final list = raw.whereType<Map<String, dynamic>>().map(AdminUser.fromJson).toList(growable: false);
    return UserPage(
      users: list,
      page: 1,
      limit: limit,
      totalRecords: list.length,
      totalPages: 1,
      hasNextPage: false,
      hasPrevPage: false,
    );
  }

  /// Direct map (ApiClient may pass the full object through if the
  /// shape changes).
  factory UserPage.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}') ?? 0;
    bool asBool(dynamic v) => v == true || v == 't' || v == 'true';
    final pagination = json['pagination'];
    final data = json['data'];
    final users = data is List
        ? data
            .whereType<Map<String, dynamic>>()
            .map(AdminUser.fromJson)
            .toList(growable: false)
        : const <AdminUser>[];
    if (pagination is Map<String, dynamic>) {
      return UserPage(
        users: users,
        page: asInt(pagination['page']),
        limit: asInt(pagination['limit']),
        totalRecords: asInt(pagination['totalRecords']),
        totalPages: asInt(pagination['totalPages']),
        hasNextPage: asBool(pagination['hasNextPage']),
        hasPrevPage: asBool(pagination['hasPrevPage']),
      );
    }
    return UserPage(
      users: users,
      page: 1,
      limit: users.length,
      totalRecords: users.length,
      totalPages: 1,
      hasNextPage: false,
      hasPrevPage: false,
    );
  }
}

/// Filter set applied to /api/users. Empty fields mean "no filter".
@immutable
class UserFilter {
  final String search;
  final UserRole? role;
  final UserStatusFilter? status;
  final int page;
  final int limit;

  const UserFilter({
    this.search = '',
    this.role,
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  UserFilter copyWith({
    Object? search = const _Sentinel(),
    Object? role = const _Sentinel(),
    Object? status = const _Sentinel(),
    int? page,
    int? limit,
  }) {
    // For search: pass-through uses the sentinel — if a caller wants
    // to clear it they pass ''. For role/status we keep the nullable
    // convention so `null` means "clear this filter".
    final nextSearch =
        identical(search, const _Sentinel()) ? this.search : search as String;
    return UserFilter(
      search: nextSearch,
      role: identical(role, const _Sentinel())
          ? this.role
          : role as UserRole?,
      status: identical(status, const _Sentinel())
          ? this.status
          : status as UserStatusFilter?,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  /// Update the page only (helper for pagination).
  UserFilter withPage(int newPage) => copyWith(page: newPage);

  /// Reset to page 1 with the same filters (helper for filter changes).
  UserFilter resetPage() => copyWith(page: 1);

  Map<String, String> toQuery() {
    final out = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search.isNotEmpty) out['search'] = search;
    if (role != null) out['role'] = role!.wire;
    if (status != null) out['status'] = status!.wire;
    return out;
  }
}

/// Sentinel marker so `copyWith` can tell "argument omitted" from
/// "argument passed as null / empty string".
class _Sentinel {
  const _Sentinel();
}

/// Result of PATCH /api/users/:id/password.
@immutable
class ResetPasswordResult {
  final String temporaryPassword;
  final String message;
  const ResetPasswordResult({required this.temporaryPassword, required this.message});

  factory ResetPasswordResult.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResult(
      temporaryPassword: (json['temporaryPassword'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
    );
  }
}
