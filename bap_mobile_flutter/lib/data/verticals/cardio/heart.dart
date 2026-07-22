// lib/data/verticals/cardio/heart.dart — Heart Structure topic.
//
// Content migrated from the PDF courseware pack "Heart Essentials — Meril L&D ·
// Cardio". The pack is structured as two modules plus a glossary and source map:
//
//   M1 Heart Anatomy Essentials (Screens 1.1 – 1.8)
//   M2 Why Aortic Valve Replacement Is Done (Screens 2.1 – 2.5)
//   M3 Glossary + Source mapping + Course recap video
//
// All teaching copy, image carousels and video placeholders mirror the PDF's
// flow one-to-one. Real image assets are referenced from assets/cardio/ with
// stable paths; the carousel renderer falls back to a labelled placeholder
// when a file is missing, so the layout is ready the moment art is dropped in.

import '../../../models/content.dart';
import '../../page_builders.dart';
import '../../../theme/accents.dart';
import 'exams.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Module 1 — Heart Anatomy Essentials — concept layers
// ─────────────────────────────────────────────────────────────────────────────

const _m1ValveLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Tricuspid valve', color: '#fca5a5', desc: 'Right atrioventricular valve (3 cusps); lets blood pass from the right atrium into the right ventricle.'),
  AnatomyLayer(name: 'Pulmonary semilunar valve', color: '#fde68a', desc: 'Half-moon cusps at the exit from the right ventricle into the pulmonary trunk; prevent backflow into the ventricle.'),
  AnatomyLayer(name: 'Mitral (bicuspid) valve', color: '#bbf7d0', desc: 'Left atrioventricular valve (2 cusps); lets blood pass from the left atrium into the left ventricle.'),
  AnatomyLayer(name: 'Aortic semilunar valve', color: '#fed7aa', desc: 'Half-moon cusps at the exit from the left ventricle into the aorta; prevents backflow between heartbeats.'),
  AnatomyLayer(name: 'Chordae tendineae', color: '#ddd6fe', desc: 'Fine collagen cords tethering AV-valve cusps to papillary muscles in the ventricle wall — stop the cusps from prolapsing when the ventricle contracts.'),
];

