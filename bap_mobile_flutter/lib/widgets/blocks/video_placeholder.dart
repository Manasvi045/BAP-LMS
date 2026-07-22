// lib/widgets/blocks/video_placeholder.dart — consistent placeholder for a future
// video clip (anatomy walkthrough, surgical technique, implant explanation, etc.).
//
// Carries title, short description, optional thumbnail, optional future URL, and
// optional duration. Until the real URL is plugged in the component renders a
// labelled card so the layout and behaviour are ready to ship.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';
import '../../theme/themes.dart';
import '../../theme/utils.dart';

class VideoPlaceholder extends StatelessWidget {
  final String title;
  final String description;
  final String? thumbnailSrc;
  final String? futureUrl;
  final String? duration;
  final String accent;

  const VideoPlaceholder({
    super.key,
    required this.title,
    required this.description,
    required this.accent,
    this.thumbnailSrc,
    this.futureUrl,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accentColor = hexToColor(accent);
    final isWired = futureUrl != null && futureUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(14),
        boxShadow: t.shadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Video stage (16:9). Shows thumbnail when supplied; otherwise renders
          // a tasteful dark gradient with a play glyph and a "Video placeholder"
          // label so it's obvious this is where the clip will live.
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (thumbnailSrc != null && thumbnailSrc!.isNotEmpty)
                  Image(
                    image: _resolveImage(thumbnailSrc!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _stage(t, accentColor),
                  )
                else
                  _stage(t, accentColor),
                // Subtle vignette so the play glyph always reads on top.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.85,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.35),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.movie_outlined,
                          size: 11,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration ?? '—',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isWired ? Icons.link : Icons.schedule_outlined,
                          size: 11,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isWired ? 'URL ready' : 'Video placeholder',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tint(accent, 0.14),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.ondemand_video_outlined,
                            size: 11,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'VIDEO',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: t.textMid,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: t.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: t.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isWired
                            ? Icons.check_circle_outline
                            : Icons.info_outline,
                        size: 14,
                        color: isWired ? accentColor : t.textDim,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          isWired
                              ? 'Video URL set — wire to player when ready.'
                              : 'Future video URL will be plugged in here.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: t.textDim,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  Widget _stage(AppTheme t, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF11151f),
            tint(accent, 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  ImageProvider _resolveImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }
}