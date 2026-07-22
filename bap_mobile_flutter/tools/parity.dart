// tools/parity.dart — count totals from the Dart registry.
// Run with: dart run tools/parity.dart

import 'package:bap_mobile/data/registry.dart';

void main() {
  int v = 0, t = 0, s = 0, p = 0;
  for (final vt in data.verticals) {
    v++;
    print('  ${vt.label}: ${vt.topics.length} topics');
    for (final tp in vt.topics) {
      t++;
      int sp = 0;
      for (final sc in tp.sections) {
        s++;
        sp += sc.pages.length;
      }
      print('    ${tp.label}: ${tp.sections.length} sections / $sp pages');
      p += sp;
    }
  }
  print('TOTAL: $v verticals, $t topics, $s sections, $p pages');
}
