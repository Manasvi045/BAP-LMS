// lib/data/verticals/cardio/exams.dart — final-exam banks for Cardio.
// 1:1 port of src/content/verticals/cardio/exams.ts.
//
// Heart Structure exam is built from the heart-anatomy + aortic-valve content
// in src/content/verticals/cardio/heart.dart. It combines the legacy 6 anatomy
// questions with 6 new Module-2 questions on aortic stenosis, valve replacement
// and the SAVR-vs-TAVR trade-off.

import '../../../models/content.dart';

const _heartExam = <Question>[
  // Module 1 — anatomy foundations
  Question(q: 'Which valve sits between the left ventricle and the aorta and is the target of TAVR and SAVR?', options: ['Mitral valve', 'Aortic valve', 'Tricuspid valve', 'Pulmonary valve'], correct: 1),
  Question(q: 'The three cusps of the aortic valve are:', options: ['Anterior, posterior, septal', 'LCC, RCC, and NCC', 'Septal and two mural', 'Right and left only'], correct: 1),
  Question(q: 'Where do the left and right coronary arteries originate?', options: ['From the pulmonary artery', 'From the sinuses of Valsalva just above the aortic valve', 'From the right atrium', 'From the coronary sinus'], correct: 1),
  Question(q: 'Which chamber is the heart\'s main systemic pumping chamber?', options: ['Right atrium', 'Right ventricle', 'Left atrium', 'Left ventricle'], correct: 3),
  Question(q: 'Which valve lies between the left atrium and the left ventricle?', options: ['Tricuspid valve', 'Pulmonary valve', 'Mitral valve', 'Aortic valve'], correct: 2),
  Question(q: 'Deoxygenated blood enters the right atrium from which vessels?', options: ['Pulmonary veins', 'SVC and IVC', 'Aorta', 'Coronary arteries'], correct: 1),

  // Module 2 — aortic stenosis and valve replacement
  Question(q: 'In aortic stenosis the leaflets of the aortic valve become…', options: ['Soft and floppy', 'Calcified and unable to open fully', 'Fused together at the commissures only', 'Inflamed and infected'], correct: 1),
  Question(q: 'Roughly what fraction of the population is born with a bicuspid aortic valve?', options: ['About 0.02%', 'About 0.2%', 'About 2%', 'About 20%'], correct: 2),
  Question(q: 'Why is the onset of symptoms in severe aortic stenosis urgent?', options: ['Symptoms are painful but harmless', 'The untreated outlook is poor — many patients pass within about three years', 'The valve will repair itself', 'Medication reverses the narrowing'], correct: 1),
  Question(q: 'In severe aortic stenosis the left ventricular wall typically…', options: ['Thins and weakens', 'Thickens in response to pressure overload', 'Becomes infected', 'Disappears'], correct: 1),
  Question(q: 'TAVR differs from SAVR mainly because TAVR…', options: ['Uses a catheter through the femoral artery rather than opening the chest', 'Is performed without imaging guidance', 'Does not deploy a new valve', 'Requires a sternotomy'], correct: 0),
  Question(q: 'A tissue (bioprosthetic) valve from pig or cow typically lasts…', options: ['About 5 years', 'About 15–20 years', 'A lifetime', 'About 50 years'], correct: 1),
];

Question _q(String q, List<String> opts, int ans) => Question(q: q, options: opts, correct: ans);

