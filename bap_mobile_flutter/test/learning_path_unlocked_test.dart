// test/learning_path_unlocked_test.dart — regression guard for module unlocking.
//
// These tests pin down the post-removal behavior of LearningPathScreen:
//   * Every section renders a Start CTA, regardless of completion state.
//   * The final exam renders a Take exam CTA on a fresh topic.
//   * No "Locked" / "Up next" text or padlock icon appears anywhere.
//   * The "Done" pill still appears for completed sections.
//   * The Take exam CTA flips to a Retake CTA after the exam is passed.
//
// If a future change reintroduces sequential locking, one of these assertions
// will fail and point at the exact contract that was broken.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bap_mobile/data/registry.dart';
import 'package:bap_mobile/screens/learning_path.dart';
import 'package:bap_mobile/state/progress.dart';
import 'package:bap_mobile/theme/theme_builder.dart';
import 'package:bap_mobile/theme/themes.dart';

void main() {
  // The TKR topic has 6 sections + a final exam — same shape as the
  // screenshots in the spec.
  final topic = data.verticals
      .firstWhere((v) => v.id == 'ortho')
      .topics
      .firstWhere((t) => t.id == 'tkr');

  Widget mountLearningPath({
    ProgressEntry entry = const ProgressEntry(
      sectionsDone: <String>[],
      attempts: <Attempt>[],
    ),
  }) {
    return MaterialApp(
      theme: buildThemeData(lightTheme),
      home: LearningPathScreen(
        vId: 'ortho',
        tId: 'tkr',
        back: () {},
        get: (_, __) => entry,
        recordSection: (_, __, ___) async {},
        recordExam: (_, __) async {},
      ),
    );
  }

  testWidgets('every section renders a Start CTA on a fresh topic', (tester) async {
    tester.view.physicalSize = const Size(440 * 2, 1200 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(mountLearningPath());
    await tester.pump();

    // One "Start" CTA per section. No "Locked" / "Up next" text rendered.
    expect(find.text('Start'), findsNWidgets(topic.sections.length),
        reason: 'every not-done section must show a Start button');
    expect(find.text('Take exam'), findsOneWidget,
        reason: 'final exam must show a Take exam CTA on a fresh topic');
    expect(find.text('Locked'), findsNothing);
    expect(find.text('Up next'), findsNothing);
    expect(find.byIcon(Icons.lock_outline), findsNothing);
  });

  testWidgets('done sections show a Review CTA and a Done pill', (tester) async {
    tester.view.physicalSize = const Size(440 * 2, 1200 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final doneEntry = ProgressEntry(
      sectionsDone: topic.sections.map((s) => s.id).toList(),
      attempts: const <Attempt>[],
    );

    await tester.pumpWidget(mountLearningPath(entry: doneEntry));
    await tester.pump();

    expect(find.text('Review'), findsNWidgets(topic.sections.length),
        reason: 'every done section must show a Review button');
    expect(find.text('Done'), findsNWidgets(topic.sections.length),
        reason: 'every done section must show a Done pill');
    expect(find.text('Start'), findsNothing);
    expect(find.text('Locked'), findsNothing);
    expect(find.text('Up next'), findsNothing);
  });

  testWidgets('after passing the exam, the exam CTA flips to Retake',
      (tester) async {
    tester.view.physicalSize = const Size(440 * 2, 1200 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final passedEntry = const ProgressEntry(
      sectionsDone: <String>[],
      attempts: <Attempt>[],
      examPassed: true,
      examBest: 92,
      certEarned: true,
    );

    await tester.pumpWidget(mountLearningPath(entry: passedEntry));
    await tester.pump();

    expect(find.text('Retake'), findsOneWidget);
    expect(find.textContaining('Passed 92%'), findsOneWidget);
    expect(find.text('Take exam'), findsNothing);
  });
}