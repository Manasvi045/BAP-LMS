// lib/services/assistant/context.dart — RAG: build a context-aware system prompt
// from the BAP content tree. Pure function, no I/O.
// 1:1 port of src/lib/assistant/context.ts.

import '../../data/registry.dart';
import '../../models/content.dart' as model;
import '../../state/nav.dart';
import 'api.dart';
import 'config.dart';

class AssistantContext {
  final NavTarget currentScreen;
  final String? threadId;
  AssistantContext({required this.currentScreen, this.threadId});
}

/// Catalog listing — verticals / topics / sections, compact.
String _buildCatalog(int maxChars) {
  final lines = <String>[];
  for (final v in data.verticals) {
    lines.add('- ${v.label} (${v.id}, ${v.section})');
    for (final tp in v.topics) {
      lines.add('    · ${tp.label} (${tp.id})');
      for (final s in tp.sections) {
        lines.add('        - ${s.title} (${s.id}): ${s.blurb}');
      }
    }
  }
  var out = lines.join('\n');
  if (out.length > maxChars) {
    out = '${out.substring(0, maxChars)}\n…(catalog truncated)';
  }
  return out;
}

/// Reference data — the FULL BAP content tree (read bodies, product cards,
/// tables, anatomy layers, decision nodes, video headings).
///
/// Quiz/exam questions and video bodies are intentionally omitted — the
/// assistant should teach from the material, not regurgitate test answers.
String _buildReferenceData(int maxChars) {
  final lines = <String>[];
  for (final v in data.verticals) {
    lines.add('\n## ${v.label}');
    for (final tp in v.topics) {
      lines.add('\n### ${tp.label} (cert: ${tp.cert})');
      for (final sec in tp.sections) {
        lines.add('\n#### ${sec.title}');
        if (sec.blurb.isNotEmpty) lines.add('> ${sec.blurb}');
        for (final page in sec.pages) {
          if (page is model.ReadPage) {
            lines.add('[read] ${page.heading}');
            lines.add(page.body);
          } else if (page is model.CardsPage) {
            lines.add('[cards] ${page.heading}');
            for (final it in page.items) {
              final head = <String>[it.sku];
              if (it.generic != null) head.add('(${it.generic})');
              if (it.category != null) head.add('[${it.category}]');
              if (it.construction != null) head.add('construction: ${it.construction}');
              if (it.coating != null) head.add('coating: ${it.coating}');
              if (it.absorption != null && it.absorption != '—') {
                head.add('absorption: ${it.absorption}');
              }
              if (it.origin != null) head.add('origin: ${it.origin}');
              if (it.ethiconEquiv != null) head.add('(equiv: ${it.ethiconEquiv})');
              lines.add('- ${head.join('  ·  ')}');
              if (it.features != null && it.features!.isNotEmpty) {
                lines.add('  features:');
                for (final f in it.features!) {
                  lines.add('    - $f');
                }
              }
              if (it.uses != null && it.uses!.isNotEmpty) {
                lines.add('  uses:');
                for (final u in it.uses!) {
                  lines.add('    - $u');
                }
              }
              if (it.cautions != null && it.cautions!.isNotEmpty) {
                lines.add('  cautions:');
                for (final c in it.cautions!) {
                  lines.add('    - $c');
                }
              }
            }
          } else if (page is model.TablePage) {
            lines.add('[table] ${page.heading}');
            lines.add('columns: ${page.columns.join(' | ')}');
            for (final row in page.rows) {
              lines.add(row.join(' | '));
            }
          } else if (page is model.AnatomyPage) {
            lines.add('[anatomy] ${page.heading}');
            for (final layer in page.layers) {
              final depthPart = layer.depth != null ? ' (${layer.depth})' : '';
              lines.add('- ${layer.name}$depthPart: ${layer.desc}');
            }
          } else if (page is model.DecisionPage) {
            lines.add('[decision] ${page.heading}');
            for (final n in page.nodes) {
              final hint = n.hint != null ? '  (hint: ${n.hint})' : '';
              lines.add('- Q: ${n.q}$hint');
            }
          }
          // `video` and quiz/exam bodies are intentionally omitted.
        }
      }
    }
  }
  var out = lines.join('\n');
  if (out.length > maxChars) {
    out = '${out.substring(0, maxChars)}\n…(reference truncated)';
  }
  return out;
}

String _describeScreen(NavTarget s) {
  if (s is NavVerticalSelect) {
    return 'The home screen — listing all verticals (Country Landscape, Endo, Ortho, Cardio).';
  }
  if (s is NavTopicSelect) {
    model.Vertical? v;
    for (final x in data.verticals) {
      if (x.id == s.vId) {
        v = x;
        break;
      }
    }
    if (v != null) {
      final labels = v.topics.map((tp) => tp.label).join(', ');
      return 'The topics list for the "${v.label}" vertical. Topics: $labels.';
    }
    return 'The topics list for vertical ${s.vId}.';
  }
  if (s is NavLearningPath) {
    model.Vertical? v;
    for (final x in data.verticals) {
      if (x.id == s.vId) {
        v = x;
        break;
      }
    }
    model.Topic? tp;
    if (v != null) {
      for (final x in v.topics) {
        if (x.id == s.tId) {
          tp = x;
          break;
        }
      }
    }
    if (v != null && tp != null) {
      final titles = <String>[];
      for (int i = 0; i < tp.sections.length; i++) {
        titles.add('${i + 1}. ${tp.sections[i].title}');
      }
      return 'The learning path for ${v.label} → ${tp.label} '
          '(${tp.sections.length} sections + final exam, certificate: "${tp.cert}"). '
          'Section titles: ${titles.join('; ')}.';
    }
    return 'A learning path (${s.vId}/${s.tId}).';
  }
  if (s is NavProgress) {
    return 'The progress dashboard — overall completion, certificates earned, recent attempts.';
  }
  if (s is NavAssistant) {
    return 'The assistant screen itself (this one).';
  }
  return 'Unknown screen.';
}

String buildSystemPrompt(AssistantContext ctx) {
  final catalog = AssistantConfig.catalogBudgetChars;
  final reference = AssistantConfig.referenceBudgetChars;
  final screen = _describeScreen(ctx.currentScreen);
  final catalogText = _buildCatalog(catalog);
  final referenceText = _buildReferenceData(reference);
  return '$systemPromptIdentity\n\n'
      'Where the user is right now: $screen\n\n'
      'Catalog (structural map — verticals, topics, sections):\n'
      '$catalogText\n\n'
      'Reference data (use these names + facts to answer; this is the substantive BAP content):\n'
      '$referenceText';
}

/// Convert internal chat history to OpenRouter's expected wire shape.
List<WireChatMessage> buildRequestMessages(
  List<({WireRole role, String text})> history,
  String systemPrompt,
  String newUserText,
) {
  final out = <WireChatMessage>[
    WireChatMessage(role: WireRole.system, content: systemPrompt),
    for (final m in history)
      if (m.text.trim().isNotEmpty)
        WireChatMessage(role: m.role, content: m.text),
    WireChatMessage(role: WireRole.user, content: newUserText),
  ];
  return out;
}