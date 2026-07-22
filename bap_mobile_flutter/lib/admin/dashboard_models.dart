// lib/admin/dashboard_models.dart
// ============================================================================
// Strongly-typed view of the /api/dashboard/stats payload. Mirrors the
// backend contract from lms_backend/controllers/dashboardController.js —
// if the backend shape changes, this is the only file that has to move.
// ============================================================================

import 'package:flutter/foundation.dart';

/// Counts for the six top-line tiles. Backend shape:
///
/// ```json
/// {
///   "totalUsers":     int,
///   "activeUsers":    int,
///   "inactiveUsers":  int,
///   "admins":         int,
///   "editors":        int,
///   "learners":       int
/// }
/// ```
@immutable
class DashboardOverview {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final int admins;
  final int editors;
  final int learners;

  const DashboardOverview({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.admins,
    required this.editors,
    required this.learners,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}') ?? 0;
    return DashboardOverview(
      totalUsers: asInt(json['totalUsers']),
      activeUsers: asInt(json['activeUsers']),
      inactiveUsers: asInt(json['inactiveUsers']),
      admins: asInt(json['admins']),
      editors: asInt(json['editors']),
      learners: asInt(json['learners']),
    );
  }

  static const empty = DashboardOverview(
    totalUsers: 0,
    activeUsers: 0,
    inactiveUsers: 0,
    admins: 0,
    editors: 0,
    learners: 0,
  );
}

/// One row in the "Recent users" list. Backend columns:
/// `id, full_name, email, role, is_active, created_at`.
@immutable
class RecentUser {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final bool isActive;
  final DateTime? createdAt;

  const RecentUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory RecentUser.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    final active = json['is_active'];
    return RecentUser(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id'] ?? ''}') ?? 0,
      fullName: (json['full_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      isActive: active == true || active == 't' || active == 'true',
      createdAt: parseDate(json['created_at']),
    );
  }

  /// First letter for an avatar fallback when the name is empty.
  String get initial =>
      fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
}

/// Top-level stats payload. Mirrors the backend response.
@immutable
class DashboardStats {
  final DateTime? snapshotTime;
  final DashboardOverview overview;
  final List<RecentUser> recentUsers;

  // The backend returns 0-placeholder sections for content/media/
  // learning today. We don't render them yet — but we keep them in the
  // model so Phase 7 can light them up without a re-fetch.
  final Map<String, dynamic> content;
  final Map<String, dynamic> media;
  final Map<String, dynamic> learning;

  const DashboardStats({
    required this.snapshotTime,
    required this.overview,
    required this.recentUsers,
    required this.content,
    required this.media,
    required this.learning,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    final overviewJson = json['overview'];
    final recentJson = json['recentUsers'];
    final contentJson = json['content'];
    final mediaJson = json['media'];
    final learningJson = json['learning'];

    DateTime? parseSnapshot(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return DashboardStats(
      snapshotTime: parseSnapshot(json['snapshotTime']),
      overview: overviewJson is Map<String, dynamic>
          ? DashboardOverview.fromJson(overviewJson)
          : DashboardOverview.empty,
      recentUsers: recentJson is List
          ? recentJson
              .whereType<Map<String, dynamic>>()
              .map(RecentUser.fromJson)
              .toList(growable: false)
          : const [],
      content: contentJson is Map<String, dynamic>
          ? contentJson
          : const <String, dynamic>{},
      media: mediaJson is Map<String, dynamic>
          ? mediaJson
          : const <String, dynamic>{},
      learning: learningJson is Map<String, dynamic>
          ? learningJson
          : const <String, dynamic>{},
    );
  }
}
