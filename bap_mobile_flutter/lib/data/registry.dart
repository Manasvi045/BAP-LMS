// lib/data/registry.dart — the single entry point for the app's content model.
// Assembles the 4 verticals in the order the prototype's `DATA` block used:
// country (market) first, then the 3 clinical verticals.
// 1:1 port of src/content/registry.ts.

import '../models/content.dart';
import 'verticals/cardio/index.dart';
import 'verticals/country/index.dart';
import 'verticals/endo/index.dart';
import 'verticals/ortho/index.dart';

final DataRegistry data = DataRegistry(
  verticals: <Vertical>[countryVertical, endoVertical, orthoVertical, cardioVertical],
);