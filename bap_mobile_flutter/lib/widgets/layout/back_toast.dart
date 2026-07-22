// lib/widgets/layout/back_toast.dart — "Back again to exit" snackbar.
// 1:1 port of src/components/layout/BackToast.tsx.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';

class BackToast extends StatefulWidget {
  final bool show;
  final VoidCallback onHide;
  final Duration duration;

  const BackToast({
    super.key,
    required this.show,
    required this.onHide,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<BackToast> createState() => _BackToastState();
}

class _BackToastState extends State<BackToast> {
  Timer? _timer;

  @override
  void didUpdateWidget(covariant BackToast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _timer?.cancel();
      _timer = Timer(widget.duration, widget.onHide);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();
    final t = context.t;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 90,
      child: IgnorePointer(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            builder: (context, v, child) {
              return Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(0, (1 - v) * 10),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: t.name == 'dark'
                    ? const Color(0xFF2a3142)
                    : const Color(0xFF1f2937),
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 28,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Text(
                'Back again to exit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}