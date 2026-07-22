// lib/data/verticals/endo/mesh.dart — Mesh topic: data tables + topic object.
// 1:1 port of src/content/verticals/endo/mesh.ts.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';

const _meshProducts = <ProductCard>[
  ProductCard(sku: 'FILAPROP MESH', generic: 'Non-Absorbable Polypropylene', category: 'Heavy Weight (100 gsm)', construction: 'Large Pore 1.0×1.2mm',
    features: ['Large pore aids elastic scar formation', 'High burst strength', 'Soft, elastic & pliable'],
    uses: ['Open & Lap Inguinal Hernia', 'Chest Wall Reconstruction', 'Open Ventral Repair'], ethiconEquiv: 'Prolene / Bard Mesh / Parietex-PE'),
  ProductCard(sku: 'FILAPROP MESH Soft', generic: 'Soft Polypropylene', category: 'Light Weight (45 gsm)', construction: 'Medium Pore 0.8×1.0mm',
    features: ['60% lighter — more elastic', 'Withstands high intra-abdominal pressure', 'Reduces chronic pain'],
    uses: ['Open & Lap Inguinal Hernia', 'Open Ventral Repair'], ethiconEquiv: 'Optilene LP (BBraun)'),
  ProductCard(sku: 'MERIGROW', generic: 'PP Macro Porous', category: 'Medium Weight (55 gsm)', construction: 'Very Large Pore 2.3×1.5mm',
    features: ['Round mesh edges', 'Unique interlocking knitting', 'X & Y axis extensibility'],
    uses: ['Open & Lap Inguinal', 'Open Ventral', 'TAR Repair (50×50cm)'], ethiconEquiv: 'Prolene Soft / Parietene'),
  ProductCard(sku: 'ABSOMESH', generic: 'Polyglecaprone + PP (Partially Absorbable)', category: 'Ultra Light (<30 gsm)', construction: 'Very Large Pore 2.0×2.0mm',
    features: ['60% less foreign material post-absorption', 'Mimics natural abdominal wall', 'Burst strength 313 N/cm²'],
    uses: ['Inguinal — Open & Lap', 'Ventral — Open', 'Fascial interventions'], ethiconEquiv: 'Ultrapro / Ultrapro Advance'),
  ProductCard(sku: 'MERINEUM', generic: 'PP / Polylactide-Caprolactone (TSM Dual Layer)', category: 'TSM Dual Layer (185→40 gsm)', construction: 'Tissue Separating',
    features: ['Blue lines for lap orientation', 'Drainage holes for seroma', 'PLCL barrier resorbs 90–120 days'],
    uses: ['Lap Ventral Repair', 'Incisional Hernia', 'Umbilical Hernia'], ethiconEquiv: 'Parietex Composite / Proceed'),
  ProductCard(sku: 'FILAPROP 3D MESH', generic: 'Monofilament Polypropylene', category: 'Anatomical', construction: 'Large Pore 1.0×1.5mm',
    features: ['Pre-shaped 3D anatomical design', 'No trimming required', 'Contours to groin anatomy'],
    uses: ['Open & Lap Inguinal Hernia'], ethiconEquiv: '3D Max (Bard) / Parietex Anatomical'),
  ProductCard(sku: 'PROFOUND A', generic: 'PLGA Absorbable Fixation', category: 'Fixation device', construction: '5.0mm tube, 36cm',
    features: ['Fully absorbable — no permanent material', '5mm tack', 'For TAPP & IPOM'],
    uses: ['MFD15A (15 tacks)', 'MFD30A (30 tacks)'], ethiconEquiv: 'Absorbatack / Securestrap'),
  ProductCard(sku: 'PROFOUND N', generic: 'Titanium Non-Absorbable Fixation', category: 'Fixation device', construction: '5.0mm tube, 36cm',
    features: ['Titanium — maximum strength', '3.8–4.0mm helical tack', 'Permanent fixation'],
    uses: ['MFD15N (15 tacks)', 'MFD30N (30 tacks)'], ethiconEquiv: 'Protack / Capsure'),
];

// Helper: turn the {name, color, desc} mesh stages into ProductCards.
final List<ProductCard> _meshStageCards = const <Map<String, String>>[
  {'name': 'Stage 1 — Wall Weakens or Tears', 'desc': 'Abdominal lining bulges through a weak area, beginning to form a hernia sac. May or may not be visible externally.'},
  {'name': 'Stage 2 — Reducible', 'desc': 'Visible bulge forms. Flattens when lying down or pushed in. No immediate danger — called a reducible hernia.'},
  {'name': 'Stage 3 — Incarcerated', 'desc': 'The sac containing intestine becomes trapped. Bulge does not flatten. Pain present — prompt treatment needed.'},
  {'name': 'Stage 4 — Strangulated', 'desc': 'Tightly trapped intestine loses blood supply and may necrose. Severe pain, bowel obstruction. Emergency surgery required.'},
].map((m) => ProductCard(sku: m['name']!, generic: '', category: '', construction: '', features: <String>[m['desc']!], uses: <String>[])).toList();

