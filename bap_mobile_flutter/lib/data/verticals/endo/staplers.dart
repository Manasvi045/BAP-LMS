// lib/data/verticals/endo/staplers.dart — Staplers topic: data tables + topic object.
// 1:1 port of src/content/verticals/endo/staplers.ts.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';

final TablePage _staplerGiOrgans = TablePage(
  heading: 'GI organs & reload guidance',
  columns: ['Organ', 'Wall layers', 'Reload guidance'],
  rows: <List<String>>[
    ['Esophagus', 'Mucosa, Submucosa, Muscularis, Adventitia', 'Thin — White/Grey. Esophagectomy uses linear cutter.'],
    ['Stomach', 'Mucosa, Submucosa, Muscularis, Serosa', 'Thick — Green/Black. Gastrectomy uses linear cutter.'],
    ['Small Intestine', 'Mucosa, Submucosa, Muscularis, Serosa', 'Submucosa is key holding layer. Blue reload.'],
    ['Colon / Rectum', 'Mucosa, Submucosa, Muscularis, Serosa', 'Colectomy: linear cutter. LAR: linear + circular.'],
    ['Bronchus / Lung', 'Epithelium, Submucosa, Cartilage, Adventitia', 'Thick & rigid — Black. Lobectomy uses MALS.'],
  ],
);

const _staplerWallLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Mucosa', color: '#fef9c3', desc: 'Innermost — epithelium, lamina propria, muscularis mucosae. Lines the lumen.'),
  AnatomyLayer(name: 'Submucosa', color: '#fed7aa', desc: 'Dense connective tissue with vessels, nerves, lymphatics. KEY STAPLE-HOLDING LAYER.'),
  AnatomyLayer(name: 'Muscularis Externa', color: '#fca5a5', desc: 'Inner circular + outer longitudinal muscle. Auerbach\'s plexus. Drives peristalsis.'),
  AnatomyLayer(name: 'Serosa / Adventitia', color: '#d1fae5', desc: 'Outermost. Serosa on intraperitoneal organs; adventitia on retroperitoneal/thoracic.'),
];

const _anastomosisTypes = <ProductCard>[
  ProductCard(sku: 'EEA', generic: 'End-to-End Anastomosis', category: 'Circular stapler', construction: '',
    features: ['Joins two lumen ends circularly'],
    uses: ['Lower Anterior Resection', 'Esophago-gastric']),
  ProductCard(sku: 'SEA', generic: 'Side-to-End Anastomosis', category: 'Mixed', construction: '',
    features: ['One side joined to one end'],
    uses: ['Colorectal reconstruction']),
  ProductCard(sku: 'SSA', generic: 'Side-to-Side Anastomosis', category: 'Linear cutter', construction: '',
    features: ['Two sides joined; wide lumen'],
    uses: ['Small bowel', 'Ileocolic']),
  ProductCard(sku: 'ESA', generic: 'End-to-Side Anastomosis', category: 'Mixed', construction: '',
    features: ['One end joined to a side'],
    uses: ['Roux-en-Y', 'Biliary']),
];

