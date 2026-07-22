// lib/data/verticals/endo/exams.dart — final-exam banks for the Endo vertical.
// 1:1 port of src/content/verticals/endo/exams.ts.

import '../../../models/content.dart';

final List<Question> suturesExam = <Question>[
  Question(q: 'What is the primary advantage of monofilament sutures over braided?', options: ['Lower cost', 'Reduced bacterial harboring and tissue drag', 'Greater tensile strength', 'Better knot security'], correct: 1),
  Question(q: 'Which suture material retains tensile strength longest among absorbable options?', options: ['Vicryl', 'Monocryl', 'PDS II', 'Chromic Gut'], correct: 2),
  Question(q: 'Which needle type is MOST appropriate for bowel anastomosis?', options: ['Reverse cutting', 'Conventional cutting', 'Taper point', 'Blunt point'], correct: 2),
  Question(q: 'In a Cesarean section, which suture is typically used for uterine closure?', options: ['3-0 Prolene running', '0-Vicryl running locked', '2-0 Nylon interrupted', '4-0 PDS continuous'], correct: 1),
  Question(q: 'Prolene suture is classified as which type?', options: ['Absorbable monofilament', 'Absorbable braided', 'Non-absorbable monofilament', 'Non-absorbable braided'], correct: 2),
  Question(q: 'Which suture is gold standard for coronary anastomoses in CABG?', options: ['2-0 Silk', '7-0 or 8-0 Prolene', '4-0 Vicryl', '3-0 PDS'], correct: 1),
  Question(q: 'Submucosa is the weakest suture-holding layer of the bowel wall.', options: ['True', 'False'], correct: 1),
  Question(q: 'Preferred skin closure for minimally invasive laparoscopic surgery?', options: ['#1 Steel wire', '0-Silk interrupted', '4-0 Monocryl subcuticular', '2-0 Nylon vertical mattress'], correct: 2),
];

final List<Question> meshExam = <Question>[
  Question(q: 'What is the meaning of the Latin word \'Hernia\'?', options: ['Swelling', 'Rupture', 'Protrusion', 'Weakness'], correct: 1),
  Question(q: 'What percentage of all inguinal hernias are indirect?', options: ['25–30%', '50–55%', '70–75%', '90%'], correct: 2),
  Question(q: 'A Stage 2 (reducible) hernia is best described as:', options: ['Intestine strangulated with loss of blood supply', 'Sac incarcerated and cannot be flattened', 'Visible bulge that flattens when lying down or pushed in', 'Wall weakens but no visible bulge yet'], correct: 2),
  Question(q: 'Which Meril mesh is BOTH \'Ultra Light Weight\' AND \'Very Large Pore\'?', options: ['Filaprop Mesh', 'Merigrow', 'Absomesh', 'Merineum'], correct: 2),
  Question(q: 'Filaprop Mesh (standard) weight classification is:', options: ['Ultra Light Weight', 'Light Weight', 'Medium Weight', 'Heavy Weight'], correct: 3),
  Question(q: 'In TAPP repair, how is the space closed after mesh deployment?', options: ['No closing — gas release collapses space', 'Peritoneum reapproximated with tackers; mesh fully covered', 'Balloon deflated and removed', 'Fascial sutures placed laparoscopically'], correct: 1),
  Question(q: 'Direct inguinal hernia protrudes through the:', options: ['Deep inguinal ring', 'Femoral canal', 'Hesselbach\'s triangle', 'Obturator foramen'], correct: 2),
  Question(q: 'The PLCL antiadhesive barrier in Merineum resorbs in approximately:', options: ['30–45 days', '60–80 days', '90–120 days', '180–210 days'], correct: 2),
  Question(q: 'Which Meril mesh is recommended for TAR repair of large ventral hernias?', options: ['Filaprop Mesh 15×30cm', 'Merigrow 50×50cm', 'Absomesh 30×30cm', 'Merineum 20×25cm'], correct: 1),
  Question(q: 'The Lichtenstein \'tension-free\' hernioplasty uses what incision length?', options: ['2–3 cm', '5–7 cm', '10–12 cm', '15 cm'], correct: 1),
  Question(q: 'A \'tissue separating mesh\' (TSM) like Merineum is designed to:', options: ['Increase foreign body reaction', 'Prevent visceral adhesion when placed intraperitoneally', 'Speed up absorption of the entire mesh', 'Act as a suture anchor point'], correct: 1),
  Question(q: 'Which Meril mesh fixation device is fully absorbable?', options: ['Profound N', 'Profound A', 'Filaprop 3D clips', 'Merigrow staples'], correct: 1),
];

final List<Question> staplersExam = <Question>[
  Question(q: 'What year was the first surgical stapling device invented?', options: ['1900', '1909', '1921', '1950'], correct: 1),
  Question(q: 'What does the \'Retaining Pin\' on the Mirus Linear Stapler do?', options: ['Fires the staples', 'Holds tissue within the jaw', 'Unclamps the device', 'Controls staple height'], correct: 1),
  Question(q: 'The two open staple heights for Mirus Linear Stapler reloads are:', options: ['2.5mm and 3.5mm', '3.5mm and 4.8mm', '4.0mm and 5.5mm', '3.0mm and 4.5mm'], correct: 1),
  Question(q: 'Which Mirus Linear Stapler size does NOT exist?', options: ['MALS30', 'MALS45', 'MALS60', 'MALS75'], correct: 3),
  Question(q: 'Maximum number of firings for the Mirus Linear Cutter?', options: ['4', '8', '12', '16'], correct: 1),
  Question(q: 'The Mirus Circular Stapler is available in how many lumen sizes?', options: ['4', '5', '7', '10'], correct: 2),
  Question(q: 'Key advantage of the 3-row staple line over conventional 2-row?', options: ['Faster firing speed', 'Superior hemostasis', 'Reduced device cost', 'Smaller anastomosis diameter'], correct: 1),
  Question(q: 'Which HMEC reload color corresponds to 4.4mm open staple height?', options: ['Gold', 'Green', 'Blue', 'Black'], correct: 3),
  Question(q: 'The Hemorrhoid Stapler\'s \'conduits for suture threader\' enable:', options: ['Faster anastomosis', 'Surgeon-controlled traction and even doughnut excision', 'Prevention of staple misfires', 'Adjustable staple height'], correct: 1),
  Question(q: 'Which focus surgery is MOST associated with the Circular Stapler?', options: ['Lobectomy (bronchus stapling)', 'Side-to-side anastomosis', 'End-to-end anastomosis / LAR', 'Gastrectomy'], correct: 2),
];