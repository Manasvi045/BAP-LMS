// lib/screens/progress_dashboard.dart — stats tiles, certificates, topic progress, recent attempts.
// 1:1 port of src/screens/ProgressDashboard.tsx.

import 'package:flutter/material.dart';

import '../data/lookup.dart';
import '../data/registry.dart';
import '../models/content.dart' as model;
import '../state/nav.dart';
import '../state/progress.dart';
import '../theme/accents.dart';
import '../theme/theme_builder.dart';
import '../theme/utils.dart';
import '../widgets/primitives/card_widget.dart';
import '../widgets/primitives/h1.dart';
import '../widgets/primitives/kicker.dart';
import '../widgets/primitives/pill.dart';
import '../widgets/primitives/track.dart';

class ProgressDashboardScreen extends StatelessWidget {
  final ProgressMap prog;
  final ProgressEntry Function(String vId, String tId) get;
  final int streak;
  final void Function(NavTarget) go;

  const ProgressDashboardScreen({
    super.key,
    required this.prog,
    required this.get,
    required this.streak,
    required this.go,
  });

  List<MapEntry<model.Vertical, model.Topic>> _allTopics() {
    return data.verticals
        .expand((v) => v.topics.map((tp) => MapEntry(v, tp)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final all = _allTopics();
    final certs = all.where((e) => get(e.key.id, e.value.id).certEarned).toList();

    final attempts = <_AttemptWithCtx>[];
    for (final entry in prog.entries.entries) {
      final parts = entry.key.split('.');
      if (parts.length != 2) continue;
      final v = findVertical(parts[0]);
      final topic = findTopic(parts[0], parts[1]);
      for (final a in entry.value.attempts) {
        attempts.add(_AttemptWithCtx(
          attempt: a,
          vertical: v,
          topic: topic,
        ));
      }
    }
    attempts.sort((x, y) => y.attempt.when.compareTo(x.attempt.when));

    final totalUnits = all.fold<int>(0, (s, e) => s + e.value.sections.length + 1);
    final doneUnits = all.fold<int>(0, (s, e) {
      final p = get(e.key.id, e.value.id);
      return s + p.sectionsDone.length + (p.examPassed ? 1 : 0);
    });
    final overall = totalUnits == 0 ? 0 : ((doneUnits / totalUnits) * 100).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Kicker(c: Accents.exam.c, child: const Text('Your learning')),
          const H1(child: Text('Progress')),
          const SizedBox(height: 18),
          _StatsGrid(
            stats: [
              _Stat(icon: Icons.gps_fixed, label: 'Overall', value: '$overall%', accent: Accents.ortho),
              _Stat(icon: Icons.emoji_events_outlined, label: 'Certificates',
                  value: '${certs.length}/${all.length}', accent: const _Accent(greenHex, '#16a34a')),
              _Stat(icon: Icons.assignment_outlined, label: 'Quizzes taken',
                  value: attempts.length, accent: Accents.exam),
              _Stat(icon: Icons.local_fire_department, label: 'Day streak',
                  value: streak, accent: const _Accent('#f59e0b', '#f97316')),
            ],
          ),
          const SizedBox(height: 28),
          Text('Certificates earned',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: t.text)),
          const SizedBox(height: 13),
          if (certs.isEmpty)
            _EmptyText(
                text:
                    "No certificates yet — pass a topic's final exam to earn one."),
          if (certs.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final pair in certs)
                  _CertChip(
                      vertical: pair.key,
                      topic: pair.value,
                      entry: get(pair.key.id, pair.value.id)),
              ],
            ),
          const SizedBox(height: 28),
          Text('Topic progress',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: t.text)),
          const SizedBox(height: 13),
          for (int i = 0; i < all.length; i++) ...[
            if (i > 0) const SizedBox(height: 9),
            _TopicProgressRow(
              pair: all[i],
              entry: get(all[i].key.id, all[i].value.id),
              onTap: () => go(NavLearningPath(all[i].key.id, all[i].value.id)),
            ),
          ],
          const SizedBox(height: 28),
          Text('Recent quiz & exam attempts',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: t.text)),
          const SizedBox(height: 13),
          if (attempts.isEmpty)
            _EmptyText(
                text:
                    'No attempts yet. Your quiz and exam scores will appear here.')
          else
            _AttemptsList(attempts: attempts.take(10).toList()),
        ],
      ),
    );
  }
}

