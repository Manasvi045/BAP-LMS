// lib/data/verticals/country/exams.dart — final-exam bank for the Country (Turkey) vertical.
// 1:1 port of src/content/verticals/country/exams.ts.

import '../../../models/content.dart';

final List<Question> turkeyExam = <Question>[
  Question(q: 'What is the approximate size of Turkey\'s medical device market?', options: ['~\$1.5B', '~\$4.5B', '~\$12B', '~\$45B'], correct: 1),
  Question(q: 'What proportion of medical devices in Turkey are imported?', options: ['~30%', '~55%', '80–85%', '~100%'], correct: 2),
  Question(q: 'SGK reimbursement operates through which pricing system?', options: ['DRG', 'SUT', 'HCPCS', 'ICD-10'], correct: 1),
  Question(q: 'Public e-tenders are run on which platform?', options: ['EKAP', 'ÜTS', 'DMO portal only', 'CE-Portal'], correct: 0),
  Question(q: 'Which agency is responsible for device registration and market surveillance?', options: ['SGK', 'TİTÜCK', 'Ministry of Tourism', 'DMO'], correct: 1),
  Question(q: 'Roughly what is the public/private split of Turkey\'s market?', options: ['~30% / 70%', '~65% / 35%', '~50% / 50%', '~85% / 15%'], correct: 1),
  Question(q: 'City Hospitals in Turkey are best described as:', options: ['Small rural clinics', 'Large PPP campuses (1,000–3,500 beds)', 'Private day-surgery centers', 'University research labs'], correct: 1),
  Question(q: 'Which city is the #1 medical tourism and private care hub?', options: ['Ankara', 'Istanbul', 'Erzurum', 'Konya'], correct: 1),
  Question(q: 'Every SKU and lot must be registered in which system?', options: ['ÜTS', 'EKAP', 'SUT', 'SGK'], correct: 0),
  Question(q: 'The Business Acceleration Pathway example device is a:', options: ['Drug-eluting stent', 'Transcatheter aortic valve implant', 'Orthopedic screw', 'Insulin pump'], correct: 1),
  Question(q: 'SGK covers approximately what share of the population?', options: ['~50%', '~75%', '~98%', '~25%'], correct: 2),
  Question(q: 'Foreign manufacturers must appoint an:', options: ['Authorized local representative', 'Offshore agent', 'EU notified body', 'Hospital sponsor'], correct: 0),
];