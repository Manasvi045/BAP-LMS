// lib/data/verticals/cardio/ptca.dart — PTCA topic.
// 1:1 port of src/content/verticals/cardio/ptca.ts.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';
import 'notes.dart';

const _ptcaStrategyCards = <ProductCard>[
  ProductCard(sku: 'Balloon Angioplasty Only (POBA)', generic: 'A balloon is inflated to compress the plaque and widen the artery. No permanent implant is left behind.', category: 'Least Common', construction: '',
    features: ['A balloon catheter is advanced over the guidewire to the stenosis site.', 'Antiplatelet: aspirin alone, or brief dual antiplatelet for 2–4 weeks', '~30–40% restenosis rate without a stent — why it is rarely the sole strategy', 'Drug-coated balloons (DCB) deliver paclitaxel to the vessel wall during inflation — improving outcomes without a permanent implant', 'POBA remains the first step in every PCI — all stenting begins with balloon pre-dilatation'],
    uses: ['Very small vessels (<2.0–2.5 mm)', 'Bifurcation side branches', 'In-stent restenosis (cutting/drug-coated balloon)', 'Cannot tolerate even short DAPT', 'Bridge to surgery']),
  ProductCard(sku: 'Bare Metal Stent (BMS)', generic: 'A metal mesh scaffold is permanently deployed inside the artery to prevent recoil. No drug coating.', category: 'Rarely Used Today', construction: '',
    features: ['A laser-cut mesh tube of stainless steel or cobalt-chromium alloy, crimped onto a balloon catheter.', 'Antiplatelet: DAPT (aspirin + clopidogrel) for a minimum of 4–6 weeks', '~15–25% restenosis at 1 year — significantly higher than DES (<5%)', 'Still requires DAPT for at least 4 weeks to prevent acute/subacute stent thrombosis', 'BMS use has fallen to <5% of PCI in high-income countries — largely replaced by DES'],
    uses: ['Surgery needed within 4–6 weeks (short DAPT)', 'Very high bleeding risk', 'Large-vessel lesions in resource-limited settings']),
  ProductCard(sku: 'Drug-Eluting Stent (DES)', generic: 'A metal scaffold coated with antiproliferative medication that elutes into the vessel wall, dramatically reducing re-narrowing.', category: 'Gold Standard', construction: '',
    features: ['A metal scaffold coated with a polymer that slowly releases an antiproliferative drug (commonly everolimus or zotarolimus) into the vessel wall.', 'Antiplatelet: DAPT (aspirin + P2Y12 inhibitor) for 6–12 months standard', '<5% restenosis at 1 year — the primary reason DES replaced BMS as default', 'Stent thrombosis ~0.5–1% annually — catastrophic if it occurs; prevented by uninterrupted DAPT', 'DAPT duration is the critical post-procedure decision — stopping early sharply increases stent thrombosis risk'],
    uses: ['Virtually all stentable lesions', 'STEMI (primary PCI)', 'Stable angina revascularisation', 'Complex lesions', 'Diabetic patients', 'Multivessel disease']),
];

