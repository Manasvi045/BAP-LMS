// lib/data/verticals/ortho/thr.dart — Total Hip Replacement topic.
//
// Content migrated from the PDF courseware pack "Total Hip Replacement
// Essentials — Meril Orthopedics · L&D". The pack is structured as six modules:
//
//   M1 Hip Anatomy Essentials
//   M2 Why Hip Replacement Is Done
//   M3 How a Hip Replacement Is Done
//   M4 Meril's Hip Portfolio — the Latitud™ Family
//   M5 Competitive Landscape
//   M6 Knowledge Check (Quiz) + Glossary + Source mapping
//
// All teaching copy, video placeholders and image carousels mirror the PDF's
// flow one-to-one. Real image assets have been bundled under assets/thr/ and
// are referenced by stable path so carousels and the Latitud portfolio screens
// render the corresponding diagrams and renders.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Module 1 — Hip Anatomy Essentials
// ─────────────────────────────────────────────────────────────────────────────

const _m1BoneLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Femoral head (the ball)', color: '#fde68a', desc: 'The rounded "ball" that sits deep inside the socket; carries a small central pit (fovea) for the ligamentum teres.'),
  AnatomyLayer(name: 'Femoral neck & trochanters', color: '#fef9c3', desc: 'Neck links head to shaft at a neck-shaft (CCD) angle of ~125–135°; greater and lesser trochanters are key muscle attachment sites.'),
  AnatomyLayer(name: 'Acetabulum (the socket)', color: '#fed7aa', desc: 'The cup-shaped socket formed where the ilium, ischium and pubis fuse; its horseshoe-shaped lunate surface carries the articular cartilage.'),
  AnatomyLayer(name: 'Articular cartilage', color: '#bae6fd', desc: 'A smooth, low-friction cap on both surfaces that lets the joint glide painlessly and absorb load.'),
  AnatomyLayer(name: 'Acetabular labrum', color: '#fca5a5', desc: 'A fibrocartilage collar around the socket rim that deepens the cup, improves stability and helps seal in synovial fluid.'),
  AnatomyLayer(name: 'Joint capsule & ligaments', color: '#ddd6fe', desc: 'A strong fibrous capsule surrounds the joint; thickenings form three powerful capsular ligaments (iliofemoral, pubofemoral, ischiofemoral) that keep the head seated.'),
];

