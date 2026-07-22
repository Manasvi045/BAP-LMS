// lib/data/verticals/cardio/savr.dart — SAVR topic.
// 1:1 port of src/content/verticals/cardio/savr.ts.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';
import 'notes.dart';

const _savrPhaseCards = <ProductCard>[
  ProductCard(sku: '1. Anaesthesia, Lines & Preparation', generic: 'Patient is fully anaesthetised, monitored with multiple lines, and a TOE probe is placed.', category: '', construction: '', features: ['TOE is mandatory throughout — confirms diagnosis and verifies valve function after bypass', 'Large-bore IV and arterial monitoring allow rapid response to instability', 'Whole team briefs together before incision — timeout protocol'], uses: ['General anaesthesia, intubated and ventilated.']),
  ProductCard(sku: '2. Sternotomy & Pericardiotomy', generic: 'The sternum is divided with the saw and the pericardium opened to expose the heart.', category: '', construction: '', features: ['Full sternotomy gives complete exposure — standard for complex/combined procedures', 'Mini-sternotomy: faster recovery, lower transfusion, comparable outcomes in specialist centres', 'Pericardium left open/loosely closed for post-op drainage'], uses: ['Midline incision from sternal notch to xiphisternum (~20 cm).']),
  ProductCard(sku: '3. Cardiopulmonary Bypass (CPB) Cannulation', generic: 'Tubes are inserted into the heart and aorta to connect the patient to the heart-lung machine.', category: '', construction: '', features: ['CPB initiation is a major physiological event managed by the perfusionist', 'Cross-clamp time starts when the aorta is clamped — heart is stopped and protected', 'Cardioplegia re-dosed every 20 minutes for myocardial protection'], uses: ['Aorta cannulated first as the arterial return line.']),
  ProductCard(sku: '4. Aortotomy & Native Valve Excision', generic: 'The aorta is opened and the diseased native valve completely excised and calcium removed.', category: '', construction: '', features: ['Complete leaflet excision is essential', 'Careful decalcification — too little = poor seat; too aggressive = rupture/dissection', 'Constant irrigation washes away debris to prevent emboli'], uses: ['Ascending aorta opened just above the valve (aortotomy) with the heart arrested.']),
  ProductCard(sku: '5. Annular Sizing & Prosthesis Selection', generic: 'The prepared annulus is measured to select the largest possible prosthetic valve that will fit.', category: '', construction: '', features: ['Largest possible valve is the goal — every mm² of orifice area improves haemodynamics', 'Annular enlargement (Nicks, Manouguian) allows a larger valve but adds complexity', 'Valve type confirmed by the team before opening the valve'], uses: ['Rigid circular sizers of increasing diameter are used.']),
  ProductCard(sku: '6. Valve Implantation & Suturing', generic: 'The prosthetic valve is sutured into the aortic annulus with multiple carefully placed sutures.', category: '', construction: '', features: ['Even, well-tensioned sutures are the surgeon\'s most consequential technical skill', 'Pledgeted sutures distribute tension across friable annular tissue — reduce leak/cut-through', 'Valve inspected for good seating, free leaflet/disc motion, and no paravalvular gaps'], uses: ['12–18 interrupted sutures or a running technique secure the valve.']),
  ProductCard(sku: '7. Aortotomy Closure & De-airing', generic: 'The aorta is closed, air removed from the heart, and the patient weaned from bypass.', category: '', construction: '', features: ['De-airing is safety-critical — one air bubble to the brain = stroke; to a coronary = MI', 'TOE after bypass gives the definitive intraoperative valve assessment', 'Significant paravalvular leak → surgeon can return on bypass and revise — SAVR\'s precision advantage'], uses: ['Aortotomy closed in two layers with continuous Prolene.']),
  ProductCard(sku: '8. Decannulation, Haemostasis & Chest Closure', generic: 'Bypass is disconnected, bleeding controlled, and the chest closed in layers.', category: '', construction: '', features: ['Rigid sternal wire fixation prevents instability, pain, and wound infection', 'Chest drains are critical — pericardial blood can cause tamponade', 'Most patients extubated the same evening or next morning (ERAS-cardiac)'], uses: ['CPB discontinued; heparin reversed with protamine.']),
];

const _savrComplicationCards = <ProductCard>[
  ProductCard(sku: 'Atrial Fibrillation (AF)', generic: 'Risk: 25–40%', category: 'medium', construction: '', features: ['The most common post-SAVR complication.'], uses: []),
  ProductCard(sku: 'Stroke / Neurological Events', generic: 'Risk: 1–3%', category: 'high', construction: '', features: ['Embolism from aortic manipulation, calcific debris, or air embolism.'], uses: []),
  ProductCard(sku: 'Low Cardiac Output Syndrome', generic: 'Risk: 5–10%', category: 'high', construction: '', features: ['Ventricular dysfunction following CPB and cardiac arrest.'], uses: []),
  ProductCard(sku: 'Paravalvular Leak', generic: 'Risk: 2–5%', category: 'high', construction: '', features: ['Regurgitation around the sewing ring from inadequate suturing or residual calcium.'], uses: []),
  ProductCard(sku: 'Sternal Wound Infection / Dehiscence', generic: 'Risk: 1–2%', category: 'high', construction: '', features: ['Superficial or deep (mediastinitis) sternal wound infection.'], uses: []),
  ProductCard(sku: 'Permanent Pacemaker', generic: 'Risk: 3–8%', category: 'medium', construction: '', features: ['Complete heart block from sutures/retraction near the AV node during decalcification.'], uses: []),
];

