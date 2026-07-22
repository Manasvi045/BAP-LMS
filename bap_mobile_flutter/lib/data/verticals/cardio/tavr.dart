// lib/data/verticals/cardio/tavr.dart — TAVR topic.
// 1:1 port of src/content/verticals/cardio/tavr.ts.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';
import 'notes.dart';

const _tavrPhaseCards = <ProductCard>[
  ProductCard(sku: '1. Multidisciplinary Planning & CT Assessment', generic: 'Weeks of detailed CT-based planning determine valve sizing and access strategy before the cath lab.', category: '', construction: '',
    features: ['Annular perimeter from CT is the dominant sizing parameter — the annulus is oval', 'Coronary height <10 mm is a relative contraindication — coronary obstruction risk', 'Iliofemoral minimum lumen diameter must be ≥5.0–5.5 mm for the 14–16 Fr sheath'],
    uses: ['A high-resolution CT of heart, aorta, and leg arteries is obtained.']),
  ProductCard(sku: '2. Vascular Access & Pre-Closure', generic: 'The femoral artery is accessed and pre-closure sutures placed before the large sheath is inserted.', category: '', construction: '',
    features: ['Pre-closure (Perclose × 2) enables suture-based closure of a hole too large for manual compression', 'Ultrasound-guided femoral access reduces vascular complications', 'A venous sheath is placed for the temporary pacing wire'],
    uses: ['Common femoral artery accessed under local anaesthesia with sedation.']),
  ProductCard(sku: '3. Balloon Aortic Valvuloplasty (BAV)', generic: 'A balloon is inflated inside the calcified native valve to crack calcium and create space for the TAVR valve.', category: '', construction: '',
    features: ['Rapid pacing at 180–220 bpm is the critical enabling step — without it the balloon is ejected', 'BAV risks embolising calcific debris — stroke risk is present at this step', 'Haemodynamic recovery after pacing should be swift'],
    uses: ['A guidewire is advanced across the native valve into the LV.']),
  ProductCard(sku: '4. Valve Crimping & Delivery', generic: 'The TAVR valve is compressed onto the delivery system and threaded to the aortic annulus.', category: '', construction: '',
    features: ['Crimping technique affects valve geometry — poor crimping = asymmetric expansion', 'Crossing the aortic arch can disturb atheroma, causing stroke', 'Positioning: SAPIEN ~80% ventricular / 20% aortic; Evolut légèrement plus aortic'],
    uses: ['A tri-leaflet bovine-pericardium valve on a metal frame is crimped onto the delivery system.']),
  ProductCard(sku: '5. Valve Deployment', generic: 'The valve is deployed across the native annulus, immediately beginning to function.', category: '', construction: '',
    features: ['Balloon-expandable (SAPIEN): rapid (~10 s) deployment during pacing — position fixed immediately', 'Self-expanding (Evolut): gradual, repositionable — advantage in complex anatomy', 'Immediate post-deployment aortography is mandatory — check PVL, coronary flow, position'],
    uses: ['For balloon-expandable valves, rapid pacing (180–220 bpm) is re-initiated.']),
  ProductCard(sku: '6. Result Assessment & Optimisation', generic: 'Echo and angiography assess valve function and any leak before the procedure ends.', category: '', construction: '',
    features: ['Trivial/mild PVL: acceptable — minimal long-term impact', 'Moderate/severe PVL: must be addressed before leaving the lab — increased late mortality', 'Echo immediately post-deployment guides any post-dilatation'],
    uses: ['Echo measures the mean gradient (target <20 mmHg) and grades paravalvular leak.']),
  ProductCard(sku: '7. Vascular Closure & Recovery', generic: 'The large femoral sheath is removed, pre-placed sutures close the artery, and recovery begins.', category: '', construction: '',
    features: ['Vascular closure is one of the highest-risk steps — major complications in 3–5%', 'ECG monitoring for 48–72 hours — late complete heart block can develop', 'Stable patients with no conduction issues can mobilise the next day'],
    uses: ['The delivery system is removed over the stiff guidewire.']),
];

const _tavrComplicationCards = <ProductCard>[
  ProductCard(sku: 'Permanent Pacemaker', generic: 'Risk: 10–25%', category: 'high', construction: '', features: ['Conduction disturbance caused by the valve frame compressing the bundle of His.'], uses: []),
  ProductCard(sku: 'Paravalvular Leak (PVL)', generic: 'Risk: mild common; mod/severe 3–5%', category: 'high', construction: '', features: ['Regurgitation around the valve frame; moderate/severe is linked to increased late mortality.'], uses: []),
  ProductCard(sku: 'Stroke / TIA', generic: 'Risk: 2–4%', category: 'high', construction: '', features: ['Embolisation of calcium or aortic plaque during catheter manipulation or deployment.'], uses: []),
  ProductCard(sku: 'Major Vascular Complication', generic: 'Risk: 3–5%', category: 'high', construction: '', features: ['Arterial dissection, rupture, or occlusion at the femoral access site from the large-bore sheath.'], uses: []),
  ProductCard(sku: 'Coronary Obstruction', generic: 'Risk: <1% (catastrophic)', category: 'high', construction: '', features: ['Native leaflet pushed against the coronary ostium by the valve frame, blocking flow.'], uses: []),
  ProductCard(sku: 'Annular Rupture', generic: 'Risk: <1%', category: 'high', construction: '', features: ['Over-expansion of the valve frame tears the aortic annulus.'], uses: []),
];

