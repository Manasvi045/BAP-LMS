// lib/widgets/players/section_player.dart — runs one section's pages → quiz → result.
// 1:1 port of src/components/path/SectionPlayer.tsx.

import 'package:flutter/material.dart' hide PageView;

import '../../models/content.dart' as model;
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';
import '../blocks/page_view.dart';
import '../blocks/quiz_view.dart';
import '../blocks/result_view.dart';
import '../icon_registry.dart';
import '../primitives/btn.dart';

class SectionPlayer extends StatefulWidget {
  final model.Section section;
  final int index;
  final int total;
  final int passMark;
  final VoidCallback onExit;
  final void Function(int score, bool pass) onResult;

  const SectionPlayer({
    super.key,
    required this.section,
    required this.index,
    required this.total,
    required this.passMark,
    required this.onExit,
    required this.onResult,
  });

  @override
  State<SectionPlayer> createState() => _SectionPlayerState();
}

class _SectionPlayerState extends State<SectionPlayer> {
  int _page = 0;
  String _phase = 'pages'; // "pages" | "quiz" | "result"
  bool _videoWatched = false;
  Map<int, int> _answers = <int, int>{};

  model.Page get _cur => widget.section.pages[_page];
  bool get _onLast => _page == widget.section.pages.length - 1;
  bool get _canAdvance => _cur is! model.VideoPage || _videoWatched;

  int get _score {
    if (widget.section.quiz.isEmpty) return 0;
    final correct = widget.section.quiz
        .asMap()
        .entries
        .where((e) => _answers[e.key] == e.value.correct)
        .length;
    return ((correct / widget.section.quiz.length) * 100).round();
  }

  bool get _passed => _score >= widget.passMark;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accent = widget.section.color;
    final icon = iconFor(widget.section.icon);
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
              Text(
                'Section ${widget.index + 1} of ${widget.total}',
                style: TextStyle(
                  fontSize: 12,
                  color: t.textDim,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [tint(accent, 0.85), hexToColor(accent)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: tint(accent, 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 21, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.section.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: t.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _phase == 'pages'
                          ? 'Page ${_page + 1} of ${widget.section.pages.length}'
                          : 'Section quiz',
                      style: TextStyle(fontSize: 12, color: t.textDim),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_phase == 'pages')
                    PageView(
                      cur: _cur,
                      accent: accent,
                      videoWatched: _videoWatched,
                      setVideoWatched: (v) => setState(() => _videoWatched = v),
                      page: _page,
                      totalPages: widget.section.pages.length,
                      onPrev: () {
                        if (_page > 0) {
                          setState(() {
                            _page -= 1;
                            _videoWatched = false;
                          });
                        }
                      },
                      onNext: () {
                        if (_canAdvance) {
                          setState(() {
                            _page += 1;
                            _videoWatched = false;
                          });
                        }
                      },
                      onLast: _onLast,
                      canAdvance: _canAdvance,
                      onGoQuiz: () {
                        if (_canAdvance) setState(() => _phase = 'quiz');
                      },
                    )
                  else if (_phase == 'quiz')
                    QuizView(
                      accent: accent,
                      quiz: widget.section.quiz,
                      answers: _answers,
                      setAnswers: (updater) => setState(() => _answers = updater(_answers)),
                      note:
                          'Answer all ${widget.section.quiz.length} questions. Score ${widget.passMark}% or higher to pass this section.',
                      onSubmit: () {
                        widget.onResult(_score, _passed);
                        setState(() => _phase = 'result');
                      },
                    )
                  else
                    ResultView(
                      accent: accent,
                      score: _score,
                      passed: _passed,
                      passMark: widget.passMark,
                      quiz: widget.section.quiz,
                      answers: _answers,
                      passText: 'Section passed.',
                      continueLabel: 'Continue',
                      onContinue: widget.onExit,
                      onRetake: () {
                        setState(() {
                          _answers = <int, int>{};
                          _phase = 'quiz';
                        });
                      },
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