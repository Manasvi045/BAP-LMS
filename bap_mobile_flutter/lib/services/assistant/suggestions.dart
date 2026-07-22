// lib/services/assistant/suggestions.dart — context-aware starter chips for the chat.
// 1:1 port of src/lib/assistant/suggestions.ts.

import '../../data/registry.dart';
import '../../models/content.dart' as model;
import '../../state/nav.dart';

class SuggestionsContext {
  final NavTarget from;
  const SuggestionsContext({required this.from});
}

List<String> getSuggestions(SuggestionsContext ctx) {
  final from = ctx.from;
  if (from is NavVerticalSelect) {
    final v = data.verticals.isNotEmpty ? data.verticals[0] : null;
    return <String>[
      'What verticals are available?',
      'Give me a quick tour of the ${v?.label ?? "Endo"} path',
      'How do certificates work?',
      "What's the difference between market and clinical verticals?",
    ];
  }
  if (from is NavTopicSelect) {
    model.Vertical? v;
    for (final x in data.verticals) {
      if (x.id == from.vId) {
        v = x;
        break;
      }
    }
    if (v == null) return _defaultSuggestions();
    final tp = v.topics.isNotEmpty ? v.topics[0] : null;
    return <String>[
      "What's covered in the ${tp?.label ?? v.topics[0].label} topic?",
      'How long does ${v.label} typically take?',
      'What product is ${v.label} known for?',
      'Quiz me on the basics',
    ];
  }
  if (from is NavLearningPath) {
    model.Vertical? v;
    for (final x in data.verticals) {
      if (x.id == from.vId) {
        v = x;
        break;
      }
    }
    model.Topic? tp;
    if (v != null) {
      for (final x in v.topics) {
        if (x.id == from.tId) {
          tp = x;
          break;
        }
      }
    }
    if (v == null || tp == null) return _defaultSuggestions();
    final firstSection = tp.sections.isNotEmpty ? tp.sections[0].title : 'the first section';
    return <String>[
      'Quiz me on the ${tp.label} path',
      'Explain $firstSection in simple terms',
      "What's the ${tp.label} final exam like?",
      'Which Meril products relate to ${tp.label}?',
    ];
  }
  if (from is NavProgress) {
    return <String>[
      'How am I doing overall?',
      'Which topics should I focus on next?',
      'How do I earn a certificate?',
      'Why is my streak only 4 days?',
    ];
  }
  return _defaultSuggestions();
}

List<String> _defaultSuggestions() => <String>[
      'Explain absorbable vs non-absorbable sutures',
      'Quiz me on the Cardio path',
      'Summarize the Endo topics',
      'What certificate does TKR give?',
    ];