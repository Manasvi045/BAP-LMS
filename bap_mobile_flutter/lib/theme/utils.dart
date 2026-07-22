// lib/theme/utils.dart — colour helpers (1:1 with src/theme/utils.ts).

import 'package:flutter/material.dart';

/// Append an alpha byte (00-FF) to a 6-digit hex colour.
String tintHex(String hex, double alpha) {
  final a = (alpha.clamp(0, 1) * 255).round().toRadixString(16).padLeft(2, '0');
  return hex + a;
}

/// Parse a `#RRGGBB` or `#RRGGBBAA` hex string into a Flutter Color.
Color hexToColor(String hex) {
  var h = hex.replaceFirst('#', '');
  if (h.length == 6) h = 'FF$h';
  return Color(int.parse(h, radix: 16));
}

/// Apply an alpha to a hex string and return the matching Flutter Color.
Color tint(String hex, double alpha) =>
    hexToColor(tintHex(hex, alpha));

/// Apply an alpha to a Color and return a new Color.
Color tintColor(Color c, double alpha) =>
    c.withValues(alpha: alpha.clamp(0, 1));

/// Build the standard 135° linear gradient CSS string (used by some legacy widgets).
String gradCss(Object a) {
  // Accept both Accent and AccentRef (and any object exposing .c and .g).
  final dyn = a as dynamic;
  return 'linear-gradient(135deg, ${dyn.c}, ${dyn.g})';
}

/// Flutter-native gradient.
LinearGradient gradLinear(Object a) {
  final dyn = a as dynamic;
  return LinearGradient(
    colors: [hexToColor(dyn.c as String), hexToColor(dyn.g as String)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}