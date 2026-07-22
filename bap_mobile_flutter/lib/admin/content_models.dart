// lib/admin/content_models.dart
// ============================================================================
// Typed view of the read-only content endpoints.
//
// Mirrors the backend contract from
//   lms_backend/controllers/verticalController.js
//   lms_backend/controllers/moduleController.js
//   lms_backend/controllers/sectionController.js
//
// All three list endpoints return the same shape:
//   { success, pagination, data: [...] }
//
// Only the columns the mobile app shows are modelled — the rest fall
// through into the `raw` map for future use.
// ============================================================================

import 'package:flutter/foundation.dart';

/// Publication status. Backend columns: `status` ('draft' | 'published' |
/// 'archived'). Some rows may have NULL while a vertical is mid-creation.
enum ContentStatus { draft, published, archived, unknown }

extension ContentStatusLabel on ContentStatus {
  String get label => switch (this) {
        ContentStatus.draft => 'Draft',
        ContentStatus.published => 'Published',
        ContentStatus.archived => 'Archived',
        ContentStatus.unknown => '—',
      };
  static ContentStatus fromWire(String? raw) {
    switch (raw) {
      case 'draft':
        return ContentStatus.draft;
      case 'published':
        return ContentStatus.published;
      case 'archived':
        return ContentStatus.archived;
      default:
        return ContentStatus.unknown;
    }
  }
}

/// One row in /api/verticals.
@immutable
class Vertical {
  final int id;
  final String name;
  final String slug;
  final String description;
  final ContentStatus status;
  final int displayOrder;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Vertical({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.status,
    required this.displayOrder,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vertical.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return Vertical(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id'] ?? ''}') ?? 0,
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: ContentStatusLabel.fromWire((json['status'] ?? '').toString()),
      displayOrder: json['display_order'] is int
          ? json['display_order'] as int
          : int.tryParse('${json['display_order'] ?? ''}') ?? 0,
      publishedAt: parseDate(json['published_at']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

/// One row in /api/modules.
@immutable
class ContentModule {
  final int id;
  final int verticalId;
  final String name;
  final String slug;
  final String description;
  final ContentStatus status;
  final int displayOrder;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ContentModule({
    required this.id,
    required this.verticalId,
    required this.name,
    required this.slug,
    required this.description,
    required this.status,
    required this.displayOrder,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContentModule.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return ContentModule(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id'] ?? ''}') ?? 0,
      verticalId: json['vertical_id'] is int
          ? json['vertical_id'] as int
          : int.tryParse('${json['vertical_id'] ?? ''}') ?? 0,
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: ContentStatusLabel.fromWire((json['status'] ?? '').toString()),
      displayOrder: json['display_order'] is int
          ? json['display_order'] as int
          : int.tryParse('${json['display_order'] ?? ''}') ?? 0,
      publishedAt: parseDate(json['published_at']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

/// One row in /api/sections.
@immutable
class ContentSection {
  final int id;
  final int moduleId;
  final String name;
  final String slug;
  final String description;
  final ContentStatus status;
  final int displayOrder;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ContentSection({
    required this.id,
    required this.moduleId,
    required this.name,
    required this.slug,
    required this.description,
    required this.status,
    required this.displayOrder,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContentSection.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return ContentSection(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id'] ?? ''}') ?? 0,
      moduleId: json['module_id'] is int
          ? json['module_id'] as int
          : int.tryParse('${json['module_id'] ?? ''}') ?? 0,
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: ContentStatusLabel.fromWire((json['status'] ?? '').toString()),
      displayOrder: json['display_order'] is int
          ? json['display_order'] as int
          : int.tryParse('${json['display_order'] ?? ''}') ?? 0,
      publishedAt: parseDate(json['published_at']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

/// Pagination envelope shared by all three list endpoints.
@immutable
class ContentPage<T> {
  final List<T> items;
  final int page;
  final int limit;
  final int totalRecords;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const ContentPage({
    required this.items,
    required this.page,
    required this.limit,
    required this.totalRecords,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory ContentPage.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) build,
  ) {
    int asInt(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}') ?? 0;
    bool asBool(dynamic v) => v == true || v == 't' || v == 'true';
    final pagination = json['pagination'];
    final data = json['data'];
    final items = data is List
        ? data
            .whereType<Map<String, dynamic>>()
            .map(build)
            .toList(growable: false)
        : const <Never>[];
    if (pagination is Map<String, dynamic>) {
      return ContentPage<T>(
        items: items,
        page: asInt(pagination['page']),
        limit: asInt(pagination['limit']),
        totalRecords: asInt(pagination['totalRecords']),
        totalPages: asInt(pagination['totalPages']),
        hasNextPage: asBool(pagination['hasNextPage']),
        hasPrevPage: asBool(pagination['hasPrevPage']),
      );
    }
    return ContentPage<T>(
      items: items,
      page: 1,
      limit: items.length,
      totalRecords: items.length,
      totalPages: 1,
      hasNextPage: false,
      hasPrevPage: false,
    );
  }
}
