// lib/widgets/primitives/card_widget.dart — the app's surface container.
// 1:1 port of src/components/primitives/Card.tsx.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class CardWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onClick;
  final bool hover;
  final String? accent;
  final EdgeInsetsGeometry? padding;
  final Color? background;
  final double radius;

  const CardWidget({
    super.key,
    required this.child,
    this.onClick,
    this.hover = false,
    this.accent,
    this.padding,
    this.background,
    this.radius = 18,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isHover = widget.hover && _hovered;
    final borderColor = isHover
        ? (widget.accent != null
            ? tint(widget.accent!, 0.45)
            : t.borderStrong)
        : t.border;
    final shadows = isHover ? t.shadowHover : t.shadow;

    final inner = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.background ?? t.surface,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: shadows,
      ),
      child: widget.child,
    );

    return MouseRegion(
      onEnter: (_) {
        if (widget.hover) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (widget.hover) setState(() => _hovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        transform: isHover ? (Matrix4.translationValues(0, -3, 0)) : Matrix4.identity(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.radius),
            onTap: widget.onClick,
            child: inner,
          ),
        ),
      ),
    );
  }
}