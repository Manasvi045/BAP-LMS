// lib/widgets/primitives/back_link.dart — the "← back" link used at the top of sub-screens.
// 1:1 port of src/components/primitives/BackLink.tsx.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';

class BackLink extends StatelessWidget {
  final Widget child;
  final VoidCallback onClick;

  const BackLink({super.key, required this.child, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, size: 14, color: t.textDim),
                const SizedBox(width: 4),
                DefaultTextStyle.merge(
                  style: TextStyle(
                    color: t.textDim,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}