const _staplerProductsData = <ProductCard>[
  ProductCard(sku: 'MALS (Linear Stapler)', generic: 'MALS30 / 45 / 60 / 90', category: 'Linear', construction: 'Reloads: Blue 3.5mm, Green 4.8mm',
    features: ['Retaining pin holds tissue in jaw', 'Two open staple heights'],
    uses: ['Rectal stump closure', 'Bronchus (lobectomy)', 'Gastrectomy']),
  ProductCard(sku: 'MLC (Linear Cutter)', generic: 'MLC60 / 80 / 100', category: 'Linear cutter', construction: 'Up to 8 firings',
    features: ['Cuts and staples simultaneously', '8 firings — double Ethicon\'s 4'],
    uses: ['Side-to-side anastomosis', 'Gastrectomy', 'Colectomy']),
  ProductCard(sku: 'MCS (Circular Stapler)', generic: 'MCS-19 to MCS-32', category: 'Circular', construction: '7 lumen sizes · 2-row & 3-row',
    features: ['Adjustable staple height', '3-row = superior hemostasis', 'Compression gauge'],
    uses: ['End-to-end anastomosis', 'Lower Anterior Resection']),
  ProductCard(sku: 'MPPH (Hemorrhoid)', generic: 'PPH procedure stapler', category: 'Specialty', construction: 'Housing capacity + conduits',
    features: ['Conduits for suture threader', 'Surgeon-controlled traction', 'Even doughnut excision'],
    uses: ['Stapled hemorrhoidopexy']),
  ProductCard(sku: 'Skin Stapler', generic: 'Skin closure', category: 'Specialty', construction: 'With extractor',
    features: ['Fast skin approximation', 'Dedicated extractor'],
    uses: ['Skin closure', 'Laparotomy skin']),
  ProductCard(sku: 'HMEC (Endoscopic Linear Cutter)', generic: 'HMECR45 / 60', category: 'Endoscopic', construction: '6 reload colors · proximal articulation',
    features: ['Proximal articulation', 'Black reload 4.4mm open', 'Multiple shaft lengths'],
    uses: ['Laparoscopic resection & anastomosis']),
];

final TablePage _staplerCompetitorMatrix = TablePage(
  heading: 'Stapler competitor matrix',
  columns: ['Category', 'Meril (Mirus)', 'Medtronic', 'Ethicon', 'Lotus'],
  rows: <List<String>>[
    ['Linear Cutter firings', '8', '8 (GIA)', '4 (Proximate TCL)', '8 (Prosec)'],
    ['Circular lumen sizes', '7 (14 variants)', '4', '4', '4'],
    ['Circular staple rows', '2-row & 3-row', '2-row', '2-row', '2-row'],
    ['Powered Endocutter', 'Yes', 'Yes', 'Yes', '—'],
  ],
);

const _staplerDecisionTree = <DecisionNode>[
  DecisionNode(q: 'What anastomosis geometry is needed?', hint: 'EEA → circular; SSA → linear cutter; rectal stump → linear'),
  DecisionNode(q: 'How thick is the tissue?', hint: 'Thin (esophagus) → White/Grey; thick (stomach/bronchus) → Green/Black'),
  DecisionNode(q: 'Open or laparoscopic?', hint: 'Lap → HMEC endoscopic cutter with articulation'),
  DecisionNode(q: 'Is hemostasis at the anastomosis critical?', hint: '3-row circular (MCS) gives superior hemostasis vs 2-row'),
];

