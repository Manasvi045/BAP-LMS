// lib/widgets/primitives/kicker.dart — a small uppercase eyebrow label
// that sits above a screen title. 1:1 port of src/components/primitives/Kicker.tsx.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class Kicker extends StatelessWidget {
  final Widget child;
  final String? c;

  const Kicker({super.key, required this.child, this.c});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final color = c != null ? hexToColor(c!) : t.textFaint;
    return DefaultTextStyle.merge(
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
      child: child,
    );
  }
}