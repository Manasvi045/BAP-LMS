// lib/admin/admin_placeholder_screens.dart
// ============================================================================
// Placeholder for the Activity tab. The other tabs (Dashboard, Users,
// Content, Profile) have full screens wired in.
//
// Activity is reachable from the drawer but not the bottom nav. The
// backend doesn't yet expose an events feed endpoint, so the screen
// stays as a friendly "coming soon" placeholder.
// ============================================================================

import 'package:flutter/material.dart';

import '../theme/theme_builder.dart';

class AdminActivityPlaceholder extends StatelessWidget {
  const AdminActivityPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.t.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.t.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: context.t.surfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.t.border),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.history,
                          size: 22,
                          color: context.t.textMid,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Activity',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: context.t.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Audit-style feed of recent events',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.t.textMid,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: context.t.border,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A timeline of recent user and content events lands '
                    'here once the backend exposes an audit-feed endpoint. '
                    'For now, user and content changes are visible '
                    'immediately in their respective tabs.',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.t.textDim,
                      height: 1.55,
                    ),
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
