// lib/theme/theme_builder.dart — wire AppTheme tokens into ThemeData.

import 'package:flutter/material.dart';
import 'themes.dart';

ThemeData buildThemeData(AppTheme t) {
  final base = t.name == 'dark' ? ThemeData.dark() : ThemeData.light();
  return base.copyWith(
    scaffoldBackgroundColor: t.bg,
    canvasColor: t.bg,
    cardColor: t.surface,
    dividerColor: t.border,
    colorScheme: base.colorScheme.copyWith(
      surface: t.surface,
      onSurface: t.text,
      primary: t.text,
      secondary: t.textMid,
      error: const Color(0xFFef4444),
    ),
    textTheme: base.textTheme.apply(bodyColor: t.text, displayColor: t.text),
    iconTheme: IconThemeData(color: t.textMid),
    extensions: [AppThemeExt(t)],
  );
}

/// Convenience: `final t = ctx.t;` — pulls the active AppTheme from context.
extension AppThemeCtx on BuildContext {
  AppTheme get t => Theme.of(this).extension<AppThemeExt>()!.t;
}