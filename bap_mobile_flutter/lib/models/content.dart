// lib/models/content.dart — sealed-class content model. 1:1 with src/content/schema.ts.

import 'package:flutter/foundation.dart';

/// Quiz/exam question. `correct` is the index into `options`.
@immutable
class Question {
  final String q;
  final List<String> options;
  final int correct;

  const Question({required this.q, required this.options, required this.correct});
}

@immutable
class ProductCard {
  final String sku;
  final String? generic;
  final String? category;
  final String? construction;
  final String? coating;
  final String? absorption;
  final String? origin;
  final List<String>? features;
  final List<String>? uses;
  final List<String>? cautions;
  final String? ethiconEquiv;

  const ProductCard({
    required this.sku,
    this.generic,
    this.category,
    this.construction,
    this.coating,
    this.absorption,
    this.origin,
    this.features,
    this.uses,
    this.cautions,
    this.ethiconEquiv,
  });
}

@immutable
class AnatomyLayer {
  final String name;
  final String? depth;
  final String color; // hex; layer swatch is rendered with the literal colour
  final String desc;

  const AnatomyLayer({
    required this.name,
    this.depth,
    required this.color,
    required this.desc,
  });
}

@immutable
class DecisionNode {
  final String q;
  final String? hint;

  const DecisionNode({required this.q, this.hint});
}

/// Sealed Page union. The `kind` discriminator mirrors the React discriminated union
/// from src/content/schema.ts:55-99. Dart's `when` exhaustiveness means every renderer
/// MUST handle every subtype — adding a new kind is a compile error until all switch
/// statements are updated.
@immutable
sealed class Page {
  String get heading;
  const Page();
}

@immutable
class ReadPage extends Page {
  @override
  final String heading;
  final String body;
  const ReadPage({required this.heading, required this.body});
}

@immutable
class VideoPage extends Page {
  @override
  final String heading;
  final String duration;
  final String body;
  final String? src;
  final String? poster;

  const VideoPage({
    required this.heading,
    required this.duration,
    required this.body,
    this.src,
    this.poster,
  });
}

@immutable
class TablePage extends Page {
  @override
  final String heading;
  final List<String> columns;
  final List<List<String>> rows;

  const TablePage({required this.heading, required this.columns, required this.rows});
}

@immutable
class CardsPage extends Page {
  @override
  final String heading;
  final List<ProductCard> items;

  const CardsPage({required this.heading, required this.items});
}

@immutable
class DecisionPage extends Page {
  @override
  final String heading;
  final List<DecisionNode> nodes;

  const DecisionPage({required this.heading, required this.nodes});
}

@immutable
class AnatomyPage extends Page {
  @override
  final String heading;
  final List<AnatomyLayer> layers;

  const AnatomyPage({required this.heading, required this.layers});
}

/// One slide in an image carousel. `src` is null until the real asset is wired in —
/// the renderer falls back to a labelled placeholder so the layout is ready.
@immutable
class CarouselSlide {
  final String caption;
  final String? src;
  final String? credit;

  const CarouselSlide({required this.caption, this.src, this.credit});
}

/// A swipeable, Instagram-style image carousel. Multiple related images on one page
/// so the user can review them as a single visual unit.
@immutable
class CarouselPage extends Page {
  @override
  final String heading;
  final List<CarouselSlide> slides;

  const CarouselPage({required this.heading, required this.slides});
}

/// Placeholder for a video that will be added later — anatomy walkthrough,
/// surgical technique, implant explanation, etc. Carries enough metadata to
/// describe the future clip, but renders a labelled card until a real URL is
/// plugged in.
@immutable
class VideoPlaceholderPage extends Page {
  @override
  final String heading;
  final String title;
  final String description;
  final String? thumbnailSrc;
  final String? futureUrl;
  final String? duration;

  const VideoPlaceholderPage({
    required this.heading,
    required this.title,
    required this.description,
    this.thumbnailSrc,
    this.futureUrl,
    this.duration,
  });
}

@immutable
class Section {
  final String id;
  final String title;
  final String icon; // IconName string; resolved at render via iconFor()
  final String blurb;
  final String color; // hex (first column / first row of SECTION_COLORS)
  final List<Page> pages;
  final List<Question> quiz;

  const Section({
    required this.id,
    required this.title,
    required this.icon,
    required this.blurb,
    required this.color,
    required this.pages,
    required this.quiz,
  });
}

@immutable
class Topic {
  final String id;
  final String label;
  final String icon;
  final String cert;
  final int passMark;
  final List<Section> sections;
  final List<Question> exam;

  const Topic({
    required this.id,
    required this.label,
    required this.icon,
    required this.cert,
    required this.passMark,
    required this.sections,
    required this.exam,
  });
}

@immutable
class AccentRef {
  final String c;
  final String g;
  const AccentRef(this.c, this.g);
}

@immutable
class Vertical {
  final String id;
  final String label;
  final String section; // "clinical" | "market"
  final String icon;
  final AccentRef accent;
  final int? order;
  final List<Topic> topics;

  const Vertical({
    required this.id,
    required this.label,
    required this.section,
    required this.icon,
    required this.accent,
    this.order,
    required this.topics,
  });
}

@immutable
class DataRegistry {
  final List<Vertical> verticals;
  const DataRegistry({required this.verticals});
}