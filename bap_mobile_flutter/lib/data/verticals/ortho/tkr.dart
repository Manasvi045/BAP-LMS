// lib/data/verticals/ortho/tkr.dart — Total Knee Replacement topic.
//
// Content migrated from the PDF courseware pack "TKR Essentials — Freedom® Knee
// · Meril L&D". The pack is structured as six modules:
//
//   M1 Knee Anatomy Essentials
//   M2 Why Knee Replacement Is Done
//   M3 How a Knee Replacement Is Done
//   M4 Meril's Knee Portfolio — the Freedom® Family
//   M5 Competitive Landscape
//   M6 Knowledge Check (Quiz) + Glossary
//
// All teaching copy, video placeholders and image carousels mirror the PDF's
// flow one-to-one. Real image assets and video URLs are intentionally left as
// `null` so the carousel and video-placeholder components render their built-in
// fallback layouts; drop the real paths in later without any code change.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Module 1 — Knee Anatomy Essentials
// ─────────────────────────────────────────────────────────────────────────────

const _m1BoneLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Femur (thigh bone)', color: '#fde68a', desc: 'Its two rounded condyles form the top of the joint and provide the main upper bearing surface.'),
  AnatomyLayer(name: 'Tibia (shin bone)', color: '#fed7aa', desc: 'Its flat plateau forms the base the femur rolls on and carries most of the body’s load.'),
  AnatomyLayer(name: 'Patella (kneecap)', color: '#fef9c3', desc: 'Sits in front and glides in the femur’s trochlear groove, protecting the joint and improving leverage of the quadriceps muscle during extension.'),
  AnatomyLayer(name: 'Articular cartilage', color: '#bae6fd', desc: 'A smooth, low-friction cap on the bone ends that lets the surfaces glide painlessly and absorb everyday wear.'),
];

const _m1LigamentLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'ACL — Anterior Cruciate Ligament', color: '#fca5a5', desc: 'Stops the tibia sliding forward and helps control front-to-back stability.'),
  AnatomyLayer(name: 'PCL — Posterior Cruciate Ligament', color: '#fbcfe8', desc: 'Stops the tibia sliding backward and supports posterior stability.'),
  AnatomyLayer(name: 'MCL — Medial Collateral Ligament', color: '#ddd6fe', desc: 'Stabilises the inner (medial) side and helps resist valgus stress.'),
  AnatomyLayer(name: 'LCL — Lateral Collateral Ligament', color: '#c7d2fe', desc: 'Stabilises the outer (lateral) side and helps resist varus stress.'),
];

