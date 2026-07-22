// lib/widgets/primitives/pill.dart — a small uppercase label/chip.
// 1:1 port of src/components/primitives/Pill.tsx.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class Pill extends StatelessWidget {
  final Widget child;
  final String c;
  final String? soft;

  const Pill({
    super.key,
    required this.child,
    required this.c,
    this.soft,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final fg = hexToColor(c);
    final alpha = t.name == 'dark' ? 0.2 : 0.13;
    final bg = soft != null ? hexToColor(soft!) : tint(c, alpha);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: fg,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        child: child,
      ),
    );
  }
}