class _Accent {
  final String c;
  final String g;
  const _Accent(this.c, this.g);
}

class _Stat {
  final IconData icon;
  final String label;
  final Object value;
  final Object accent; // Accent or _Accent
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  String _cStr() => accent is Accent ? (accent as Accent).c : (accent as _Accent).c;
  String _gStr() => accent is Accent ? (accent as Accent).g : (accent as _Accent).g;
}

class _StatsGrid extends StatelessWidget {
  final List<_Stat> stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 11,
      crossAxisSpacing: 11,
      childAspectRatio: 1.6,
      children: [
        for (final s in stats)
          CardWidget(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [hexToColor(s._cStr()), hexToColor(s._gStr())],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [hexToColor(s._cStr()), hexToColor(s._gStr())],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: tint(s._cStr(), 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(s.icon, size: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 9),
                          Text(s.label,
                              style: TextStyle(
                                color: t.textDim,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${s.value}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: t.text,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EmptyText extends StatelessWidget {
  final String text;
  const _EmptyText({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      margin: const EdgeInsets.only(bottom: 26),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.surfaceAlt,
        border: Border.all(color: t.borderStrong),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12.5, color: t.textDim),
      ),
    );
  }
}

class _CertChip extends StatelessWidget {
  final model.Vertical vertical;
  final model.Topic topic;
  final ProgressEntry entry;
  const _CertChip({required this.vertical, required this.topic, required this.entry});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: tint(vertical.accent.c, 0.3)),
        borderRadius: BorderRadius.circular(13),
        boxShadow: t.shadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Accent left bar — same pattern as `_AnswerRow` (avoids multi-sided `Border`
            // which silently fails to paint text on a colored surface).
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: hexToColor(vertical.accent.c),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [hexToColor(vertical.accent.c), hexToColor(vertical.accent.g)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.emoji_events, size: 17, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topic.cert,
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: t.text)),
                  Text(
                    '${vertical.label} · ${entry.examBest}%',
                    style: TextStyle(fontSize: 10.5, color: t.textDim),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicProgressRow extends StatelessWidget {
  final MapEntry<model.Vertical, model.Topic> pair;
  final ProgressEntry entry;
  final VoidCallback onTap;
  const _TopicProgressRow({required this.pair, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final pct = topicPct(pair.value, entry);
    return CardWidget(
      hover: true,
      accent: pair.key.accent.c,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
      onClick: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [hexToColor(pair.key.accent.c), hexToColor(pair.key.accent.g)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              pair.key.label[0],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${pair.key.label} › ${pair.value.label}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.text),
                    ),
                    Text(
                      '${entry.sectionsDone.length}/${pair.value.sections.length} sections'
                      '${entry.examPassed ? ' · exam ✓' : ''}',
                      style: TextStyle(fontSize: 11.5, color: t.textDim),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Track(
                  pct: pct.toDouble(),
                  accent: pair.key.accent.c,
                  gradient: pct > 0 ? gradCss(pair.key.accent) : null,
                  h: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 42,
            child: Text(
              '$pct%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: hexToColor(pair.key.accent.c),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttemptsList extends StatelessWidget {
  final List<_AttemptWithCtx> attempts;
  const _AttemptsList({required this.attempts});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return CardWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < attempts.length; i++)
            Container(
              decoration: BoxDecoration(
                border: i == 0 ? null : Border(top: BorderSide(color: t.border)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: attempts[i].attempt.pass ? greenColor : redColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: tint(
                            attempts[i].attempt.pass ? greenHex : redHex,
                            0.18,
                          ),
                          blurRadius: 0,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 12.5, color: t.textMid),
                        children: [
                          TextSpan(
                            text: '${attempts[i].vertical?.label ?? '?'} › ${attempts[i].topic?.label ?? '?'}',
                            style: TextStyle(color: t.text, fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: ' · ${attempts[i].attempt.label}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Pill(
                    c: attempts[i].attempt.pass ? greenHex : redHex,
                    child: Text('${attempts[i].attempt.score}%'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AttemptWithCtx {
  final Attempt attempt;
  final model.Vertical? vertical;
  final model.Topic? topic;
  _AttemptWithCtx({required this.attempt, required this.vertical, required this.topic});
}