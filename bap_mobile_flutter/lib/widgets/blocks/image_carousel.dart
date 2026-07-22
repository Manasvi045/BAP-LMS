// lib/widgets/blocks/image_carousel.dart — Instagram-style swipeable image carousel.
//
// Renders a group of related images as a single interactive unit. Each slide has
// a placeholder until a real image is wired in — the layout, dots and captions
// all work without real assets so the carousel is "ready" the moment content
// is dropped in.

import 'package:flutter/material.dart';

import '../../models/content.dart';
import '../../theme/theme_builder.dart';
import '../../theme/themes.dart';
import '../../theme/utils.dart';

class ImageCarousel extends StatefulWidget {
  final List<CarouselSlide> slides;
  final String accent;

  const ImageCarousel({
    super.key,
    required this.slides,
    required this.accent,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.86);
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accentColor = hexToColor(widget.accent);
    final slides = widget.slides;

    if (slides.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: t.surfaceAlt,
          border: Border.all(color: t.border),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          'No images added yet.',
          style: TextStyle(fontSize: 13, color: t.textDim),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: slides.length,
            itemBuilder: (context, i) {
              final s = slides[i];
              return AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  // The focused card is the same width as neighbours; we just
                  // visually nudge scale via the AspectRatio framing.
                ),
                child: _CarouselSlideView(
                  slide: s,
                  index: i,
                  accent: accentColor,
                  isActive: i == _index,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Pagination dots.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < slides.length; i++)
              GestureDetector(
                onTap: () => _controller.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _index ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _index
                        ? accentColor
                        : tint(widget.accent, 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        // Caption for the active slide.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Container(
            key: ValueKey(_index),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: t.surfaceAlt,
              border: Border.all(color: t.border),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: tint(widget.accent, 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${_index + 1} / ${slides.length}',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    if (slides[_index].credit != null) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          slides[_index].credit!,
                          style: TextStyle(fontSize: 10.5, color: t.textDim),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  slides[_index].caption,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: t.textMid,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CarouselSlideView extends StatelessWidget {
  final CarouselSlide slide;
  final int index;
  final Color accent;
  final bool isActive;

  const _CarouselSlideView({
    required this.slide,
    required this.index,
    required this.accent,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(
          color: isActive ? tint('#${_hex(accent)}', 0.55) : t.border,
          width: isActive ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: isActive ? t.shadowHover : t.shadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: _buildSlideBody(t),
    );
  }

  Widget _buildSlideBody(AppTheme t) {
    if (slide.src != null && slide.src!.isNotEmpty) {
      // Real asset path provided — defer to Image. Network or asset URLs both
      // work because Image accepts the resolved path string.
      // BoxFit.contain preserves the full image (no cropping of anatomical
      // labels or diagrams) and keeps the original aspect ratio; the soft
      // surface fill behind it keeps the card looking clean when the image
      // aspect ratio does not match the container.
      return Container(
        color: tint('#${_hex(accent)}', 0.06),
        alignment: Alignment.center,
        child: Image(
          image: _resolveImage(slide.src!),
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _placeholderBody(t),
        ),
      );
    }
    return _placeholderBody(t);
  }

  Widget _placeholderBody(AppTheme t) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tint('#${_hex(accent)}', 0.18),
            tint('#${_hex(accent)}', 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Subtle grid to read as "diagram placeholder".
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter(color: t.border)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: tint('#${_hex(accent)}', 0.15),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: tint('#${_hex(accent)}', 0.45),
                    ),
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    size: 22,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Image ${index + 1}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Asset to be added',
                  style: TextStyle(fontSize: 10.5, color: t.textDim),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Accept either an asset:// path or a network URL.
  ImageProvider _resolveImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  String _hex(Color c) {
    final r = (c.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (c.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (c.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '$r$g$b';
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    const step = 22.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.color != color;
}