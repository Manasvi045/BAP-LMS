// lib/widgets/primitives/centered.dart — standard vertical screen padding wrapper.
// 1:1 port of src/components/primitives/Centered.tsx.

import 'package:flutter/material.dart';

class Centered extends StatelessWidget {
  final Widget child;

  const Centered({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: child,
    );
  }
}