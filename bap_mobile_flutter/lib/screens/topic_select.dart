// lib/screens/topic_select.dart — the topics within a vertical.
// 1:1 port of src/screens/TopicSelect.tsx.

import 'package:flutter/material.dart';

import '../data/lookup.dart';
import '../models/content.dart' as model;
import '../state/nav.dart';
import '../state/progress.dart';
import '../theme/accents.dart';
import '../theme/theme_builder.dart';
import '../theme/utils.dart';
import '../widgets/icon_registry.dart';
import '../widgets/primitives/back_link.dart';
import '../widgets/primitives/card_widget.dart';
import '../widgets/primitives/centered.dart';
import '../widgets/primitives/h1.dart';
import '../widgets/primitives/kicker.dart';
import '../widgets/primitives/track.dart';

class TopicSelectScreen extends StatelessWidget {
  final String vId;
  final VoidCallback back;
  final ProgressEntry Function(String vId, String tId) get;
  final void Function(NavTarget) go;
  const TopicSelectScreen({
    super.key,
    required this.vId,
    required this.back,
    required this.get,
    required this.go,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final v = findVertical(vId);
    if (v == null) return const SizedBox.shrink();
    final vIcon = iconFor(v.icon);

    return Centered(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          BackLink(onClick: back, child: const Text('All verticals')),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [hexToColor(v.accent.c), hexToColor(v.accent.g)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(vIcon, size: 19, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Kicker(c: v.accent.c, child: Text(v.label)),
              ],
            ),
          ),
          const H1(child: Text('Choose a topic')),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Text(
              'Each topic is a guided path of sections and a final exam. Jump in anywhere — your progress is saved as you go.',
              style: TextStyle(fontSize: 14.5, color: t.textMid),
            ),
          ),
          for (int i = 0; i < v.topics.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _TopicCard(
              v: v,
              topic: v.topics[i],
              entry: get(v.id, v.topics[i].id),
              onTap: () => go(NavLearningPath(v.id, v.topics[i].id)),
            ),
          ],
        ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final model.Vertical v;
  final model.Topic topic;
  final ProgressEntry entry;
  final VoidCallback onTap;

  const _TopicCard({
    required this.v,
    required this.topic,
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final icon = iconFor(topic.icon);
    final pct = topicPct(topic, entry);
    return CardWidget(
      hover: true,
      accent: v.accent.c,
      padding: const EdgeInsets.all(22),
      onClick: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [hexToColor(v.accent.c), hexToColor(v.accent.g)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: tint(v.accent.c, 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 22, color: Colors.white),
              ),
              if (entry.certEarned)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tint(greenHex, 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.emoji_events_outlined, size: 17, color: hexToColor(greenHex)),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            topic.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.text),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Text(
              '${topic.sections.length} sections + final exam',
              style: TextStyle(fontSize: 11.5, color: t.textDim),
            ),
          ),
          Track(
            pct: pct.toDouble(),
            accent: v.accent.c,
            gradient: pct > 0 ? gradCss(v.accent) : null,
            h: 6,
          ),
          const SizedBox(height: 7),
          Text(
            '$pct% complete',
            style: TextStyle(fontSize: 11.5, color: t.textMid, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}