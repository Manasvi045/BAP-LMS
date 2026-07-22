// lib/widgets/icon_registry.dart — 17-key lucide→Material map, with BookOpen fallback.

import 'package:flutter/material.dart';

/// Resolve a content-defined icon name (string) to a Material IconData.
/// Falls back to `Icons.menu_book_outlined` (the Material twin of BookOpen).
IconData iconFor(String? name) => _icons[name] ?? Icons.menu_book_outlined;

const Map<String, IconData> _icons = {
  'Activity': Icons.show_chart,
  'Award': Icons.emoji_events_outlined,
  'BarChart3': Icons.bar_chart,
  'BookOpen': Icons.menu_book_outlined,
  'ClipboardList': Icons.assignment_outlined,
  'FileText': Icons.description_outlined,
  'Flame': Icons.local_fire_department,
  'GitBranch': Icons.account_tree,
  'Globe': Icons.public,
  'Grid3x3': Icons.grid_on,
  'Heart': Icons.favorite_border,
  'Layers': Icons.layers_outlined,
  'Ruler': Icons.straighten,
  'Scissors': Icons.content_cut,
  'Stethoscope': Icons.medical_services_outlined,
  'Syringe': Icons.vaccines_outlined,
  'Target': Icons.gps_fixed,
};