const _m1WallLayers = <AnatomyLayer>[
  AnatomyLayer(name: 'Epicardium', color: '#fde68a', desc: 'The thin outer covering — mesothelium (simple squamous epithelium) with a little areolar connective tissue.'),
  AnatomyLayer(name: 'Myocardium', color: '#dc2626', desc: 'The thick middle layer of cardiac muscle — the part that contracts and does the pumping; thickest around the left ventricle.'),
  AnatomyLayer(name: 'Endocardium', color: '#bae6fd', desc: 'The smooth inner lining of all four chambers and the valves — simple squamous epithelium over areolar connective tissue.'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Glossary — term + plain-language meaning (35 rows)
// ─────────────────────────────────────────────────────────────────────────────

const _glossaryColumns = <String>['Term', 'Plain-language meaning'];

final _glossaryRows = <List<String>>[
  <String>['Atrium / Ventricle', 'The two upper receiving chambers / the two lower pumping chambers.'],
  <String>['Interventricular septum', 'The muscular wall dividing the left and right sides of the heart.'],
  <String>['Tricuspid valve', 'Right atrioventricular valve (three cusps) between right atrium and right ventricle.'],
  <String>['Mitral / bicuspid valve', 'Left atrioventricular valve (two cusps) between left atrium and left ventricle.'],
  <String>['Semilunar valve', 'Half-moon valve at a ventricle\'s exit — pulmonary and aortic.'],
  <String>['Chordae tendineae', 'Collagen cords tethering atrioventricular-valve cusps to the papillary muscles.'],
  <String>['Papillary muscle', 'Ventricular wall muscle that anchors the chordae tendineae.'],
  <String>['Pulmonary circuit', 'Loop carrying blood from the right heart to the lungs and back.'],
  <String>['Systemic circuit', 'Loop carrying blood from the left heart to the body and back.'],
  <String>['Pulmonary trunk / arteries', 'Vessels carrying oxygen-poor blood from the right ventricle to the lungs.'],
  <String>['Pulmonary veins', 'Vessels carrying oxygen-rich blood from the lungs to the left atrium.'],
  <String>['Superior / inferior vena cava', 'Large veins returning blood from the upper / lower body to the right atrium.'],
  <String>['Aorta / aortic arch', 'The body\'s largest artery and its curve, giving off three head-and-arm branches.'],
  <String>['Coronary arteries', 'Right and left coronary arteries — first branches off the aorta; supply the heart muscle.'],
  <String>['Left anterior descending artery', 'Left anterior descending (anterior interventricular) artery; common heart-attack site.'],
  <String>['Circumflex artery', 'Left coronary branch supplying the side wall of the left ventricle.'],
  <String>['Coronary sinus', 'Large vein collecting cardiac venous blood and draining into the right atrium.'],
  <String>['Anastomosis', 'A cross-connection between vessels giving an alternative (collateral) route.'],
  <String>['Epicardium / Myocardium / Endocardium', 'Outer covering / muscular middle / inner lining of the heart wall.'],
  <String>['Pectinate muscle / Trabeculae carnae', 'Muscle ridges of the atrial walls / the ventricular walls.'],
  <String>['Fossa ovalis', 'Scar in the right-atrial wall marking the closed foetal foramen ovale.'],
  <String>['Ligamentum arteriosum', 'Remnant of the foetal ductus arteriosus between pulmonary trunk and aorta.'],
  <String>['Auricle', 'Small muscular pouch on each atrium that helps fill it.'],
  <String>['Aortic stenosis', 'Narrowing of the aortic valve so it can\'t open fully, limiting blood flow to the body.'],
  <String>['Aortic regurgitation', 'A leaky aortic valve that doesn\'t close fully, so blood flows backward into the left ventricle — the other main reason for valve replacement.'],
  <String>['Calcific / senile aortic stenosis', 'Age-related aortic stenosis from calcium build-up and wear; "senile" means age-related.'],
  <String>['Bicuspid aortic valve', 'A valve with two leaflets instead of three (~2% of people); wears out earlier.'],
  <String>['Echocardiogram', 'Ultrasound of the heart used to detect and grade a narrowed valve.'],
  <String>['Murmur', 'Abnormal heart sound from turbulent flow — often the first clue to a narrowed valve.'],
  <String>['Angina', 'Chest pain caused by the heart muscle not getting enough blood.'],
  <String>['Left-ventricular hypertrophy', 'Thickening of the left-ventricular wall in response to pressure overload.'],
  <String>['Aortic valve replacement', 'Aortic valve replacement — replacing the diseased valve.'],
  <String>['Surgical aortic valve replacement', 'Surgical aortic valve replacement — open-heart replacement via a sternotomy.'],
  <String>['Transcatheter aortic valve replacement', 'Transcatheter aortic valve replacement / implantation — a catheter-delivered valve.'],
  <String>['Mechanical / tissue valve', 'Durable metal valve (needs lifelong blood thinners) vs pig/cow valve (~15–20 yrs).'],
  <String>['Heart team', 'Surgeon, interventional cardiologist, imaging specialist and patient who decide the treatment route.'],
];

// ─────────────────────────────────────────────────────────────────────────────
// Quiz banks
// ─────────────────────────────────────────────────────────────────────────────

const _m1Quiz = <Question>[
  Question(q: 'How many cusps does the tricuspid valve have?', options: ['Two', 'Three', 'Four'], correct: 1),
  Question(q: 'Which valve lies between the left atrium and the left ventricle?', options: ['Tricuspid valve', 'Pulmonary valve', 'Mitral valve', 'Aortic valve'], correct: 2),
  Question(q: 'In the pulmonary circuit, blood flows from the right ventricle to the…', options: ['Aorta', 'Lungs', 'Body tissues', 'Left atrium'], correct: 1),
  Question(q: 'The chordae tendineae attach the AV-valve cusps to the…', options: ['Atrial wall', 'Papillary muscles', 'Aortic wall', 'Interventricular septum'], correct: 1),
  Question(q: 'The left anterior descending artery is a branch of the…', options: ['Right coronary artery', 'Left coronary artery', 'Pulmonary trunk', 'Brachiocephalic artery'], correct: 1),
  Question(q: 'The thick middle layer of the heart wall — the part that contracts — is the…', options: ['Epicardium', 'Myocardium', 'Endocardium', 'Pericardium'], correct: 1),
];

const _m2Quiz = <Question>[
  Question(q: 'Calcific (senile) aortic stenosis is most common in…', options: ['Infants', 'Teenagers', 'Older adults (70s, 80s, 90s)', 'Athletes'], correct: 2),
  Question(q: 'Why is the onset of symptoms in severe aortic stenosis urgent?', options: ['The symptoms are painful but harmless', 'Untreated, the outlook is poor — many patients pass within about three years', 'The valve will repair itself', 'Medication can reverse it'], correct: 1),
  Question(q: 'Why does the left ventricle thicken in severe aortic stenosis?', options: ['From infection', 'It must squeeze harder to force blood through the narrowed valve (pressure overload)', 'From cholesterol deposition', 'It is a normal part of ageing'], correct: 1),
  Question(q: 'Which route replaces the aortic valve without open surgery?', options: ['SAVR — surgical aortic valve replacement', 'TAVR — transcatheter aortic valve replacement', 'PTCA — percutaneous coronary angioplasty', 'CABG — coronary artery bypass grafting'], correct: 1),
  Question(q: 'A tissue (bioprosthetic) valve from pig or cow typically lasts…', options: ['About 5 years', 'About 15–20 years', 'A lifetime', 'About 50 years'], correct: 1),
];

const _m3Quiz = <Question>[
  Question(q: 'The scar in the right-atrial wall marking the closed foetal foramen ovale is called the…', options: ['Ligamentum arteriosum', 'Fossa ovalis', 'Coronary sinus', 'Trabeculae carnae'], correct: 1),
  Question(q: 'An anastomosis between coronary branches is best described as…', options: ['A blockage of a coronary artery', 'A cross-connection giving an alternative (collateral) route', 'A heart-attack site', 'A valve leaflet'], correct: 1),
  Question(q: 'Which imaging test is most commonly used to detect and grade aortic stenosis?', options: ['Chest X-ray', 'Echocardiogram (ultrasound of the heart)', 'MRI of the brain', 'CT of the abdomen'], correct: 1),
  Question(q: 'The "heart team" that decides between SAVR and TAVR typically includes…', options: ['Only the surgeon', 'Surgeon, interventional cardiologist, imaging specialist and the patient', 'Only the cardiologist', 'Only the patient'], correct: 1),
  Question(q: 'A mechanical prosthetic valve requires the patient to take…', options: ['Nothing extra', 'Lifelong blood thinners', 'Antibiotics for life', 'Insulin'], correct: 1),
];

// ─────────────────────────────────────────────────────────────────────────────
// Topic
// ─────────────────────────────────────────────────────────────────────────────

final Topic heartTopic = Topic(
  id: 'heart',
  label: 'Heart Structure',
  icon: 'Heart',
  cert: 'Cardiac Anatomy Expert',
  passMark: 80,
  sections: <Section>[
    // ───────────────────────────────────────────────────────────────────────
    // MODULE 1 — Heart Anatomy Essentials
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm1_anatomy',
      title: 'Module 1 — Heart anatomy essentials',
      icon: 'BookOpen',
      blurb: 'Chambers · valves · great vessels · blood flow · coronary circulation · heart wall.',
      color: sectionColorsHex[0],
      pages: <Page>[
        ReadPage(
          heading: 'Module 1 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Describe the heart as a double pump and name its four chambers.\n'
              '• Identify the four heart valves and explain how they keep blood flowing one way.\n'
              '• Trace the path of blood through the pulmonary and systemic circuits.\n'
              '• Outline the coronary circulation and the three layers of the heart wall.',
        ),

        // Screen 1.1
        ReadPage(
          heading: 'Screen 1.1 — The heart at a glance',
          body:
              'The heart is a muscular pump about the size of a fist that drives blood around the whole body. Although it is one organ, it works as two pumps side by side: the right side handles oxygen-poor blood and the left side handles oxygen-rich blood, so the two never mix in a healthy heart.\n\n'
              '• A colour convention, not real colour: diagrams show oxygen-poor blood in blue and oxygen-rich blood in red. Blood is always red — slightly darker when oxygen is low, brighter when it is high; the blue/red is only to make the diagram easy to follow.\n'
              '• Surface landmarks: the pointed apex sits low and to the left, while the base points up toward the right shoulder. The fatty pouches on the front are the right and left auricles, which help nudge blood into the atria.',
        ),

        // Screen 1.2 — Image 1 (anterior + coronary vessels)
        carouselPage(
          'Screen 1.2 — The four chambers & the septum',
          <String>[
            'Anterior view of the heart with the four chambers and the coronary vessels visible on the surface — the right and left atria sit on top, the right and left ventricles sit below; the right coronary artery, left coronary artery, anterior interventricular (LAD) artery, circumflex artery and marginal vessels run across the epicardial fat.',
          ],
          assets: const <String?>['assets/cardio/heart_m1_s2_anterior_with_coronaries.png'],
          credits: const <String?>['Source: Ninja Nerd heart-anatomy walkthrough (YouTube jU9w6w8LwqM)'],
        ),
        ReadPage(
          heading: 'Screen 1.2 — The four chambers & the septum',
          body:
              'Two valves and a central wall divide the heart into four chambers — two on top, two on the bottom — that fill and empty in a coordinated sequence.\n\n'
              '• Atria (the receiving chambers): the right atrium and left atrium sit on top and collect blood returning to the heart before passing it down.\n'
              '• Ventricles (the pumping chambers): the right ventricle and left ventricle sit below and contract to push blood out of the heart.\n'
              '• Unequal walls: the left ventricle has much thicker muscle than the right because it must pump blood to the entire body; the right ventricle only pushes blood to the nearby lungs, so its wall is thinner.\n'
              '• The dividing wall: the interventricular septum separates left from right. On the right-atrial wall, the fossa ovalis is the scar left by the foetal foramen ovale once it closes after birth.\n'
              '• Inner muscle texture: comb-like pectinate muscles line the atrial walls, while irregular ridges called trabeculae carnae line the ventricular walls.',
        ),

        // Screen 1.3 — Image 2 (internal — four valves)
        carouselPage(
          'Screen 1.3 — The four valves (one-way flow)',
          <String>[
            'Internal cutaway view showing all four valves in one frame — the tricuspid, pulmonary semilunar, mitral and aortic valves — with the cusps clearly visible and the chambers of the heart exposed in cross-section.',
          ],
          assets: const <String?>['assets/cardio/heart_m1_s3_internal_valves.png'],
          credits: const <String?>['Source: Path-of-blood-flow video (YouTube n0HfMDslEQI)'],
        ),
        ReadPage(
          heading: 'Screen 1.3 — The four valves (one-way flow)',
          body:
              'Valves exist to keep blood moving in a single direction. Each opens to let blood through, then snaps shut to stop it leaking backward — and it is this snapping shut of the valves, not the muscle squeezing, that produces the familiar heart sounds.\n\n'
              '• Tricuspid valve: the right atrioventricular valve, with three cusps; lets blood pass from the right atrium into the right ventricle.\n'
              '• Pulmonary semilunar valve: guards the exit from the right ventricle into the pulmonary trunk; its half-moon (semilunar) cusps prevent backflow.\n'
              '• Mitral (bicuspid) valve: the left atrioventricular valve, with two cusps; lets blood pass from the left atrium into the left ventricle.\n'
              '• Aortic semilunar valve: guards the exit from the left ventricle into the aorta.\n'
              '• What holds the atrioventricular valves: fine collagen cords called chordae tendineae run from the valve cusps to papillary muscles in the ventricle wall, stopping the cusps from blowing inside-out when the ventricle contracts.',
        ),
        anatomyPage('Screen 1.3 — The four valves, summarised', _m1ValveLayers),

        // Screen 1.4 — Image 3 (internal — chordae tendineae highlighted)
        carouselPage(
          'Screen 1.4 — The great vessels',
          <String>[
            'Same internal cutaway view of the four valves, with the chordae tendineae highlighted — fine collagen cords tethering the AV-valve cusps to the papillary muscles inside the ventricles.',
          ],
          assets: const <String?>['assets/cardio/heart_m1_s4_internal_chordae.png'],
          credits: const <String?>['Source: Path-of-blood-flow video (YouTube n0HfMDslEQI)'],
        ),
        ReadPage(
          heading: 'Screen 1.4 — The great vessels',
          body:
              'Large vessels carry blood into and out of the heart. Two of them break the usual "arteries are red, veins are blue" rule — a common point of confusion.\n\n'
              '• Returning to the heart (oxygen-poor): the superior vena cava drains the upper body (formed by the right and left brachiocephalic veins, with the azygos vein joining it) and the inferior vena cava drains the lower body; both empty into the right atrium.\n'
              '• To the lungs: the pulmonary trunk splits into the right and left pulmonary arteries. These arteries carry oxygen-poor blood — the exception that makes them appear blue.\n'
              '• Back from the lungs: the pulmonary veins return oxygen-rich blood to the left atrium — the exception that makes these veins appear red.\n'
              '• Out to the body: the aorta is the largest vessel — ascending aorta, then the aortic arch, then the descending aorta. Three branches leave the arch: the brachiocephalic artery (splitting into the right subclavian and right common carotid), the left common carotid, and the left subclavian.\n'
              '• A foetal remnant: the ligamentum arteriosum is the closed-off remnant of the ductus arteriosus, which once shunted blood past the lungs before birth.',
        ),

        // Screen 1.5 — Image 4 (great vessels simplified)
        carouselPage(
          'Screen 1.5 — The path of blood flow',
          <String>[
            'Simplified anterior view of the heart with the great vessels clearly labelled — the superior and inferior vena cavae enter the right atrium, the pulmonary trunk splits into right and left pulmonary arteries, and the four pulmonary veins return to the left atrium. The aorta rises from the centre.',
          ],
          assets: const <String?>['assets/cardio/heart_m1_s5_great_vessels.png'],
          credits: const <String?>['Source: Ninja Nerd heart-anatomy walkthrough (YouTube jU9w6w8LwqM)'],
        ),
        ReadPage(
          heading: 'Screen 1.5 — The path of blood flow',
          body:
              'Blood travels through two loops connected in series. Follow it once and the chambers, valves and vessels all fall into order.\n\n'
              '• Pulmonary circuit (to the lungs): right atrium → tricuspid valve → right ventricle → pulmonary semilunar valve → pulmonary trunk and arteries → lungs (pick up oxygen, drop off carbon dioxide) → pulmonary veins → left atrium.\n'
              '• Systemic circuit (to the body): left atrium → mitral valve → left ventricle → aortic semilunar valve → aorta → body tissues (drop off oxygen, pick up carbon dioxide) → superior and inferior vena cavae → right atrium, where the loop begins again.\n'
              '• One-way pump, passive return: the heart actively pumps blood away from itself through arteries, but it does not pump blood back. Venous return relies on smooth muscle in the vein walls, the movement of the body, and gravity.',
        ),

        // Recap image — Image 5 (double-circulation schematic)
        carouselPage(
          'Screen 1.5 — Recap: the double circulation',
          <String>[
            'Double circulation schematic — the pulmonary loop carries oxygen-poor blood to the lungs and back; the systemic loop carries oxygen-rich blood to the body and back. Blue = oxygen-poor / CO₂-rich blood; red = oxygen-rich / CO₂-poor blood.',
          ],
          assets: const <String?>['assets/cardio/heart_m1_s5_double_circulation.png'],
          credits: const <String?>['Source: anatomy learning deck'],
        ),

        // Screen 1.6 — Image 6 (anterior with coronary arteries)
        carouselPage(
          'Screen 1.6 — Coronary circulation',
          <String>[
            'Anterior view of the heart showing the coronary arteries (right coronary, left coronary, anterior interventricular / LAD, circumflex, marginal) and the cardiac veins on the surface of the heart.',
          ],
          assets: const <String?>['assets/cardio/heart_m1_s6_coronary_circulation.png'],
          credits: const <String?>['Source: Ninja Nerd heart-anatomy walkthrough (YouTube jU9w6w8LwqM)'],
        ),
        ReadPage(
          heading: 'Screen 1.6 — Coronary circulation (the heart feeds itself)',
          body:
              'The heart muscle needs its own blood supply. Two coronary arteries are the very first branches off the ascending aorta, just above the aortic valve, and they wrap around the heart like a crown — which is what "coronary" means.\n\n'
              '• Right coronary artery: runs in the coronary sulcus and gives off the marginal artery (to the right ventricle\'s side wall) and, at the back, the posterior interventricular artery.\n'
              '• Left coronary artery: splits into the anterior interventricular artery — also called the left anterior descending artery — and the circumflex artery, which wraps left to supply the side wall of the left ventricle.\n'
              '• Why the left anterior descending artery matters: it supplies the front walls of both ventricles and the septum, and is involved in roughly 40% of heart attacks when it becomes blocked.\n'
              '• Venous drainage: the great, middle and small cardiac veins and the posterior vein of the left ventricle empty into the coronary sinus, which drains into the right atrium.\n'
              '• Built-in back-up: anastomoses (cross-connections) between coronary branches provide collateral routes, helping blood reach the muscle if one vessel is partly blocked. A fully blocked coronary artery starves the muscle of oxygen — a heart attack.',
        ),

        // Screen 1.7 — heart wall layers
        ReadPage(
          heading: 'Screen 1.7 — The heart wall — three layers',
          body:
              'From the outside in, the wall of the heart is built from three layers, each with a distinct job.\n\n'
              '• Epicardium: the thin outer covering, made of mesothelium (simple squamous epithelium with a little areolar connective tissue).\n'
              '• Myocardium: the thick middle layer of cardiac muscle — this is the part that contracts and does the pumping, and it is thickest around the left ventricle.\n'
              '• Endocardium: the smooth inner lining of all four chambers and the valves, again a simple squamous epithelium over areolar connective tissue.',
        ),
        anatomyPage('Screen 1.7 — The heart wall — three layers', _m1WallLayers),

        // Placeholder for the wall cross-section image
        carouselPage(
          'Screen 1.7 — Cross-section of the heart wall',
          <String>[
            'Image placeholder — cross-section of the heart wall showing the epicardium, myocardium and endocardium. (Asset to be supplied; the carousel placeholder preserves the intended position.)',
          ],
          assets: const <String?>[null],
          credits: const <String?>['Asset to be supplied'],
        ),

        // Screen 1.8 — video walkthrough
        videoPlaceholderPage(
          'Screen 1.8 — Video: the path of blood flow (full walkthrough)',
          title: 'Path of blood flow through the heart',
          description:
              'Now that you have met the chambers, valves and great vessels, this video ties them all together. It follows a single red blood cell on its complete journey through the heart, so the order of structures you have just learned clicks into place as one continuous loop. Watch it as a recap of the whole module.\n\n'
              'What the walkthrough covers:\n'
              '• The pulmonary loop — right atrium → tricuspid valve → right ventricle → pulmonary semilunar valve → pulmonary trunk and arteries → lungs (where the blood picks up oxygen) → pulmonary veins → left atrium.\n'
              '• The systemic loop — left atrium → mitral valve → left ventricle → aortic semilunar valve → aorta and its branches → the body → superior and inferior vena cavae → back to the right atrium.\n'
              '• Why the diagram uses blue and red, why the left ventricle\'s wall is so much thicker, and how the coronary arteries branch off the aorta to feed the heart muscle itself.\n'
              '• The fact to remember — the heart sounds you hear are the valves snapping shut, not the muscle pumping.\n\n'
              'Try it yourself: after watching, pause on the unlabelled heart and name every chamber, valve and vessel in order, starting from the right atrium. If you can do that, you know the path cold.',
          duration: '≈10 min',
          url: 'https://youtube.com/watch?v=n0HfMDslEQI',
        ),

        // Module 1 — Quick check
        ReadPage(
          heading: 'Module 1 — Quick check',
          body:
              'Q: Why is the wall of the left ventricle so much thicker than the right?\n'
              'A: Because it must pump blood to the entire body, while the right ventricle only pumps to the nearby lungs.\n\n'
              'Q: Which artery is involved in about 40% of heart attacks, and where does it branch from?\n'
              'A: The anterior interventricular artery — a branch of the left coronary artery.',
        ),

        // Module 1 — Key takeaways
        ReadPage(
          heading: 'Module 1 — Key takeaways',
          body:
              '★ The heart is a double pump: the right side sends oxygen-poor blood to the lungs, the left side sends oxygen-rich blood to the body.\n'
              '★ Four chambers (two atria, two ventricles) and four valves (tricuspid, pulmonary, mitral, aortic) keep blood moving one way — the valves closing make the heart sounds.\n'
              '★ Pulmonary circuit: right heart → lungs → left heart. Systemic circuit: left heart → body → right heart.\n'
              '★ Coronary arteries (right coronary artery, left anterior descending, circumflex) feed the heart muscle itself; a blockage causes a heart attack.\n'
              '★ The heart wall has three layers: epicardium (outer), myocardium (muscle), endocardium (inner lining).',
        ),
      ],
      quiz: _m1Quiz,
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 2 — Why Aortic Valve Replacement Is Done
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm2_av_replacement',
      title: 'Module 2 — Why aortic valve replacement is done',
      icon: 'Stethoscope',
      blurb: 'Aortic stenosis · causes · symptoms · indications · surgical vs transcatheter replacement.',
      color: sectionColorsHex[1],
      pages: <Page>[
        ReadPage(
          heading: 'Module 2 — Learning objectives',
          body:
              'By the end of this module you can:\n\n'
              '• Explain what the aortic valve does and what goes wrong in aortic stenosis.\n'
              '• Identify the main causes of aortic stenosis and who is affected.\n'
              '• Recognise the symptoms — and why the onset of symptoms is urgent.\n'
              '• Describe why replacement is the only effective fix, and the two main routes (surgical and transcatheter replacement).',
        ),

        // Screen 2.1
        ReadPage(
          heading: 'Screen 2.1 — What the aortic valve does — and what goes wrong',
          body:
              'The aortic valve is the final one-way door on the left side of the heart. Every time the left ventricle squeezes, the valve opens to let oxygen-rich blood rush into the aorta and out to the body, then snaps shut so blood cannot leak back. It does this around 100,000 times a day, for decades.\n\n'
              '• Aortic stenosis: over the years the valve can stiffen and calcify, so it no longer opens fully. Instead of swinging wide open, the leaflets only part a little, leaving a narrowed opening.\n'
              '• Why that is a problem: a smaller opening means the heart cannot push enough blood out to the body, even though it is working harder to do so.\n'
              '• Aortic regurgitation: the other main reason the valve is replaced. Here the fault is the opposite of stenosis — the valve does not close tightly, so with each beat some blood leaks backward from the aorta into the left ventricle.\n'
              '• Why that is a problem: the left ventricle has to pump the same blood over and over, so it takes on extra volume and, over time, enlarges and weakens — which is why a leaking valve, like a narrowed one, may need replacing.',
        ),
        carouselPage(
          'Screen 2.1 — Normal vs stenotic aortic valve',
          <String>[
            'Image placeholder — a normal aortic valve opening fully versus a calcified, stenotic valve with a narrowed opening.',
          ],
          assets: const <String?>[null],
          credits: const <String?>['Asset to be supplied'],
        ),

        // Screen 2.2
        ReadPage(
          heading: 'Screen 2.2 — Causes & who is affected',
          body:
              'Aortic stenosis is common — a few percent of the population — and falls into a few recognisable groups.\n\n'
              '• Calcific (senile) aortic stenosis: the most common form, from years of wear and calcium build-up. It typically shows up in older adults, often in their 70s, 80s or 90s. ("Senile" simply means age-related — it has nothing to do with memory.)\n'
              '• Bicuspid aortic valve: about 2% of people are born with two leaflets instead of the usual three. The valve was "designed" for three, so two leaflets take more wear and tear, and these patients often come to attention younger — sometimes in their 40s — with a narrowed or leaky valve.\n'
              '• Unicuspid valve: a single-leaflet valve is very rare and tends to cause problems very early in life.\n'
              '• Increasingly caught early: with good primary care and echocardiography, many people are now picked up with mild aortic stenosis years before they would ever need surgery, and are simply monitored over time.',
        ),
        carouselPage(
          'Screen 2.2 — Tricuspid vs bicuspid aortic valve',
          <String>[
            'Image placeholder — a normal tricuspid (three-leaflet) aortic valve next to a bicuspid (two-leaflet) valve.',
          ],
          assets: const <String?>[null],
          credits: const <String?>['Asset to be supplied'],
        ),

        // Screen 2.3
        ReadPage(
          heading: 'Screen 2.3 — Symptoms — and why their onset is urgent',
          body:
              'Aortic stenosis can be silent for a long time. Often the first clue is a heart murmur heard on examination, which leads to an ultrasound of the heart (an echocardiogram) showing the narrowed valve.\n\n'
              '• Only severe aortic stenosis causes symptoms. Disease is graded mild, moderate or severe, and it generally has to be severe before a patient feels anything.\n'
              '• The classic symptoms: breathlessness on exertion (struggling with activities or stairs that were easy six months ago), light-headedness or "brown-outs" (needing to grab onto something), and finally angina — chest pain.\n'
              '• Why onset changes everything: a patient can do well for years with aortic stenosis, but once symptoms begin, the untreated outlook is poor — worse than most cancers, with many patients passing away within about three years. As soon as symptoms appear, the clock starts ticking.',
        ),
        carouselPage(
          'Screen 2.3 — Symptom timeline',
          <String>[
            'Image placeholder — timeline showing a long asymptomatic phase, then rapid decline once symptoms (breathlessness, syncope, angina) begin.',
          ],
          assets: const <String?>[null],
          credits: const <String?>['Asset to be supplied'],
        ),

        // Screen 2.4
        ReadPage(
          heading: 'Screen 2.4 — Why the heart can\'t wait: the left ventricle',
          body:
              'Reduced blood flow is only half the problem. The other half is the strain the narrowing puts on the left ventricle.\n\n'
              '• Pressure overload: to force blood through the tight opening, the left ventricle has to squeeze much harder. In response, its muscular wall thickens and becomes stiffer (less compliant).\n'
              '• Back-pressure to the lungs: as things worsen, pressure builds inside the heart and backs up into the lungs — which is what makes the patient short of breath.\n'
              '• The take-home: this progressive, partly irreversible damage to the heart muscle is a key reason to treat severe symptomatic aortic stenosis promptly rather than waiting.',
        ),
        carouselPage(
          'Screen 2.4 — Hypertrophied left ventricle',
          <String>[
            'Image placeholder — a thickened (hypertrophied) left-ventricular wall resulting from pressure overload against a stenotic valve.',
          ],
          assets: const <String?>[null],
          credits: const <String?>['Asset to be supplied'],
        ),

        // Screen 2.5
        ReadPage(
          heading: 'Screen 2.5 — Why replacement — and the two routes',
          body:
              'Aortic stenosis is a mechanical narrowing, so it needs a mechanical fix. There is no pill that reopens the valve; the definitive treatment is to replace it. Two routes are used today, and the choice is made by a "heart team" of surgeon, interventional cardiologist, imaging specialist and the patient — guided by a computed tomography scan of the heart.\n\n'
              '• Surgical aortic valve replacement: open-heart surgery through the sternum to remove the worn valve and sew in a new one — either a mechanical valve (very durable but requires lifelong blood thinners) or a tissue valve from pig or cow (no long-term blood thinners, lasting roughly 15–20 years). It carries a real but modest procedural risk and a longer, more painful recovery, and is often the right choice for younger patients.\n'
              '• Transcatheter aortic valve replacement: a catheter is threaded up from the femoral artery and a new valve is expanded inside the old one — no open surgery. Recovery is fast, often home the next day. Long-term durability looks comparable out to about 10 years so far, though some patients need a pacemaker afterward.\n'
              '• Not everyone is suitable for the transcatheter route: very heavy calcification, certain bicuspid valves, or coronary arteries sitting too close to the valve can make the transcatheter route unsafe — which is exactly what the pre-procedure computed tomography scan checks for.',
        ),
        carouselPage(
          'Screen 2.5 — SAVR vs TAVR side-by-side',
          <String>[
            'Image placeholder — side-by-side of surgical valve replacement and a transcatheter valve being deployed across the diseased valve.',
          ],
          assets: const <String?>[null],
          credits: const <String?>['Asset to be supplied'],
        ),

        // Module 2 — video placeholder
        videoPlaceholderPage(
          'Module 2 — Video: aortic stenosis and TAVR explained',
          title: 'Aortic stenosis & transcatheter aortic valve replacement',
          description:
              'A clinical discussion covering what aortic stenosis is, how it progresses, and how transcatheter aortic valve replacement (TAVR) compares to surgical aortic valve replacement (SAVR). Useful as a recap after the five teaching screens.\n\n'
              'What the discussion covers:\n'
              '• Why aortic stenosis is a mechanical problem that ultimately needs a mechanical fix.\n'
              '• How symptoms progress once they begin, and why prompt treatment matters.\n'
              '• The role of the heart team and the pre-procedure CT scan in choosing between SAVR and TAVR.\n'
              '• Recovery, durability and the trade-offs of mechanical vs tissue valve choices.',
          duration: '≈10 min',
          url: 'https://youtube.com/watch?v=P0kn4zSA6V4',
        ),

        // Module 2 — Quick check
        ReadPage(
          heading: 'Module 2 — Quick check',
          body:
              'Q: A patient with severe aortic stenosis has just started getting breathless on the stairs. Why is that significant?\n'
              'A: Symptom onset marks a turning point — untreated, the outlook is poor (many patients pass within about three years), so it\'s time to act.\n\n'
              'Q: Why won\'t medication fix aortic stenosis?\n'
              'A: It\'s a mechanical narrowing of the valve, so it needs a mechanical fix — valve replacement (surgical or transcatheter).',
        ),

        // Module 2 — Key takeaways
        ReadPage(
          heading: 'Module 2 — Key takeaways',
          body:
              '★ The aortic valve is the heart\'s final one-way door; in aortic stenosis it calcifies and won\'t open fully, so too little blood reaches the body.\n'
              '★ Main causes: age-related (senile) calcific stenosis in older adults, and bicuspid valves (~2% of people) that wear out earlier.\n'
              '★ It is often silent until severe; once symptoms (breathlessness, light-headedness, angina) appear, the untreated outlook is worse than most cancers.\n'
              '★ The narrowing also overloads and thickens the left ventricle — another reason to treat promptly.\n'
              '★ No pill fixes it: replacement is definitive — surgical or transcatheter — chosen by a heart team after a computed tomography scan.',
        ),
      ],
      quiz: _m2Quiz,
    ),

    // ───────────────────────────────────────────────────────────────────────
    // MODULE 3 — Glossary + Source mapping + Course-recap video
    // ───────────────────────────────────────────────────────────────────────
    Section(
      id: 'm3_glossary_refs',
      title: 'Module 3 — Glossary, references & course recap',
      icon: 'ClipboardList',
      blurb: 'Mobile quick-reference glossary, source map and a course-recap video.',
      color: sectionColorsHex[2],
      pages: <Page>[
        tablePage(
          'Glossary (mobile quick-reference)',
          columns: _glossaryColumns,
          rows: _glossaryRows,
        ),
        ReadPage(
          heading: 'Source mapping & references',
          body:
              'Teaching copy on every screen is distilled from the supplied heart-anatomy video transcripts. Diagram captions are placeholders: drop a licensed anatomy image onto each page to match the teaching point, as the THR/TKR packs do.\n\n'
              '• Module 1 · 1.2, 1.3, 1.5, 1.8 — chambers, valves, blood flow & the video walkthrough — Path-of-blood-flow video (YouTube n0HfMDslEQI).\n'
              '• Module 1 · 1.1, 1.4, 1.6, 1.7 — surfaces, great vessels, coronary circulation & heart wall — Ninja Nerd heart-anatomy walkthrough (YouTube jU9w6w8LwqM).\n'
              '• Module 1 · supplementary reference — Additional heart-anatomy video (YouTube heSsAreO_y0).\n'
              '• Module 2 · 2.1–2.5 — aortic stenosis, causes, symptoms, indications & surgical vs transcatheter replacement — "Talking With Docs" aortic stenosis & transcatheter aortic valve replacement discussion (YouTube P0kn4zSA6V4).\n\n'
              'Note on accuracy: descriptions follow the supplied transcripts and standard cardiac anatomy and practice. Clinical figures in Module 2 (e.g. ~2% bicuspid prevalence, ~3-year untreated prognosis after symptom onset, valve-durability ranges) are taken from the source discussion and should be re-verified against approved Meril clinical materials before publishing. Replace every image placeholder with a properly licensed diagram.',
        ),
        videoPlaceholderPage(
          'Course wrap-up video',
          title: 'Heart Essentials — course recap',
          description:
              'A 4–6 minute wrap-up that walks through the two modules in one sitting: heart anatomy essentials and why aortic valve replacement is done. Useful as a quick refresher after the course is complete.',
          duration: '≈4–6 min',
        ),
      ],
      quiz: _m3Quiz,
    ),
  ],
  exam: heartExam,
);