const _tavrDecision = <DecisionNode>[
  DecisionNode(q: 'Is the patient symptomatic with severe AS?', hint: 'AVA <1.0 cm², mean gradient >40 mmHg, symptoms: angina, syncope, or heart failure'),
  DecisionNode(q: 'Is iliofemoral access adequate?', hint: 'CT minimum lumen diameter throughout the iliofemoral route'),
  DecisionNode(q: 'SAPIEN or Evolut — which platform?', hint: 'Anatomy, calcification pattern, coronary height, pacemaker risk'),
  DecisionNode(q: 'Significant PVL on completion angiography?', hint: 'Colour Doppler or angiography shows circumferential leak'),
  DecisionNode(q: 'Pre-existing RBBB on ECG?', hint: 'Right bundle branch block is the highest pacemaker risk factor'),
  DecisionNode(q: 'Elevated gradients at 30-day follow-up echo?', hint: 'Could be valve thrombosis or patient-prosthesis mismatch'),
];

const _tavrPortfolioCards = <ProductCard>[
  ProductCard(sku: 'Myval™ THV', generic: 'Balloon-expandable transcatheter heart valve', category: 'TAVR Valve', construction: 'Bovine pericardium on hybrid frame',
    features: ['Hybrid honeycomb (hexagonal) frame with anti-calcification-treated bovine pericardial leaflets', 'Unusually broad size matrix: conventional 20/23/26/29 mm, intermediate 21.5/24.5/27.5 mm, and XL 30.5/32 mm', 'Intermediate sizes reduce under-/over-sizing — lower pacemaker rates vs SAPIEN-3 in comparative studies', 'Low paravalvular leak; the first Indian-made commercially launched TAVR valve (2018)'],
    uses: ['Severe symptomatic aortic stenosis', 'Bicuspid / large-annulus anatomy (XL)', 'Valve-in-valve (off-label)']),
  ProductCard(sku: 'Myval Octacor™', generic: 'Next-generation balloon-expandable THV', category: 'TAVR Valve (new gen)', construction: '',
    features: ['Evolution of the Myval platform with a refined frame geometry', 'Comparable early safety and efficacy to leading contemporary THVs'],
    uses: ['Severe aortic stenosis across anatomies']),
  ProductCard(sku: 'Navigator™ Delivery System', generic: 'High-flex over-the-wire delivery system', category: 'Delivery System', construction: '',
    features: ['Distal end flexes beyond 180° to cross the native valve and aortic arch', 'Counter-opposing soft stoppers crimp the Myval directly onto the balloon', 'Dense / light marking bands aid coplanar deployment'],
    uses: ['Myval / Myval Octacor delivery']),
  ProductCard(sku: 'MyClip™', generic: 'Transcatheter edge-to-edge mitral repair (TEER)', category: 'Structural Heart (Mitral)', construction: '',
    features: ['Made-in-India TEER device introduced in 2025 for mitral regurgitation', 'Edge-to-edge leaflet approximation'],
    uses: ['Mitral regurgitation repair']),
];

final TablePage _tavrCompTable = TablePage(
  heading: 'TAVR competitive landscape',
  columns: ['Segment', 'Meril', 'Edwards', 'Medtronic', 'Abbott', 'Boston Scientific'],
  rows: <List<String>>[
    ['Balloon-expandable THV', 'Myval / Myval Octacor', 'SAPIEN 3 / 3 Ultra', '—', '—', '—'],
    ['Self-expanding THV', '—', '—', 'Evolut R / PRO / FX', 'Navitor', 'ACURATE neo2'],
    ['XL / large-annulus', 'Myval XL (30.5 / 32 mm)', 'SAPIEN 3 (≤29 mm)', 'Evolut FX (≤34 mm)', '—', '—'],
    ['Delivery system', 'Navigator', 'Commander / Alterra', 'EnVeo / InLine', 'FlexNav', '—'],
    ['Mitral TEER', 'MyClip', 'PASCAL', '—', 'MitraClip', '—'],
  ],
);

List<Question> _phq(String title, int n) =>
    List.generate(n, (i) => Question(q: 'Placeholder $title question ${i + 1}? (replace with real content)', options: ['Answer A', 'Answer B', 'Answer C'], correct: i % 3));

