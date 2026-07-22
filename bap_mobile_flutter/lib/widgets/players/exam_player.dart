// lib/widgets/players/exam_player.dart — runs a topic's final exam.
// 1:1 port of src/components/path/ExamPlayer.tsx.

import 'package:flutter/material.dart';

import '../../models/content.dart' as model;
import '../../theme/accents.dart';
import '../../theme/theme_builder.dart';
import '../../theme/themes.dart';
import '../../theme/utils.dart';
import '../blocks/quiz_view.dart';
import '../blocks/result_view.dart';
import '../primitives/btn.dart';
import '../primitives/card_widget.dart';
import '../primitives/pill.dart';

class ExamPlayer extends StatefulWidget {
  final model.Topic topic;
  final VoidCallback onExit;
  final void Function(int score, bool pass) onResult;

  const ExamPlayer({
    super.key,
    required this.topic,
    required this.onExit,
    required this.onResult,
  });

  @override
  State<ExamPlayer> createState() => _ExamPlayerState();
}

class _ExamPlayerState extends State<ExamPlayer> {
  String _phase = 'intro'; // "intro" | "quiz" | "result"
  Map<int, int> _answers = <int, int>{};

  int get _score {
    if (widget.topic.exam.isEmpty) return 0;
    final correct = widget.topic.exam
        .asMap()
        .entries
        .where((e) => _answers[e.key] == e.value.correct)
        .length;
    return ((correct / widget.topic.exam.length) * 100).round();
  }

  bool get _passed => _score >= widget.topic.passMark;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final exAccent = Accents.exam;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Btn(
                variant: BtnVariant.ghost,
                onClick: widget.onExit,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.chevron_left, size: 15),
                    SizedBox(width: 4),
                    Text('Path'),
                  ],
                ),
              ),
              Pill(c: exAccent.c, child: const Text('Final exam')),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_phase == 'intro') _buildIntro(t, exAccent)
                  else if (_phase == 'quiz')
                    QuizView(
                      accent: exAccent.c,
                      quiz: widget.topic.exam,
                      answers: _answers,
                      setAnswers: (updater) => setState(() => _answers = updater(_answers)),
                      note:
                          '${widget.topic.exam.length} questions · ${widget.topic.passMark}% to pass and earn your certificate.',
                      onSubmit: () {
                        widget.onResult(_score, _passed);
                        setState(() => _phase = 'result');
                      },
                    )
                  else
                    ResultView(
                      accent: exAccent.c,
                      score: _score,
                      passed: _passed,
                      passMark: widget.topic.passMark,
                      quiz: widget.topic.exam,
                      answers: _answers,
                      passText: 'Certificate earned: ${widget.topic.cert}',
                      continueLabel: 'Back to path',
                      onContinue: widget.onExit,
                      onRetake: () {
                        setState(() {
                          _answers = <int, int>{};
                          _phase = 'quiz';
                        });
                      },
                      showCert: _passed,
                      certName: widget.topic.cert,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntro(AppTheme t, dynamic exAccent) {
    return CardWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(28, 34, 28, 30),
            decoration: BoxDecoration(
              gradient: gradLinear(exAccent),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: const Center(
                        child: Icon(Icons.emoji_events, size: 32, color: Colors.white),
                      ),
                    ),
                    Text(
                      '${widget.topic.label} final exam',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
            child: Column(
              children: [
                Text(
                  '${widget.topic.exam.length} questions drawn from a dedicated exam bank — separate from the section quizzes.',
                  style: TextStyle(fontSize: 13.5, color: t.textMid, height: 1.6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13.5, color: t.textMid),
                    children: [
                      TextSpan(text: 'Score ${widget.topic.passMark}%+ to earn the '),
                      TextSpan(
                        text: widget.topic.cert,
                        style: TextStyle(color: t.text, fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ' certificate.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Btn(
                  accent: exAccent.c,
                  gradient: 'linear-gradient(135deg, ${exAccent.c}, ${exAccent.g})',
                  onClick: () => setState(() => _phase = 'quiz'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Begin exam'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}