final TablePage _meshCompetitorMatrix = TablePage(
  heading: 'Mesh competitor matrix',
  columns: ['Category', 'Meril', 'Bard', 'Medtronic', 'Ethicon', 'BBraun'],
  rows: <List<String>>[
    ['PP Flat Mesh', 'Filaprop Mesh', 'Bard Mesh', 'Parietex-PE', 'Prolene', 'Premeline'],
    ['PP Soft Mesh', 'Filaprop Soft', '—', '—', '—', 'Optilene LP'],
    ['PP Macro-porous', 'Merigrow', 'Bard Soft', 'Parietene', 'Prolene Soft', 'Optilene Elastic'],
    ['Anatomical', 'Filaprop 3D', '3D Max', 'Parietex Anatomical', '—', '—'],
    ['Self Gripping', '—', '—', 'Progrip', '—', '—'],
    ['Partially Absorbable', 'Absomesh', '—', '—', 'Ultrapro', '—'],
    ['TSM (Lap Ventral)', 'Merineum', '—', 'Parietex Composite', 'Proceed', '—'],
  ],
);

const _meshDecisionTree = <DecisionNode>[
  DecisionNode(q: 'Inguinal or ventral hernia?', hint: 'Inguinal → flat/anatomical PP; ventral → consider TSM for IPOM'),
  DecisionNode(q: 'Open or laparoscopic approach?', hint: 'Lap intraperitoneal needs tissue-separating mesh (Merineum)'),
  DecisionNode(q: 'Is chronic-pain reduction a priority?', hint: 'Lightweight large-pore (Filaprop Soft, Merigrow) reduces stiffness'),
  DecisionNode(q: 'Large/complex ventral defect (TAR)?', hint: 'Merigrow up to 50×50cm for wide coverage'),
  DecisionNode(q: 'Want reduced long-term foreign material?', hint: 'Absomesh — partially absorbable, 60% mass reduction'),
];

