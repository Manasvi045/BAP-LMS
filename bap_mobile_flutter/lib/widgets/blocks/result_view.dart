// lib/widgets/blocks/result_view.dart — quiz/exam result screen.

import 'package:flutter/material.dart';

import '../../models/content.dart';
import '../../theme/accents.dart';
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';
import '../primitives/btn.dart';
import '../primitives/card_widget.dart';

class ResultView extends StatelessWidget {
  final String accent;
  final int score;
  final bool passed;
  final int passMark;
  final List<Question> quiz;
  final Map<int, int> answers;
  final String passText;
  final String continueLabel;
  final VoidCallback onContinue;
  final VoidCallback onRetake;
  final bool showCert;
  final String? certName;

  const ResultView({
    super.key,
    required this.accent,
    required this.score,
    required this.passed,
    required this.passMark,
    required this.quiz,
    required this.answers,
    required this.passText,
    required this.continueLabel,
    required this.onContinue,
    required this.onRetake,
    this.showCert = false,
    this.certName,
  });

  @override
  Widget build(BuildContext context) {
    final greenAccent = hexToColor(greenHex);
    final redAccent = hexToColor(redHex);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardWidget(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: passed
                        ? [greenAccent, const Color(0xFF16a34a)]
                        : [redAccent, const Color(0xFFdc2626)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                          child: Center(
                            child: Icon(
                              passed ? Icons.check : Icons.close,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          '$score%',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          passed
                              ? passText
                              : 'You need $passMark%. Review and try again.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showCert && passed && certName != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                      decoration: BoxDecoration(
                        color: tint(Accents.exam.c, 0.13),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events_outlined, size: 16, color: Accents.exam.color),
                          const SizedBox(width: 7),
                          Text(
                            certName!,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Accents.exam.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        for (int qi = 0; qi < quiz.length; qi++) ...[
          if (qi > 0) const SizedBox(height: 8),
          _AnswerRow(
            q: quiz[qi].q,
            correct: quiz[qi].options[quiz[qi].correct],
            right: answers[qi] == quiz[qi].correct,
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            if (!passed)
              Expanded(
                child: Btn(
                  variant: BtnVariant.ghost,
                  full: true,
                  onClick: onRetake,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.refresh, size: 14),
                      SizedBox(width: 6),
                      Text('Retake'),
                    ],
                  ),
                ),
              ),
            if (!passed) const SizedBox(width: 10),
            Expanded(
              child: Btn(
                accent: passed ? greenHex : accent,
                gradient: passed
                    ? 'linear-gradient(135deg, $greenHex, #16a34a)'
                    : null,
                full: true,
                onClick: onContinue,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(continueLabel),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnswerRow extends StatelessWidget {
  final String q;
  final String correct;
  final bool right;
  const _AnswerRow({required this.q, required this.correct, required this.right});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final greenAccent = hexToColor(greenHex);
    final redAccent = hexToColor(redHex);
    final accentColor = right ? greenAccent : redAccent;
    final borderColor = right ? tint(greenHex, 0.3) : tint(redHex, 0.25);
    // Outer surface card — uses the same BoxDecoration pattern as CardWidget
    // (color + Border.all + borderRadius), which paints reliably.
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Accent left bar.
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 11),
            // Icon.
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Icon(
                right ? Icons.check : Icons.close,
                size: 16,
                color: accentColor,
              ),
            ),
            const SizedBox(width: 10),
            // Question + correct answer text.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 15, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: t.textMid,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Correct answer: $correct',
                      style: TextStyle(fontSize: 11.5, color: t.textDim),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}