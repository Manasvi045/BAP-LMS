// lib/widgets/blocks/quiz_view.dart — the question/answer screen.
// 1:1 port of src/components/blocks/QuizView.tsx.

import 'package:flutter/material.dart';

import '../../models/content.dart';
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';
import '../primitives/btn.dart';
import '../primitives/card_widget.dart';

class QuizView extends StatelessWidget {
  final String accent;
  final List<Question> quiz;
  final Map<int, int> answers;
  final void Function(Map<int, int> Function(Map<int, int> updater)) setAnswers;
  final String note;
  final VoidCallback onSubmit;

  const QuizView({
    super.key,
    required this.accent,
    required this.quiz,
    required this.answers,
    required this.setAnswers,
    required this.note,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final complete = answers.length >= quiz.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            note,
            style: TextStyle(fontSize: 12.5, color: t.textMid, height: 1.5),
          ),
        ),
        for (int qi = 0; qi < quiz.length; qi++) ...[
          if (qi > 0) const SizedBox(height: 12),
          CardWidget(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 13),
                  child: Text(
                    '${qi + 1}. ${quiz[qi].q}',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: t.text,
                    ),
                  ),
                ),
                for (int oi = 0; oi < quiz[qi].options.length; oi++) ...[
                  if (oi > 0) const SizedBox(height: 9),
                  _OptionTile(
                    label: quiz[qi].options[oi],
                    selected: answers[qi] == oi,
                    accent: accent,
                    onTap: () => setAnswers((a) {
                      final n = Map<int, int>.from(a);
                      n[qi] = oi;
                      return n;
                    }),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        Btn(
          accent: accent,
          full: true,
          disabled: !complete,
          onClick: complete ? onSubmit : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Text('Submit'),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final String accent;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accentColor = hexToColor(accent);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          decoration: BoxDecoration(
            color: selected
                ? tint(accent, t.name == 'dark' ? 0.18 : 0.09)
                : t.surfaceAlt,
            border: Border.all(
              color: selected ? accentColor : t.border,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 18,
                color: selected ? accentColor : t.textFaint,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: selected ? t.text : t.textMid,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}