const _ptcaPhaseCards = <ProductCard>[
  ProductCard(sku: '1. Patient Preparation & Access', generic: 'Patient is positioned, local anaesthetic applied, and arterial access obtained in the wrist or groin.', category: '', construction: '',
    features: ['Radial access: fewer complications, no bed rest, patient can sit up immediately after', 'Ultrasound guidance for access reduces puncture complications', 'Heparin given to maintain ACT >250 seconds throughout'],
    uses: ['The patient lies flat on the cath lab table.']),
  ProductCard(sku: '2. Guide Catheter & Coronary Engagement', generic: 'A guide catheter is steered to the opening of the target coronary artery under X-ray guidance.', category: '', construction: '',
    features: ['Guide catheter selection depends on coronary anatomy — different shapes for left and right', 'Contrast injection with fluoroscopy defines lesion severity, length, and calcification', 'Guide catheter must provide enough backup support for forceful device delivery'],
    uses: ['A 5–7 French guide catheter is advanced around the aortic arch to the coronary ostia.']),
  ProductCard(sku: '3. Guidewire Crossing', generic: 'A 0.014-inch guidewire is steered through the stenosis and parked in the distal vessel beyond it.', category: '', construction: '',
    features: ['The guidewire is the foundation of the entire procedure — everything else is delivered over it', 'Wire tip shape is critical — too stiff = perforation; too soft = won\'t cross', 'CTOs may need dedicated CTO wires, retrograde approaches, or dissection-re-entry'],
    uses: ['A 0.014-inch (0.36 mm) wire is positioned distal to the blockage.']),
  ProductCard(sku: '4. Pre-Dilatation (Balloon Angioplasty)', generic: 'A balloon catheter is advanced to the stenosis and inflated to open the lesion before stenting.', category: '', construction: '',
    features: ['Pre-dilatation is standard before stenting — underprepared vessels cause stent under-expansion', 'Calcified lesions: Rotablator or IVL may be required before any balloon can expand', 'For POBA-only strategy: this is the definitive treatment step'],
    uses: ['A semi-compliant balloon sized to the vessel diameter is inflated at the lesion.']),
  ProductCard(sku: '5. Stent Deployment', generic: 'The stent (BMS or DES) is positioned precisely at the lesion and expanded with balloon inflation.', category: '', construction: '',
    features: ['Stent diameter matched to the vessel reference diameter (typically 2.5–4.0 mm)', 'Stent length must cover the whole lesion plus normal vessel each side (avoid geographic miss)', 'Deployment pressure determines final expansion — under-expansion is the #1 cause of stent thrombosis'],
    uses: ['The balloon-mounted stent is advanced over the wire and expanded.']),
  ProductCard(sku: '6. Post-Dilatation & Optimisation', generic: 'A non-compliant balloon inflates at high pressure inside the stent to ensure full expansion and apposition.', category: '', construction: '',
    features: ['OCT or IVUS-guided PCI reduces stent thrombosis vs angiography alone', 'TIMI-3 flow should be confirmed on final angiography', 'Any dissection, flow limitation, or edge problem → additional stent immediately'],
    uses: ['A non-compliant balloon is inflated to 14–20+ atmospheres inside the stent.']),
  ProductCard(sku: '7. Closure & Recovery', generic: 'Access site is closed and the patient monitored before discharge.', category: '', construction: '',
    features: ['Radial access: no bed rest, faster discharge, higher patient satisfaction', 'DAPT must be started before and continued uninterrupted — premature cessation is the top cause of stent thrombosis', 'All patients need outpatient cardiology follow-up and cardiac rehabilitation referral'],
    uses: ['Guidewire, catheters, and sheath are removed.']),
];

const _ptcaComplicationCards = <ProductCard>[
  ProductCard(sku: 'Stent Thrombosis', generic: 'Risk: 0.5–1%/year', category: 'high', construction: '', features: ['Acute clot formation on the stent surface — presents as acute MI.'], uses: []),
  ProductCard(sku: 'In-Stent Restenosis', generic: 'Risk: <5% (DES), ~20% (BMS)', category: 'medium', construction: '', features: ['Gradual re-narrowing due to neointimal tissue growth through stent struts.'], uses: []),
  ProductCard(sku: 'Access Site Complications', generic: 'Risk: 1–3%', category: 'medium', construction: '', features: ['Haematoma, pseudoaneurysm, or arteriovenous fistula at the radial or femoral access site.'], uses: []),
  ProductCard(sku: 'Coronary Dissection / Perforation', generic: 'Risk: <1%', category: 'high', construction: '', features: ['Guidewire or balloon can dissect or perforate the artery — emergency covered stent or surgery may be required.'], uses: []),
  ProductCard(sku: 'Contrast-Induced Nephropathy', generic: 'Risk: 1–5%', category: 'medium', construction: '', features: ['Contrast dye can impair kidney function, especially in diabetic or CKD patients.'], uses: []),
  ProductCard(sku: 'Stroke', generic: 'Risk: <0.5%', category: 'high', construction: '', features: ['Catheter manipulation can dislodge aortic plaque.'], uses: []),
];