const _m1LigamentLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Iliofemoral ligament', color: '#86efac', desc: 'The strongest ligament in the body — "Y"-shaped; sits at the front of the hip and prevents hyperextension.'),
  AnatomyLayer(name: 'Pubofemoral ligament', color: '#fde68a', desc: 'Reinforces the joint inferiorly and limits excess abduction and extension.'),
  AnatomyLayer(name: 'Ischiofemoral ligament', color: '#fbcfe8', desc: 'Spirals across the back of the capsule and helps hold the femoral head in the socket.'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Module 2 — Why Hip Replacement Is Done
// ─────────────────────────────────────────────────────────────────────────────

const _m2DiseaseLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Healthy hip', color: '#bbf7d0', desc: 'Smooth cartilage, an even joint space and a head that glides freely in the socket.'),
  AnatomyLayer(name: 'Cartilage thinning', color: '#fde68a', desc: 'Cartilage thins and disappears; the joint space narrows — the earliest sign of osteoarthritis.'),
  AnatomyLayer(name: 'Osteophytes', color: '#fca5a5', desc: 'Bone spurs form at the joint margins as the body tries to compensate for lost cartilage.'),
  AnatomyLayer(name: 'Head loses round contour', color: '#fecaca', desc: 'The femoral head loses its smooth, rounded shape; the head deforms and loses its congruent fit in the socket.'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Module 3 — How a Hip Replacement Is Done — anatomical anchor layers
// ─────────────────────────────────────────────────────────────────────────────

const _m3ReconstructLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Acetabular shell + liner (new socket)', color: '#bae6fd', desc: 'A metal acetabular shell with a polyethylene (or ceramic) liner that forms the new bearing surface.'),
  AnatomyLayer(name: 'Femoral stem + modular head (new femur)', color: '#fde68a', desc: 'A stem placed down the femoral canal carrying a modular femoral head that articulates with the liner.'),
];

const _m3ApproachLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Posterior (Moore / Southern)', color: '#fca5a5', desc: 'The most common approach — excellent exposure of the femur and acetabulum.'),
  AnatomyLayer(name: 'Direct lateral (Hardinge / transgluteal)', color: '#fde68a', desc: 'Good exposure while preserving the bulk of the gluteus; low dislocation rate.'),
  AnatomyLayer(name: 'Anterior (Smith-Petersen)', color: '#bbf7d0', desc: 'Inter-muscular approach associated with faster early recovery.'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Module 4 — Meril's Hip Portfolio: the Latitud™ Family
// ─────────────────────────────────────────────────────────────────────────────

const _m4FamilyCards = <ProductCard>[
  ProductCard(
    sku: 'LATITUD™ Uncemented Femoral Stem',
    generic: 'HA-coated, dual-taper, titanium primary stem',
    category: 'Primary Cementless THR',
    construction: 'Forged Ti-6Al-4V ELI alloy + Osprovit® HA coating (~155 µm, plasma-sprayed)',
    features: [
      'Full Osprovit® HA coating promotes early osteo-integration and long-term fixation.',
      'Dual-taper trapezoidal design — vertical and horizontal grooves resist rotational and axial loading and prevent subsidence.',
      '11 sizes with 135° standard, 135° lateral (high-offset) and 125° coxa-vara neck angles for lateralisation and varied anatomy.',
      'Low modulus titanium reduces stiffness mismatch with bone and helps reduce thigh pain.',
      'Three neck-angle options address the full range of CCD angles seen in Caucasian (135°–145°) and Asian (125°–135°) patients.',
    ],
    uses: ['Primary cementless THR; HA-coated dual-taper stem with 11 sizes and three neck angles.'],
  ),
  ProductCard(
    sku: 'LATITUD™ Acetabular Cup System',
    generic: 'Press-fit titanium shell + XLPE liner',
    category: 'Cementless Acetabular Cup',
    construction: 'Hemispherical forged-Ti shell + Ti-Growth porous plasma-sprayed coating; XLPE liner',
    features: [
      'Press-fit ~1.3 mm at the rim so press-fit occurs just below the acetabular bone margin to aid retention and stability.',
      'Highly cross-linked polyethylene (XLPE) liner with minimum ~5.5 mm wall in the main load area for low wear; ceramic options available.',
      'No-hole or multi-hole shells; supplementary bone screws available for additional fixation.',
      'Polished cup edge prevents psoas irritation and impingement.',
      'Modular heads available in CoCr, stainless and Biolox® Delta ceramic via 12/14 taper.',
    ],
    uses: ['Press-fit titanium shell + XLPE/ceramic liner for total hip replacement.'],
  ),
  ProductCard(
    sku: 'LATITUD™ Cemented Femoral Stem',
    generic: 'Polished, dual-tapered, loaded-taper stem',
    category: 'Cemented Primary THR',
    construction: 'High-nitrogen stainless steel (HNSS) — collarless, polished double-tapered',
    features: [
      'Polished surface — designed to reduce friction between cement and implant, reducing third-body wear.',
      'Loaded-taper principle with biomechanics proven over more than three decades of clinical use.',
      'Collarless neck for intra-operative leg-length adjustment with depth-marked rasp.',
      'Centraliser (wingless or winged, PMMA) allows the stem to subside within the cement mantle without end-bearing.',
      'Cement restrictor with slots and flanges conforms to the medullary canal and aids pressurisation.',
    ],
    uses: ['Primary THR in older / osteoporotic bone; polished dual-taper, loaded-taper principle.'],
  ),
  ProductCard(
    sku: 'LATITUD™ Monoblock Bipolar System',
    generic: 'Head-within-a-cup for hemiarthroplasty',
    category: 'Bipolar Hip / Hemiarthroplasty',
    construction: 'Pre-assembled monoblock self-centering design — outer 316L SS (Ra = 0.05 µm), inner UHMWPE GUR 1050',
    features: [
      'Pre-assembled monoblock self-centering design — optimises load transfer and reduces wear.',
      'Outer articulating layer: 316L stainless steel with Ra = 0.05 µm; preserves host acetabular cartilage.',
      'Inner bearing: UHMWPE GUR 1050 with a durable PE-to-shell connection to prevent micro-motion.',
      'Outer diameter range 37–63 mm (22 sizes) — broad patient fit; 37–43 mm compatible with 22 mm heads, 44–63 mm with 28 mm heads.',
      'Various neck lengths to properly restore joint biomechanics.',
    ],
    uses: ['Hemiarthroplasty for femoral-neck fractures where the socket is healthy.'],
  ),
  ProductCard(
    sku: 'LATITUD™ Femoral Heads (CoCr / HNSS / Biolox® Delta)',
    generic: '12/14 modular heads in three materials',
    category: 'Femoral Heads — All Bearings',
    construction: '12/14 taper — Cobalt-Chromium, High Nitrogen Stainless Steel (ISO 5832-9) or Biolox® Delta composite ceramic',
    features: [
      'Biolox® Delta — mixed oxide alumina-zirconia ceramic; diamond-like hardness, lowest wear rates in class, outstanding biocompatibility.',
      'Biolox® Delta shows greater resistance to stripe wear than predecessor alumina.',
      'Larger Biolox® Delta diameters give improved range of motion and lower dislocation rates.',
      'CoCr modular heads — proven historical bearing partner with XLPE liners.',
      'HNSS heads per ISO 5832-9, Ra = 0.05 µm — cost-effective option for value segment.',
      'Multiple offsets so head length can be used intra-operatively to fine-tune offset and leg length.',
    ],
    uses: ['Modular heads via 12/14 taper; CoCr, stainless or Biolox® Delta ceramic in multiple offsets.'],
  ),
  ProductCard(
    sku: 'LATITUD™ MonoMod™ Revision Stem',
    generic: '"World\'s first monobloc-modular" Tapered Fluted Titanium (TFT) revision stem',
    category: 'Revision THR',
    construction: 'Tapered Fluted Titanium (TFT) with HA-coated neck and highly porous 3D-printed proximal femoral augments',
    features: [
      'Monobloc stem with no junction — carries no risk of breakage at a trunnion.',
      'Shoulder-Height Level (SHL) markings, a Bone Reference Mark (BRM) and a two-step PP/SS reaming-trialing process reproduce the soft-tissue balance usually needing modularity.',
      'Lateralised 2.5° taper geometry, 8–10 broad longitudinal ribs for rotational resistance, HA-coated neck.',
      'Smaller Ø12 & Ø13 sizes suit narrow / Asian anatomy.',
      'Constant-force stem applicators support reproducible insertion.',
      'Four lengths (L1–L4) with horizontal offset and length gradations.',
      'Highly porous 3D-printed proximal femoral augments back up fixation and unite a trochanteric fragment.',
    ],
    uses: ['Revision surgery; world-first monobloc-modular TFT stem with porous augments.'],
  ),
];

// Latitud design philosophy — the differentiators that frame Module 4.
const _m4DifferentiatorCards = <ProductCard>[
  ProductCard(
    sku: 'Freedom of choice',
    generic: 'Cemented and cementless stems, total and partial (bipolar) options and a revision stem on one familiar instrument philosophy',
    category: 'Design differentiator',
    features: [
      'Modular system lets the surgeon mix and match shell + liner + stem + head to suit the bone and the case.',
      'Cemented or cementless, total or partial — all on the same instrument platform.',
    ],
    uses: ['One philosophy across primary, partial and revision cases.'],
  ),
  ProductCard(
    sku: 'Revision innovation — MonoMod™',
    generic: 'World\'s first monobloc-modular TFT revision stem',
    category: 'Revision differentiator',
    features: [
      'Monobloc (no junction) eliminates the trunnion-breakage risk of modular designs.',
      'SHL/BRM + two-step reaming process reproduces soft-tissue balance without modularity.',
      'A clear talking point against modular-only revision systems.',
    ],
    uses: ['Revision: monobloc-modular TFT stem with porous augments.'],
  ),
  ProductCard(
    sku: 'Anatomic fit & offset',
    generic: 'Three neck angles and smaller revision sizes',
    category: 'Fit differentiator',
    features: [
      'Three neck angles (135° standard, 135° lateral, 125° coxa-vara) on the uncemented stem.',
      'Smaller Ø12 and Ø13 MonoMod revision sizes suit narrow / Asian anatomy.',
      'Modular heads in multiple offsets fine-tune offset and leg length intra-operatively.',
    ],
    uses: ['Engineered to fit a global patient population.'],
  ),
  ProductCard(
    sku: 'Material & coating choices',
    generic: 'HA-coated titanium, XLPE, Biolox® Delta ceramic',
    category: 'Material differentiator',
    features: [
      'Forged Ti-6Al-4V ELI alloy with full Osprovit® HA coating (~155 µm) on the uncemented stem.',
      'Highly cross-linked polyethylene (XLPE) liner with minimum ~5.5 mm wall in the main load area.',
      'Biolox® Delta ceramic heads available for low-wear bearings.',
    ],
    uses: ['Proven materials paired with modern coatings.'],
  ),
  ProductCard(
    sku: 'Value positioning',
    generic: 'Clinically proven designs at efficient instrumentation cost',
    category: 'Value differentiator',
    features: [
      'Clinically proven implant designs with simple, efficient and precise instrumentation.',
      'Particularly competitive in emerging markets and value-conscious settings.',
      'Versatile, optimised implant inventory reduces SKU overhead.',
    ],
    uses: ['Full performance with a focused, value-strong inventory.'],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Module 5 — Competitive Landscape
// ─────────────────────────────────────────────────────────────────────────────

final TablePage _m5CompetitorMatrix = TablePage(
  heading: 'Competitor matrix — flagship hip brands',
  columns: ['Company', 'Flagship hip brands', 'Robotic / enabling tech', 'Design signature'],
  rows: <List<String>>[
    ['Meril (Maxx) — Latitud', 'Uncemented / Cemented stems, Acetabular & Bipolar cups, MonoMod', 'MISSO platform', 'Freedom of choice; HA dual-taper; world-first monobloc-modular revision'],
    ['Zimmer Biomet', 'Taperloc, Avenir, Arcos (revision); G7 / Continuum cups', 'ROSA Hip', 'Broad portfolio; established tapered-wedge stems'],
    ['Stryker', 'Accolade II, Insignia, Restoration; Trident / Tritanium cups', 'Mako', 'Mako-led THA; dual-mobility (ADM); beta-Ti stems'],
    ['DePuy Synthes (J&J)', 'Corail, Actis, Summit; Pinnacle cup', 'VELYS', 'Corail HA stem heritage; Pinnacle modular cup'],
    ['Smith+Nephew', 'Polarstem, Anthology, Redapt (revision); R3 cup', 'CORI', 'Polished/HA stems; dual-mobility R3'],
    ['B. Braun / Aesculap', 'Excia, Metha (short); Plasmafit cup', 'OrthoPilot navigation', 'European; short-stem & navigation focus'],
    ['MicroPort Orthopedics', 'Profemur; Dynasty cup', '—', 'Modular-neck stem heritage'],
    ['Medacta', 'AMIStem, Quadra, MasterLoc; Mpact cup', 'NextAR / MySolutions', 'AMIS anterior approach ecosystem'],
    ['Corin', 'MiniHip, Metafix, Trinity cup', 'OPS / Apex', 'Optimised Positioning System (OPS) planning'],
    ['Exactech', 'Alteon; Logical cup', 'Active Intelligence / GPS', 'Guidance / data analytics'],
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// Source-mapping notes (per PDF)
// ─────────────────────────────────────────────────────────────────────────────

// Each module renders its source mapping in Module 6 so reviewers can trace
// content back to the original courseware pack. Sources used:
//
//   M1 — Anatomy: Meril Hip Training Manual (anatomy slides); hip-anatomy video
//        (YouTube qlCvKEOZtpo).
//   M2 — Why: Meril Hip Training Manual (arthritis, biomechanics, offset and
//        treatment-pathway slides).
//   M3 — How: Latitud Surgical Steps (Acetabular & Bipolar brochures); Meril
//        Hip Training Manual (approaches, templating).
//   M4 — Latitud: Latitud Acetabular Cup System; Bi-Polar Cup & Cemented Stem;
//        MonoMod Revision Stem brochures; Meril Hip Training Manual;
//        merillife.com.
//   M5 — Competitors: public manufacturer & registry / market sources
//        (Zimmer Biomet, Stryker, DePuy Synthes, Smith+Nephew, AAHKS implant
//        review, market analyses).

// ─────────────────────────────────────────────────────────────────────────────
// Topic
// ─────────────────────────────────────────────────────────────────────────────

final Topic thrTopic = Topic(
  id: 'thr',
  label: 'THR',
  icon: 'Activity',
  cert: 'THR Essentials — Latitud™ Hip System',
  passMark: 80,
  sections: <Section>[
    // ───────────────────────────────────────────────────────────────────────
    // MODULE 1 — Hip Anatomy Essentials
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm1_anatomy',
      title: 'Module 1 — Hip anatomy essentials',
      icon: 'BookOpen',
      blurb: 'Foundation module — ball-and-socket vocabulary, the anatomy video, bones & capsule.',
      color: sectionColorsHex[0],
      pages: <Page>[
        ReadPage(
          heading: 'Module 1 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Name the bones that form the hip joint and describe the ball-and-socket design.\n'
              '• Describe the role of the joint capsule and the three major ligaments.\n'
              '• Explain what articular cartilage and the labrum do.\n'
              '• Connect cartilage loss to osteoarthritis — the road to replacement.',
        ),
        ReadPage(
          heading: 'Screen 1.1 — The hip at a glance',
          body:
              'The hip is a ball-and-socket synovial (fluid-lubricated) joint — the second-largest joint in the body. It trades some mobility for stability and is built to carry the entire weight of the upper body through to the lower limbs with every step, which is why small changes in its structure have a big impact on function.\n\n'
              'Two bones meet at the hip: the femur (thigh bone), whose rounded head forms the "ball," and the pelvic acetabulum — a cup formed where the ilium, ischium and pubis fuse — which forms the "socket."',
        ),
        carouselPage(
          'Screen 1.1 — The hip at a glance',
          <String>[
            'Labelled hip anatomy — pelvis, labrum, cartilage, head of femur, acetabulum, capsule, ligament and joint fluid.',
            'Coronal section through the joint showing the femoral head seated in the acetabulum with cartilage and labrum in place.',
          ],
          assets: const <String?>[
            'assets/thr/m1_anatomy_labelled_overview.png',
            'assets/thr/m1_coronal_section_bones.png',
          ],
          credits: const <String?>[
            'Source: Hip Pain Professionals, 2018',
            'Source: anatomy learning deck',
          ],
        ),
        videoPlaceholderPage(
          'Screen 1.2 — Video: anatomy of the hip joint',
          title: 'Anatomy of the hip joint',
          description:
              'Watch the short anatomy video (≈4–5 min). It is the anchor for this module and gives you a visual reference for the rest of the course.\n\n'
              'Before you watch, look for: the ball and socket, where cartilage and the labrum sit, and how the capsule and ligaments hold everything together.\n\n'
              'After you watch, you should be able to: point to the femoral head, neck and acetabulum, and name the three capsular ligaments.',
          duration: '≈4–5 min',
          url: 'https://youtube.com/watch?v=qlCvKEOZtpo',
        ),
        ReadPage(
          heading: 'Screen 1.3 — The bones & the joint surfaces',
          body:
              '• Femoral head: the rounded "ball" that sits deep inside the socket; it carries a small central pit (fovea) for the ligamentum teres.\n'
              '• Femoral neck & trochanters: the neck links the head to the shaft at a neck-shaft (CCD) angle of about 125–135°; the greater and lesser trochanters are key muscle-attachment sites.\n'
              '• Acetabulum: the cup-shaped socket; its horseshoe-shaped lunate surface carries the articular cartilage.\n'
              '• Articular cartilage: a smooth, low-friction cap on both surfaces that lets the joint glide painlessly and absorb load.',
        ),
        anatomyPage('Screen 1.3 — The bones & joint surfaces', _m1BoneLayers),
        carouselPage(
          'Screen 1.3 — The five standard views of the proximal femur',
          <String>[
            '1. Superior view — head, fovea, greater and lesser trochanters, intertrochanteric line and trochanteric fossa.',
            '2. Anterior view — head, greater and lesser trochanters and shaft landmarks.',
            '3. Posterior view — head with fovea, greater and lesser trochanters, quadrate tubercle and pectineal (spiral) line.',
            '4. Lateral view — head, greater and lesser trochanters and shaft.',
            '5. Medial view — head with fovea, neck, end of intertrochanteric line and pectineal line.',
          ],
          assets: const <String?>[
            'assets/thr/m1_proximal_femur_superior.png',
            'assets/thr/m1_proximal_femur_anterior.png',
            'assets/thr/m1_proximal_femur_posterior.png',
            'assets/thr/m1_proximal_femur_lateral.png',
            'assets/thr/m1_proximal_femur_medial.png',
          ],
          credits: const <String?>[
            'Source: anatomy learning deck',
            'Source: anatomy learning deck',
            'Source: anatomy learning deck',
            'Source: anatomy learning deck',
            'Source: anatomy learning deck',
          ],
        ),
        ReadPage(
          heading: 'Screen 1.4 — The capsule & the three major ligaments (stability)',
          body:
              'A strong fibrous capsule surrounds the joint; thickenings of the capsule form three powerful ligaments that keep the head seated and resist unwanted movement.\n\n'
              '• Iliofemoral ligament: the strongest ligament in the body; "Y"-shaped, it prevents hyperextension at the front.\n'
              '• Pubofemoral ligament: reinforces the joint inferiorly and limits excess abduction and extension.\n'
              '• Ischiofemoral ligament: spirals across the back of the capsule and helps hold the femoral head in the socket.',
        ),
        anatomyPage('Screen 1.4 — The three capsular ligaments', _m1LigamentLayers),
        carouselPage(
          'Screen 1.4 — Capsule & three ligaments — anterior and posterior views',
          <String>[
            'Anterior view — iliofemoral and pubofemoral ligaments reinforcing the front of the capsule.',
            'Posterior view — ischiofemoral ligament spiralling across the back of the capsule.',
          ],
          assets: const <String?>[
            'assets/thr/m1_capsule_three_ligaments.png',
            'assets/thr/m1_capsule_three_ligaments.png',
          ],
          credits: const <String?>[
            'Source: Meril Hip Training Manual',
            'Source: Meril Hip Training Manual',
          ],
        ),
        ReadPage(
          heading: 'Screen 1.5 — Cartilage, labrum & cushioning',
          body:
              '• Acetabular labrum: a fibrocartilage collar around the socket rim that deepens the cup, improves stability and helps seal in synovial fluid.\n'
              '• Articular cartilage: the smooth gliding surface that lets the joint move quietly and with little friction.\n'
              '• When it wears out: cartilage thins and disappears, bone rubs on bone, and the result is pain, stiffness and reduced motion — the classic pattern of osteoarthritis and the start of the road to hip replacement.',
        ),
        ReadPage(
          heading: 'Module 1 — Quick check',
          body:
              'Q: Which is the strongest ligament in the body, and where does it sit on the hip?\n'
              'A: The iliofemoral ligament — at the front of the hip, preventing hyperextension.',
        ),
        ReadPage(
          heading: 'Module 1 — Key takeaways',
          body:
              '★ The hip is a ball-and-socket synovial joint: the femoral head is the ball, the acetabulum is the socket.\n'
              '★ A fibrous capsule and three ligaments (iliofemoral, pubofemoral, ischiofemoral) provide stability.\n'
              '★ Articular cartilage and the labrum cushion the joint and let it glide.\n'
              '★ Losing cartilage → bone-on-bone → osteoarthritis.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'What type of joint is the hip?', options: ['Hinge', 'Ball-and-socket', 'Pivot', 'Saddle'], correct: 1),
        Question(q: 'The "ball" of the hip joint is the…', options: ['Acetabulum', 'Femoral head', 'Greater trochanter', 'Pelvis'], correct: 1),
        Question(q: 'Which three bones fuse to form the acetabulum?', options: ['Ilium, ischium and pubis', 'Femur, tibia and patella', 'Scapula, humerus and clavicle', 'Sacrum, coccyx and lumbar vertebra'], correct: 0),
        Question(q: 'The strongest ligament in the body is the…', options: ['Pubofemoral', 'Ischiofemoral', 'Iliofemoral', 'Ligamentum teres'], correct: 2),
        Question(q: 'The fibrocartilage collar that deepens the socket is the…', options: ['Joint capsule', 'Labrum', 'Synovium', 'Bursa'], correct: 1),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 2 — Why Hip Replacement Is Done
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm2_why',
      title: 'Module 2 — Why hip replacement is done',
      icon: 'FileText',
      blurb: 'Turns anatomy into clinical need — osteoarthritis, biomechanics and the treatment pathway.',
      color: sectionColorsHex[1],
      pages: <Page>[
        ReadPage(
          heading: 'Module 2 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Explain what osteoarthritis does to the hip.\n'
              '• List the common reasons a THR is performed.\n'
              '• Understand offset, leg length and the neck-shaft (CCD) angle.\n'
              '• Place THR correctly in the orthopaedic treatment pathway.',
        ),
        ReadPage(
          heading: 'Screen 2.1 — What goes wrong',
          body:
              '• Healthy hip: smooth cartilage, an even joint space and a head that glides freely in the socket.\n'
              '• Arthritic hip: cartilage thins and disappears, the joint space narrows, bone spurs (osteophytes) form and the head loses its smooth contour.\n'
              '• What the patient feels: groin or buttock pain, a shorter walking distance, night pain, stiffness, a shortened limb and difficulty squatting or sitting cross-legged.',
        ),
        anatomyPage('Screen 2.1 — Healthy vs arthritic hip', _m2DiseaseLayers),
        carouselPage(
          'Screen 2.1 — Radiographs of arthritic hips',
          <String>[
            'Three radiographs of arthritic hips showing joint-space narrowing, sclerosis and loss of the round femoral head.',
            'The same views illustrating progressive joint-space narrowing and deformity of the head.',
          ],
          assets: const <String?>[
            'assets/thr/m2_arthritic_hips_xray.png',
            'assets/thr/m2_arthritic_hips_xray.png',
          ],
          credits: const <String?>[
            'Source: Meril Hip Training Manual',
            'Source: Meril Hip Training Manual',
          ],
        ),
        ReadPage(
          heading: 'Screen 2.2 — Why a hip replacement?',
          body:
              'A hip replacement (arthroplasty) resurfaces or replaces the worn joint with implant components to relieve pain, restore function and improve quality of life. It is considered when:\n\n'
              '• Advanced osteoarthritis / cartilage damage — the most common reason, especially when pain persists despite conservative care.\n'
              '• Rheumatoid or post-traumatic arthritis, where inflammation or previous injury has damaged the joint.\n'
              '• Avascular necrosis (death of the femoral head from disrupted blood supply).\n'
              '• Displaced femoral-neck fracture in older patients — often treated with hemiarthroplasty.\n'
              '• Severe, persistent pain and loss of mobility not relieved by non-surgical care.',
        ),
        ReadPage(
          heading: 'Screen 2.3 — Biomechanics the surgery must restore',
          body:
              'A good replacement does more than remove pain — it must rebuild the mechanics of the joint so the muscles work efficiently and the leg lengths match.\n\n'
              '• Offset: the horizontal distance from the centre of the femoral head to the femoral axis. Restoring offset keeps the abductor muscles tensioned, improving stability and reducing wear and limp.\n'
              '• Leg length: neck length and stem seating are chosen to avoid a leg-length discrepancy.\n'
              '• Neck-shaft (CCD) angle: normally 125–135°; a higher angle is valgus and a lower angle is varus, and the implant neck angle is selected to match.',
        ),
        carouselPage(
          'Screen 2.3 — Neutral, varus & valgus inclination (≈125–140°)',
          <String>[
            'Diagram of the proximal femur showing neutral inclination at ≈125–140°.',
            'Same view with varus and valgus deviation labelled — a higher angle is valgus, a lower angle is varus.',
          ],
          assets: const <String?>[
            'assets/thr/m2_inclination_varus_valgus.png',
            'assets/thr/m2_inclination_varus_valgus.png',
          ],
          credits: const <String?>[
            'Source: Meril Hip Training Manual',
            'Source: Meril Hip Training Manual',
          ],
        ),
        ReadPage(
          heading: 'Screen 2.4 — The treatment pathway — where THR fits',
          body:
              'Orthopaedic care is a ladder; surgery is the last rung, used when earlier steps stop controlling pain or restoring function:\n\n'
              '1. Conservative management — activity modification, weight management and basic exercise.\n'
              '2. Physiotherapy to improve strength, mobility and confidence in movement.\n'
              '3. Injections — e.g. corticosteroid — to calm inflammation.\n'
              '4. Medications — analgesics / anti-inflammatories — for short-term symptom control.\n'
              '5. Hip replacement — when conservative options are exhausted and the joint remains too painful or limited for daily life.',
        ),
        ReadPage(
          heading: 'Screen 2.4 — Total vs partial (Meril portfolio hook)',
          body:
              'When the socket cartilage is healthy and only the femoral head is the problem (typically a femoral-neck fracture), a hemiarthroplasty replaces just the head — Meril offers this as the Latitud Monoblock Bipolar System (Module 4).',
        ),
        ReadPage(
          heading: 'Module 2 — Quick check',
          body:
              'Q: What does "offset" mean, and why does restoring it matter?\n'
              'A: Offset is the horizontal distance from the femoral head centre to the femoral axis; restoring it keeps the abductors tensioned for stability and reduces limp and wear.',
        ),
        ReadPage(
          heading: 'Module 2 — Key takeaways',
          body:
              '★ Osteoarthritis = cartilage loss, joint-space narrowing, osteophytes, stiffness and pain.\n'
              '★ THR is done for advanced arthritis, AVN, fracture, severe pain and lost mobility.\n'
              '★ Surgery must restore offset, leg length and the neck-shaft angle, not just remove pain.\n'
              '★ Surgery is the final step after conservative care, physio, injections and medication.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'The most common reason for a total hip replacement is…', options: ['Rheumatoid arthritis', 'Osteoarthritis', 'Avascular necrosis', 'Femoral-neck fracture'], correct: 1),
        Question(q: 'A hemiarthroplasty is most often performed for…', options: ['Hip osteoarthritis', 'Displaced femoral-neck fracture in older patients', 'Labral tears', 'Snapping hip'], correct: 1),
        Question(q: 'The horizontal distance from the femoral head centre to the femoral axis is called…', options: ['Offset', 'Version', 'Inclination', 'Anteversion'], correct: 0),
        Question(q: 'The normal neck-shaft (CCD) angle is roughly…', options: ['90–100°', '105–115°', '125–135°', '150–160°'], correct: 2),
        Question(q: 'In the treatment pathway, THR is the…', options: ['First step', 'Second step', 'Final step', 'Always done immediately'], correct: 2),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 3 — How a Hip Replacement Is Done
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm3_how',
      title: 'Module 3 — How a hip replacement is done',
      icon: 'Stethoscope',
      blurb: 'A simplified walkthrough for product knowledge — not a surgical instruction manual.',
      color: sectionColorsHex[2],
      pages: <Page>[
        ReadPage(
          heading: 'Module 3 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Outline the major phases of a THR, in order.\n'
              '• State what is resurfaced or replaced and why.\n'
              '• Recognise the main surgical approaches and the role of templating.\n'
              '• Describe how the hemiarthroplasty and revision procedures differ.',
        ),
        ReadPage(
          heading: 'Screen 3.1 — The goal of surgery',
          body:
              'Surgery removes the worn joint and replaces it with implant components, then restores offset, leg length and stability so the hip is comfortable through its full range of motion. In a total hip replacement, two sides are reconstructed:',
        ),
        anatomyPage('Screen 3.1 — Two sides reconstructed', _m3ReconstructLayers),
        ReadPage(
          heading: 'Screen 3.1 — Two sides, one new joint',
          body:
              '• The socket — a metal acetabular shell with a polyethylene (or ceramic) liner that forms the new bearing surface.\n'
              '• The femur — a stem placed down the femoral canal, carrying a modular femoral head that articulates with the liner.',
        ),
        ReadPage(
          heading: 'Screen 3.2 — Step 1: planning & templating',
          body:
              '• Physical exam: hip range of motion, leg length, stability and deformity, so the surgeon understands how the joint behaves before planning.\n'
              '• Pre-operative templating on an AP X-ray estimates implant size, the level of the neck cut, offset and leg-length correction; the final size is confirmed during surgery.\n'
              '• Reference the femoral head centre and key radiographic landmarks to plan cup position and femoral fit.',
        ),
        ReadPage(
          heading: 'Screen 3.3 — Step 2: exposure & approach',
          body:
              'The hip joint is reached through one of several standard approaches; the choice depends on surgeon preference, anatomy and dislocation risk:',
        ),
        anatomyPage('Screen 3.3 — Standard surgical approaches', _m3ApproachLayers),
        carouselPage(
          'Screen 3.3 — Patient positioning for the procedure',
          <String>[
            'Patient positioning on the operating table in the lateral decubitus position for a posterior approach.',
            'Patient supine for a direct anterior approach.',
          ],
          assets: const <String?>[
            'assets/thr/m3_patient_positioning.png',
            'assets/thr/m3_patient_positioning.png',
          ],
          credits: const <String?>[
            'Source: Latitud Surgical Steps',
            'Source: Latitud Surgical Steps',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.4 — Step 3: femoral neck resection',
          body:
              'The femoral neck is cut at the level set during templating (commonly 1–2 cm above the lesser trochanter) so the head can be removed. The cut is made perpendicular to the neck; the femoral head is then removed with a corkscrew.',
        ),
        carouselPage(
          'Screen 3.4 — Femoral neck cut & head removal',
          <String>[
            'Femoral neck cut with an oscillating saw at the templated level.',
            'Femoral head removed with a corkscrew extractor.',
          ],
          assets: const <String?>[
            'assets/thr/m3_femoral_neck_cut.png',
            'assets/thr/m3_femoral_head_removed.png',
          ],
          credits: const <String?>[
            'Source: Latitud Surgical Steps',
            'Source: Latitud Surgical Steps',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.5 — Step 4: acetabular (socket) preparation',
          body:
              'The socket is reamed in increasing sizes until healthy bleeding bone is reached and the hemispherical shape matches the chosen shell.\n\n'
              '• Press-fit: the cementless shell is slightly larger than the last reamer so it wedges firmly into bone; supplementary screws can be added for extra fixation.\n'
              '• A polyethylene, ceramic or metal liner is then locked into the shell to form the bearing surface.',
        ),
        carouselPage(
          'Screen 3.5 — Acetabular reaming',
          <String>[
            'Acetabular reamer preparing the socket to the planned hemispherical shape.',
          ],
          assets: const <String?>[
            'assets/thr/m3_acetabular_reaming.png',
          ],
          credits: const <String?>[
            'Source: Latitud Surgical Steps',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.6 — Step 5: femoral (stem) preparation',
          body:
              'The femoral canal is opened with a box chisel and prepared with reamers, then shaped with broaches / rasps of increasing size until a stable fit is achieved.',
        ),
        carouselPage(
          'Screen 3.6 — Femoral broaching / rasping',
          <String>[
            'Broaching the proximal femur to shape the canal for the chosen stem size.',
          ],
          assets: const <String?>[
            'assets/thr/m3_femoral_broaching.png',
          ],
          credits: const <String?>[
            'Source: Latitud Surgical Steps',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.7 — Step 6: trialing, head selection & final implantation',
          body:
              'Trial components and trial heads are used to check stability, range of motion, leg length and offset before final parts are fitted.\n\n'
              '• Head selection: the modular head length (offset) is chosen here to fine-tune leg length and soft-tissue tension.\n'
              '• Fixation: the definitive stem is fixed cementless (press-fit, relying on bone in-growth into the HA / porous surface) or cemented; the head is then impacted onto the taper and the joint reduced.',
        ),
        carouselPage(
          'Screen 3.7 — Trial head and sizing / introducer',
          <String>[
            'Trial head on the introducer used to confirm fit, offset and stability before final implantation.',
          ],
          assets: const <String?>[
            'assets/thr/m3_trial_head_sizing.png',
          ],
          credits: const <String?>[
            'Source: Latitud Surgical Steps',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.8 — Variation: hemiarthroplasty (partial hip)',
          body:
              'When only the femoral head needs replacing — most often a displaced femoral-neck fracture in an older patient — a hemiarthroplasty is performed. The socket is left alone; the femoral side is prepared as above, but instead of articulating against a liner, a bipolar head (a head within a mobile outer cup) articulates directly against the patient\'s own cartilage.',
        ),
        ReadPage(
          heading: 'Screen 3.9 — Variation: revision THR',
          body:
              'When a previous implant loosens, wears or is associated with bone loss, a revision is performed. It removes the old components and reconstructs lost bone, often using a longer stem that gains fixation further down the femur.\n\n'
              'Revision technique — the MonoMod two-step: Meril\'s MonoMod revision stem uses a two-step reaming / trialing process — primary provisional (PP) then secondary scratch-fit (SS) — together with Shoulder-Height Level (SHL) and Bone Reference Mark (BRM) concepts and constant-force stem applicators, so a monobloc stem can achieve the precise soft-tissue balance usually associated with modular designs (Module 4).',
        ),
        ReadPage(
          heading: 'Module 3 — Quick check',
          body:
              'Q: In a total hip replacement, which two sides are reconstructed, and how does a hemiarthroplasty differ?\n'
              'A: Both the socket (shell + liner) and the femur (stem + head) are reconstructed. A hemiarthroplasty replaces only the femoral head — the socket is left alone and a bipolar head articulates against the native cartilage.',
        ),
        ReadPage(
          heading: 'Module 3 — Key takeaways',
          body:
              '★ THR rebuilds two sides: an acetabular shell + liner, and a femoral stem + modular head.\n'
              '★ Order: plan / template → expose (posterior, lateral or anterior) → neck cut → ream socket → broach femur → trial → implant.\n'
              '★ Stems are fixed cementless (press-fit / bone in-growth) or cemented; head length sets offset and leg length.\n'
              '★ Hemiarthroplasty replaces only the head; revision reconstructs bone loss, often with a longer stem.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'In a total hip replacement, which two sides are reconstructed?', options: ['Femur only', 'Socket + femur', 'Pelvis only', 'Cartilage + labrum'], correct: 1),
        Question(q: 'Which procedure replaces only the femoral head, leaving the socket intact?', options: ['Total hip replacement', 'Hip resurfacing', 'Hemiarthroplasty (bipolar)', 'Core decompression'], correct: 2),
        Question(q: 'Cementless Latitud stems gain fixation mainly through…', options: ['Bone cement only', 'Press-fit and bone in-growth into the HA / porous coating', 'Screws through the cortex', 'Ligament reconstruction'], correct: 1),
        Question(q: 'Which surgical approach is described as the most common in the PDF?', options: ['Anterior (Smith-Petersen)', 'Direct lateral (Hardinge)', 'Posterior (Moore / Southern)', 'Posterolateral with trochanteric flip'], correct: 2),
        Question(q: 'Head length (offset) is selected during which step?', options: ['Planning', 'Exposure', 'Trialing', 'Wound closure'], correct: 2),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 4 — Meril's Hip Portfolio: the Latitud™ Family
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm4_latitud',
      title: 'Module 4 — Meril\'s hip portfolio: the Latitud™ family',
      icon: 'Layers',
      blurb: 'Maps the Latitud product family onto the procedure and explains what each variant adds.',
      color: sectionColorsHex[3],
      pages: <Page>[
        ReadPage(
          heading: 'Module 4 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Explain Meril\'s position in orthopaedics and the Maxx relationship.\n'
              '• Describe the Latitud design philosophy and its differentiators.\n'
              '• Identify each member of the Latitud hip family and when it is used.\n'
              '• Recall the MonoMod revision stem\'s headline claim.',
        ),
        ReadPage(
          heading: 'Screen 4.1 — Meril in orthopaedics',
          body:
              '• Who: Meril Life Sciences is a global medical-device company headquartered in Vapi, India, with an expanding orthopaedics presence.\n'
              '• The Maxx link: Meril Orthopedics operates in association with Maxx Ortho Inc.; together they develop and market joint-replacement systems used in 40+ countries.\n'
              '• The promise: "combining long-term clinically proven implant designs with simple, efficient and precise instrumentation, plus a versatile, optimised implant inventory."\n\n'
              'For this course: treat Latitud as Meril\'s flagship hip brand — a "freedom of choice" system spanning cemented and cementless THR, hemiarthroplasty and revision.',
        ),
        ReadPage(
          heading: 'Screen 4.2 — The Latitud system at a glance',
          body:
              'Latitud is a modular system that lets the surgeon mix and match a shell, liner, stem and head to suit the bone and the case — cemented or cementless, total or partial.',
        ),
        carouselPage(
          'Screen 4.2 — The Latitud system at a glance',
          <String>[
            'The Latitud Hip System — acetabular shell, cross-linked liner and uncemented femoral stem.',
          ],
          assets: const <String?>[
            'assets/thr/m4_cover_latitud_system.png',
          ],
          credits: const <String?>[
            'Source: Latitud Acetabular Cup System brochure',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.3 — The uncemented (cementless) femoral stem',
          body:
              '• Material & coating: forged Ti-6Al-4V ELI alloy with full Osprovit® hydroxyapatite (HA) coating (~155 µm) applied by plasma spraying to promote early osteo-integration.\n'
              '• Dual-taper trapezoidal design: vertical and horizontal grooves resist rotational and axial loading and prevent subsidence.\n'
              '• Choice of geometry: 11 sizes with 135° standard, 135° lateral (high-offset) and 125° coxa-vara neck angles for lateralisation and varied anatomy.\n'
              '• Why titanium: its low modulus of elasticity reduces stiffness mismatch with bone and helps reduce thigh pain.',
        ),
        carouselPage(
          'Screen 4.3 — The uncemented HA-coated dual-taper stem',
          <String>[
            'The Latitud uncemented, HA-coated, dual-taper femoral stem.',
          ],
          assets: const <String?>[
            'assets/thr/m4_uncemented_stem.png',
          ],
          credits: const <String?>[
            'Source: Latitud brochure',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.4 — The acetabular cup system',
          body:
              '• Press-fit shell: a hemispherical, titanium-coated forged-Ti shell; oversized ~1.3 mm at the rim so press-fit occurs just below the acetabular bone margin to aid retention and stability.\n'
              '• Liner: highly cross-linked polyethylene (XLPE), with a minimum ~5.5 mm wall in the main load area for low wear; ceramic and other options exist.\n'
              '• Fixation options: no-hole or multi-hole shells; supplementary bone screws available for additional fixation.',
        ),
        carouselPage(
          'Screen 4.4 — The acetabular cup system',
          <String>[
            'Shell interior with screw holes for additional fixation.',
            'Press-fit shell geometry — hemispherical with oversized rim for press-fit retention.',
          ],
          assets: const <String?>[
            'assets/thr/m4_cup_interior_screwholes.png',
            'assets/thr/m4_pressfit_shell.png',
          ],
          credits: const <String?>[
            'Source: Latitud Acetabular Cup System brochure',
            'Source: Latitud Acetabular Cup System brochure',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.5 — The cemented femoral stem',
          body:
              '• Design: a polished, dual-tapered stem based on the loaded-taper principle, with biomechanics proven over more than three decades of clinical use.\n'
              '• When it is used: older or osteoporotic bone, where immediate cement fixation gives reliable early stability.\n'
              '• System support: centraliser and cement-restrictor accessories and depth-marked instruments support a controlled cementing technique.',
        ),
        carouselPage(
          'Screen 4.5 — The polished, dual-tapered Latitud cemented stem',
          <String>[
            'The polished, dual-tapered Latitud cemented stem — collarless neck for leg-length adjustment.',
          ],
          assets: const <String?>[
            'assets/thr/m4_cemented_stem.png',
          ],
          credits: const <String?>[
            'Source: Latitud Cemented Stem brochure',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.6 — Femoral heads, liners & the bipolar (hemi) option',
          body:
              '• Modular heads: available in CoCr, stainless and Biolox® Delta ceramic, in several offsets, connecting via a 12/14 taper; head length is used intra-operatively to fine-tune offset and leg length.\n'
              '• Bipolar system: the Latitud Monoblock Bipolar System provides a head-within-a-cup for hemiarthroplasty — used mainly for femoral-neck fractures where the socket is healthy.',
        ),
        carouselPage(
          'Screen 4.6 — The Latitud bipolar construct',
          <String>[
            'The Latitud bipolar construct — outer cup, inner head and stem trunnion.',
          ],
          assets: const <String?>[
            'assets/thr/m4_bipolar_construct.png',
          ],
          credits: const <String?>[
            'Source: Latitud Bi-Polar Cup System brochure',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.7 — The MonoMod™ revision stem — "world\'s first monobloc-modular"',
          body:
              'For revision surgery, Meril\'s MonoMod is a Tapered Fluted Titanium (TFT) revision stem designed (with Dr Vijay C. Bose) to combine the advantages of monobloc and modular TFT stems while eliminating their disadvantages — it is a monobloc stem with no junction, so it carries no risk of breakage at a trunnion.\n\n'
              'How it stays precise: Shoulder-Height Level (SHL) markings, a Bone Reference Mark (BRM), a two-step PP/SS reaming-trialing process and constant-force stem applicators reproduce the soft-tissue balance usually needing modularity.\n\n'
              'Stability features: lateralised 2.5° taper geometry, 8–10 broad longitudinal ribs for rotational resistance, and an HA-coated neck; smaller Ø12 & Ø13 sizes suit narrow / Asian anatomy.\n\n'
              'Bone support: highly porous 3D-printed proximal femoral augments are available to back up fixation and unite a trochanteric fragment.',
        ),
        carouselPage(
          'Screen 4.7 — The MonoMod revision stem',
          <String>[
            'MonoMod revision stem — single-piece TFT with HA-coated neck and porous proximal body.',
            'MonoMod revision stem — four lengths (L1–L4) with horizontal offset and length gradations.',
          ],
          assets: const <String?>[
            'assets/thr/m4_monomod_revision_stem.png',
            'assets/thr/m4_monomod_four_lengths.png',
          ],
          credits: const <String?>[
            'Source: Latitud MonoMod Revision Stem brochure',
            'Source: Latitud MonoMod Revision Stem brochure',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.8 — The Latitud family — when to use what',
          body:
              'The Latitud portfolio spans primary, hemi, revision and bearing options. Each member addresses a specific patient or surgical need; tap a brand to expand its positioning and key selling points.',
        ),
        cardsPage('Screen 4.8 — The Latitud family — product map', _m4FamilyCards),
        ReadPage(
          heading: 'Screen 4.9 — How Latitud differentiates',
          body:
              'Latitud competes on freedom of choice, the monobloc-modular revision stem, anatomic fit and value — not on having its own robot. Position to strengths.',
        ),
        cardsPage('Screen 4.9 — Latitud differentiators', _m4DifferentiatorCards),
        ReadPage(
          heading: 'Module 4 — Quick check',
          body:
              'Q: What makes the MonoMod revision stem unusual, and what is its headline claim?\n'
              'A: It is the world\'s first monobloc-modular TFT revision stem — a monobloc (no junction, so no trunnion breakage) that still achieves modular-level soft-tissue balance via SHL / BRM and a two-step reaming process.',
        ),
        ReadPage(
          heading: 'Module 4 — Key takeaways',
          body:
              '★ Latitud is Meril\'s "freedom of choice" hip brand, developed with Maxx Ortho.\n'
              '★ It spans cementless and cemented stems, a press-fit acetabular cup, a bipolar hemi system and the MonoMod revision stem.\n'
              '★ Differentiators: HA-coated dual-taper stems, multiple neck angles for offset, XLPE liners and Biolox® Delta ceramic heads.\n'
              '★ MonoMod is the world\'s first monobloc-modular TFT revision stem, with 3D-printed porous augments.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'The Latitud Uncemented Stem has how many neck-angle options?', options: ['One', 'Two', 'Three', 'Four'], correct: 2),
        Question(q: 'Latitud cementless stems gain fixation mainly through…', options: ['Bone cement only', 'Press-fit and bone in-growth into the HA / porous coating', 'Screws through the cortex', 'Soft-tissue tension'], correct: 1),
        Question(q: 'The Latitud bipolar system is used mainly for…', options: ['Hip osteoarthritis', 'Femoral-neck fractures (hemiarthroplasty)', 'Labral tears', 'Acetabular dysplasia'], correct: 1),
        Question(q: 'What is unique about Meril\'s MonoMod revision stem?', options: ['It is the only cemented revision stem', 'It is the world\'s first monobloc-modular TFT revision stem', 'It uses a ceramic head', 'It cannot be combined with porous augments'], correct: 1),
        Question(q: 'The modular heads connect to the stem via which taper?', options: ['8/10', '10/12', '12/14', '14/16'], correct: 2),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 5 — Competitive Landscape
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm5_competition',
      title: 'Module 5 — Competitive landscape',
      icon: 'GitBranch',
      blurb: 'Names, robots and design philosophies — and how Latitud differentiates.',
      color: sectionColorsHex[4],
      pages: <Page>[
        ReadPage(
          heading: 'Module 5 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Name the major global hip manufacturers and their flagship hip brands.\n'
              '• Match each company to its robotic / enabling platform.\n'
              '• Articulate how Latitud differentiates.',
        ),
        ReadPage(
          heading: 'Screen 5.1 — The "Big Four" and the field',
          body:
              '• Market leaders: in hips, Zimmer Biomet (~25%), Stryker (~24%) and DePuy Synthes / J&J (~21%) lead, followed by Smith+Nephew (~9%) — together roughly 80% of the global market.\n'
              '• Other notable players: B. Braun / Aesculap, MicroPort Orthopedics, Medacta, Corin and Exactech, each with a regional or design emphasis.\n'
              '• Where Meril (Latitud) plays: a design-differentiated, value-strong global challenger — particularly competitive in emerging markets and value-conscious settings, and notable for its monobloc-modular revision stem.',
        ),
        _m5CompetitorMatrix,
        ReadPage(
          heading: 'Screen 5.2 — How Latitud differentiates',
          body:
              'Freedom of choice: cemented and cementless stems, total and partial (bipolar) options and a revision stem on one familiar instrument philosophy.\n\n'
              'Revision innovation: the MonoMod is the world\'s first monobloc-modular TFT revision stem — a clear talking point against modular-only revision systems.\n\n'
              'Anatomic fit & offset: three neck angles (135° standard, 135° lateral, 125° coxa-vara) and smaller Ø12 / Ø13 revision sizes suit narrow / Asian anatomy.\n\n'
              'Value: clinically proven designs and efficient instrumentation positioned for value-conscious and emerging markets.',
        ),
        ReadPage(
          heading: 'Screen 5.3 — Be honest in the field',
          body:
              'The Big Four lead on robotic ecosystems and registry volume. Latitud competes on design choice, the monobloc-modular revision stem, anatomic fit and value — position to strengths.',
        ),
        ReadPage(
          heading: 'Module 5 — Quick check',
          body:
              'Q: Match the platform to the maker: Mako, ROSA Hip, VELYS, CORI.\n'
              'A: Mako = Stryker; ROSA Hip = Zimmer Biomet; VELYS = DePuy Synthes; CORI = Smith+Nephew.',
        ),
        ReadPage(
          heading: 'Module 5 — Key takeaways',
          body:
              '★ Hip Big Four: Zimmer Biomet (Taperloc / Avenir), Stryker (Accolade II), DePuy (Corail / Actis), Smith+Nephew (Polarstem).\n'
              '★ Platforms: Mako / ROSA Hip / VELYS / CORI respectively.\n'
              '★ Latitud differentiates on freedom of choice, the monobloc-modular revision stem, anatomic fit and value.\n'
              '★ The leaders win on robotics and registry data — position Latitud to design and value strengths.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'Which company makes the Accolade hip stem, and what is its robot?', options: ['Zimmer Biomet; ROSA Hip', 'Stryker; Mako', 'DePuy Synthes; VELYS', 'Smith+Nephew; CORI'], correct: 1),
        Question(q: 'Zimmer Biomet\'s hip robotic platform is called…', options: ['Mako', 'ROSA Hip', 'VELYS', 'CORI'], correct: 1),
        Question(q: 'Latitud\'s MonoMod revision stem is positioned as the…', options: ['Only cemented revision stem', 'World\'s first monobloc-modular TFT revision stem', 'Only short-stem revision stem', 'Only ceramic-on-ceramic revision stem'], correct: 1),
        Question(q: 'Which competitor is most associated with the AMIS anterior approach ecosystem?', options: ['Zimmer Biomet', 'Stryker', 'Medacta', 'MicroPort Orthopedics'], correct: 2),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 6 — Knowledge Check + Glossary + Source mapping
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm6_quiz',
      title: 'Module 6 — Knowledge check, glossary & references',
      icon: 'ClipboardList',
      blurb: 'Final-module knowledge check plus a glossary and source map for review and traceability.',
      color: sectionColorsHex[5],
      pages: <Page>[
        ReadPage(
          heading: 'Module 6 — How this works',
          body:
              'Fifteen questions spanning all five modules. The same bank — with options, correct answers and answer-level feedback — is on the Quiz Bank tab of the source workbook, formatted for import and ready to support LMS upload.\n\n'
              'Suggested pass mark: 80%.',
        ),
        ReadPage(
          heading: 'Glossary — quick reference',
          body:
              '• Arthroplasty: surgical resurfacing / replacement of a joint.\n'
              '• Acetabulum: the cup-shaped socket of the pelvis.\n'
              '• Femoral head / neck: the "ball" and the bridge that links it to the femoral shaft.\n'
              '• Articular cartilage: smooth cap on bone ends that lets the joint glide.\n'
              '• Labrum: fibrocartilage rim that deepens the socket and adds stability.\n'
              '• Iliofemoral / pubofemoral / ischiofemoral: the three capsular ligaments of the hip.\n'
              '• Osteoarthritis: wear-and-tear loss of cartilage causing pain and stiffness.\n'
              '• Osteophyte: a bone spur that forms in an arthritic joint.\n'
              '• AVN: avascular necrosis — death of the femoral head from lost blood supply.\n'
              '• Offset: horizontal distance from femoral head centre to femoral axis.\n'
              '• CCD angle: caput-collum-diaphyseal (neck-shaft) angle, normally 125–135°.\n'
              '• Press-fit: fixation by wedging a slightly oversized component into bone.\n'
              '• HA coating: hydroxyapatite coating that promotes bone in-growth.\n'
              '• XLPE: highly cross-linked polyethylene — the liner material.\n'
              '• Bipolar / hemiarthroplasty: partial hip replacement of the femoral head only.\n'
              '• Revision: surgery to replace a failed or loosened implant.\n'
              '• TFT: Tapered Fluted Titanium — the MonoMod revision-stem family.\n'
              '• SHL / BRM: Shoulder-Height Level / Bone Reference Mark (MonoMod technique).\n'
              '• THR / THA: Total Hip Replacement / Arthroplasty.',
        ),
        ReadPage(
          heading: 'Source mapping & references',
          body:
              'Each module is grounded in the supplied Meril / Latitud materials, supplemented by public manufacturer information for the competitor section. All embedded diagrams and renders are drawn from the sources below and selected to match the teaching point on the page.\n\n'
              '• Module 1 — Anatomy: Meril Hip Training Manual (anatomy slides); hip-anatomy video (YouTube qlCvKEOZtpo).\n'
              '• Module 2 — Why: Meril Hip Training Manual (arthritis, biomechanics, offset and treatment-pathway slides).\n'
              '• Module 3 — How: Latitud Surgical Steps (Acetabular & Bipolar brochures); Meril Hip Training Manual (approaches, templating).\n'
              '• Module 4 — Latitud: Latitud Acetabular Cup System; Bi-Polar Cup & Cemented Stem; MonoMod Revision Stem brochures; Meril Hip Training Manual; merillife.com.\n'
              '• Module 5 — Competitors: public manufacturer & registry / market sources (Zimmer Biomet, Stryker, DePuy Synthes, Smith+Nephew, AAHKS implant review, market analyses).\n\n'
              'Note on accuracy: Competitor brand and platform names reflect public information current at the time of writing and should be re-verified before publishing, as portfolios change. Clinical and design claims are quoted from Meril / Maxx materials and should carry their original citations in the published course.',
        ),
        videoPlaceholderPage(
          'Module 6 — Course wrap-up video',
          title: 'THR Essentials — course recap',
          description:
              'A 4–6 minute wrap-up that walks through the six modules in one sitting: anatomy, why, how, the Latitud family, competitive positioning and the knowledge check. Useful as a quick refresher after the course is complete.',
          duration: '≈4–6 min',
        ),
      ],
      quiz: <Question>[
        Question(q: 'What type of joint is the hip?', options: ['Hinge', 'Ball-and-socket synovial', 'Pivot', 'Saddle'], correct: 1),
        Question(q: 'The "ball" of the hip joint is the … and the "socket" is the …', options: ['Femoral head; acetabulum', 'Greater trochanter; lesser trochanter', 'Iliac crest; pubic symphysis', 'Tibia; talus'], correct: 0),
        Question(q: 'Which three bones fuse to form the acetabulum?', options: ['Ilium, ischium and pubis', 'Femur, tibia and patella', 'Scapula, humerus and clavicle', 'Sacrum, coccyx and lumbar vertebra'], correct: 0),
        Question(q: 'Which is the strongest ligament in the body?', options: ['Pubofemoral', 'Ischiofemoral', 'Iliofemoral', 'Ligamentum teres'], correct: 2),
        Question(q: 'The fibrocartilage collar that deepens the socket is the …', options: ['Joint capsule', 'Labrum', 'Synovium', 'Bursa'], correct: 1),
        Question(q: 'The most common reason for a total hip replacement is …', options: ['Rheumatoid arthritis', 'Osteoarthritis', 'Osteonecrosis', 'Fracture'], correct: 1),
        Question(q: 'The horizontal distance from the femoral head centre to the femoral axis is called …', options: ['Version', 'Offset', 'Inclination', 'Anteversion'], correct: 1),
        Question(q: 'The normal neck-shaft (CCD) angle is roughly …', options: ['125–135°', '85–95°', '60–70°', '150–160°'], correct: 0),
        Question(q: 'In a total hip replacement, which two components form the new socket?', options: ['Femoral stem + head', 'Acetabular shell + liner', 'Modular neck + cup', 'PE liner + bone screw'], correct: 1),
        Question(q: 'Which procedure replaces only the femoral head, leaving the socket intact?', options: ['Total hip replacement', 'Hip resurfacing', 'Hemiarthroplasty (bipolar)', 'Core decompression'], correct: 2),
        Question(q: 'Cementless Latitud stems gain fixation mainly through …', options: ['Bone cement', 'Press-fit and bone in-growth into the HA / porous coating', 'Screws only', 'Soft-tissue repair'], correct: 1),
        Question(q: 'The Latitud bipolar system is used mainly for …', options: ['Hip osteoarthritis', 'Femoral-neck fractures (hemiarthroplasty)', 'Labral tears', 'Acetabular dysplasia'], correct: 1),
        Question(q: 'What is unique about Meril\'s MonoMod revision stem?', options: ['It is the only cemented revision stem', 'It is the world\'s first monobloc-modular TFT revision stem', 'It uses a ceramic head', 'It cannot be combined with augments'], correct: 1),
        Question(q: 'Which company makes the Accolade hip stem, and what is its robot?', options: ['Zimmer Biomet; ROSA Hip', 'Stryker; Mako', 'DePuy Synthes; VELYS', 'Smith+Nephew; CORI'], correct: 1),
        Question(q: 'Zimmer Biomet\'s hip robotic platform is called …', options: ['Mako', 'ROSA Hip', 'VELYS', 'CORI'], correct: 1),
      ],
    ),
  ],
  exam: thrExam,
);