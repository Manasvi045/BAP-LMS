// lib/data/verticals/country/index.dart — Country (Turkey) vertical.
// 1:1 port of src/content/verticals/country/index.ts.

import '../../../models/content.dart';
import 'turkey.dart';

final Vertical countryVertical = Vertical(
  id: 'country',
  label: 'Country Landscape',
  section: 'market',
  icon: 'Globe',
  accent: AccentRef('#14b8a6', '#06b6d4'),
  topics: <Topic>[turkeyTopic],
);