final Topic staplersTopic = Topic(
  id: 'staplers',
  label: 'Staplers',
  icon: 'Layers',
  cert: 'Stapler Specialist',
  passMark: 80,
  sections: <Section>[
    Section(id: 'history', title: 'History & benefits', icon: 'BookOpen', blurb: 'Origins of surgical stapling and its clinical benefits.', color: sectionColorsHex[0], pages: <Page>[
      read('History of surgical stapling', 'The first surgical stapling device was invented in 1909 by Dr. Humer Hultl in Hungary. Modern devices evolved into reloadable, precise instruments used across GI, thoracic, and bariatric surgery.'),
      read('Benefits of stapling', 'Stapling provides reliable hemostasis along the staple line, gentler tissue handling, consistent and reproducible anastomoses, and significant time savings versus hand-sewn techniques — especially valuable in laparoscopic and deep-cavity work where suturing is difficult.'),
      vid('History & benefits of stapling'),
    ], quiz: <Question>[
      Question(q: 'The first surgical stapler was invented in:', options: ['1900', '1909', '1950'], correct: 1),
      Question(q: 'Which is a key benefit of stapling?', options: ['Reliable hemostasis & reproducible anastomosis', 'Higher infection rate', 'Slower than hand-sewing'], correct: 0),
    ]),
    Section(id: 'anastomosis', title: 'Anastomosis & GI anatomy', icon: 'FileText', blurb: 'EEA/SEA/SSA/ESA techniques and the GI wall layers relevant to stapling.', color: sectionColorsHex[1], pages: <Page>[
      cardsPage('Anastomosis types', _anastomosisTypes),
      _staplerGiOrgans,
      anatomyPage('GI wall — four layers', _staplerWallLayers),
      vid('Anastomosis fundamentals'),
    ], quiz: <Question>[
      Question(q: 'End-to-End Anastomosis (EEA) is performed with a:', options: ['Linear cutter', 'Circular stapler', 'Skin stapler'], correct: 1),
      Question(q: 'The key staple-holding layer of the GI wall is the:', options: ['Mucosa', 'Submucosa', 'Serosa'], correct: 1),
      Question(q: 'Thick tissue like stomach/bronchus needs which reload range?', options: ['White/Grey (thin)', 'Green/Black (thick)', 'No reload'], correct: 1),
    ]),
    Section(id: 'portfolio', title: 'Mirus portfolio', icon: 'Layers', blurb: '7 product lines — linear, cutter, circular, hemorrhoid, skin, endoscopic.', color: sectionColorsHex[2], pages: <Page>[
      cardsPage('Mirus stapler portfolio', _staplerProductsData),
      vid('Mirus portfolio overview'),
    ], quiz: <Question>[
      Question(q: 'Which Mirus linear stapler size does NOT exist?', options: ['MALS30', 'MALS75', 'MALS90'], correct: 1),
      Question(q: 'The Mirus Linear Cutter supports a maximum of how many firings?', options: ['4', '8', '16'], correct: 1),
      Question(q: 'What does the retaining pin on the linear stapler do?', options: ['Fires staples', 'Holds tissue within the jaw', 'Sets staple height'], correct: 1),
    ]),
    Section(id: 'circular', title: 'Circular & specialty detail', icon: 'Ruler', blurb: 'Circular lumen sizes, the 3-row advantage, and specialty staplers.', color: sectionColorsHex[3], pages: <Page>[
      read('Circular stapler — sizes & 3-row advantage', 'The Mirus Circular Stapler offers 7 lumen sizes (14 variants including 2-row and 3-row) versus only 4 from Medtronic, Ethicon, and Lotus. The 3-row staple configuration provides superior hemostasis compared to conventional 2-row, with adjustable staple height and a compression gauge.'),
      read('Hemorrhoid & skin staplers', 'The Mirus Hemorrhoid Stapler (MPPH) performs stapled hemorrhoidopexy; its conduits for a suture threader enable surgeon-controlled traction and even doughnut excision. The skin stapler offers fast approximation with a dedicated extractor.'),
      read('Endoscopic linear cutter (HMEC)', 'The HMEC features proximal articulation and 6 reload colors across multiple shaft lengths for laparoscopic resection and anastomosis. The Black reload has the largest staple — 4.4 mm open / 2.25 mm closed.'),
      vid('Circular & specialty staplers'),
    ], quiz: <Question>[
      Question(q: 'How many lumen sizes does the Mirus Circular Stapler offer?', options: ['4', '5', '7'], correct: 2),
      Question(q: 'The 3-row staple line\'s key advantage over 2-row is:', options: ['Lower cost', 'Superior hemostasis', 'Smaller diameter'], correct: 1),
      Question(q: 'Which HMEC reload color is 4.4mm open staple height?', options: ['Gold', 'Blue', 'Black'], correct: 2),
    ]),
    Section(id: 'competition', title: 'Competitors & decision', icon: 'GitBranch', blurb: 'Meril vs Medtronic vs Ethicon vs Lotus, and stapler selection.', color: sectionColorsHex[4], pages: <Page>[
      _staplerCompetitorMatrix,
      decisionPage('Stapler selection framework', _staplerDecisionTree),
      vid('Competitive analysis'),
    ], quiz: <Question>[
      Question(q: 'Which focus surgery is most associated with the circular stapler?', options: ['Lobectomy (bronchus)', 'End-to-end anastomosis / LAR', 'Side-to-side anastomosis'], correct: 1),
      Question(q: 'For a laparoscopic case you would reach for:', options: ['MALS open linear', 'HMEC endoscopic cutter', 'Skin stapler'], correct: 1),
    ]),
  ],
  exam: staplersExam,
);