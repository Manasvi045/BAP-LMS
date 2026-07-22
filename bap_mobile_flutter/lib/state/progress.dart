// lib/state/progress.dart — the app's only stateful progress tracker.
// 1:1 port of src/hooks/useProgress.ts, plus persistence via shared_preferences.
//
// The shape matches the prototype's `useProgress` exactly so the data model
// stays 1:1 with what the screens and dashboard expect. Persistence is the
// one addition — Phase 5 work item in the React codebase is delivered now.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/lookup.dart';

/// One quiz / exam / section attempt.
@immutable
class Attempt {
  final String label;
  final int score;
  final bool pass;
  final int when;
  const Attempt({required this.label, required this.score, required this.pass, required this.when});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'label': label, 'score': score, 'pass': pass, 'when': when};
  static Attempt fromJson(Map<String, dynamic> j) =>
      Attempt(label: j['label'] as String, score: j['score'] as int, pass: j['pass'] as bool, when: j['when'] as int);
}

/// Per-topic progress entry.
@immutable
class ProgressEntry {
  final List<String> sectionsDone;
  final List<Attempt> attempts;
  final bool examPassed;
  final int examBest;
  final bool certEarned;

  const ProgressEntry({
    required this.sectionsDone,
    required this.attempts,
    this.examPassed = false,
    this.examBest = 0,
    this.certEarned = false,
  });

  ProgressEntry copyWith({
    List<String>? sectionsDone,
    List<Attempt>? attempts,
    bool? examPassed,
    int? examBest,
    bool? certEarned,
  }) =>
      ProgressEntry(
        sectionsDone: sectionsDone ?? this.sectionsDone,
        attempts: attempts ?? this.attempts,
        examPassed: examPassed ?? this.examPassed,
        examBest: examBest ?? this.examBest,
        certEarned: certEarned ?? this.certEarned,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sectionsDone': sectionsDone,
        'attempts': attempts.map((a) => a.toJson()).toList(),
        'examPassed': examPassed,
        'examBest': examBest,
        'certEarned': certEarned,
      };
  static ProgressEntry fromJson(Map<String, dynamic> j) => ProgressEntry(
        sectionsDone: (j['sectionsDone'] as List).map((e) => e as String).toList(),
        attempts: (j['attempts'] as List).map((e) => Attempt.fromJson(e as Map<String, dynamic>)).toList(),
        examPassed: j['examPassed'] as bool? ?? false,
        examBest: j['examBest'] as int? ?? 0,
        certEarned: j['certEarned'] as bool? ?? false,
      );

  static const ProgressEntry empty = ProgressEntry(sectionsDone: <String>[], attempts: <Attempt>[]);
}

/// Map from `vId.tId` → ProgressEntry.
@immutable
class ProgressMap {
  final Map<String, ProgressEntry> entries;
  const ProgressMap(this.entries);

  factory ProgressMap.fromJson(Map<String, dynamic> j) => ProgressMap(
        j.map((k, v) => MapEntry(k, ProgressEntry.fromJson(v as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() =>
      entries.map((k, v) => MapEntry(k, v.toJson()));
}

const String _storageKey = 'bap.progress.v1';
const int defaultStreak = 4;

/// Pure-Dart ProgressNotifier — UI-agnostic. The notifier owns the state map
/// and exposes `recordSection`, `recordExam`, and `get`. Persistence is
/// optional and decoupled — a thin `ProgressStore` wrapper handles the
/// `SharedPreferences` round-trip.
class ProgressNotifier extends ChangeNotifier {
  ProgressMap _prog = const ProgressMap(<String, ProgressEntry>{});
  ProgressMap get prog => _prog;

  final int streak;
  final ProgressStore? store;

  ProgressNotifier({this.streak = defaultStreak, this.store}) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    final s = store;
    if (s == null) return;
    final loaded = await s.load();
    if (loaded != null) {
      _prog = loaded;
      notifyListeners();
    }
  }

  ProgressEntry get(String vId, String tId) =>
      _prog.entries[topicKey(vId, tId)] ?? ProgressEntry.empty;

  Future<void> recordSection(String vId, String tId, String sectionId, int score, bool pass) async {
    final k = topicKey(vId, tId);
    final cur = _prog.entries[k] ?? ProgressEntry.empty;
    final sectionsDone = (pass && !cur.sectionsDone.contains(sectionId))
        ? <String>[...cur.sectionsDone, sectionId]
        : cur.sectionsDone;
    final updated = Map<String, ProgressEntry>.from(_prog.entries);
    updated[k] = cur.copyWith(
      sectionsDone: sectionsDone,
      attempts: <Attempt>[
        ...cur.attempts,
        Attempt(label: secTitle(vId, tId, sectionId), score: score, pass: pass, when: DateTime.now().millisecondsSinceEpoch),
      ],
    );
    _prog = ProgressMap(updated);
    notifyListeners();
    await store?.save(_prog);
  }

  Future<void> recordExam(String vId, String tId, int score, bool pass) async {
    final k = topicKey(vId, tId);
    final cur = _prog.entries[k] ?? ProgressEntry.empty;
    final updated = Map<String, ProgressEntry>.from(_prog.entries);
    updated[k] = cur.copyWith(
      examPassed: cur.examPassed || pass,
      examBest: cur.examBest > score ? cur.examBest : score,
      certEarned: cur.certEarned || pass,
      attempts: <Attempt>[
        ...cur.attempts,
        Attempt(label: 'Final exam', score: score, pass: pass, when: DateTime.now().millisecondsSinceEpoch),
      ],
    );
    _prog = ProgressMap(updated);
    notifyListeners();
    await store?.save(_prog);
  }
}

/// Thin SharedPreferences wrapper. The notifier calls `load()` on hydrate and
/// `save()` after each mutation. The storage layer is decoupled so tests can
/// inject an in-memory store without a binding.
abstract class ProgressStore {
  Future<ProgressMap?> load();
  Future<void> save(ProgressMap map);
}

class SharedPrefsProgressStore implements ProgressStore {
  @override
  Future<ProgressMap?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      return ProgressMap.fromJson(j);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(ProgressMap map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(map.toJson()));
  }
}

/// Topic completion % — sections done + exam pass over (sections + final exam).
int topicPct(dynamic topic, ProgressEntry p) {
  final n = (topic.sections as List).length;
  final done = p.sectionsDone.length + (p.examPassed ? 1 : 0);
  return ((done / (n + 1)) * 100).round();
}