// lib/widgets/blocks/road_node.dart — a single step in the LearningPath.
// 1:1 port of src/components/blocks/RoadNode.tsx.
// ignore_for_file: use_null_aware_elements

import 'package:flutter/material.dart';

import '../../theme/accents.dart';
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class RoadNode extends StatelessWidget {
  final String color;
  final String? gradient;
  final bool isDone;
  final IconData icon;

  /// Optional CTA (e.g. a "Start" button) shown at the bottom of the card.
  final Widget? cta;
  final Widget? title;
  final Widget? subtitle;
  final Widget? body;

  const RoadNode({
    super.key,
    required this.color,
    this.gradient,
    required this.isDone,
    required this.icon,
    this.cta,
    this.title,
    this.subtitle,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final greenColor = hexToColor(greenHex);
    final colorObj = hexToColor(color);
    final fill = isDone ? greenColor : gradient != null ? null : colorObj;

    final boxShadows = <BoxShadow>[
      if (isDone)
        BoxShadow(
          color: tint(greenHex, 0.35),
          blurRadius: 12,
          offset: const Offset(0, 4),
        )
      else
        ...[
          BoxShadow(
            color: tint(color, 0.16),
            blurRadius: 0,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: tint(color, 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
    ];

    final Widget badge =
        isDone ? Icon(Icons.check, size: 19, color: Colors.white) : Icon(icon, size: 19, color: Colors.white);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Badge column.
          Container(
            margin: const EdgeInsets.only(top: 0),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: isDone ? null : Border.all(color: colorObj, width: 2),
                boxShadow: boxShadows,
              ),
              child: Center(child: badge),
            ),
          ),
          const SizedBox(width: 13),
          // Content card.
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: t.surface,
                border: Border.all(color: t.border),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) title!,
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: subtitle!,
                    ),
                  if (body != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: body!,
                    ),
                  if (cta != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(alignment: Alignment.centerLeft, child: cta!),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}