final List<Question> ptcaExam = <Question>[
  _q('What does PTCA stand for?', ['Percutaneous Transluminal Coronary Angioplasty', 'Peripheral Transcatheter Coronary Angiography', 'Pulmonary Transluminal Catheter Approach', 'Percutaneous Thoracic Coronary Ablation'], 0),
  _q('Currently preferred arterial access site for PCI and why?', ['Femoral — larger artery, easier access', 'Radial — lower bleeding, earlier ambulation, reduced mortality in ACS', 'Brachial — intermediate bleeding risk', 'Subclavian — most direct route to coronary ostia'], 1),
  _q('Drug-eluting stents (DES) prevent restenosis by releasing which agent?', ['Warfarin', 'Sirolimus analogues (everolimus, zotarolimus) or paclitaxel', 'Heparin', 'Aspirin'], 1),
  _q('When is balloon angioplasty alone (POBA) most appropriate?', ['STEMI — always use POBA first', 'Very small vessels (<2mm), side branches, or in-stent restenosis', 'Whenever the patient cannot afford a stent', 'Only in femoral access cases'], 1),
  _q('FFR (Fractional Flow Reserve) <0.80 means what?', ['The stenosis is not flow-limiting — defer stenting', 'The stenosis is haemodynamically significant — stenting improves outcomes', 'The vessel is totally occluded', 'The guidewire is in the wrong vessel'], 1),
  _q('Main difference between a bare metal stent (BMS) and a drug-eluting stent (DES)?', ['BMS is used in legs; DES in coronary arteries', 'DES has an antiproliferative drug coating that reduces restenosis; BMS does not', 'BMS dissolves after 12 months', 'DES does not require antiplatelet therapy'], 1),
];

final List<Question> tavrExam = <Question>[
  _q('What valve disease is TAVR primarily designed to treat?', ['Mitral stenosis', 'Aortic stenosis', 'Pulmonary regurgitation', 'Tricuspid regurgitation'], 1),
  _q('Why is rapid pacing used during TAVR valve deployment?', ['To improve fluoroscopy image quality', 'To temporarily drop cardiac output so the valve is not displaced during deployment', 'To induce anaesthesia', 'To check pacemaker function'], 1),
  _q('What is paravalvular leak (PVL), and when is it clinically significant?', ['Blood leaking through (not around) the valve — always significant', 'Blood leaking around the valve frame and native annulus — moderate/severe is associated with increased mortality', 'Clot forming on the valve leaflets', 'Air in the aorta after deployment'], 1),
  _q('Why do 10–25% of TAVR patients require a permanent pacemaker?', ['Because of radiation exposure during fluoroscopy', 'The valve frame compresses the bundle of His, which runs adjacent to the aortic annulus', 'Because rapid pacing damages the SA node', 'Due to femoral artery injury disrupting blood supply to the AV node'], 1),
  _q('SAPIEN vs Evolut — what is the key mechanical difference?', ['SAPIEN is self-expanding; Evolut is balloon-expandable', 'SAPIEN is balloon-expandable; Evolut is self-expanding and repositionable', 'SAPIEN is for femoral access only; Evolut for transapical', 'SAPIEN replaces the mitral valve; Evolut the aortic'], 1),
];

final List<Question> savrExam = <Question>[
  _q('What is the main advantage of SAVR over TAVR for a 55-year-old patient?', ['SAVR is less invasive', 'SAVR allows concomitant CABG, mitral repair, or root replacement in the same operation', 'SAVR has a shorter recovery time', 'SAVR does not require cardiopulmonary bypass'], 1),
  _q('Which prosthetic valve requires lifelong warfarin anticoagulation?', ['Tissue (bioprosthetic) valve', 'Mechanical valve', 'Both require lifelong anticoagulation', 'Neither requires anticoagulation'], 1),
  _q('What is the purpose of cardioplegia in SAVR?', ['To speed up the heart during valve implantation', 'To arrest and protect the heart muscle from ischaemia during aortic cross-clamp', 'To prevent arrhythmias after valve deployment', 'To wash blood out of the pericardial space'], 1),
  _q('What is \'valve-in-valve TAVR\', and when is it used?', ['A second TAVR performed in the same native aortic valve', 'A TAVR valve deployed inside a previously implanted failed surgical bioprosthetic valve', 'Using two stents overlapping inside the aorta', 'Replacing a TAVR valve with a surgical valve'], 1),
];

final List<Question> heartExam = _heartExam;