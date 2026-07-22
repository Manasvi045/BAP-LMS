// lib/state/nav.dart — sealed NavTarget + NavController state notifier.
// 1:1 port of src/App.tsx + src/hooks/useBackHandler.ts.
//
// NavTarget drives which screen renders. Five screens: verticals, topics, path,
// assistant, progress. The bottom-nav maps to 3 high-level destinations (Learn
// covers the first three; Assistant; Progress).
//
// Back-stack rules:
//   - Forward navigation into a non-root screen pushes the previous onto the
//     stack.
//   - Forward navigation into a root screen clears the stack (tab switch).
//   - Back pops the stack; if empty and we're at verticals root, the first
//     press shows a toast, the second within 2 s triggers `exitApp()`.

import 'package:flutter/foundation.dart';

/// Screen identifiers — the 5 destinations the app can render.
enum NavScreen { verticals, topics, path, assistant, progress }

/// Sealed NavTarget union. 1:1 with the React NavTarget discriminated union.
@immutable
sealed class NavTarget {
  NavScreen get screen;
  const NavTarget();
}

@immutable
class NavVerticalSelect extends NavTarget {
  @override
  NavScreen get screen => NavScreen.verticals;
  const NavVerticalSelect();
}

@immutable
class NavTopicSelect extends NavTarget {
  @override
  NavScreen get screen => NavScreen.topics;
  final String vId;
  const NavTopicSelect(this.vId);
}

@immutable
class NavLearningPath extends NavTarget {
  @override
  NavScreen get screen => NavScreen.path;
  final String vId;
  final String tId;
  const NavLearningPath(this.vId, this.tId);
}

@immutable
class NavAssistant extends NavTarget {
  @override
  NavScreen get screen => NavScreen.assistant;
  const NavAssistant();
}

@immutable
class NavProgress extends NavTarget {
  @override
  NavScreen get screen => NavScreen.progress;
  const NavProgress();
}

/// Root screen ids — back-stack resets on tab switch.
const Set<NavScreen> _rootScreens = {
  NavScreen.verticals,
  NavScreen.assistant,
  NavScreen.progress,
};

/// What `back()` should do, mirroring React's `BackAction` discriminated union.
@immutable
sealed class BackAction {
  const BackAction();
}

@immutable
class BackPop extends BackAction {
  final NavTarget target;
  const BackPop(this.target);
}

@immutable
class BackExit extends BackAction {
  const BackExit();
}

@immutable
class BackShowToast extends BackAction {
  const BackShowToast();
}

@immutable
class BackNavigateVerticals extends BackAction {
  const BackNavigateVerticals();
}

/// Default app entry.
NavTarget get initialNav => const NavVerticalSelect();

/// Window for the "press again to exit" double-tap (matches React).
const int exitWindowMs = 2000;

/// State held by the NavController.
@immutable
class NavState {
  final NavTarget current;
  final List<NavTarget> history;
  final int lastBackAtRootMs; // 0 = never

  const NavState({
    required this.current,
    required this.history,
    required this.lastBackAtRootMs,
  });

  NavState copyWith({
    NavTarget? current,
    List<NavTarget>? history,
    int? lastBackAtRootMs,
  }) =>
      NavState(
        current: current ?? this.current,
        history: history ?? this.history,
        lastBackAtRootMs: lastBackAtRootMs ?? this.lastBackAtRootMs,
      );

  static const NavState initial = NavState(
    current: NavVerticalSelect(),
    history: <NavTarget>[],
    lastBackAtRootMs: 0,
  );
}

/// NavController — pure state, no widget dependencies. The app shell listens
/// to `state` and dispatches `BackAction`s (pop / show toast / navigate /
/// exit). 1:1 with React's `useBackHandler` + the App-level nav state.
class NavController {
  NavState _state = NavState.initial;
  NavState get state => _state;

  /// Subscribers notified after each mutation.
  final List<VoidCallback> _listeners = <VoidCallback>[];
  void addListener(VoidCallback cb) => _listeners.add(cb);
  void removeListener(VoidCallback cb) => _listeners.remove(cb);

  void _emit() {
    for (final l in List<VoidCallback>.of(_listeners)) {
      l();
    }
  }

  /// Forward navigation. Mirrors React's `go(next)` + `registerGo(prev, next)`.
  void go(NavTarget next) {
    final prev = _state.current;
    if (_rootScreens.contains(next.screen)) {
      _state = _state.copyWith(current: next, history: const <NavTarget>[]);
    } else {
      _state = _state.copyWith(
        current: next,
        history: <NavTarget>[..._state.history, prev],
      );
    }
    _emit();
  }

  /// Decides what to do on hardware back. Caller dispatches the action.
  /// Side effect: pops the history or records the root-exit timestamp.
  BackAction back() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_state.history.isNotEmpty) {
      final newHist = List<NavTarget>.of(_state.history);
      final target = newHist.removeLast();
      _state = _state.copyWith(history: newHist);
      _emit();
      return BackPop(target);
    }
    // No history — root screen.
    if (_state.current.screen == NavScreen.verticals) {
      if (now - _state.lastBackAtRootMs < exitWindowMs) {
        _state = _state.copyWith(lastBackAtRootMs: now);
        _emit();
        return const BackExit();
      }
      _state = _state.copyWith(lastBackAtRootMs: now);
      _emit();
      return const BackShowToast();
    }
    if (_state.current.screen == NavScreen.assistant ||
        _state.current.screen == NavScreen.progress) {
      const fallback = NavVerticalSelect();
      _state = _state.copyWith(current: fallback, history: const <NavTarget>[]);
      _emit();
      return const BackNavigateVerticals();
    }
    // Defensive: unknown screen at root level → fall back to Learn root.
    const fallback = NavVerticalSelect();
    _state = _state.copyWith(current: fallback, history: const <NavTarget>[]);
    _emit();
    return const BackNavigateVerticals();
  }

  /// Apply the result of a BackAction. The BackAction returned by `back()`
  /// already mutates the state, but callers that want to keep the dispatch
  /// separate (e.g. to invoke App.exitApp()) can use these.
  void applyPop(NavTarget target) {
    _state = _state.copyWith(current: target);
    _emit();
  }

  void applyNavigateVerticals() {
    _state = _state.copyWith(
      current: const NavVerticalSelect(),
      history: const <NavTarget>[],
    );
    _emit();
  }
}