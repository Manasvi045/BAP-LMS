// test/parity_test.dart — verify content totals match the React source.
// React source totals (counted from src/content/verticals/**/*.ts):
//   4 verticals · 10 topics · 56 sections · 224 pages.

import 'package:bap_mobile/data/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('content parity vs React source', () {
    int v = 0, t = 0, s = 0, p = 0;
    for (final vt in data.verticals) {
      v++;
      for (final tp in vt.topics) {
        t++;
        for (final sc in tp.sections) {
          s++;
          p += sc.pages.length;
        }
      }
    }
    print('PARITY: $v verticals / $t topics / $s sections / $p pages');
    // Expected: 4 verticals, 10 topics, 56 sections, 224 pages (React source counts).
    expect(v, 4, reason: 'verticals');
    expect(t, 10, reason: 'topics');
    expect(s, 56, reason: 'sections');
    expect(p, 224, reason: 'pages');
  });
}
