// lib/screens/vertical_select.dart — the home screen showing all verticals grouped by section.
// 1:1 port of src/screens/VerticalSelect.tsx.

import 'package:flutter/material.dart';

import '../data/registry.dart';
import '../models/content.dart' as model;
import '../state/nav.dart';
import '../theme/accents.dart';
import '../theme/theme_builder.dart';
import '../theme/utils.dart';
import '../widgets/icon_registry.dart';
import '../widgets/primitives/card_widget.dart';
import '../widgets/primitives/centered.dart';
import '../widgets/primitives/h1.dart';
import '../widgets/primitives/kicker.dart';

class VerticalSelectScreen extends StatelessWidget {
  final void Function(NavTarget) go;
  const VerticalSelectScreen({super.key, required this.go});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final market = data.verticals.where((v) => v.section == 'market').toList();
    final clinical = data.verticals.where((v) => v.section == 'clinical').toList();

    Widget group(String title, List<model.Vertical> items, String dot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: hexToColor(dot),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: t.textDim,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _VerticalCard(vertical: items[i], go: go),
          ],
          const SizedBox(height: 28),
        ],
      );
    }

    return Centered(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Kicker(c: Accents.exam.c, child: const Text('Business Acceleration Platform (BAP)')),
            const H1(child: Text('Choose where to learn')),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                'Guided learning paths with quizzes, final exams and certificates.',
                style: TextStyle(fontSize: 14.5, color: t.textMid),
              ),
            ),
            if (market.isNotEmpty) group('Market Intelligence', market, Accents.country.c),
            if (clinical.isNotEmpty) group('Clinical Verticals', clinical, Accents.endo.c),
          ],
        ),
      ),
    );
  }
}

class _VerticalCard extends StatelessWidget {
  final model.Vertical vertical;
  final void Function(NavTarget) go;
  const _VerticalCard({required this.vertical, required this.go});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accent = vertical.accent;
    final icon = iconFor(vertical.icon);
    return CardWidget(
      hover: true,
      accent: accent.c,
      padding: EdgeInsets.zero,
      onClick: () => go(NavTopicSelect(vertical.id)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [hexToColor(accent.c), hexToColor(accent.g)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: tint(accent.c, 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vertical.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: t.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${vertical.topics.length} topics',
                    style: TextStyle(fontSize: 12, color: t.textDim),
                  ),
                ],
              ),
            ),
            Transform.rotate(
              angle: 3.14159,
              child: Icon(Icons.chevron_left, size: 18, color: t.textFaint),
            ),
          ],
        ),
      ),
    );
  }
}