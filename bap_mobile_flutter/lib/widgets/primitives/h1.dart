// lib/widgets/primitives/h1.dart — the screen title. 1:1 port of src/components/primitives/H1.tsx.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';

class H1 extends StatelessWidget {
  final Widget child;

  const H1({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return DefaultTextStyle.merge(
      style: TextStyle(
        color: t.text,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.15,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: child,
      ),
    );
  }
}