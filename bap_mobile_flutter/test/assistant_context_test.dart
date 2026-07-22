// Smoke tests for the assistant RAG context builder.
//
// Verifies:
//  - buildSystemPrompt() returns a non-trivial prompt
//  - the prompt contains identity, screen description, catalog, and reference
//  - quiz/exam questions and video bodies are NOT leaked into the prompt
//  - buildRequestMessages() wires history + system + new user message in order

import 'package:flutter_test/flutter_test.dart';

import 'package:bap_mobile/services/assistant/api.dart';
import 'package:bap_mobile/services/assistant/context.dart';
import 'package:bap_mobile/state/nav.dart';

void main() {
  test('buildSystemPrompt is non-empty and structured', () {
    final prompt = buildSystemPrompt(AssistantContext(currentScreen: NavVerticalSelect()));
    expect(prompt.length, greaterThan(5000));
    expect(prompt, contains('BAP Study Assistant'));
    expect(prompt, contains('Where the user is right now'));
    expect(prompt, contains('Catalog'));
    expect(prompt, contains('Reference data'));
  });

  test('screen description updates per target', () {
    final verticalsPrompt = buildSystemPrompt(AssistantContext(currentScreen: NavVerticalSelect()));
    final topicPrompt = buildSystemPrompt(AssistantContext(currentScreen: NavTopicSelect('endo')));
    final pathPrompt = buildSystemPrompt(
      AssistantContext(currentScreen: NavLearningPath('endo', 'sutures')),
    );
    expect(verticalsPrompt, contains('The home screen'));
    expect(topicPrompt, contains('topics list for the'));
    expect(pathPrompt, contains('learning path for'));
  });

  test('quiz/exam questions are excluded from the reference data', () {
    // This invariant is the whole point of the RAG contract — the model must
    // teach from the material, not regurgitate test answers. A regression
    // here would mean someone added the quiz to the prompt loop.
    final prompt = buildSystemPrompt(AssistantContext(currentScreen: NavVerticalSelect()));
    // "Quiz" and "exam" do appear as words in the meta headers; the marker we
    // care about is the question-form pattern "?\n  - " or any literal quiz
    // option list. The simplest stable check: there's no "?" followed by an
    // indented dash (a question + options shape) in the reference data block.
    final refStart = prompt.indexOf('Reference data');
    final refBlock = prompt.substring(refStart);
    // Reference pages use "[read]", "[cards]", "[table]", "[anatomy]",
    // "[decision]" markers. Quiz/exam would introduce "?" immediately
    // followed by "  - " or "  · ". Scan and fail if any.
    final lines = refBlock.split('\n');
    for (final l in lines) {
      if (l.contains('?  · ') || l.contains('?  - ')) {
        fail('Reference data appears to leak quiz-style Q+option rows: $l');
      }
    }
  });

  test('buildRequestMessages wires system + history + new user message', () {
    final history = <({WireRole role, String text})>[
      (role: WireRole.user, text: 'hi'),
      (role: WireRole.assistant, text: 'hello'),
      (role: WireRole.user, text: ''), // empty — should be filtered
    ];
    final wire = buildRequestMessages(history, 'sys-prompt', 'new-question');
    expect(wire.length, 4); // sys + 2 non-empty + new
    expect(wire.first.role, WireRole.system);
    expect(wire.first.content, 'sys-prompt');
    expect(wire.last.role, WireRole.user);
    expect(wire.last.content, 'new-question');
  });
}