const _savrDecision = <DecisionNode>[
  DecisionNode(q: 'Mechanical or tissue valve — patient age 58, no bleeding risk?', hint: 'Under 60, able to manage anticoagulation safely'),
  DecisionNode(q: 'Tissue or mechanical — patient age 70, history of GI bleeding?', hint: 'Elderly patient, significant bleeding history'),
  DecisionNode(q: 'SAVR or TAVR — patient age 62, STS score 2%, bicuspid valve?', hint: 'Young, low surgical risk, complex anatomy'),
  DecisionNode(q: 'SAVR + CABG needed — is TAVR still an option?', hint: 'Concomitant coronary disease requiring bypass'),
  DecisionNode(q: 'Patient-prosthesis mismatch risk in small woman — small annulus?', hint: 'Indexed EOA after implantation may be inadequate'),
  DecisionNode(q: 'Tissue valve failing at 18 years — redo surgery or valve-in-valve TAVR?', hint: 'Previous surgical valve now degenerated — high surgical re-do risk'),
];

const _savrPortfolioCards = <ProductCard>[
  ProductCard(sku: 'Meril Mechanical Heart Valve', generic: 'Bileaflet mechanical prosthesis', category: 'Mechanical Valve', construction: '',
    features: ['Durable mechanical prosthesis for aortic, mitral, and double valve replacement', 'Requires lifelong anticoagulation (warfarin)', 'Latest designs compatible with minimal-access surgery'],
    uses: ['AVR / MVR / DVR in younger patients']),
  ProductCard(sku: 'Meril Bioprosthetic (Pericardial) Valve', generic: 'Pericardial tissue valve', category: 'Tissue Valve', construction: '',
    features: ['Pericardial bioprosthesis — no long-term anticoagulation required', 'For aortic and mitral replacement', 'Minimal-access compatible; suited to future valve-in-valve'],
    uses: ['AVR / MVR in older patients or those who cannot anticoagulate']),
  ProductCard(sku: 'Intra-Aortic Balloon Catheter Kit', generic: 'IABP counter-pulsation', category: 'Cardiac Surgery', construction: '',
    features: ['Provides counter-pulsation in the aorta to reduce left-ventricular workload', 'For cardiogenic shock, refractory angina, weaning from bypass, post-surgical dysfunction'],
    uses: ['Haemodynamic support']),
  ProductCard(sku: 'Intra-Coronary Shunt', generic: 'Coronary shunt for CABG', category: 'Cardiac Surgery', construction: '',
    features: ['Maintains distal flow and a bloodless field during vessel anastomosis', 'Reduces the risk of myocardial damage during CABG'],
    uses: ['CABG anastomosis']),
  ProductCard(sku: 'Tissue Stabiliser', generic: 'Myocardial stabiliser', category: 'Cardiac Surgery', construction: '',
    features: ['Stabilises the beating-heart surface during off-pump CABG'],
    uses: ['Off-pump CABG']),
];

final TablePage _savrCompTable = TablePage(
  heading: 'Surgical valve competitive landscape',
  columns: ['Segment', 'Meril', 'Edwards', 'Medtronic', 'Abbott', 'LivaNova'],
  rows: <List<String>>[
    ['Tissue (pericardial) AV', 'Meril Pericardial Valve', 'PERIMOUNT / Inspiris Resilia', 'Avalus / Hancock II / Mosaic', 'Trifecta GT / Epic', 'Crown PRT'],
    ['Mechanical AV', 'Meril Mechanical Valve', '—', 'Open Pivot', 'Regent / Masters HP', 'Bicarbon'],
    ['Sutureless / rapid-deployment', '—', 'INTUITY Elite', '—', '—', 'Perceval'],
    ['Mitral tissue valve', 'Meril Pericardial (mitral)', 'PERIMOUNT Mitral', 'Hancock II Mitral', 'Epic Mitral', 'Mitroflow / Crown'],
    ['Intra-aortic balloon pump', 'Meril IABP kit', '—', '—', '—', '—'],
  ],
);

List<Question> _phq(String title, int n) =>
    List.generate(n, (i) => Question(q: 'Placeholder $title question ${i + 1}? (replace with real content)', options: ['Answer A', 'Answer B', 'Answer C'], correct: i % 3));

