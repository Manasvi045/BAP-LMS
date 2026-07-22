// lib/theme/accents.dart — vertical accents, section palette, brand colours.
// 1:1 port of src/theme/accents.ts.

import 'package:flutter/material.dart';

@immutable
class Accent {
  final String c; // primary color
  final String g; // gradient stop
  const Accent(this.c, this.g);

  Color get color => Color(int.parse(c.substring(1), radix: 16) | 0xFF000000);
  Color get gradient => Color(int.parse(g.substring(1), radix: 16) | 0xFF000000);
}

class Accents {
  static const endo = Accent('#3b82f6', '#6366f1'); // blue -> indigo
  static const ortho = Accent('#f59e0b', '#f97316'); // amber -> orange
  static const cardio = Accent('#ef4444', '#ec4899'); // red -> pink
  static const country = Accent('#14b8a6', '#06b6d4'); // teal -> cyan
  static const exam = Accent('#8b5cf6', '#a855f7'); // violet -> purple
}

/// 6-color rotation for section badges.
const List<String> sectionColorsHex = [
  '#3b82f6',
  '#14b8a6',
  '#f59e0b',
  '#ec4899',
  '#8b5cf6',
  '#06b6d4',
];

List<Color> get sectionColors =>
    sectionColorsHex.map((h) => Color(int.parse(h.substring(1), radix: 16) | 0xFF000000)).toList();

const String greenHex = '#22c55e';
const String redHex = '#ef4444';

Color get greenColor => const Color(0xFF22c55e);
Color get redColor => const Color(0xFFef4444);