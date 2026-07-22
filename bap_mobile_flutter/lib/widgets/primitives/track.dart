// lib/widgets/primitives/track.dart — a thin progress bar with rounded ends.
// 1:1 port of src/components/primitives/Track.tsx.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class Track extends StatelessWidget {
  final double pct;
  final String accent;
  final String? gradient;
  final double h;

  const Track({
    super.key,
    required this.pct,
    required this.accent,
    this.gradient,
    this.h = 7,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final clamped = pct.clamp(0.0, 100.0);
    return Container(
      height: h,
      decoration: BoxDecoration(
        color: t.track,
        borderRadius: BorderRadius.circular(h),
      ),
      clipBehavior: Clip.hardEdge,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: clamped / 100.0),
          duration: const Duration(milliseconds: 500),
          curve: const Cubic(0.4, 0, 0.2, 1),
          builder: (context, value, _) {
            return FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: gradient != null
                      ? gradLinearCss(gradient!, fallback: hexToColor(accent))
                      : LinearGradient(
                          colors: [
                            tint(accent, 0.7),
                            hexToColor(accent),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(h),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Build a LinearGradient from a CSS-style gradient string (e.g. "linear-gradient(135deg, #a, #b)").
/// Falls back to the supplied [fallback] if the string can't be parsed.
LinearGradient gradLinearCss(String css, {required Color fallback}) {
  final open = css.indexOf('(');
  final close = css.lastIndexOf(')');
  if (open < 0 || close < 0 || close <= open) {
    return LinearGradient(colors: [fallback, fallback]);
  }
  final inner = css.substring(open + 1, close);
  final parts = inner.split(',').map((s) => s.trim()).toList();
  // Last two non-percentage / non-direction tokens should be the colour stops.
  final colorParts = parts.where((p) => !p.endsWith('deg')).toList();
  if (colorParts.length < 2) {
    return LinearGradient(colors: [fallback, fallback]);
  }
  return LinearGradient(
    colors: [hexToColor(colorParts[0]), hexToColor(colorParts[1])],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}