final Topic savrTopic = Topic(
  id: 'savr',
  label: 'SAVR',
  icon: 'Stethoscope',
  cert: 'SAVR Specialist',
  passMark: 90,
  sections: <Section>[
    Section(id: 'overview', title: 'Overview', icon: 'BookOpen', blurb: 'What SAVR is, SAVR vs TAVR, valve types, and outcomes.', color: sectionColorsHex[0], pages: <Page>[
      read('What Is SAVR?', 'Surgical Aortic Valve Replacement is the open-heart operation that excises the diseased native valve and sutures in a prosthetic valve under direct vision, on cardiopulmonary bypass.'),
      read('Who Needs SAVR vs TAVR?', 'SAVR suits younger, lower-risk patients, those needing concomitant procedures (CABG, root, mitral), or complex anatomy; TAVR suits higher-risk or older patients.'),
      read('The Two Prosthetic Valve Types', 'Mechanical valves (durable but need lifelong warfarin) and tissue / bioprosthetic valves (no long-term anticoagulation but limited durability).'),
      read('Surgical Approach', 'Full median sternotomy or minimally invasive (mini-sternotomy / thoracotomy) provides access; the aorta is opened above the valve (aortotomy).'),
      read('Cardiopulmonary Bypass & Cardiac Arrest', 'A heart-lung machine takes over circulation while the aorta is cross-clamped and cardioplegia arrests and protects the heart.'),
      read('Outcomes & Durability', 'SAVR has decades of proven durability; tissue valves last ~10–20 years, mechanical valves often lifelong, with low operative mortality in elective cases.'),
      vid('SAVR overview'),
    ], quiz: _phq('SAVR overview', 2)),
    Section(id: 'fundamentals', title: 'Fundamentals', icon: 'FileText', blurb: 'Valve choice, cardioplegia, sizing, mismatch, and combined surgery.', color: sectionColorsHex[1], pages: <Page>[
      read('Mechanical vs Tissue Valve — The Core Decision', 'Driven mainly by age and bleeding risk: mechanical for younger patients who can manage warfarin; tissue for older patients or those cannot anticoagulate.'),
      read('Cardioplegia — Protecting the Heart During Arrest', 'Cold, high-potassium solution stops the heart in diastole and minimises metabolism, protecting the myocardium during the cross-clamp period.'),
      read('Valve Sizing & Suture Techniques', 'The annulus is measured with sizers to fit the largest appropriate valve; pledgeted interrupted or running sutures secure it without paravalvular gaps.'),
      read('Transcatheter Valve-in-Valve — Planning for the Future', 'Implanting a tissue valve with future valve-in-valve TAVR in mind influences valve choice and sizing.'),
      read('Patient-Prosthesis Mismatch', 'When the prosthesis effective orifice area is too small for the patient\'s body size, residual gradients persist; avoided by choosing an adequately sized valve.'),
      read('Concomitant Procedures', 'SAVR allows simultaneous CABG, aortic root replacement, mitral surgery, or AF ablation in one operation — a key advantage over TAVR.'),
      vid('SAVR fundamentals'),
    ], quiz: _phq('SAVR fundamentals', 2)),
    Section(id: 'procedure', title: 'Surgical technique', icon: 'Activity', blurb: 'The eight surgical phases from anaesthesia to chest closure.', color: sectionColorsHex[2], pages: <Page>[
      read('How SAVR works', 'SAVR removes the diseased native aortic valve and replaces it with a prosthetic valve under direct vision, on cardiopulmonary bypass with the heart arrested and protected by cardioplegia.'),
      cardsPage('The eight surgical phases', _savrPhaseCards),
      vid('SAVR surgical walkthrough'),
    ], quiz: _phq('SAVR procedure', 2)),
    Section(id: 'outcomes', title: 'Recovery, complications & decisions', icon: 'ClipboardList', blurb: 'Recovery, key complications, and clinical decision points.', color: sectionColorsHex[3], pages: <Page>[
      read('Recovery journey', 'Day 0–1 (ICU) — intubated and ventilated initially. Day 2–3 — transfer from ICU to step-down ward. Day 4–7 — hospital discharge for uncomplicated recovery. 6 weeks — sternal union confirmed. 3–6 months — full recovery.'),
      cardsPage('Complications', _savrComplicationCards),
      decisionPage('SAVR clinical decision points', _savrDecision),
      vid('Recovery & complications'),
    ], quiz: _phq('SAVR outcomes', 2)),
    Section(id: 'portfolio', title: 'Meril portfolio', icon: 'Layers', blurb: 'Meril\'s surgical heart valves and cardiac-surgery devices.', color: sectionColorsHex[4], pages: <Page>[
      read('Meril cardiac-surgery portfolio', portfolioNote),
      cardsPage('Meril surgical valve & cardiac-surgery portfolio', _savrPortfolioCards),
      vid('Meril cardiac-surgery portfolio'),
    ], quiz: _phq('Meril SAVR portfolio', 2)),
    Section(id: 'competitors', title: 'Competitive landscape', icon: 'Grid3x3', blurb: 'Meril surgical valves against Edwards, Medtronic, Abbott and LivaNova.', color: sectionColorsHex[5], pages: <Page>[
      read('Competitor landscape', portfolioNote),
      _savrCompTable,
      vid('Competitive positioning'),
    ], quiz: _phq('SAVR competition', 2)),
  ],
  exam: savrExam,
);