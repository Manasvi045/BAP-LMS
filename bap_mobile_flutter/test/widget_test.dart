// Smoke test — boots BapApp and verifies the shell renders without throwing.
// More thorough tests land in later phases; this is the "does it even compile
// and render?" gate.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bap_mobile/app.dart';

void main() {
  testWidgets('BapApp renders without throwing', (WidgetTester tester) async {
    // SharedPreferences in tests uses an in-memory backing store.
    SharedPreferences.setMockInitialValues(<String, Object>{});

    // Phone-frame viewport — matches the ConstrainedBox(maxWidth: 440) the
    // shell applies, but taller than the default 600 so the vertical-select
    // column fits without overflowing.
    tester.view.physicalSize = const Size(440 * 2, 900 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const BapApp());
    // Pump a couple of frames so the async key-probe and progress-hydrate
    // settle into a stable build.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // App shell renders.
    expect(find.text('BAP'), findsOneWidget);
  });
}