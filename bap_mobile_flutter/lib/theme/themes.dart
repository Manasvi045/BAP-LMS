// lib/theme/themes.dart — light/dark token sets, lifted from src/theme/themes.ts verbatim.

import 'package:flutter/material.dart';

@immutable
class AppTheme {
  final String name;
  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceHover;
  final Color border;
  final Color borderStrong;
  final Color text;
  final Color textMid;
  final Color textDim;
  final Color textFaint;
  final Color navBar;
  final List<BoxShadow> shadow;
  final List<BoxShadow> shadowHover;
  final Color track;

  const AppTheme({
    required this.name,
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceHover,
    required this.border,
    required this.borderStrong,
    required this.text,
    required this.textMid,
    required this.textDim,
    required this.textFaint,
    required this.navBar,
    required this.shadow,
    required this.shadowHover,
    required this.track,
  });
}

const AppTheme lightTheme = AppTheme(
  name: 'light',
  bg: Color(0xFFf3f4f8),
  surface: Color(0xFFffffff),
  surfaceAlt: Color(0xFFf7f8fc),
  surfaceHover: Color(0xFFeef0f7),
  border: Color(0xFFe6e8f0),
  borderStrong: Color(0xFFd4d8e4),
  text: Color(0xFF171a23),
  textMid: Color(0xFF565d70),
  textDim: Color(0xFF8b91a4),
  textFaint: Color(0xFFaeb4c5),
  navBar: Color(0xD2ffffff),
  shadow: [
    BoxShadow(color: Color(0x0A171A23), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0D171A23), blurRadius: 20, offset: Offset(0, 6)),
  ],
  shadowHover: [
    BoxShadow(color: Color(0x17171A23), blurRadius: 16, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x1A171A23), blurRadius: 44, offset: Offset(0, 18)),
  ],
  track: Color(0xFFe9ebf3),
);

const AppTheme darkTheme = AppTheme(
  name: 'dark',
  bg: Color(0xFF0a0c12),
  surface: Color(0xFF151823),
  surfaceAlt: Color(0xFF1b1f2d),
  surfaceHover: Color(0xFF222636),
  border: Color(0xFF272c3c),
  borderStrong: Color(0xFF363c50),
  text: Color(0xFFf0f2f7),
  textMid: Color(0xFFa6adbf),
  textDim: Color(0xFF727a90),
  textFaint: Color(0xFF565d72),
  navBar: Color(0xD210131C),
  shadow: [
    BoxShadow(color: Color(0x4D000000), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x66000000), blurRadius: 20, offset: Offset(0, 6)),
  ],
  shadowHover: [
    BoxShadow(color: Color(0x73000000), blurRadius: 16, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x8C000000), blurRadius: 44, offset: Offset(0, 18)),
  ],
  track: Color(0xFF272c3c),
);

/// Provider-side lookup so widgets can fetch the active theme via
/// `Theme.of(context).extension<AppThemeExt>()`.
@immutable
class AppThemeExt extends ThemeExtension<AppThemeExt> {
  final AppTheme t;
  const AppThemeExt(this.t);

  @override
  ThemeExtension<AppThemeExt> copyWith() => this;

  @override
  ThemeExtension<AppThemeExt> lerp(ThemeExtension<AppThemeExt>? other, double t) => this;
}