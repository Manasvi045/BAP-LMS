// lib/data/verticals/cardio/index.dart — Cardio vertical (Heart + PTCA + TAVR + SAVR).
// 1:1 port of src/content/verticals/cardio/index.ts.

import '../../../models/content.dart';
import 'heart.dart';
import 'ptca.dart';
import 'savr.dart';
import 'tavr.dart';

final Vertical cardioVertical = Vertical(
  id: 'cardio',
  label: 'Cardio',
  section: 'clinical',
  icon: 'Stethoscope',
  accent: AccentRef('#ef4444', '#ec4899'),
  topics: <Topic>[heartTopic, ptcaTopic, tavrTopic, savrTopic],
);