final Topic meshTopic = Topic(
  id: 'mesh',
  label: 'Mesh',
  icon: 'Grid3x3',
  cert: 'Mesh Specialist',
  passMark: 80,
  sections: <Section>[
    Section(id: 'overview', title: 'Overview & disease state', icon: 'BookOpen', blurb: 'Hernia definition, the 4 stages of progression, and the hernia sac.', color: sectionColorsHex[0], pages: <Page>[
      read('What is a hernia?', 'Hernia derives from the Latin word for \'rupture\' — a breach in the body wall through which an organ or tissue protrudes. It arises from a congenital gap or acquired weakening in muscle/fascia. A visible or palpable swelling is the hallmark clinical sign.'),
      cardsPage('4 stages of hernia progression', _meshStageCards),
      read('The hernia sac & causes', 'The hernia sac has anatomical parts: the mouth (neck), the body, and the contents (often bowel or omentum). Causes include congenital defects, raised intra-abdominal pressure (chronic cough, straining, heavy lifting), obesity, pregnancy, ascites, and prior surgical incisions that weaken the wall.'),
      vid('Hernia disease state'),
    ], quiz: <Question>[
      Question(q: 'The Latin word \'hernia\' means:', options: ['Swelling', 'Rupture', 'Weakness'], correct: 1),
      Question(q: 'A Stage 2 (reducible) hernia is one that:', options: ['Is strangulated with lost blood supply', 'Flattens when lying down or pushed in', 'Cannot be flattened'], correct: 1),
      Question(q: 'Which is a common cause of hernia?', options: ['Raised intra-abdominal pressure', 'Low blood pressure', 'Vitamin deficiency'], correct: 0),
    ]),
    Section(id: 'fundamentals', title: 'Fundamentals', icon: 'FileText', blurb: 'Hernia classification, abdominal wall layers, and inguinal anatomy.', color: sectionColorsHex[1], pages: <Page>[
      read('Classification of hernia', 'Hernias are classified by site and behavior. By site: inguinal (indirect 70–75%, passing through the deep ring lateral to the inferior epigastric vessels; direct, through Hesselbach\'s triangle medial to those vessels), femoral, umbilical, incisional, and ventral. By behavior: reducible, incarcerated, and strangulated.'),
      read('Inguinal anatomy', 'Indirect inguinal hernias pass through the internal (deep) ring, lateral to the inferior epigastric vessels, and account for 70–75% of inguinal hernias. Direct hernias protrude through the weakened posterior wall in Hesselbach\'s triangle, medial to the inferior epigastric vessels.'),
      anatomyPage('Layers of the abdominal wall (inside-out)', <AnatomyLayer>[
        AnatomyLayer(name: 'Peritoneum', color: '#ddd6fe', depth: 'innermost', desc: 'Serous lining of the cavity.'),
        AnatomyLayer(name: 'Transversalis fascia', color: '#c7d2fe', desc: 'Key structural layer in repair.'),
        AnatomyLayer(name: 'Transversus abdominis', color: '#fca5a5', desc: 'Deepest of the three flat muscles.'),
        AnatomyLayer(name: 'Internal oblique', color: '#fed7aa', desc: 'Middle flat muscle.'),
        AnatomyLayer(name: 'External oblique', color: '#fde68a', desc: 'Outermost flat muscle; aponeurosis forms inguinal canal.'),
        AnatomyLayer(name: 'Skin & subcutaneous', color: '#fef9c3', depth: 'outermost', desc: 'Scarpa\'s & Camper\'s fascia.'),
      ]),
      vid('Hernia fundamentals'),
    ], quiz: <Question>[
      Question(q: 'Indirect inguinal hernias account for what % of inguinal hernias?', options: ['25–30%', '70–75%', '90%'], correct: 1),
      Question(q: 'Direct inguinal hernias protrude through:', options: ['The deep inguinal ring', 'Hesselbach\'s triangle', 'The femoral canal'], correct: 1),
      Question(q: 'Which is the innermost abdominal wall layer listed?', options: ['External oblique', 'Peritoneum', 'Skin'], correct: 1),
    ]),
    Section(id: 'portfolio', title: 'Meril portfolio', icon: 'Layers', blurb: '6 mesh products + 2 fixation devices — specs, weight class, pores, indications.', color: sectionColorsHex[2], pages: <Page>[
      cardsPage('Meril mesh & fixation portfolio', _meshProducts),
      vid('Mesh portfolio deep-dive'),
    ], quiz: <Question>[
      Question(q: 'Which mesh is BOTH ultra-light AND very-large-pore?', options: ['Filaprop Mesh', 'Absomesh', 'Merineum'], correct: 1),
      Question(q: 'Filaprop Mesh (standard, 100 gsm) is classified as:', options: ['Ultra Light Weight', 'Heavy Weight', 'Medium Weight'], correct: 1),
      Question(q: 'Which fixation device is fully absorbable?', options: ['Profound N', 'Profound A', 'Filaprop 3D'], correct: 1),
    ]),
    Section(id: 'procedures', title: 'Procedures', icon: 'Activity', blurb: 'Open Lichtenstein, TAPP, TEP, and ventral repair.', color: sectionColorsHex[3], pages: <Page>[
      read('Open inguinal — Lichtenstein', 'The Lichtenstein \'tension-free\' hernioplasty uses a 5–7 cm incision. The mesh overlaps the pubic tubercle by 2 cm, covers Hesselbach\'s triangle by 3–4 cm, and extends 5–6 cm lateral to the internal ring.'),
      read('Laparoscopic — TAPP & TEP', 'TAPP (TransAbdominal PrePeritoneal) enters the peritoneal cavity, places mesh in the preperitoneal space, then reapproximates the peritoneum over the mesh with tackers — the mesh must be completely covered to prevent bowel contact. TEP (Totally ExtraPeritoneal) stays entirely outside the peritoneum, avoiding cavity entry.'),
      read('Ventral & incisional repair', 'Ventral hernias are repaired open or laparoscopically. Laparoscopic IPOM places a tissue-separating mesh (e.g. Merineum) intraperitoneally with its antiadhesive barrier facing the viscera. Large/complex defects may need Transversus Abdominis Release (TAR) with wide-coverage mesh such as Merigrow up to 50×50 cm.'),
      vid('Mesh procedures'),
    ], quiz: <Question>[
      Question(q: 'The Lichtenstein technique uses an incision of:', options: ['2–3 cm', '5–7 cm', '15 cm'], correct: 1),
      Question(q: 'In TAPP, the space is closed by:', options: ['No closure — gas release collapses it', 'Reapproximating peritoneum over mesh with tackers', 'Fascial sutures only'], correct: 1),
      Question(q: 'Which mesh suits laparoscopic intraperitoneal ventral repair?', options: ['Filaprop flat PP', 'Merineum (tissue-separating)', 'Silk'], correct: 1),
    ]),
    Section(id: 'competition', title: 'Competitors & decision', icon: 'GitBranch', blurb: 'Competitive matrix and the mesh-selection framework.', color: sectionColorsHex[4], pages: <Page>[
      _meshCompetitorMatrix,
      decisionPage('Mesh selection framework', _meshDecisionTree),
      vid('Competitive landscape'),
    ], quiz: <Question>[
      Question(q: 'The Meril equivalent in the \'TSM (Lap Ventral)\' category is:', options: ['Merineum', 'Filaprop Mesh', 'Merigrow'], correct: 0),
      Question(q: 'For chronic-pain reduction you would favor:', options: ['Heavyweight small-pore mesh', 'Lightweight large-pore mesh', 'Steel mesh'], correct: 1),
    ]),
  ],
  exam: meshExam,
);