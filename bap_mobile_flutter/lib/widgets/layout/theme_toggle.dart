// lib/widgets/layout/theme_toggle.dart — the light/dark switch in the top header.
// 1:1 port of src/components/layout/ThemeToggle.tsx.

import 'package:flutter/material.dart';

import '../../theme/accents.dart';
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class ThemeToggle extends StatelessWidget {
  final String themeName;
  final ValueChanged<String> setThemeName;

  const ThemeToggle({
    super.key,
    required this.themeName,
    required this.setThemeName,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isDark = themeName == 'dark';
    final bg = isDark ? tint(Accents.exam.c, 0.2) : tint('#f59e0b', 0.15);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setThemeName(isDark ? 'light' : 'dark'),
        child: Container(
          margin: const EdgeInsets.only(left: 4),
          width: 52,
          height: 28,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: t.border),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: const Cubic(0.4, 0, 0.2, 1),
                left: isDark ? 26 : 2,
                top: 2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2a3142) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined,
                      size: 13,
                      color: isDark ? const Color(0xFFc4b5fd) : const Color(0xFFf59e0b),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}