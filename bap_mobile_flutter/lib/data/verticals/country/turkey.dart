// lib/data/verticals/country/turkey.dart — Turkey market topic.
// 1:1 port of src/content/verticals/country/turkey.ts.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';

final List<Section> _sectionDefs = <Section>[
  Section(
    id: 'marketOverview',
    title: 'Market Overview',
    icon: 'BarChart3',
    blurb: 'Market size, structure, growth drivers and opportunities.',
    color: sectionColorsHex[0],
    pages: <Page>[
      read('Market snapshot', 'Turkey is an Import-Driven medical device market.\n\n80–85% imported devices. Centralized state procurement via SGK/SUT reimbursement. Growing medical tourism sector.\n\nKey figures:\n• Market Size: ~\$4.5B\n• Import Share: 80–85%\n• Public/Private Split: ~65% / 35%\n• Annual Growth: 8–10%'),
      read('Market structure', '• 80–85% of devices imported, limited local manufacturing\n• Strong Ministry of Health influence on pricing and access\n• Large public healthcare footprint (SGK covers ~98% of population)\n• Growing private and medical tourism sector'),
      read('Growth drivers & opportunities', 'Growth drivers:\n• Aging population and rising chronic disease burden\n• PPP City Hospital network expansion\n• Medical tourism inflows (>1M patients/year)\n• Government push for localization of select categories\n\nOpportunities:\n• Advanced surgical devices in tertiary centers\n• Premium tech in private hospital chains\n• Medical tourism growth\n• PPP City Hospital equipment refresh cycles'),
    ],
    quiz: <Question>[
      Question(q: 'Roughly what share of medical devices in Turkey is imported?', options: ['20–25%', '50–55%', '80–85%'], correct: 2),
      Question(q: 'Which reimbursement system underpins centralized state procurement in Turkey?', options: ['NHS tariff', 'SGK / SUT', 'US Medicare'], correct: 1),
      Question(q: 'What is Turkey\'s approximate annual market growth?', options: ['1–2%', '8–10%', '20–25%'], correct: 1),
    ],
  ),
  Section(
    id: 'procurement',
    title: 'Procurement',
    icon: 'ClipboardList',
    blurb: 'How public and private buyers purchase devices.',
    color: sectionColorsHex[1],
    pages: <Page>[
      read('Procurement model', 'Model: Centralized public tendering with decentralized private negotiation.\n\n• Reimbursement body: SGK\n• Reimbursement system: SUT\n• Tender platform: EKAP'),
      read('Buying criteria', '• Price (typically 70–80% of tender score)\n• Technical compliance with specification\n• Local registration & ÜTS traceability\n• After-sales service and warranty terms'),
      read('Channels & highlights', 'Channels:\n• EKAP — official e-tender platform for public bids\n• DMO (State Supply Office) — framework contracts\n• Provincial Health Directorates — local public buys\n• Private hospital group purchasing — direct distributor negotiation\n\nHighlights:\n• Public purchasing is tender-driven and highly price-sensitive\n• Centralized for public hospitals via DMO and MoH; decentralized in private chains\n• Products must be registered (ÜTS/TİTÜCK) before reimbursement eligibility\n• Premium positioning typically requires private-segment focus'),
    ],
    quiz: <Question>[
      Question(q: 'What is the official e-tender platform for public bids in Turkey?', options: ['EKAP', 'DMO', 'SUT'], correct: 0),
      Question(q: 'In public tenders, price typically accounts for what share of the score?', options: ['10–20%', '40–50%', '70–80%'], correct: 2),
      Question(q: 'Before a product is reimbursement-eligible it must be registered in which system?', options: ['EKAP', 'ÜTS / TİTÜCK', 'SGK payroll'], correct: 1),
    ],
  ),
  Section(
    id: 'stakeholders',
    title: 'Stakeholders',
    icon: 'Layers',
    blurb: 'The key players shaping market access.',
    color: sectionColorsHex[2],
    pages: <Page>[
      read('Government & regulators', 'Ministry of Health (Sağlık Bakanlığı): Policy, regulation, and centralized procurement oversight for the public system.\n\nTİTÜCK (Turkish Medicines & Medical Devices Agency): Regulatory authority — device registration, market surveillance, and CE/UDI compliance.\n\nSGK (Social Security Institution): National reimbursement authority — defines SUT pricing and coverage scope.\n\nPublic Hospital Systems: Includes general state hospitals, PPP City Hospitals, and Provincial Health Directorates.'),
      read('Academic, private & channel', 'University Hospitals: Research-focused tertiary institutions purchasing advanced technologies.\n\nPrivate Hospital Groups: Acıbadem, Memorial, Medical Park, Liv, Medipol — premium purchasers.\n\nDistributors & Channel Partners: Local distributors are mandatory for foreign manufacturers.'),
    ],
    quiz: <Question>[
      Question(q: 'Which agency handles device registration and market surveillance in Turkey?', options: ['SGK', 'TİTÜCK', 'EKAP'], correct: 1),
      Question(q: 'Which institution defines SUT pricing and coverage scope?', options: ['Ministry of Health', 'SGK', 'TİTÜCK'], correct: 1),
      Question(q: 'Acıbadem, Memorial and Medipol are examples of:', options: ['University hospitals', 'Private hospital groups', 'Distributors'], correct: 1),
    ],
  ),
  Section(
    id: 'hospitalLandscape',
    title: 'Hospitals',
    icon: 'Stethoscope',
    blurb: 'Hospital landscape and bed capacity.',
    color: sectionColorsHex[3],
    pages: <Page>[
      read('Hospital statistics', '• Total Hospitals: 1,500+\n• Public Hospitals: ~900\n• Private Hospitals: ~570\n• University Hospitals: ~70\n• City Hospitals (PPP): 20+\n• Total Beds: ~250,000'),
      read('Landscape notes', '• City Hospitals are large PPP campuses (1,000–3,500 beds) consolidating regional public capacity\n• Specialty centers concentrated in oncology, cardiology, and transplantation\n• Bed capacity skews public (~60–65%) with private growing fastest'),
    ],
    quiz: <Question>[
      Question(q: 'Approximately how many total hospitals are there in Turkey?', options: ['~500', '~900', '1,500+'], correct: 2),
      Question(q: 'City Hospitals (PPP) typically range in size from:', options: ['50–200 beds', '1,000–3,500 beds', '5,000+ beds'], correct: 1),
    ],
  ),
  Section(
    id: 'geography',
    title: 'Regions',
    icon: 'Globe',
    blurb: 'Geographic concentration of demand.',
    color: sectionColorsHex[4],
    pages: <Page>[
      read('Key regions', 'Marmara — Istanbul, Kocaeli, Bursa: Largest private hospital concentration, medical tourism hub.\n\nCentral Anatolia — Ankara, Konya, Kayseri: Government purchasing center, MoH HQ, major university hospitals.\n\nAegean & Mediterranean — Izmir, Antalya, Adana: Tourism-driven healthcare, strong private clinic networks.\n\nEastern & Southeastern Anatolia — Diyarbakir, Erzurum, Trabzon, Gaziantep: Regional referral hospitals, public-heavy market.'),
      read('Hubs & purchasing pattern', 'Key hubs:\n• Istanbul — #1 medical tourism and private care hub\n• Ankara — government & academic procurement nexus\n• Izmir & Antalya — Aegean/Mediterranean tourism corridor\n\nPurchasing pattern: Public tenders skew to Ankara (central) and major provincial directorates; private buying concentrated in Istanbul/Izmir/Antalya.'),
    ],
    quiz: <Question>[
      Question(q: 'Which region is the largest private hospital concentration and medical tourism hub?', options: ['Central Anatolia', 'Marmara', 'Eastern Anatolia'], correct: 1),
      Question(q: 'Government and academic procurement is concentrated in:', options: ['Istanbul', 'Ankara', 'Antalya'], correct: 1),
    ],
  ),
  Section(
    id: 'reimbursement',
    title: 'Reimbursement',
    icon: 'FileText',
    blurb: 'Who pays, pricing and coverage pathways.',
    color: sectionColorsHex[5],
    pages: <Page>[
      read('Authority & pricing', '• Authority: SGK\n• Pricing mechanism: SUT reimbursement ceiling\n• Coding system: SUT codes + national device classification aligned with EU MDR/CE'),
      read('Coverage & funding', 'Coverage pathways:\n• SUT-listed devices: reimbursed at fixed ceiling price\n• Non-listed devices: out-of-pocket or private insurance only\n• Hospital global budgets cover most consumables in public system\n\nFunding mechanisms:\n• SGK contributions (employer + employee + state)\n• Out-of-pocket in private segment\n• Private health insurance (growing but small share)'),
      read('Market access considerations', '• Products priced above SUT limits face adoption challenges in public\n• Clinical value dossiers required to justify premium pricing\n• Periodic SUT revisions can compress margins'),
    ],
    quiz: <Question>[
      Question(q: 'What pricing mechanism does SGK use?', options: ['Free pricing', 'SUT reimbursement ceiling', 'Cost-plus only'], correct: 1),
      Question(q: 'Devices not listed in SUT are typically:', options: ['Fully reimbursed', 'Out-of-pocket or private insurance only', 'Banned'], correct: 1),
    ],
  ),
  Section(
    id: 'compliance',
    title: 'Compliance',
    icon: 'Activity',
    blurb: 'Registration, labeling and local presence rules.',
    color: sectionColorsHex[0],
    pages: <Page>[
      read('Registration & labeling', 'Device registration:\n• TİTÜCK device registration (mandatory before market entry)\n• ÜTS (Product Tracking System) registration for every SKU and lot\n• CE Mark accepted; MDR alignment expected\n\nLabeling & tracking:\n• Turkish-language labeling and IFU required\n• UDI barcode tied to ÜTS record'),
      read('Local presence & pathways', 'Local presence:\n• Authorized local representative required for foreign manufacturers\n• Distributor agreements typically exclusive by category/region\n\nCompliance pathways:\n• Class I/IIa/IIb/III classification mirrors EU MDR\n• Post-market surveillance and vigilance reporting via TİTÜCK'),
      read('Requirements checklist', '✓ TİTÜCK registration required\n✓ ÜTS product tracking mandatory\n✓ Turkish labeling and IFU\n✓ Authorized local representative\n✓ Distributor partnership (typically exclusive)\n✓ Post-market vigilance reporting'),
    ],
    quiz: <Question>[
      Question(q: 'Foreign manufacturers entering Turkey must appoint a:', options: ['Government liaison', 'Authorized local representative', 'Hospital sponsor'], correct: 1),
      Question(q: 'Which tracking system must register every SKU and lot?', options: ['EKAP', 'ÜTS', 'SUT'], correct: 1),
    ],
  ),
  Section(
    id: 'bap',
    title: 'Business Acceleration Pathway',
    icon: 'Target',
    blurb: 'Commercialization route for a high-risk device.',
    color: sectionColorsHex[1],
    pages: <Page>[
      read('Pathway overview', 'Business Acceleration Pathway (BAP)\n\nObjective: Commercialization path for a high-risk medical device in Turkey — example: Aortic Valve Implant.\n\nSummary: A practical route from classification and local sponsor setup through TİTÜCK registration, ÜTS tracking, and launch readiness for a Class III structural heart implant.'),
      read('Stages 1–4', '1. Define product scope: Confirm intended use, high-risk classification, materials, and clinical claims for the aortic valve implant.\n\n2. Appoint local representative: Assign an authorized Turkish legal manufacturer / importer / distributor.\n\n3. Build technical dossier: Prepare EU MDR-aligned documentation — design dossier, risk management, biocompatibility, sterilization, IFU in Turkish, and clinical evidence.\n\n4. Register with TİTÜCK: Submit the device for Turkish market registration.'),
      read('Stages 5–7', '5. Activate ÜTS traceability: Create SKU and lot-level product tracking entries.\n\n6. Prepare access strategy: Map pricing, reimbursement evidence, tender pathway, and hospital value proposition.\n\n7. Launch and monitor: Release the device only after approval and maintain vigilance reporting.'),
      read('Aortic valve implant example', '• Example device: transcatheter aortic valve implant (Class III / high risk)\n• Typical buyers: cardiac centers, university hospitals, private heart institutes\n• Commercial gate: registration must be complete before procurement and reimbursement discussions'),
    ],
    quiz: <Question>[
      Question(q: 'The BAP worked example is based on which device?', options: ['Hip implant', 'Transcatheter aortic valve implant', 'Surgical stapler'], correct: 1),
      Question(q: 'Per the BAP, the device should be launched:', options: ['Before registration to gain speed', 'Only after approval, with vigilance reporting', 'Without a local representative'], correct: 1),
    ],
  ),
];

final Topic turkeyTopic = Topic(
  id: 'turkey',
  label: 'Turkey',
  icon: 'Globe',
  cert: 'Turkey Market Expert',
  passMark: 80,
  sections: _sectionDefs,
  exam: turkeyExam,
);