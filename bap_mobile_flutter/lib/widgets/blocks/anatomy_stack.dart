// lib/widgets/blocks/anatomy_stack.dart — renders an AnatomyPage (stacked colour swatches).
// 1:1 port of src/components/blocks/AnatomyStack.tsx.

import 'package:flutter/material.dart';

import '../../models/content.dart';
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class AnatomyStack extends StatelessWidget {
  final List<AnatomyLayer> layers;

  const AnatomyStack({super.key, required this.layers});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < layers.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: t.surface,
              border: Border.all(color: t.border),
              borderRadius: BorderRadius.circular(13),
            ),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: hexToColor(layers[i].color),
                      border: Border.all(color: t.border),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            layers[i].name,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: t.text,
                            ),
                          ),
                          if (layers[i].depth != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: t.surfaceAlt,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                layers[i].depth!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: t.textDim,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        layers[i].desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: t.textMid,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}