const _m1CushioningLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Medial meniscus', color: '#a7f3d0', desc: 'C-shaped fibrocartilage pad on the inside of the joint — shock absorber and load distributor.'),
  AnatomyLayer(name: 'Lateral meniscus', color: '#bbf7d0', desc: 'C-shaped fibrocartilage pad on the outside of the joint — adds stability and dissipates load.'),
  AnatomyLayer(name: 'Articular cartilage', color: '#bae6fd', desc: 'Smooth gliding cap on the bone ends. When it wears out, bone rubs on bone — the start of osteoarthritis.'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Module 2 — Why Knee Replacement Is Done
// ─────────────────────────────────────────────────────────────────────────────

const _m2DiseaseLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Healthy cartilage', color: '#bbf7d0', desc: 'Smooth, even joint space with a thick gliding surface and minimal friction.'),
  AnatomyLayer(name: 'Cartilage thinning', color: '#fde68a', desc: 'Cartilage thins and disappears; the joint space narrows — the earliest sign of osteoarthritis.'),
  AnatomyLayer(name: 'Osteophytes', color: '#fca5a5', desc: 'Bone spurs form at the joint margins as the body tries to compensate for lost cartilage.'),
  AnatomyLayer(name: 'Thickened synovium', color: '#fecaca', desc: 'The joint lining becomes inflamed and thickened, contributing to pain and swelling.'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Module 3 — How a Knee Replacement Is Done — surgical phases
// ─────────────────────────────────────────────────────────────────────────────

const _m3ResurfacedCards = <ProductCard>[
  ProductCard(
    sku: 'Femoral component',
    generic: 'End of femur (metal)',
    category: 'Femoral cap',
    construction: 'Cobalt-chromium alloy',
    features: [
      'Recreates the upper joint surface with a contoured metal cap.',
      'Multi-radius geometry follows the natural arc of motion.',
      'Cemented fixation is standard; cementless options are available.',
    ],
    uses: ['Replaces the worn articular surface of the distal femur.'],
  ),
  ProductCard(
    sku: 'Tibial baseplate',
    generic: 'Top of tibia (metal)',
    category: 'Tibial platform',
    construction: 'Titanium or CoCr alloy',
    features: [
      'Flat platform that supports the polyethylene insert.',
      'Stem or keel for stable fixation into the tibial metaphysis.',
      'Available as metal-backed or all-polyethylene tibial construct.',
    ],
    uses: ['Anchors the new tibial surface to the proximal tibia.'],
  ),
  ProductCard(
    sku: 'Polyethylene insert',
    generic: 'Spacer (plastic)',
    category: 'Bearing surface',
    construction: 'UHMWPE (GUR 1020)',
    features: [
      'Provides the articulating bearing surface between the femur and tibia.',
      'Available thicknesses 9, 11, 14, 17 mm to fine-tune gap balance.',
      'CR, PS, UC and MC insert options match stability and motion goals.',
    ],
    uses: ['The new gliding surface that absorbs and transmits load.'],
  ),
  ProductCard(
    sku: 'Patellar button',
    generic: 'Back of patella (plastic)',
    category: 'Patella (optional)',
    construction: 'UHMWPE dome',
    features: [
      'Dome-shaped polyethylene component cemented onto the resected patella.',
      'Resurfacing is optional — depends on surgeon preference and bone quality.',
      'Minimum 8 mm of residual patellar bone should be retained.',
    ],
    uses: ['Improves patellar tracking and reduces anterior knee pain.'],
  ),
];

const _m3InsertCards = <ProductCard>[
  ProductCard(
    sku: 'CR — Cruciate-Retaining',
    generic: 'PCL kept',
    category: 'Least constrained',
    features: [
      'Relies on the patient’s own PCL for stability.',
      'Least constrained of the four insert types.',
      'Preserves more native kinematics and proprioception.',
    ],
    uses: ['Used when the PCL is intact and competent.'],
  ),
  ProductCard(
    sku: 'PS — Posterior-Stabilised',
    generic: 'PCL substituted by post-and-cam',
    category: 'Post-and-cam',
    features: [
      'A post-and-cam mechanism replaces the PCL.',
      'Requires a box cut on the distal femur.',
      'Modified Freedom post-cam allows up to 15° rotation to reduce impingement.',
    ],
    uses: ['Used when the PCL is absent, incompetent or sacrificed.'],
  ),
  ProductCard(
    sku: 'UC — Ultra-Congruent',
    generic: 'PCL sacrificed',
    category: 'Deep-dish',
    features: [
      'A deep-dished insert provides stability without a post.',
      'No box cut is required.',
      'Acts as a constrained CR alternative.',
    ],
    uses: ['Used when extra stability is needed without moving to PS.'],
  ),
  ProductCard(
    sku: 'MC — Medial-Congruent',
    generic: 'PCL either kept or sacrificed',
    category: 'Medial-pivot',
    features: [
      'Conforming medial side mimics natural medial-pivot motion.',
      'Lateral side allows femoral rollback during flexion.',
      'Compatible with both CR and PCL-sacrificing approaches.',
      'Heightened anterior lip prevents femoral subluxation.',
    ],
    uses: ['Designed to mimic native knee kinematics.'],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Module 4 — Meril's Knee Portfolio: the Freedom® Family
// ─────────────────────────────────────────────────────────────────────────────

const _m4FamilyCards = <ProductCard>[
  ProductCard(
    sku: 'Freedom® Total Knee',
    generic: 'Flagship 7-radii multi-radius knee',
    category: 'Primary TKR',
    features: [
      'First USFDA-cleared knee with 7 tangential radii.',
      'Multi-radius design: radii 1–3 manage patellofemoral contact; radii 4–7 control rollback and flexion.',
      '8 femoral sizes (A–H), 8 universal tibial trays with intermediate D size bridging Asian and Caucasian anatomy.',
      'CR or PS on the same instrument platform; all-poly or metal-backed tibia.',
      'High flexion up to 155° with bone-conserving thin anterior flange (3.0–6.8 mm).',
      'Cobalt-chromium-molybdenum femur; UHMWPE (GUR 1020) inserts.',
      'Universal symmetric tibial baseplate with 5-point peripheral locking mechanism.',
      'Modified post-cam (PS) allows up to 15° of rotation to help prevent impingement.',
      '10-year follow-up 98.3% survivorship (per Maxx/Meril-cited studies); cemented use.',
    ],
    uses: ['Primary TKR; CR or PS; all-poly or metal-backed tibia.'],
  ),
  ProductCard(
    sku: 'Freedom® Partial Knee (UKR)',
    generic: 'Bone-sparing single-compartment resurfacing',
    category: 'Unicompartmental / Partial Knee',
    features: [
      'Resurfaces only the diseased compartment.',
      'Preserves the cruciate ligaments for more natural kinematics.',
      'Smaller incision, less blood loss, faster recovery.',
      'Outpatient / ASC efficiency via QRS® instrumentation.',
    ],
    uses: ['Patients with isolated medial or lateral compartment osteoarthritis.'],
  ),
  ProductCard(
    sku: 'Freedom® Renew',
    generic: 'Resurfacing unicondylar inlay',
    category: 'Resurfacing Partial Knee',
    features: [
      'Minimal bone resection.',
      'Same-day discharge pathway.',
      'Designed for younger, active patients.',
    ],
    uses: ['Resurfacing unicondylar inlay — minimal resection, same-day discharge.'],
  ),
  ProductCard(
    sku: 'Freedom® Titan (TiNbN)',
    generic: 'Low-ion knee for metal sensitivity',
    category: 'Titanium / Hypersensitivity Knee',
    features: [
      'Titanium Niobium Nitride (TiNbN) surface coating.',
      '~4× harder, low friction, biocompatible.',
      'Reduces cobalt / chromium ion release for metal-sensitive patients.',
      'Same multi-radius Freedom geometry and instrumentation.',
    ],
    uses: ['TiNbN-coated Freedom for patients with metal-ion sensitivity or allergy.'],
  ),
  ProductCard(
    sku: 'Freedom® Porous',
    generic: 'Cementless fixation',
    category: 'Cementless Primary TKR',
    features: [
      'AsymMatrix® porous coating promotes bone in-growth.',
      'Cementless femoral fixation option.',
      'Same Freedom geometry and instrument platform.',
    ],
    uses: ['Cementless fixation; AsymMatrix® porous coating for bone in-growth.'],
  ),
  ProductCard(
    sku: 'Freedom® PCK Revision',
    generic: 'Modular constrained revision platform',
    category: 'Revision Knee System',
    features: [
      'Modular build-up with PCK femoral and tibial inserts.',
      'Stemmed tibial baseplate and stem extensions for stability.',
      'Tibial and femoral augments plus offset junctions for bone defects.',
      'Increasing levels of constraint to address ligament insufficiency.',
      'Titan (TiNbN) coating option for metal sensitivity.',
    ],
    uses: ['Revision surgery; varying constraint, stems, augments and offset junctions.'],
  ),
  ProductCard(
    sku: 'Stemmed Tibial Baseplate',
    generic: 'Added stability for poor bone stock or severe deformity',
    category: 'Revision Augment',
    features: [
      'Stem extension provides diaphyseal fixation.',
      'Used when metaphyseal bone is deficient.',
      'Pairs with Freedom revision instrumentation.',
    ],
    uses: ['Added stability for poor bone stock or severe deformity.'],
  ),
  ProductCard(
    sku: 'Freedom® Medial Congruent insert',
    generic: 'Medial-pivot kinematics',
    category: 'Insert option',
    features: [
      'Asymmetric design: highly conforming medial side gives stability.',
      'Lateral side allows femoral rollback to mimic native motion.',
      'Heightened anterior lip prevents femoral subluxation.',
      'Compatible with both CR and PCL-sacrificing approaches.',
    ],
    uses: ['Medial-pivot kinematics — designed to mimic the native knee.'],
  ),
];

// Five attributes behind the Freedom design philosophy.
const _m4Attributes = <ProductCard>[
  ProductCard(
    sku: 'Size',
    generic: 'Global anatomic fit',
    category: 'Global fit',
    features: [
      'Eight femoral sizes (A–H) including an intermediate D size.',
      'Bridges Asian and Caucasian anatomy; broadens fit across patient groups.',
    ],
    uses: ['Engineered to fit a global patient population.'],
  ),
  ProductCard(
    sku: 'Shape',
    generic: 'Multi-radius 7-radii geometry',
    category: 'Multi-radius',
    features: [
      'First USFDA-cleared knee with 7 tangential radii.',
      'Radii 1–3 control patellofemoral contact; radii 4–7 control rollback and flexion.',
    ],
    uses: ['Follows the knee through its whole arc of motion.'],
  ),
  ProductCard(
    sku: 'Bone conservation',
    generic: 'Preserves native bone stock',
    category: 'Bone-sparing',
    features: [
      'Thin anterior flange (3.0–6.8 mm).',
      '8 mm box and 9 mm posterior condylar resection.',
      'Preserves up to ~40% more bone vs conventional designs.',
    ],
    uses: ['Keeps more bone for any future revision.'],
  ),
  ProductCard(
    sku: 'Flexion range',
    generic: 'Up to 155° of high flexion',
    category: 'High flexion',
    features: [
      'Engineered for high flexion AND bone conservation — not traded off.',
      'Supports stairs, squats and daily deep-bend activities.',
    ],
    uses: ['Designed and tested to 135–155° of flexion.'],
  ),
  ProductCard(
    sku: 'Clinical / economic environment',
    generic: 'Versatility for global markets',
    category: 'All-poly first',
    features: [
      'All-poly first — the first all-poly tibia cleared by US FDA for high flexion.',
      'Surgeon flexibility: choose all-poly or metal-backed tibia without compromising performance.',
    ],
    uses: ['Full performance at lower cost and with a simpler construct.'],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Module 5 — Competitive Landscape
// ─────────────────────────────────────────────────────────────────────────────

final TablePage _m5CompetitorMatrix = TablePage(
  heading: 'Competitor matrix — flagship knee brands',
  columns: ['Company', 'Flagship knee', 'Robotic / enabling tech', 'Design signature'],
  rows: <List<String>>[
    ['Meril (Maxx) — Freedom', 'Freedom Total Knee (+ DestiKnee/Opulent)', 'Misso robotic platform', 'Multi-radius (7 radii); high-flex + bone-conserving; all-poly high-flex; global sizing'],
    ['Zimmer Biomet', 'Persona', 'ROSA Knee', '"The Personalized Knee"; broad portfolio (NexGen, Vanguard)'],
    ['Stryker', 'Triathlon', 'Mako', 'Single-radius design; mid-flexion stability'],
    ['DePuy Synthes (J&J)', 'ATTUNE', 'VELYS', '"Natural feel"; gradually reducing radius (also SIGMA)'],
    ['Smith+Nephew', 'LEGION', 'CORI', 'JOURNEY II for natural kinematics (also GENESIS II)'],
    ['B. Braun / Aesculap', 'Columbus / VEGA', 'OrthoPilot navigation', 'European; ceramic "Advanced Surface" coating'],
    ['MicroPort Orthopedics', 'Evolution', '—', 'Medial-pivot kinematics'],
    ['Medacta', 'GMK Sphere', 'NextAR / MySolutions', 'Medial-pivot (Sphere)'],
    ['Exactech', 'Truliant', 'ExactechGPS', 'Guidance / "Active Intelligence" (also Optetrak)'],
  ],
);

const _m5FreedomDifferentiators = <ProductCard>[
  ProductCard(
    sku: 'Multi-radius (7 radii) design',
    category: 'Design differentiator',
    features: [
      'Multi-radius (7-radii) anatomic design vs single-radius (Stryker) and reducing-radius (DePuy) philosophies.',
      'A clear talking point in competitive discussions.',
    ],
    uses: ['Follows the knee through its entire arc of motion.'],
  ),
  ProductCard(
    sku: 'Bone conservation + high flex',
    category: 'Clinical differentiator',
    features: [
      'Achieves high flexion without sacrificing posterior bone.',
      'Valuable for younger / revision-bound patients and smaller anatomy.',
    ],
    uses: ['Preserves tissue where preserving tissue matters.'],
  ),
  ProductCard(
    sku: 'All-poly high-flex tibia',
    category: 'Value differentiator',
    features: [
      'The only all-poly tibia FDA-cleared for high flexion.',
      'Full performance at lower cost and with a lighter construct.',
    ],
    uses: ['Cost-effective option without compromising performance.'],
  ),
  ProductCard(
    sku: 'Global sizing (A–H)',
    category: 'Fit differentiator',
    features: [
      'Eight femoral sizes (A–H) with intermediate D bridging Asian and Caucasian anatomy.',
      'Improves fit across a broader patient population.',
    ],
    uses: ['Designed for both Western and Eastern anatomy.'],
  ),
  ProductCard(
    sku: 'Options others lack as a bundle',
    category: 'Portfolio differentiator',
    features: [
      'TiNbN (Titan) coating for metal sensitivity.',
      'Medial-Congruent insert for native kinematics.',
      'QRS® efficiency for ASC settings.',
    ],
    uses: ['Solutions tailored to specific patient and surgical needs.'],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Source-mapping notes (per PDF)
// ─────────────────────────────────────────────────────────────────────────────

// Each module renders its source mapping as a small Read page so reviewers can
// trace content back to the original courseware pack. Sources used:
//
//   M1 — Anatomy: Presentation_on_Knee.pptx (slides 2–5); knee-anatomy video
//        (YouTube mOtvA-dvD_w).
//   M2 — Why: Presentation_on_Knee.pptx (slides 6–9, incl. OA & treatment-
//        pathway visuals).
//   M3 — How: Surgical_Techniques.pptx; Freedom Total Knee Surgical Technique
//        (MXO-MP00005 R10).
//   M4 — Freedom: Freedom Knee Family Overview (MXO-MP00045 R02); Medial
//        Congruent Insert brochure (MXO-MP00058); merillife.com.
//   M5 — Competitors: Public manufacturer & registry/market sources (Stryker,
//        Zimmer Biomet, DePuy Synthes, Smith+Nephew, etc.).

// ─────────────────────────────────────────────────────────────────────────────
// Topic
// ─────────────────────────────────────────────────────────────────────────────

final Topic tkrTopic = Topic(
  id: 'tkr',
  label: 'TKR',
  icon: 'Activity',
  cert: 'TKR Essentials — Freedom® Knee',
  passMark: 80,
  sections: <Section>[
    // ───────────────────────────────────────────────────────────────────────
    // MODULE 1 — Knee Anatomy Essentials
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm1_anatomy',
      title: 'Module 1 — Knee anatomy essentials',
      icon: 'BookOpen',
      blurb: 'Foundation module — vocabulary, video anchor and the road to osteoarthritis.',
      color: sectionColorsHex[0],
      pages: <Page>[
        ReadPage(
          heading: 'Module 1 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Name the three bones that form the knee joint.\n'
              '• Describe the role of the four major ligaments (ACL, PCL, MCL, LCL).\n'
              '• Explain what the menisci and articular cartilage do.\n'
              '• Connect cartilage loss to osteoarthritis — the road to replacement.',
        ),
        ReadPage(
          heading: 'Screen 1.1 — The knee at a glance',
          body:
              'The knee is the largest synovial (fluid-lubricated) joint in the human body. It behaves like a hinge but also rotates slightly, letting you walk, squat, climb and kneel while carrying several times your body weight with every step. That is why small changes in structure can have a big impact on function.\n\n'
              '• Three bones meet at the knee: the femur (thigh bone), the tibia (shin bone) and the patella (kneecap), each contributing to load-bearing, movement and protection.',
        ),
        carouselPage(
          'Screen 1.1 — Human knee anatomy (image set)',
          <String>[
            'Anterior view of the human knee with labelled muscles, tendons, cartilage, meniscus, ACL, PCL and the surrounding bones (femur, tibia, fibula, patella).',
            'Ligaments of the knee — anterior view highlighting the ACL, PCL, MCL and LCL in relation to the femur, tibia and menisci.',
            'Anterior view of the knee showing the femur, patella, articular cartilage and the medial and lateral menisci on the tibial plateau.',
          ],
          assets: const <String?>[
            'assets/tkr/m1_anatomy_overview.png',
            'assets/tkr/m1_ligaments_of_knee.png',
            'assets/tkr/m1_menisci_anterior.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
            'Source: TKR Essentials PDF',
            'Source: TKR Essentials PDF',
          ],
        ),
        videoPlaceholderPage(
          'Screen 1.2 — Video: anatomy of the knee joint',
          title: 'Anatomy of the knee joint',
          description:
              'Watch this short anatomy video (≈3–5 min) before continuing. It is the anchor for Module 1 and gives you a visual reference for the rest of the course.\n\n'
              'Before you watch, look for: the three bones, where cartilage sits, and how the ligaments hold everything together.\n\n'
              'After you watch, you should be able to: point to the femur, tibia and patella; name the four ligaments; and identify the menisci without needing to replay the whole clip.',
          duration: '≈3–5 min',
          url: 'https://youtube.com/watch?v=mOtvA-dvD_w',
        ),
        ReadPage(
          heading: 'Screen 1.3 — The bones & the joint surfaces',
          body:
              '• Femur (thigh bone): its two rounded condyles form the top of the joint and provide the main upper bearing surface.\n'
              '• Tibia (shin bone): its flat plateau forms the base the femur rolls on and carries most of the body\'s load.\n'
              '• Patella (kneecap): sits in front and glides in the femur\'s trochlear groove, protecting the joint and improving the leverage of the quadriceps muscle during extension.\n'
              '• Articular cartilage: a smooth, low-friction cap on the bone ends that lets the surfaces glide painlessly and absorb everyday wear.',
        ),
        anatomyPage('Screen 1.3 — The four bones & joint surfaces', _m1BoneLayers),
        ReadPage(
          heading: 'Screen 1.4 — The four major ligaments (stability)',
          body:
              'Ligaments are strong bands that tie bone to bone and keep the knee stable by resisting unwanted movement in different directions.\n\n'
              '• ACL (Anterior Cruciate Ligament): stops the tibia sliding forward and helps control front-to-back stability.\n'
              '• PCL (Posterior Cruciate Ligament): stops the tibia sliding backward and supports posterior stability.\n'
              '• MCL (Medial Collateral Ligament): stabilises the inner (medial) side and helps resist valgus stress.\n'
              '• LCL (Lateral Collateral Ligament): stabilises the outer (lateral) side and helps resist varus stress.',
        ),
        anatomyPage('Screen 1.4 — The four major ligaments', _m1LigamentLayers),
        ReadPage(
          heading: 'Screen 1.4 — Why this matters for TKR',
          body:
              'Knee implants are described as cruciate-retaining (CR) or posterior-stabilised (PS) depending on whether the PCL is kept or substituted by the implant. You\'ll meet these terms again in Modules 3 and 4.',
        ),
        ReadPage(
          heading: 'Screen 1.5 — Menisci & cartilage (cushioning)',
          body:
              '• Menisci: two C-shaped pads (medial and lateral) act as shock absorbers between femur and tibia, spreading load, reducing pressure and adding stability.\n'
              '• Articular cartilage: provides the smooth gliding surface that helps the joint move quietly and with less friction.\n'
              '• When it wears out: cartilage thins and disappears, bone rubs on bone, and the result is pain, stiffness and reduced motion — the classic pattern of osteoarthritis and the start of the road to knee replacement.',
        ),
        anatomyPage('Screen 1.5 — Menisci & articular cartilage', _m1CushioningLayers),
        ReadPage(
          heading: 'Module 1 — Quick check',
          body:
              'Q: Which ligament stops the shin bone (tibia) from sliding forward?\n'
              'A: The ACL (Anterior Cruciate Ligament).',
        ),
        ReadPage(
          heading: 'Module 1 — Key takeaways',
          body:
              '★ The knee is the body\'s largest synovial joint; femur, tibia and patella meet there.\n'
              '★ Four ligaments — ACL, PCL, MCL, LCL — provide stability.\n'
              '★ Menisci cushion and spread load; articular cartilage lets surfaces glide.\n'
              '★ Losing cartilage → bone-on-bone → osteoarthritis.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'Which three bones form the knee joint?', options: ['Femur, tibia, patella', 'Femur, fibula, patella', 'Femur, tibia, fibula', 'Humerus, radius, ulna'], correct: 0),
        Question(q: 'Which ligament prevents the tibia from sliding forward?', options: ['PCL', 'ACL', 'MCL', 'LCL'], correct: 1),
        Question(q: 'What is the primary role of the menisci?', options: ['Provide varus-valgus stability', 'Cushion and distribute load between femur and tibia', 'Lubricate the patellofemoral joint', 'Anchor the quadriceps tendon'], correct: 1),
        Question(q: 'Cartilage loss → bone rubs on bone describes which condition?', options: ['Rheumatoid arthritis', 'Osteoporosis', 'Osteoarthritis', 'Osteonecrosis'], correct: 2),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 2 — Why Knee Replacement Is Done
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm2_why',
      title: 'Module 2 — Why knee replacement is done',
      icon: 'FileText',
      blurb: 'Turns anatomy into clinical need — osteoarthritis, deformities and the treatment pathway.',
      color: sectionColorsHex[1],
      pages: <Page>[
        ReadPage(
          heading: 'Module 2 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Explain what osteoarthritis does to the knee.\n'
              '• List the common reasons a TKR is performed.\n'
              '• Recognise varus and valgus deformity.\n'
              '• Place TKR correctly in the orthopaedic treatment pathway.',
        ),
        ReadPage(
          heading: 'Screen 2.1 — What goes wrong',
          body:
              '• Healthy knee: smooth cartilage, an even joint space and a joint surface that moves with minimal friction.\n'
              '• Osteoarthritic knee: cartilage thins and disappears, the joint space narrows, bone spurs (osteophytes) form, and the joint lining (synovium) thickens as the joint becomes more irritated.\n'
              '• What the patient feels: pain, swelling, stiffness, reduced movement and difficulty walking, standing or climbing stairs, often with a gradual loss of daily function.',
        ),
        anatomyPage('Screen 2.1 — Healthy vs osteoarthritic knee', _m2DiseaseLayers),
        carouselPage(
          'Screen 2.1 — Normal knee vs knee osteoarthritis',
          <String>[
            'Side-by-side comparison of a normal knee (left) and a knee with osteoarthritis (right) — labelled with cartilage, joint space, osteophytes, synovium and bone.',
          ],
          assets: const <String?>[
            'assets/tkr/m2_osteoarthritis_knee.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 2.2 — Why a knee replacement?',
          body:
              'A knee replacement (arthroplasty) resurfaces the worn joint with implant components to relieve pain, restore function and improve quality of life. It is considered when:\n\n'
              '• Advanced osteoarthritis / cartilage damage (the most common reason), especially when pain and stiffness persist despite conservative care.\n'
              '• Rheumatoid or post-traumatic arthritis, where inflammation or previous injury has damaged the joint.\n'
              '• Severe, persistent pain not relieved by non-surgical care, even after appropriate treatment has been tried.\n'
              '• Significant loss of mobility and quality of life, making everyday tasks progressively harder.\n'
              '• Knee deformity affecting alignment and load, which can worsen symptoms and accelerate wear.',
        ),
        ReadPage(
          heading: 'Screen 2.3 — Deformities the surgery corrects',
          body:
              '• Normal alignment: the leg\'s mechanical axis runs straight through the centre of the knee, distributing force evenly.\n'
              '• Varus ("bow-legged"): load shifts onto the medial (inner) compartment, increasing pressure on the inside of the knee.\n'
              '• Valgus ("knock-knees"): load shifts onto the lateral (outer) compartment, increasing pressure on the outside of the knee.\n\n'
              'A core goal of TKR is to realign the limb and rebalance how load passes through the knee so the joint functions more predictably.',
        ),
        carouselPage(
          'Screen 2.3 — Normal, varus & valgus alignment',
          <String>[
            'Three lower-limb skeletons side-by-side showing normal alignment, varus ("bow-legged") and valgus ("knock-knee") deformity.',
          ],
          assets: const <String?>[
            'assets/tkr/m2_alignment_combined.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 2.4 — The treatment pathway — where TKR fits',
          body:
              'Orthopaedic care is a ladder; surgery is the last rung, used when earlier steps stop controlling pain or restoring function and the simpler options are no longer enough:\n\n'
              '1. Conservative management — activity modification, weight management and basic exercise to reduce stress on the joint.\n'
              '2. Physiotherapy to improve strength, mobility and confidence in movement.\n'
              '3. Injections — e.g. corticosteroid or viscosupplementation — to try to calm inflammation or improve joint lubrication.\n'
              '4. Medications — analgesics / anti-inflammatories — to help control symptoms in the short term.\n'
              '5. Total Knee Replacement — when conservative options are exhausted and the joint remains too painful or limited for daily life.',
        ),
        carouselPage(
          'Screen 2.4 — Knee osteoarthritis treatment pathway',
          <String>[
            'Treatment pathway for knee osteoarthritis — conservative management → physiotherapy → injections → medications → total knee replacement.',
          ],
          assets: const <String?>[
            'assets/tkr/m2_treatment_pathway.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 2.4 — Partial vs total (Meril portfolio hook)',
          body:
              'When only one compartment is worn, a partial (unicompartmental) replacement may be enough — Meril offers this as the Freedom Partial and Freedom Renew (you\'ll see these in Module 4).',
        ),
        ReadPage(
          heading: 'Module 2 — Quick check',
          body:
              'Q: A patient with "bow-legged" alignment has which deformity, and which compartment is overloaded?\n'
              'A: Varus deformity — the medial (inner) compartment is overloaded.',
        ),
        ReadPage(
          heading: 'Module 2 — Key takeaways',
          body:
              '★ Osteoarthritis = cartilage loss, joint-space narrowing, osteophytes, stiffness and pain.\n'
              '★ TKR is done mainly for advanced arthritis, severe pain, lost mobility and deformity.\n'
              '★ Varus = bow-legged (medial overload); valgus = knock-knees (lateral overload).\n'
              '★ Surgery is the final step after conservative care, physio, injections and medication.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'The most common reason for a Total Knee Replacement is:', options: ['Rheumatoid arthritis', 'Osteoarthritis', 'Post-traumatic arthritis', 'Fracture'], correct: 1),
        Question(q: '"Bow-legged" alignment is called:', options: ['Valgus', 'Varus', 'Anteversion', 'Recurvatum'], correct: 1),
        Question(q: 'In the treatment pathway, Total Knee Replacement is the:', options: ['First step', 'Second step', 'Final step', 'Always done immediately'], correct: 2),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 3 — How a Knee Replacement Is Done
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm3_how',
      title: 'Module 3 — How a knee replacement is done',
      icon: 'Stethoscope',
      blurb: 'A simplified walkthrough for product knowledge — not a surgical instruction manual.',
      color: sectionColorsHex[2],
      pages: <Page>[
        ReadPage(
          heading: 'Module 3 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Outline the major phases of a TKR, in order.\n'
              '• State what is resurfaced and why.\n'
              '• Recognise key instruments and decisions (CR vs PS, sizing, gap balancing).\n'
              '• Describe how components are trialed and fixed.',
        ),
        ReadPage(
          heading: 'Screen 3.1 — The goal of surgery',
          body:
              'Surgery removes the worn surfaces and replaces them with implant components, then restores alignment and balances the soft tissues so the knee is stable through its full range of motion and comfortable through flexion and extension.\n\n'
              'Four surfaces are resurfaced: the end of the femur (metal femoral component), the top of the tibia (metal baseplate), a plastic spacer (poly insert) between them, and usually the back of the patella (poly button) which can improve tracking and comfort.',
        ),
        cardsPage('Screen 3.1 — The four resurfaced surfaces', _m3ResurfacedCards),
        carouselPage(
          'Screen 3.1 — Assembled Freedom Total Knee components',
          <String>[
            'Lateral view of the assembled Freedom Total Knee — femoral component, polyethylene insert and tibial baseplate with stem.',
          ],
          assets: const <String?>[
            'assets/tkr/m3_freedom_anterior.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.2 — Step 1: pre-operative planning',
          body:
              '• Physical exam: knee function, ligament stability, muscle tone and deformities, so the surgeon can understand how the joint behaves before planning the operation.\n'
              '• Review the mechanical and anatomical axes to plan alignment and understand how weight will pass through the new joint.\n'
              '• Estimate implant size with radiographic (X-ray) overlay templates — the final size is confirmed during surgery when the anatomy can be measured directly.',
        ),
        ReadPage(
          heading: 'Screen 3.3 — Step 2: exposure',
          body:
              '• Limb prepared and draped; a tourniquet is applied after Esmarch exsanguination to keep the field clear and controlled.\n'
              '• An anterior midline incision is made; the joint is entered through a medial parapatellar arthrotomy to reach the joint surfaces safely.\n'
              '• The patella is moved aside, osteophytes are removed, the ACL is released and the menisci are removed for access so the surgeon can fully expose the joint.',
        ),
        carouselPage(
          'Screen 3.3 — Common surgical approaches to expose the knee',
          <String>[
            'Three surgical approaches to expose the knee: medial parapatellar, mid-vastus and sub-vastus — each with a different balance of exposure and quadriceps preservation.',
          ],
          assets: const <String?>[
            'assets/tkr/m3_approach_combined.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.4 — Step 3: femoral preparation',
          body:
              '• Alignment: an intramedullary (IM) rod sets the femoral alignment and valgus angle so the cut follows the chosen mechanical plan.\n'
              '• Distal cut: made with the Distal Femoral Cutting Guide (DFCG) to create a consistent starting surface.\n'
              '• Sizing & rotation: an A/P sizing guide selects the component size; external rotation is set (e.g. 3° / 4.5° / 6°) to support correct tracking and balance.',
        ),
        carouselPage(
          'Screen 3.4 — Femoral preparation tools',
          <String>[
            'A/P femoral sizing guide seated on the distal femur to select the right component size (large / left).',
            'The 5-in-1 femoral cutting block — anterior, posterior, chamfer and trochlear cuts in one guided step.',
            'Box-cut preparation on a posterior-stabilised (PS) femur to house the post-and-cam mechanism.',
          ],
          assets: const <String?>[
            'assets/tkr/m3_ap_sizing_guide.png',
            'assets/tkr/m3_5in1_cutting_block.png',
            'assets/tkr/m3_ps_box_cut_prep.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
            'Source: TKR Essentials PDF',
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.4 — Femoral cuts — the 5-in-1 & the box cut',
          body:
              '• Five cuts in one: the 5-in-1 cutting block makes the anterior, posterior, anterior-chamfer, posterior-chamfer and trochlear cuts in a single guided step.\n'
              '• Box cut (PS only): creates the intercondylar space for the post-and-cam of a posterior-stabilised design and prepares the femur for that mechanism.',
        ),
        ReadPage(
          heading: 'Screen 3.5 — Step 4: tibial preparation',
          body:
              '• Extramedullary (EM) or IM guides set the proximal tibial cut, perpendicular to the tibial mechanical axis with a small (~3°) posterior slope to support flexion mechanics.\n'
              '• The baseplate is sized for full coverage with no overhang; rotation is set to the medial third of the tibial tubercle so the implant sits correctly on the bone.\n'
              '• Keel / boss space is prepared by reaming and broaching (a smaller keel is used for an all-poly tibia) to create a stable fit for fixation.',
        ),
        carouselPage(
          'Screen 3.5 — Tibial preparation tools',
          <String>[
            'Extramedullary tibial alignment and cutting guide used to set the proximal tibial cut (EM guide and rod assembly).',
            'Reaming and broaching instruments used to prepare the keel space for the tibial baseplate.',
          ],
          assets: const <String?>[
            'assets/tkr/m3_tibial_em_guide.png',
            'assets/tkr/m3_keel_reaming.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 3.6 — Step 5: trialing & balancing',
          body:
              '• Trial femoral component, tibial tray and poly insert are placed so the surgeon can assess the joint before final fixation.\n'
              '• The knee is taken through its range of motion; the surgeon checks flexion/extension gaps, varus/valgus stability and patellar tracking to fine-tune the balance.\n'
              '• Soft-tissue releases are performed if needed to balance the knee and remove any residual tightness.\n'
              '• Insert decision: CR, PS, UC or MC is chosen here (see the reference card below) based on stability, restraint and motion goals.',
        ),
        carouselPage(
          'Screen 3.6 — Trial reduction',
          <String>[
            'Trial components in place — knee ranged through flexion/extension to assess balance and tracking before final implantation.',
          ],
          assets: const <String?>[
            'assets/tkr/m3_trial_components.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        cardsPage('Screen 3.6b — Reference card: the four insert types', _m3InsertCards),
        ReadPage(
          heading: 'Screen 3.7 — Step 6: patella preparation',
          body:
              '• Patella thickness is measured with a caliper; at least 8 mm of bone is retained to maintain strength and avoid fracture risk.\n'
              '• It is resected, sized and drilled for pegs, then trialed to check tracking and confirm that it moves smoothly.\n'
              '• Resurfacing the patella is optional — it depends on the surgeon and the condition of the bone as well as the chosen technique.',
        ),
        ReadPage(
          heading: 'Screen 3.8 — Step 7: final implantation & closure',
          body:
              '• Bone surfaces are irrigated and dried; cement is pressurised into the bone to improve fixation and interlock.\n'
              '• Cementing order: tibial baseplate → femoral component → poly insert → patella, following the usual sequence used in the procedure.\n'
              '• Excess cement is removed, the locking mechanism is engaged and balance is re-checked before closure.\n'
              '• The wound is closed in layers to restore tissue coverage and complete the procedure.',
        ),
        ReadPage(
          heading: 'Screen 3.8 — Note',
          body:
              'The Freedom Total Knee is indicated for cemented use. (The Freedom Porous variant supports cementless femoral fixation — Module 4.)',
        ),
        ReadPage(
          heading: 'Module 3 — Quick check',
          body:
              'Q: Which cutting instrument makes five of the femoral cuts, and what extra cut does a PS knee need?\n'
              'A: The 5-in-1 cutting block; a PS knee also needs a box cut for the post-and-cam.',
        ),
        ReadPage(
          heading: 'Module 3 — Key takeaways',
          body:
              '★ Four surfaces are resurfaced: femur, tibia, poly spacer and (usually) patella.\n'
              '★ Femur first (IM rod → DFCG → sizing → 5-in-1 → box cut for PS), then tibia.\n'
              '★ Trialing balances the gaps and stability; the insert type (CR/PS/UC/MC) is chosen here.\n'
              '★ Components are cemented in order: tibia → femur → poly → patella.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'How many joint surfaces are resurfaced in a total knee replacement?', options: ['2', '3', '4', '5'], correct: 2),
        Question(q: 'The 5-in-1 cutting block is used during which step?', options: ['Pre-operative planning', 'Femoral preparation', 'Tibial preparation', 'Patellar preparation'], correct: 1),
        Question(q: 'In a posterior-stabilised (PS) knee, the PCL is:', options: ['Preserved', 'Substituted by a post-and-cam', 'Replaced with a meniscus', 'Tightened'], correct: 1),
        Question(q: 'The recommended cementing order begins with the:', options: ['Femoral component', 'Poly insert', 'Patella', 'Tibial component'], correct: 3),
        Question(q: 'Minimum patellar bone thickness to retain after resurfacing is:', options: ['4 mm', '8 mm', '12 mm', 'No minimum'], correct: 1),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 4 — Meril's Knee Portfolio: the Freedom® Family
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm4_freedom',
      title: 'Module 4 — Meril\'s knee portfolio: the Freedom® family',
      icon: 'Layers',
      blurb: 'Maps the Freedom product family onto the procedure and explains what each variant adds.',
      color: sectionColorsHex[3],
      pages: <Page>[
        ReadPage(
          heading: 'Module 4 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Explain Meril\'s position in orthopaedics and the Maxx relationship.\n'
              '• Describe the Freedom design philosophy and its differentiators.\n'
              '• Identify each member of the Freedom family and when it is used.\n'
              '• Recall Freedom\'s key design and clinical claims.',
        ),
        ReadPage(
          heading: 'Screen 4.1 — Meril in orthopaedics',
          body:
              '• Who: Meril Life Sciences is a global medical-device company headquartered in Vapi, India, with an expanding orthopaedics presence.\n'
              '• How it entered ortho: Meril acquired Maxx Orthopedics (USA) around 2009, bringing knee expertise into its broader portfolio.\n'
              '• The Freedom link: Maxx designed and manufactures the Freedom Total Knee System; Meril manufactures and distributes it globally and offers Meril-branded equivalents — DestiKnee™ and the Opulent TiNbN knee — built on the same licensed design for different market needs.\n'
              '• Reach: knee and hip replacement, revision, trauma and spine — used in 50+ countries across a broad clinical footprint.\n\n'
              'For this course: treat "Freedom Knee" as Meril\'s flagship knee brand.',
        ),
        ReadPage(
          heading: 'Screen 4.2 — Design philosophy: "think globally, design locally"',
          body:
              'Freedom was engineered around five market attributes: size, shape, bone conservation, flexion range and the clinical/economic environment, so it can fit both anatomy and workflow realities.',
        ),
        cardsPage('Screen 4.2 — The five design attributes', _m4Attributes),
        carouselPage(
          'Screen 4.2 — Design philosophy diagram',
          <String>[
            'The five critical market attributes behind the Freedom design: size, shape, bone conservation, flexion range and clinical environment (Venn-diagram layout).',
            'Femoral / tibial sizing matrix (sizes A–H) used to match global anatomy, including tibial liner thicknesses (9, 11, 14, 17 mm).',
          ],
          assets: const <String?>[
            'assets/tkr/m4_design_attributes.png',
            'assets/tkr/m4_femoral_tibial_sizing.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.3 — The multi-radius (7-radii) design',
          body:
              'Freedom is the first USFDA-cleared knee with 7 tangential radii, shaped to follow the knee through its whole arc of motion and support a more anatomical feel:\n\n'
              '• Radii 1–3: manage patellofemoral contact — smooth kneecap tracking over a thin anterior flange in the front of the knee.\n'
              '• Radii 4–7: control femoral rollback and flexion, from walking through to deep flexion, helping the knee move naturally across the arc.\n'
              '• Tracking: a 6° patellar groove and a deep trochlear groove give natural tracking, with or without resurfacing the patella, which supports a smoother motion path.\n\n'
              'Talking point: several large competitors build their knees on a single-radius philosophy. Freedom\'s multi-radius design is a key differentiator — see Module 5.',
        ),
        carouselPage(
          'Screen 4.3 — The seven tangential radii',
          <String>[
            'Lateral view of the Freedom femoral component with the seven tangential radii labelled (1–7) — radii 1–3 cover patellofemoral contact, radii 4–7 govern rollback and flexion.',
          ],
          assets: const <String?>[
            'assets/tkr/m4_seven_radii_lateral.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.4 — Key features & proof points',
          body:
              '• CR or PS options on the same instrument platform, giving surgeons a familiar workflow with technique choice.\n'
              '• Universal, symmetric tibial baseplate with a 5-point peripheral locking mechanism for secure engagement and broad compatibility.\n'
              '• Poly insert options: CR, PS, UC and MC so the system can match different stability and kinematic goals.\n'
              '• Cobalt-chromium-molybdenum femur; UHMWPE (GUR 1020) inserts, using well-established implant materials.\n'
              '• Modified post-cam (PS) with up to 15° of rotation to help prevent impingement and support smoother motion.\n'
              '• Clinical claim: 10-year follow-up 98.3% survivorship (per Maxx/Meril-cited studies). Intended for cemented use and presented here as a headline proof point.',
        ),
        ReadPage(
          heading: 'Screen 4.5 — The Freedom family — when to use what',
          body:
              'The Freedom portfolio spans primary, partial, resurfacing, coated, porous and revision variants. Each member addresses a specific patient or surgical need; tap a brand to expand its positioning and key selling points.',
        ),
        cardsPage('Screen 4.5 — The Freedom family — product map', _m4FamilyCards),
        carouselPage(
          'Screen 4.5 — Freedom family at a glance',
          <String>[
            'Freedom Total Knee — flagship primary TKR with CR or PS, all-poly or metal-backed tibia (lateral view of the assembled implant).',
          ],
          assets: const <String?>[
            'assets/tkr/m4_freedom_total_knee.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Screen 4.6 — Spotlight: the Medial Congruent (MC) insert',
          body:
              '• Asymmetric design: a highly conforming medial side gives stability; the lateral side allows femoral rollback so the insert can mimic native motion.\n'
              '• Heightened anterior lip: prevents femoral subluxation — with or without the PCL — and adds another layer of control.\n'
              '• Flexible technique: compatible with both cruciate-retaining and cruciate-sacrificing approaches, which gives the surgeon more options intra-operatively.\n'
              '• Positioning: "mimics native knee kinematics" so the product can be described in a simple, memorable way.',
        ),
        carouselPage(
          'Screen 4.6 — Medial Congruent (MC) insert',
          <String>[
            'Freedom Medial Congruent (MC) insert alone — conforming medial side and lateral rollback-friendly surface designed to mimic native knee kinematics.',
          ],
          assets: const <String?>[
            'assets/tkr/m4_mc_insert_only.png',
          ],
          credits: const <String?>[
            'Source: TKR Essentials PDF',
          ],
        ),
        ReadPage(
          heading: 'Module 4 — Quick check',
          body:
              'Q: Which Freedom product is coated for patients with a metal-ion sensitivity, and what is the coating?\n'
              'A: Freedom Titan — a Titanium Niobium Nitride (TiNbN) coating.',
        ),
        ReadPage(
          heading: 'Module 4 — Key takeaways',
          body:
              '★ Meril acquired Maxx Orthopedics (~2009); Freedom is its flagship knee brand.\n'
              '★ Differentiators: 7-radii multi-radius design, high-flex + bone-conserving, global A–H sizing, all-poly high-flex tibia.\n'
              '★ The family spans primary, partial, resurfacing, coated, porous, revision and MC-insert options.\n'
              '★ Headline claim: 10-yr 98.3% survivorship; cemented use.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'How many tangential radii define the Freedom Knee femoral geometry?', options: ['3', '5', '7', '9'], correct: 2),
        Question(q: 'Which Freedom product is coated for patients with metal-ion sensitivity?', options: ['Freedom Renew', 'Freedom Porous', 'Freedom Titan', 'Freedom Partial'], correct: 2),
        Question(q: 'The Medial Congruent (MC) insert is designed to:', options: ['Restrict all rotation', 'Mimic native medial-pivot kinematics', 'Replace the PCL mechanically', 'Lock into a box cut'], correct: 1),
        Question(q: 'Freedom Porous uses which coating to promote bone in-growth?', options: ['Hydroxyapatite', 'TiNbN', 'AsymMatrix® porous coating', 'PMMA'], correct: 2),
      ],
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 5 — Competitive Landscape
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm5_competition',
      title: 'Module 5 — Competitive landscape',
      icon: 'GitBranch',
      blurb: 'Names, robots and design philosophies — and how Freedom differentiates.',
      color: sectionColorsHex[4],
      pages: <Page>[
        ReadPage(
          heading: 'Module 5 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Name the major global knee manufacturers and their flagship brands.\n'
              '• Match each company to its robotic / enabling platform.\n'
              '• Articulate how Freedom differentiates.',
        ),
        ReadPage(
          heading: 'Screen 5.1 — The "Big Four" and the field',
          body:
              '• Market leaders: Zimmer Biomet, Stryker, DePuy Synthes (Johnson & Johnson) and Smith+Nephew lead the global knee market with broad portfolios and strong installed bases.\n'
              '• Other notable players: B. Braun / Aesculap, MicroPort Orthopedics, Medacta and Exactech, each with its own regional or design emphasis.\n'
              '• Where Meril (Freedom) plays: a design-differentiated, value-strong global challenger — particularly competitive in emerging markets and in outpatient / ASC settings where efficiency matters.',
        ),
        _m5CompetitorMatrix,
        ReadPage(
          heading: 'Screen 5.2 — How Freedom differentiates',
          body:
              'Freedom competes on design, bone conservation, intra-operative flexibility and value — not on having its own robot. Position to strengths.',
        ),
        cardsPage('Screen 5.3 — Freedom differentiators', _m5FreedomDifferentiators),
        ReadPage(
          heading: 'Screen 5.3 — Be honest in the field',
          body:
              'The Big Four lead on robotic ecosystems and registry volume. Freedom competes on design, bone conservation, intra-operative flexibility and value — not on having its own robot. Position to strengths.',
        ),
        ReadPage(
          heading: 'Module 5 — Quick check',
          body:
              'Q: Match the robot to the maker: Mako, ROSA, VELYS, CORI.\n'
              'A: Mako = Stryker; ROSA = Zimmer Biomet; VELYS = DePuy Synthes; CORI = Smith+Nephew.',
        ),
        ReadPage(
          heading: 'Module 5 — Key takeaways',
          body:
              '★ Big Four: Zimmer Biomet (Persona), Stryker (Triathlon), DePuy (ATTUNE), Smith+Nephew (LEGION).\n'
              '★ Robots: Mako / ROSA / VELYS / CORI respectively.\n'
              '★ Freedom differentiates on multi-radius design, bone conservation, all-poly high-flex and value.\n'
              '★ Several rivals (Stryker, MicroPort, Medacta) push single-radius or medial-pivot kinematics.',
        ),
      ],
      quiz: <Question>[
        Question(q: 'Which company makes the Triathlon knee?', options: ['Zimmer Biomet', 'Stryker', 'DePuy Synthes', 'Smith+Nephew'], correct: 1),
        Question(q: 'Which robotic platform pairs with Smith+Nephew\'s portfolio?', options: ['Mako', 'ROSA', 'CORI', 'VELYS'], correct: 2),
        Question(q: 'Freedom\'s 7-radii design differentiates it most clearly from:', options: ['Single-radius (Stryker) designs', 'All-poly designs', 'Partial knee designs', 'Revision systems'], correct: 0),
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
              '• Arthroplasty: surgical resurfacing/replacement of a joint.\n'
              '• Articular cartilage: smooth cap on bone ends that lets the joint glide.\n'
              '• ACL / PCL: cruciate ligaments inside the knee; stop the tibia sliding forward / backward.\n'
              '• MCL / LCL: collateral ligaments; stabilise the inner / outer side of the knee.\n'
              '• Osteoarthritis: wear-and-tear loss of cartilage causing pain and stiffness.\n'
              '• Osteophyte: a bone spur that forms in an arthritic joint.\n'
              '• Varus / Valgus: bow-legged / knock-kneed alignment.\n'
              '• CR / PS: Cruciate-Retaining / Posterior-Stabilised implant designs.\n'
              '• UC / MC: Ultra-Congruent / Medial-Congruent poly inserts.\n'
              '• DFCG: Distal Femoral Cutting Guide.\n'
              '• 5-in-1 block: cutting guide that makes five femoral cuts.\n'
              '• Box cut: intercondylar cut that houses the post-and-cam of a PS knee.\n'
              '• Gap balancing: equalising the flexion and extension spaces for stability.\n'
              '• UHMWPE: ultra-high-molecular-weight polyethylene — the plastic insert material.\n'
              '• TiNbN: Titanium Niobium Nitride — hard coating used on Freedom Titan.\n'
              '• TKR / TKA: Total Knee Replacement / Arthroplasty.\n'
              '• ASC: Ambulatory Surgery Centre (outpatient surgery setting).',
        ),
        ReadPage(
          heading: 'Source mapping & references',
          body:
              'Each module is grounded in the supplied materials, supplemented by public manufacturer information for the competitor section.\n\n'
              '• Module 1 — Anatomy: Presentation_on_Knee.pptx (slides 2–5); knee-anatomy video (YouTube mOtvA-dvD_w).\n'
              '• Module 2 — Why: Presentation_on_Knee.pptx (slides 6–9, incl. OA & treatment-pathway visuals).\n'
              '• Module 3 — How: Surgical_Techniques.pptx; Freedom Total Knee Surgical Technique (MXO-MP00005 R10).\n'
              '• Module 4 — Freedom: Freedom Knee Family Overview (MXO-MP00045 R02); Medial Congruent Insert brochure (MXO-MP00058); merillife.com.\n'
              '• Module 5 — Competitors: public manufacturer & registry/market sources (Stryker, Zimmer Biomet, DePuy Synthes, Smith+Nephew, etc.).\n\n'
              'Note on accuracy: Competitor brand and robotic-platform names reflect public information current at the time of writing and should be re-verified before publishing, as portfolios change over time. Clinical claims (e.g. survivorship) are quoted from Maxx/Meril materials and should carry their original citations in the published course for accuracy and traceability.',
        ),
        videoPlaceholderPage(
          'Module 6 — Course wrap-up video',
          title: 'TKR Essentials — course recap',
          description:
              'A 3–5 minute wrap-up that walks through the six modules in one sitting: anatomy, why, how, the Freedom family, competitive positioning and the knowledge check. Useful as a quick refresher after the course is complete.',
          duration: '≈3–5 min',
        ),
      ],
      quiz: <Question>[
        Question(q: 'What is the largest synovial joint in the human body?', options: ['Hip', 'Shoulder', 'Knee', 'Ankle'], correct: 2),
        Question(q: 'Which ligament prevents the tibia from sliding forward?', options: ['PCL', 'MCL', 'ACL', 'LCL'], correct: 2),
        Question(q: 'The two C-shaped shock absorbers between femur and tibia are the…', options: ['Ligaments', 'Menisci', 'Tendons', 'Osteophytes'], correct: 1),
        Question(q: 'The most common reason for a total knee replacement is…', options: ['Rheumatoid arthritis', 'Osteoarthritis', 'Osteonecrosis', 'Fracture'], correct: 1),
        Question(q: 'A "bow-legged" deformity is called…', options: ['Valgus', 'Varus', 'Anteversion', 'Recurvatum'], correct: 1),
        Question(q: 'In the treatment pathway, total knee replacement is the…', options: ['First step', 'Middle step', 'Final step', 'Always first'], correct: 2),
        Question(q: 'In a posterior-stabilised (PS) knee, the PCL is…', options: ['Kept', 'Substituted by a post-and-cam', 'Removed and not replaced', 'Replaced with a meniscus'], correct: 1),
        Question(q: 'The 5-in-1 cutting block is used during…', options: ['Femoral preparation', 'Tibial preparation', 'Patellar preparation', 'Closure'], correct: 0),
        Question(q: 'The minimum patellar bone thickness to retain is…', options: ['4 mm', '6 mm', '8 mm', '12 mm'], correct: 2),
        Question(q: 'The recommended cementing order begins with the…', options: ['Femoral component', 'Patella', 'Poly insert', 'Tibial component'], correct: 3),
        Question(q: 'Freedom is the first FDA-cleared knee with how many tangential radii?', options: ['Five', 'Six', 'Seven', 'Eight'], correct: 2),
        Question(q: 'Which Freedom product is TiNbN-coated for metal sensitivity?', options: ['Freedom Titan', 'Freedom Renew', 'Freedom Porous', 'Freedom Partial'], correct: 0),
        Question(q: 'Which company makes the Triathlon knee?', options: ['Zimmer Biomet', 'Stryker', 'DePuy', 'Smith+Nephew'], correct: 1),
        Question(q: 'Stryker\'s robotic platform is called…', options: ['ROSA', 'Mako', 'VELYS', 'CORI'], correct: 1),
        Question(q: 'Which insert is designed to mimic native medial-pivot kinematics?', options: ['CR', 'PS', 'UC', 'MC (Medial Congruent)'], correct: 3),
      ],
    ),
  ],
  exam: tkrExam,
);