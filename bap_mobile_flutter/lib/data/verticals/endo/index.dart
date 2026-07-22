// lib/data/verticals/endo/index.dart — Endo vertical (Sutures + Mesh + Staplers).
// 1:1 port of src/content/verticals/endo/index.ts.

import '../../../models/content.dart';
import 'mesh.dart';
import 'staplers.dart';
import 'sutures.dart';

final Vertical endoVertical = Vertical(
  id: 'endo',
  label: 'Endo',
  section: 'clinical',
  icon: 'Scissors',
  accent: AccentRef('#3b82f6', '#6366f1'),
  topics: <Topic>[suturesTopic, meshTopic, staplersTopic],
);