const _ptcaDecision = <DecisionNode>[
  DecisionNode(q: 'Is this a STEMI — ST elevation on ECG?', hint: 'Complete vessel occlusion, immediate threat to myocardium'),
  DecisionNode(q: 'Is lesion significance uncertain on angiography?', hint: 'Intermediate stenosis 40–70% by visual estimate'),
  DecisionNode(q: 'DES or BMS — which stent?', hint: 'Restenosis risk vs DAPT compliance and bleeding risk'),
  DecisionNode(q: 'Balloon only (no stent) — when is POBA appropriate?', hint: 'Small vessels, bifurcation side branches, in-stent restenosis'),
  DecisionNode(q: 'Is the lesion severely calcified?', hint: 'Heavy calcium prevents balloon and stent expansion'),
  DecisionNode(q: 'Stent underexpansion suspected after deployment?', hint: 'IVUS or OCT shows incomplete apposition or small minimum lumen area'),
];

const _ptcaPortfolioCards = <ProductCard>[
  ProductCard(sku: 'BioMime™', generic: 'Sirolimus-eluting coronary stent (SES)', category: 'Drug-Eluting Stent', construction: '65 µm ultra-thin CoCr',
    features: ['Ultra-thin 65 µm struts for faster endothelialisation and early vascular healing', 'Novel hybrid design — closed cells at both ends, open cells in the middle — enabling morphology-mediated expansion', 'BioPoly biodegradable polymer (~2 µm), stable and elastic', 'Low balloon overhang <0.5 mm to minimise healthy-vessel injury', 'Non-inferiority to Xience DES shown in meriT-V (EuroIntervention, 2018)'],
    uses: ['De novo coronary lesions', '>500,000 deployed in >94 countries']),
  ProductCard(sku: 'BioMime Morph™', generic: 'World\'s first tapered sirolimus-eluting stent', category: 'Tapered DES', construction: '',
    features: ['First tapered SES — diameter steps down along its length to match natural vessel tapering', 'Designed for long, tapering coronary segments'],
    uses: ['Long / tapering lesions']),
  ProductCard(sku: 'BioMime Lineage™', generic: '65 µm SES on a monolithic delivery system', category: 'Drug-Eluting Stent', construction: '65 µm CoCr',
    features: ['Proven BioMime hybrid open/closed cell design', 'Monolithic distal-shaft delivery — strong pushability and trackability', 'Reinforced hypo-tube and hydrophilic coating for complex anatomy', 'Elongated 7.5 mm distal tip for a low entry profile'],
    uses: ['Complex / difficult-to-cross lesions']),
  ProductCard(sku: 'Evermine50™', generic: 'Everolimus-eluting coronary stent (EES)', category: 'Ultra-thin DES', construction: '50 µm strut',
    features: ['50 µm struts — among the thinnest EES platforms', 'Faster endothelialisation, less vessel injury and inflammation'],
    uses: ['De novo coronary lesions']),
  ProductCard(sku: 'MeRes100™', generic: 'Sirolimus-eluting bioresorbable scaffold (BRS)', category: 'Bioresorbable Scaffold', construction: '100 µm poly-L-lactic acid',
    features: ['100 µm PLLA scaffold — thinner than earlier BRS (Absorb 156 µm, Igaki-Tamai 170 µm)', 'Provides support then fully resorbs over ~2–3 years, leaving no permanent implant', 'Releases sirolimus with near-complete strut coverage', 'Zero scaffold thrombosis and low MACE in MeRes-1 / MeRes-1 Extend'],
    uses: ['De novo lesions in suitable vessels']),
  ProductCard(sku: 'Mozec™ (Rx / NC / CTO)', generic: 'PTCA balloon dilatation catheters', category: 'Balloon Catheters', construction: '',
    features: ['Mozec Rx semi-compliant and Mozec NC non-compliant balloons', 'Novalon balloon material with multi-fold low-wrap profile; MeriStem hypo-tube; MeriGlide hydrophilic coating', 'Mozec CTO balloon for chronic total occlusions and complex lesions', 'US-FDA approved'],
    uses: ['Pre-dilatation', 'Post-dilatation / optimisation', 'CTO crossing']),
];

