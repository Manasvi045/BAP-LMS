// lib/screens/learning_path.dart — the topic path with gradient hero + section list.
// 1:1 port of src/screens/LearningPath.tsx. Owns the SectionPlayer/ExamPlayer
// active-step state (no extra state in App).

import 'package:flutter/material.dart';

import '../data/lookup.dart';
import '../models/content.dart' as model;
import '../state/progress.dart';
import '../theme/accents.dart';
import '../theme/theme_builder.dart';
import '../theme/utils.dart';
import '../widgets/blocks/road_node.dart';
import '../widgets/icon_registry.dart';
import '../widgets/players/exam_player.dart';
import '../widgets/players/section_player.dart';
import '../widgets/primitives/back_link.dart';
import '../widgets/primitives/btn.dart';
import '../widgets/primitives/pill.dart';

sealed class ActiveStep {
  const ActiveStep();
}

class SectionStep extends ActiveStep {
  final int idx;
  const SectionStep(this.idx);
}

class ExamStep extends ActiveStep {
  const ExamStep();
}

class LearningPathScreen extends StatefulWidget {
  final String vId;
  final String tId;
  final VoidCallback back;
  final ProgressEntry Function(String vId, String tId) get;
  final Future<void> Function(String sectionId, int score, bool pass) recordSection;
  final Future<void> Function(int score, bool pass) recordExam;

  const LearningPathScreen({
    super.key,
    required this.vId,
    required this.tId,
    required this.back,
    required this.get,
    required this.recordSection,
    required this.recordExam,
  });

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  ActiveStep? _active;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final v = findVertical(widget.vId);
    final topic = findTopic(widget.vId, widget.tId);
    if (v == null || topic == null) return const SizedBox.shrink();

    final p = widget.get(widget.vId, widget.tId);
    final sections = topic.sections;

    if (_active is SectionStep) {
      final idx = (_active as SectionStep).idx;
      return SectionPlayer(
        key: ValueKey(sections[idx].id),
        section: sections[idx],
        index: idx,
        total: sections.length,
        passMark: topic.passMark,
        onExit: () => setState(() => _active = null),
        onResult: (s, pa) => widget.recordSection(sections[idx].id, s, pa),
      );
    }
    if (_active is ExamStep) {
      return ExamPlayer(
        topic: topic,
        onExit: () => setState(() => _active = null),
        onResult: (s, pa) => widget.recordExam(s, pa),
      );
    }

    final pct = topicPct(topic, p);
    return Container(
      color: t.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackLink(onClick: widget.back, child: Text('${v.label} topics')),
            const SizedBox(height: 16),
            _Hero(vertical: v, topic: topic, pct: pct),
            const SizedBox(height: 22),
            Stack(
              children: [
                Positioned(
                  left: 21,
                  top: 26,
                  bottom: 26,
                  child: Container(width: 2, color: t.border),
                ),
                Column(
                  children: [
                    for (int i = 0; i < sections.length; i++)
                      _SectionNode(
                        section: sections[i],
                        index: i,
                        isDone: p.sectionsDone.contains(sections[i].id),
                        onActivate: () => setState(() => _active = SectionStep(i)),
                      ),
                    _FinalExamNode(
                      topic: topic,
                      examPassed: p.examPassed,
                      examBest: p.examBest,
                      onActivate: () => setState(() => _active = const ExamStep()),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final model.Vertical vertical;
  final model.Topic topic;
  final int pct;
  const _Hero({required this.vertical, required this.topic, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor(vertical.accent.c), hexToColor(vertical.accent.g)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: tint(vertical.accent.c, 0.35),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -50,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vertical.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${topic.label} path',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${topic.sections.length} sections · final exam · ${topic.cert}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$pct%',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'complete',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: pct / 100.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) {
                  return Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionNode extends StatelessWidget {
  final model.Section section;
  final int index;
  final bool isDone;
  final VoidCallback onActivate;
  const _SectionNode({
    required this.section,
    required this.index,
    required this.isDone,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final icon = iconFor(section.icon);
    return RoadNode(
      color: section.color,
      isDone: isDone,
      icon: icon,
      title: Row(
        children: [
          Flexible(
            child: Text(
              '${index + 1}. ${section.title}',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: t.text),
            ),
          ),
          if (isDone) ...[
            const SizedBox(width: 8),
            Pill(c: greenHex, child: const Text('Done')),
          ],
        ],
      ),
      subtitle: Text(section.blurb, style: TextStyle(fontSize: 12.5, color: t.textMid)),
      body: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          '${section.pages.length} pages · ${section.quiz.length}-q quiz',
          style: TextStyle(fontSize: 11, color: t.textFaint),
        ),
      ),
      cta: Btn(
        accent: section.color,
        variant: isDone ? BtnVariant.ghost : BtnVariant.primary,
        full: true,
        onClick: onActivate,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: isDone
              ? const [
                  Icon(Icons.refresh, size: 13),
                  SizedBox(width: 6),
                  Text('Review'),
                ]
              : const [
                  Text('Start'),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 13),
                ],
        ),
      ),
    );
  }
}

class _FinalExamNode extends StatelessWidget {
  final model.Topic topic;
  final bool examPassed;
  final int examBest;
  final VoidCallback onActivate;
  const _FinalExamNode({
    required this.topic,
    required this.examPassed,
    required this.examBest,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return RoadNode(
      color: Accents.exam.c,
      gradient: gradCss(Accents.exam),
      isDone: examPassed,
      icon: Icons.emoji_events,
      title: Row(
        children: [
          Flexible(
            child: Text(
              'Final exam',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: t.text),
            ),
          ),
          if (examPassed) ...[
            const SizedBox(width: 8),
            Pill(c: greenHex, child: Text('Passed $examBest%')),
          ],
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          '${topic.exam.length} questions · earns the ${topic.cert} certificate',
          style: TextStyle(fontSize: 12.5, color: t.textMid),
        ),
      ),
      cta: Btn(
        accent: Accents.exam.c,
        gradient: !examPassed ? gradCss(Accents.exam) : null,
        variant: examPassed ? BtnVariant.ghost : BtnVariant.primary,
        full: true,
        onClick: onActivate,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: examPassed
              ? const [
                  Icon(Icons.refresh, size: 13),
                  SizedBox(width: 6),
                  Text('Retake'),
                ]
              : const [
                  Text('Take exam'),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 13),
                ],
        ),
      ),
    );
  }
}