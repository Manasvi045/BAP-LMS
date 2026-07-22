// lib/widgets/layout/nav_tab.dart — one tab in the BottomNav.
// 1:1 port of src/components/layout/NavTab.tsx.

import 'package:flutter/material.dart';

import '../../theme/accents.dart';
import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class NavTab extends StatelessWidget {
  final bool active;
  final VoidCallback onClick;
  final IconData icon;
  final String label;
  final bool highlight;

  const NavTab({
    super.key,
    required this.active,
    required this.onClick,
    required this.icon,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final c = active ? Accents.exam.color : t.textDim;
    final fg = active ? Colors.white : c;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (highlight)
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: active ? gradLinear(Accents.exam) : null,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: tint(Accents.exam.c, 0.45),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(icon, size: 20, color: fg),
                    ),
                  )
                else
                  Icon(icon, size: 21, color: c),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    color: c,
                    fontSize: 10.5,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}