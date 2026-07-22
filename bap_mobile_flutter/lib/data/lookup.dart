// lib/data/lookup.dart — top-level helpers for navigating the data tree.
// 1:1 port of src/content/lookup.ts.

import '../models/content.dart';
import 'registry.dart';

/// Find a vertical by its id, or undefined.
Vertical? findVertical(String id) {
  for (final v in data.verticals) {
    if (v.id == id) return v;
  }
  return null;
}

/// Find a topic by vertical+topic id, or undefined.
Topic? findTopic(String vId, String tId) {
  final v = findVertical(vId);
  if (v == null) return null;
  for (final t in v.topics) {
    if (t.id == tId) return t;
  }
  return null;
}

/// Build the stable storage key for a (vertical, topic) progress entry.
String topicKey(String vId, String tId) => '$vId.$tId';

/// Resolve a section id to its title (or the raw id if not found).
String secTitle(String vId, String tId, String sId) {
  return findTopic(vId, tId)?.sections.firstWhere(
        (s) => s.id == sId,
        orElse: () => Section(
          id: sId, title: sId, icon: '', blurb: '', color: '', pages: <Page>[], quiz: <Question>[],
        ),
      ).title ??
      sId;
}

/// A safe accessor for a section (used in dashboards where missing is OK).
Section? findSection(String vId, String tId, String sId) {
  final t = findTopic(vId, tId);
  if (t == null) return null;
  for (final s in t.sections) {
    if (s.id == sId) return s;
  }
  return null;
}
