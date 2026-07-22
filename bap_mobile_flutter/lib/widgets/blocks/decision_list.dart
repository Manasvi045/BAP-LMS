// lib/widgets/blocks/decision_list.dart — renders a DecisionPage (branching-questions list).
// 1:1 port of src/components/blocks/DecisionList.tsx.

import 'package:flutter/material.dart';

import '../../models/content.dart';
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class DecisionList extends StatelessWidget {
  final List<DecisionNode> nodes;
  final String accent;

  const DecisionList({super.key, required this.nodes, required this.accent});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accentColor = hexToColor(accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < nodes.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: t.surface,
              border: Border(
                left: BorderSide(color: accentColor, width: 3),
                top: BorderSide(color: t.border),
                right: BorderSide(color: t.border),
                bottom: BorderSide(color: t.border),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: tint(accent, 0.18),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nodes[i].q,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: t.text,
                          height: 1.45,
                        ),
                      ),
                      if (nodes[i].hint != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            nodes[i].hint!,
                            style: TextStyle(fontSize: 11.5, color: t.textDim),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}