final Topic tavrTopic = Topic(
  id: 'tavr',
  label: 'TAVR',
  icon: 'Stethoscope',
  cert: 'TAVR Specialist',
  passMark: 90,
  sections: <Section>[
    Section(id: 'overview', title: 'Overview', icon: 'BookOpen', blurb: 'Aortic stenosis, what TAVR is, and who it is for.', color: sectionColorsHex[0], pages: <Page>[
      read('What Is Aortic Stenosis?', 'Progressive calcific narrowing of the aortic valve that obstructs outflow from the left ventricle, causing angina, syncope, and heart failure.'),
      read('Why Is AS So Dangerous Without Treatment?', 'Once symptomatic, severe aortic stenosis carries a poor prognosis, with high mortality within 2–3 years if the valve is not replaced.'),
      read('What Is TAVR?', 'Transcatheter Aortic Valve Replacement delivers a bioprosthetic valve via a catheter (usually femoral) without sternotomy, cardiac arrest, or a heart-lung machine.'),
      read('Who Is TAVR For?', 'Initially high- and intermediate-surgical-risk patients with severe symptomatic AS; now extended across all risk categories, including selected low-risk patients.'),
      read('The Two Main Valve Platforms', 'Balloon-expandable (Edwards SAPIEN) and self-expanding (Medtronic Evolut); Meril\'s Myval is balloon-expandable. Choice depends on anatomy, calcification, and pacemaker risk.'),
      read('Pre-Procedural Planning', 'CT measures the annulus, coronary height, and iliofemoral access; multidisciplinary heart-team planning determines valve size and access route.'),
      vid('TAVR overview'),
    ], quiz: _phq('TAVR overview', 2)),
    Section(id: 'fundamentals', title: 'Fundamentals', icon: 'FileText', blurb: 'Valve anatomy, CT sizing, pacing, leak, and valve-in-valve.', color: sectionColorsHex[1], pages: <Page>[
      read('Aortic Valve Anatomy', 'A three-cusp semilunar valve (left, right, and non-coronary cusps) between the LV and aorta; the bundle of His runs just below the annulus.'),
      read('CT Sizing & Annular Measurement', 'The oval annulus is sized by perimeter/area from CT — not diameter alone — to select the correct valve and minimise leak or rupture.'),
      read('Rapid Ventricular Pacing', 'Pacing at 180–220 bpm drops cardiac output to near zero for seconds so the ejecting heart does not displace the valve during deployment.'),
      read('Paravalvular Leak', 'Regurgitation around the valve frame; moderate or severe PVL is associated with increased late mortality and must be addressed before leaving the lab.'),
      read('Conduction Disturbances & Pacemaker', 'The frame can compress the adjacent conduction system; 10–25% of patients need a permanent pacemaker, with pre-existing RBBB the strongest risk factor.'),
      read('Valve-in-Valve TAVR', 'A transcatheter valve deployed inside a degenerated surgical bioprosthesis, avoiding a high-risk redo open operation.'),
      vid('TAVR fundamentals'),
    ], quiz: _phq('TAVR fundamentals', 2)),
    Section(id: 'procedure', title: 'TAVR procedure', icon: 'Activity', blurb: 'From CT planning to deployment and vascular closure.', color: sectionColorsHex[2], pages: <Page>[
      read('How TAVR works', 'TAVR replaces a severely narrowed aortic valve with a new bioprosthetic valve delivered through a catheter in the femoral artery — without opening the chest, stopping the heart, or using a heart-lung machine.'),
      cardsPage('Step-by-step TAVR', _tavrPhaseCards),
      vid('TAVR procedure walkthrough'),
    ], quiz: _phq('TAVR procedure', 2)),
    Section(id: 'outcomes', title: 'Recovery, complications & decisions', icon: 'ClipboardList', blurb: 'Recovery, key complications, and clinical decision points.', color: sectionColorsHex[3], pages: <Page>[
      read('Recovery journey', 'Day 0–1 — CCU monitoring. Day 1–2 — mobilisation begins if haemodynamically stable. Day 2–5 — hospital discharge for most patients. 30 days — mandatory outpatient review. 12 months and annually — echocardiogram for valve surveillance.'),
      cardsPage('Complications', _tavrComplicationCards),
      decisionPage('TAVR clinical decision points', _tavrDecision),
      vid('Recovery & complications'),
    ], quiz: _phq('TAVR outcomes', 2)),
    Section(id: 'portfolio', title: 'Meril portfolio', icon: 'Layers', blurb: 'Meril\'s Myval THV series and structural-heart devices.', color: sectionColorsHex[4], pages: <Page>[
      read('Meril structural-heart portfolio', portfolioNote),
      cardsPage('Meril TAVR / structural portfolio', _tavrPortfolioCards),
      vid('Meril TAVR portfolio'),
    ], quiz: _phq('Meril TAVR portfolio', 2)),
    Section(id: 'competitors', title: 'Competitive landscape', icon: 'Grid3x3', blurb: 'Myval against Edwards SAPIEN, Medtronic Evolut and others.', color: sectionColorsHex[5], pages: <Page>[
      read('Competitor landscape', portfolioNote),
      _tavrCompTable,
      vid('Competitive positioning'),
    ], quiz: _phq('TAVR competition', 2)),
  ],
  exam: tavrExam,
);