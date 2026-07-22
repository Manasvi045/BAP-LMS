// lib/widgets/layout/bottom_nav.dart — the 3-tab bottom navigation.
// 1:1 port of src/components/layout/BottomNav.tsx.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';
import 'nav_tab.dart';

class BottomNav extends StatelessWidget {
  final bool onLearn;
  final bool isAssistant;
  final bool isProgress;
  final VoidCallback onLearnClick;
  final VoidCallback onAssistantClick;
  final VoidCallback onProgressClick;

  const BottomNav({
    super.key,
    required this.onLearn,
    required this.isAssistant,
    required this.isProgress,
    required this.onLearnClick,
    required this.onAssistantClick,
    required this.onProgressClick,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: t.navBar,
            border: Border(top: BorderSide(color: t.border)),
          ),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: Row(
            children: [
              NavTab(
                active: onLearn,
                onClick: onLearnClick,
                icon: Icons.home_outlined,
                label: 'Learn',
              ),
              NavTab(
                active: isAssistant,
                onClick: onAssistantClick,
                icon: Icons.chat_bubble_outline,
                label: 'Assistant',
                highlight: true,
              ),
              NavTab(
                active: isProgress,
                onClick: onProgressClick,
                icon: Icons.bar_chart,
                label: 'Progress',
              ),
            ],
          ),
        ),
      ),
    );
  }
}