final TablePage _ptcaCompTable = TablePage(
  heading: 'Coronary competitive landscape',
  columns: ['Segment', 'Meril', 'Abbott', 'Boston Scientific', 'Medtronic', 'Biotronik', 'Terumo'],
  rows: <List<String>>[
    ['Workhorse DES', 'BioMime / BioMime Lineage', 'Xience', 'Promus ELITE', 'Resolute Onyx', 'Orsiro Mission', 'Ultimaster Tansei'],
    ['Ultra-thin-strut DES', 'Evermine50', 'Xience Skypoint', 'Synergy', 'Onyx Frontier', 'Orsiro', 'Ultimaster'],
    ['Bioresorbable scaffold', 'MeRes100', 'Absorb (withdrawn)', '—', '—', '—', '—'],
    ['PTCA balloons (SC / NC)', 'Mozec / Mozec NC', 'NC Trek / NC Traveler', 'NC Emerge', 'NC Euphora / Sprinter', 'Pantera', '—'],
    ['CTO / specialty balloon', 'Mozec CTO', 'Mini Trek', 'Sterling', '—', '—', '—'],
    ['Drug-coated balloon', '—', '—', 'Agent DCB', '—', 'Pantera Lux', '—'],
  ],
);

final Topic ptcaTopic = Topic(
  id: 'ptca',
  label: 'PTCA',
  icon: 'Activity',
  cert: 'PTCA Specialist',
  passMark: 85,
  sections: <Section>[
    Section(
      id: 'overview',
      title: 'Overview',
      icon: 'BookOpen',
      blurb: 'Coronary artery disease, what PTCA is, and why it is performed.',
      color: sectionColorsHex[0],
      pages: <Page>[
        read('What Is Coronary Artery Disease?', 'Coronary artery disease is narrowing of the coronary arteries by atherosclerotic plaque, reducing blood flow to the heart muscle and causing angina, ischaemia, or myocardial infarction.'),
        read('What Is PTCA?', 'Percutaneous Transluminal Coronary Angioplasty is a catheter-based procedure that reopens a narrowed coronary artery using balloon inflation, usually followed by stent placement, to restore myocardial blood flow.'),
        read('Why Is PTCA Performed?', 'To relieve angina, restore blood flow in acute coronary syndromes (especially STEMI), and improve outcomes when medical therapy alone is insufficient.'),
        read('The Three Types of Coronary Intervention', 'Balloon angioplasty alone (POBA), bare-metal stent (BMS), and drug-eluting stent (DES) — selected by vessel size, lesion type, and the patient\'s ability to take antiplatelet therapy.'),
        read('Coronary Anatomy', 'The left main divides into the LAD and circumflex; the right coronary artery supplies the inferior wall. Lesion location and the territory supplied determine procedural risk and urgency.'),
        read('Access & Guidance', 'Access is most commonly radial (lower bleeding, faster ambulation) or femoral; fluoroscopy with contrast guides the catheters, while IVUS/OCT or FFR refine decisions.'),
        vid('PTCA overview'),
      ],
      quiz: _placeholderQuiz('PTCA overview', 2),
    ),
    Section(
      id: 'fundamentals',
      title: 'Fundamentals',
      icon: 'FileText',
      blurb: 'Atherosclerosis, the ACS spectrum, guidewires, and physiology.',
      color: sectionColorsHex[1],
      pages: <Page>[
        read('Atherosclerosis — The Root Cause', 'Lipid-rich plaque builds up in the arterial wall over decades; plaque rupture triggers thrombosis and acute coronary syndromes.'),
        read('The ACS Spectrum', 'Acute coronary syndrome spans unstable angina, NSTEMI, and STEMI — STEMI represents complete vessel occlusion needing immediate reperfusion.'),
        read('Guidewires — The Foundation of All PCI', 'A 0.014-inch guidewire is steered across the lesion first; every balloon and stent is delivered over it, so wire choice and handling are critical.'),
        read('Balloon Angioplasty Mechanics', 'An inflated balloon compresses plaque and stretches the vessel wall; it is the first step in every PCI and the definitive treatment in POBA-only cases.'),
        read('Stent Thrombosis vs Restenosis', 'Stent thrombosis is acute clot on the stent (presents as MI, prevented by uninterrupted DAPT); restenosis is gradual re-narrowing from tissue growth (far lower with DES).'),
        read('Fractional Flow Reserve (FFR)', 'FFR measures the pressure drop across a stenosis; a value below 0.80 indicates a flow-limiting lesion that benefits from stenting.'),
        vid('PTCA fundamentals'),
      ],
      quiz: _placeholderQuiz('PTCA fundamentals', 2),
    ),
    Section(
      id: 'procedure',
      title: 'Coronary intervention',
      icon: 'Activity',
      blurb: 'The three strategies and the step-by-step PCI procedure.',
      color: sectionColorsHex[2],
      pages: <Page>[
        read('How coronary intervention works', 'Percutaneous Coronary Intervention restores flow through a narrowed or blocked coronary artery using catheters, guidewires, and one of three strategies: balloon angioplasty alone, bare-metal stent, or drug-eluting stent.'),
        cardsPage('The three intervention strategies', _ptcaStrategyCards),
        cardsPage('Step-by-step PCI', _ptcaPhaseCards),
        vid('PCI procedure walkthrough'),
      ],
      quiz: _placeholderQuiz('coronary intervention', 2),
    ),
    Section(
      id: 'outcomes',
      title: 'Recovery, complications & decisions',
      icon: 'ClipboardList',
      blurb: 'Recovery timeline, key complications, and clinical decision points.',
      color: sectionColorsHex[3],
      pages: <Page>[
        read('Recovery journey', 'Same day — radial-access patients discharged 2–4 hours post-procedure. 24–48 hours — wrist bruising is normal with radial access. 1–4 weeks — cardiac rehabilitation starts. 1–6 months — outpatient cardiology review. Long-term — annual cardiology follow-up.'),
        cardsPage('Complications', _ptcaComplicationCards),
        decisionPage('PTCA clinical decision points', _ptcaDecision),
        vid('Recovery & complications'),
      ],
      quiz: _placeholderQuiz('PTCA outcomes', 2),
    ),
    Section(
      id: 'portfolio',
      title: 'Meril portfolio',
      icon: 'Layers',
      blurb: 'Meril\'s coronary stents, scaffold, and PTCA balloons.',
      color: sectionColorsHex[4],
      pages: <Page>[
        read('Meril coronary portfolio', portfolioNote),
        cardsPage('Meril coronary intervention portfolio', _ptcaPortfolioCards),
        vid('Meril coronary portfolio'),
      ],
      quiz: _placeholderQuiz('Meril PTCA portfolio', 2),
    ),
    Section(
      id: 'competitors',
      title: 'Competitive landscape',
      icon: 'Grid3x3',
      blurb: 'Positioning Meril against Abbott, Boston Scientific, Medtronic and others.',
      color: sectionColorsHex[5],
      pages: <Page>[
        read('Competitor landscape', portfolioNote),
        _ptcaCompTable,
        vid('Competitive positioning'),
      ],
      quiz: _placeholderQuiz('PTCA competition', 2),
    ),
  ],
  exam: ptcaExam,
);

// Helper to replicate the `phq(title, n)` placeholder from helpers.ts.
List<Question> _placeholderQuiz(String title, int n) =>
    List.generate(n, (i) => Question(q: 'Placeholder $title question ${i + 1}? (replace with real content)', options: ['Answer A', 'Answer B', 'Answer C'], correct: i % 3));