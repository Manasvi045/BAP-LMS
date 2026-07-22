// lib/data/verticals/ortho/index.dart — Ortho vertical (THR + TKR).
// 1:1 port of src/content/verticals/ortho/index.ts.

import '../../../models/content.dart';
import 'thr.dart';
import 'tkr.dart';

final Vertical orthoVertical = Vertical(
  id: 'ortho',
  label: 'Ortho',
  section: 'clinical',
  icon: 'Activity',
  accent: AccentRef('#f59e0b', '#f97316'),
  topics: <Topic>[thrTopic, tkrTopic],
);