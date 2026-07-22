// Smoke tests for ProgressNotifier + SharedPrefsProgressStore.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bap_mobile/state/progress.dart';

class _InMemoryStore implements ProgressStore {
  ProgressMap? _map;
  @override
  Future<ProgressMap?> load() async => _map;
  @override
  Future<void> save(ProgressMap map) async {
    _map = map;
  }
}

void main() {
  test('recordSection persists across notifier restarts', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final store = _InMemoryStore();
    final n1 = ProgressNotifier(store: store);
    await n1.recordSection('endo', 'sutures', 'anatomy', 90, true);
    expect(n1.get('endo', 'sutures').sectionsDone, contains('anatomy'));
    // Simulate app restart: fresh notifier, same store.
    final n2 = ProgressNotifier(store: store);
    // ProgressNotifier hydrates async; give the future a tick.
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(n2.get('endo', 'sutures').sectionsDone, contains('anatomy'));
  });

  test('recordExam updates examPassed, examBest, and certEarned', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final n = ProgressNotifier(store: _InMemoryStore());
    await n.recordExam('endo', 'sutures', 75, true);
    final e = n.get('endo', 'sutures');
    expect(e.examPassed, true);
    expect(e.examBest, 75);
    expect(e.certEarned, true);

    // A lower pass shouldn't lower examBest.
    await n.recordExam('endo', 'sutures', 60, true);
    expect(n.get('endo', 'sutures').examBest, 75);
  });

  test('recordSection only adds the section on pass', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final n = ProgressNotifier(store: _InMemoryStore());
    await n.recordSection('endo', 'sutures', 'anatomy', 40, false);
    expect(n.get('endo', 'sutures').sectionsDone, isNot(contains('anatomy')));
    // But the attempt is still recorded (for the dashboard).
    expect(n.get('endo', 'sutures').attempts.length, 1);
  });
}