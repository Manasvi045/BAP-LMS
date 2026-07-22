// lib/widgets/primitives/btn.dart — the app's primary button.
// 1:1 port of src/components/primitives/Btn.tsx.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

/// Build a LinearGradient from a CSS-style "linear-gradient(135deg, #a, #b)" string.
LinearGradient _gradFromCss(String css) {
  final inner = css.substring(css.indexOf('(') + 1, css.lastIndexOf(')'));
  final parts = inner.split(',').map((s) => s.trim()).toList();
  final stops = parts.where((p) => !p.endsWith('deg')).toList();
  if (stops.length < 2) {
    return const LinearGradient(colors: [Colors.white, Colors.white]);
  }
  return LinearGradient(
    colors: [hexToColor(stops[0]), hexToColor(stops[1])],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

enum BtnVariant { primary, ghost, dark }

class Btn extends StatefulWidget {
  final Widget child;
  final VoidCallback? onClick;
  final bool disabled;
  final String accent;
  final String? gradient;
  final BtnVariant variant;
  final bool full;
  final String? ariaLabel;

  const Btn({
    super.key,
    required this.child,
    this.onClick,
    this.disabled = false,
    this.accent = '#3b82f6',
    this.gradient,
    this.variant = BtnVariant.primary,
    this.full = false,
    this.ariaLabel,
  });

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final base = BoxDecoration(
      gradient: widget.variant == BtnVariant.primary && widget.gradient != null
          ? _gradFromCss(widget.gradient!)
          : null,
      color: widget.variant == BtnVariant.primary
          ? null
          : widget.variant == BtnVariant.ghost
              ? t.surface
              : (t.name == 'dark' ? const Color(0xFF2a3142) : const Color(0xFF1a1d24)),
      borderRadius: BorderRadius.circular(11),
      border: widget.variant == BtnVariant.ghost
          ? Border.all(color: t.border)
          : Border.all(color: Colors.transparent),
      boxShadow: widget.disabled || widget.variant != BtnVariant.primary
          ? null
          : [
              BoxShadow(
                color: tint(widget.accent, 0.4),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
    );
    final fg = widget.variant == BtnVariant.primary
        ? Colors.white
        : widget.variant == BtnVariant.ghost
            ? t.textMid
            : Colors.white;

    final bgColor = widget.variant == BtnVariant.primary && widget.gradient == null
        ? hexToColor(widget.accent)
        : null;

    return Opacity(
      opacity: widget.disabled ? 0.45 : 1,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(0, _hovered && !widget.disabled && widget.variant == BtnVariant.primary ? -1 : 0, 0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(11),
              onTap: widget.disabled ? null : widget.onClick,
              child: Container(
                width: widget.full ? double.infinity : null,
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                decoration: base.copyWith(color: bgColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: widget.full ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        color: fg,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}