// lib/data/page_builders.dart — page-builder helpers. 1:1 with src/content/helpers.ts.

import '../models/content.dart';

const _placeholderBody = 'Training video placeholder — wire the real clip here.';

/// `vid(h)` → VideoPage(heading:h, duration:"—", body:placeholder)
VideoPage vid(String h) => VideoPage(heading: h, duration: '—', body: _placeholderBody);

ReadPage read(String heading, String body) => ReadPage(heading: heading, body: body);

TablePage tablePage(String heading, {required List<String> columns, required List<List<String>> rows}) =>
    TablePage(heading: heading, columns: columns, rows: rows);

CardsPage cardsPage(String heading, List<ProductCard> items) =>
    CardsPage(heading: heading, items: items);

DecisionPage decisionPage(String heading, List<DecisionNode> nodes) =>
    DecisionPage(heading: heading, nodes: nodes);

AnatomyPage anatomyPage(String heading, List<AnatomyLayer> layers) =>
    AnatomyPage(heading: heading, layers: layers);

/// Build a swipeable image carousel page from a list of captions.
/// Pass `credits` to label the source for each slide (e.g. "Source: anatomy deck").
CarouselPage carouselPage(
  String heading,
  List<String> captions, {
  List<String?>? assets,
  List<String?>? credits,
}) {
  assert(credits == null || credits.length == captions.length,
      'credits length must match captions length');
  return CarouselPage(
    heading: heading,
    slides: <CarouselSlide>[
      for (int i = 0; i < captions.length; i++)
        CarouselSlide(
          caption: captions[i],
          src: assets != null ? assets[i] : null,
          credit: credits != null ? credits[i] : null,
        ),
    ],
  );
}

/// Build a video placeholder page. Pass `url` later to indicate the clip is
/// already known but not yet wired into the player.
VideoPlaceholderPage videoPlaceholderPage(
  String heading, {
  required String title,
  required String description,
  String? thumbnailSrc,
  String? url,
  String? duration,
}) {
  return VideoPlaceholderPage(
    heading: heading,
    title: title,
    description: description,
    thumbnailSrc: thumbnailSrc,
    futureUrl: url,
    duration: duration,
  );
}