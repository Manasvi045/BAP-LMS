// lib/widgets/blocks/card_grid.dart — renders a CardsPage (list of ProductCard).
// 1:1 port of src/components/blocks/CardGrid.tsx.

import 'package:flutter/material.dart';

import '../../models/content.dart';
import '../../theme/accents.dart';
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';
import '../primitives/pill.dart';

String _hex(Color c) {
  final r = (c.r * 255).round().toRadixString(16).padLeft(2, '0');
  final g = (c.g * 255).round().toRadixString(16).padLeft(2, '0');
  final b = (c.b * 255).round().toRadixString(16).padLeft(2, '0');
  return '#$r$g$b';
}

class CardGrid extends StatelessWidget {
  final List<ProductCard> items;
  final String accent;

  const CardGrid({super.key, required this.items, required this.accent});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _ProductCardTile(card: items[i], accent: accent, t: t),
        ],
      ],
    );
  }
}

class _ProductCardTile extends StatelessWidget {
  final ProductCard card;
  final String accent;
  final dynamic t;

  const _ProductCardTile({required this.card, required this.accent, required this.t});

  @override
  Widget build(BuildContext context) {
    final accentColor = hexToColor(accent);
    final hasMeta = card.category != null ||
        card.construction != null ||
        (card.absorption != null && card.absorption != '—') ||
        card.origin != null;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(14),
        boxShadow: t.shadow,
      ),
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.sku,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: t.text,
                      ),
                    ),
                    if (card.generic != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          card.generic!,
                          style: TextStyle(fontSize: 11.5, color: t.textDim),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (hasMeta) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 5, runSpacing: 5, children: [
              if (card.category != null)
                Pill(c: accent, child: Text(card.category!)),
              if (card.construction != null)
                Pill(
                  c: _hex(t.textDim),
                  soft: _hex(t.surfaceHover),
                  child: Text(card.construction!),
                ),
              if (card.absorption != null && card.absorption != '—')
                Pill(c: greenHex, child: Text(card.absorption!)),
              if (card.origin != null)
                Pill(
                  c: _hex(t.textDim),
                  soft: _hex(t.surfaceHover),
                  child: Text(card.origin!),
                ),
            ]),
          ],
          if (card.features != null && card.features!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'FEATURES',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: t.textDim,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            for (final f in card.features!)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.check, size: 12, color: accentColor),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(fontSize: 12, color: t.textMid, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (card.cautions != null && card.cautions!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'CAUTIONS',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: redColor,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            for (final c in card.cautions!)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.close, size: 12, color: redColor),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        c,
                        style: TextStyle(fontSize: 12, color: t.textMid, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

const String greenHex = '#22c55e';