// lib/widgets/blocks/page_view.dart — renders a single Page (any kind) inside SectionPlayer.
// 1:1 port of src/components/blocks/PageView.tsx.
//
// The `switch (cur)` uses Dart's exhaustiveness on the sealed Page union —
// adding a new page kind is a compile error here until it's handled.

import 'package:flutter/material.dart';

import '../../models/content.dart' as model show Page, ReadPage, TablePage, CardsPage, DecisionPage, AnatomyPage, VideoPage, CarouselPage, VideoPlaceholderPage;
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';
import '../primitives/btn.dart';
import '../primitives/card_widget.dart';
import 'anatomy_stack.dart';
import 'card_grid.dart';
import 'data_table.dart' as dt;
import 'decision_list.dart';
import 'image_carousel.dart';
import 'video_placeholder.dart';

class PageView extends StatelessWidget {
  final model.Page cur;
  final String accent;
  final bool videoWatched;
  final ValueChanged<bool> setVideoWatched;
  final int page;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final bool onLast;
  final bool canAdvance;
  final VoidCallback onGoQuiz;

  const PageView({
    super.key,
    required this.cur,
    required this.accent,
    required this.videoWatched,
    required this.setVideoWatched,
    required this.page,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
    required this.onLast,
    required this.canAdvance,
    required this.onGoQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Page-position dots.
        Row(
          children: [
            for (int i = 0; i < totalPages; i++)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5,
                  margin: EdgeInsets.only(right: i < totalPages - 1 ? 5 : 0),
                  decoration: BoxDecoration(
                    color: i < page
                        ? hexToColor(accent)
                        : i == page
                            ? tint(accent, 0.5)
                            : t.track,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        CardWidget(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          child: SizedBox(
            // Pin min height for visual consistency across kinds.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cur.heading,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 14),
                _PageBody(
                  page: cur,
                  accent: accent,
                  videoWatched: videoWatched,
                  setVideoWatched: setVideoWatched,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Btn(
                variant: BtnVariant.ghost,
                disabled: page == 0,
                onClick: onPrev,
                full: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_back, size: 14),
                    SizedBox(width: 6),
                    Text('Previous'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Btn(
                accent: accent,
                disabled: !canAdvance,
                onClick: onLast ? onGoQuiz : onNext,
                full: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(onLast ? 'Go to quiz' : 'Next'),
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

class _PageBody extends StatelessWidget {
  final model.Page page;
  final String accent;
  final bool videoWatched;
  final ValueChanged<bool> setVideoWatched;

  const _PageBody({
    required this.page,
    required this.accent,
    required this.videoWatched,
    required this.setVideoWatched,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final p = page;
    switch (p) {
      case model.ReadPage():
        return Text(
          p.body,
          style: TextStyle(
            fontSize: 14.5,
            color: t.textMid,
            height: 1.8,
          ),
        );
      case model.TablePage():
        return dt.DataTable(
          columns: p.columns,
          rows: p.rows,
          accent: accent,
        );
      case model.CardsPage():
        return CardGrid(items: p.items, accent: accent);
      case model.DecisionPage():
        return DecisionList(nodes: p.nodes, accent: accent);
      case model.AnatomyPage():
        return AnatomyStack(layers: p.layers);
      case model.CarouselPage():
        return ImageCarousel(slides: p.slides, accent: accent);
      case model.VideoPlaceholderPage():
        return VideoPlaceholder(
          title: p.title,
          description: p.description,
          thumbnailSrc: p.thumbnailSrc,
          futureUrl: p.futureUrl,
          duration: p.duration,
          accent: accent,
        );
      case model.VideoPage():
        return _VideoBlock(
          page: p,
          accent: accent,
          videoWatched: videoWatched,
          setVideoWatched: setVideoWatched,
        );
    }
  }
}

class _VideoBlock extends StatelessWidget {
  final model.VideoPage page;
  final String accent;
  final bool videoWatched;
  final ValueChanged<bool> setVideoWatched;

  const _VideoBlock({
    required this.page,
    required this.accent,
    required this.videoWatched,
    required this.setVideoWatched,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Base gradient backdrop.
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF11151f), Color(0xFF1a1424)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Radial accent overlay.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.7,
                    colors: [
                      tint(accent, 0.35),
                      tint(accent, 0),
                    ],
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 56,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 14,
                child: Text(
                  page.duration,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (videoWatched)
                Positioned(
                  top: 12,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check, size: 13, color: Color(0xFF86efac)),
                        SizedBox(width: 4),
                        Text(
                          'Watched',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF86efac),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          page.body,
          style: TextStyle(
            fontSize: 13.5,
            color: t.textMid,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        if (!videoWatched)
          Btn(
            variant: BtnVariant.dark,
            onClick: () => setVideoWatched(true),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check, size: 14, color: Colors.white),
                SizedBox(width: 6),
                Text('Mark video as watched'),
              ],
            ),
          ),
        if (!videoWatched)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Finish the video to continue.',
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFFf97316),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}