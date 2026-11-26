import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import 'country.dart';
import 'general.dart';

List<TaskItem> _tasks() => [
      TaskItem(id: 'fr-vlsts', title: 'Validate your VLS-TS visa online', detail: 'Your long-stay student visa must be validated online within 3 months of arrival.', url: 'https://administration-etrangers-en-france.interieur.gouv.fr/'),
      TaskItem(id: 'fr-enrol', title: 'Finish university enrolment', detail: 'Pay the CVEC student contribution, then enrol and collect your student card.', url: 'https://cvec.etudiant.gouv.fr/'),
      TaskItem(id: 'fr-ameli', title: 'Register for health insurance (Ameli)', detail: 'Register on the student social security website so your care is reimbursed.', url: 'https://etudiant-etranger.ameli.fr/'),
      TaskItem(id: 'fr-bank', title: 'Open a bank account', detail: 'You need a French account (and IBAN/RIB) for rent, CAF and wages.'),
      TaskItem(id: 'fr-sim', title: 'Get a French SIM', detail: 'SIM-only plans without commitment (sans engagement) are cheap.'),
      TaskItem(id: 'fr-caf', title: 'Apply for housing aid (CAF)', detail: 'Many students can get monthly help with rent. Apply soon after moving in.', url: 'https://www.caf.fr/'),
      TaskItem(id: 'fr-doctor', title: 'Choose a médecin traitant', detail: 'Declaring a regular doctor means better reimbursement.'),
      TaskItem(id: 'fr-insurance', title: 'Get home insurance', detail: 'Home insurance (assurance habitation) is usually required for rentals.'),
      TaskItem(id: 'fr-emergency', title: 'Save emergency numbers', detail: '112 for any emergency, 15 ambulance, 17 police, 18 fire, 114 by text.'),
      TaskItem(id: 'fr-club', title: 'Join a student association', detail: 'Associations (BDE) and university sport (SUAPS) are great ways to meet people.'),
    ];

const _guides = <Guide>[
  Guide(
    id: 'visa',
    title: 'Visa & residence',
    summary: 'Validating your VLS-TS, renewing your residence permit and staying after graduation.',
    warning: 'General information, not legal advice. For your situation, ask your university’s international office or the préfecture.',
    sections: [
      GuideSection('Your long-stay visa (VLS-TS)', [
        'Validate your VLS-TS online within 3 months of arriving. Until it’s validated you can’t work or travel and come back.',
        'Before it expires, apply online for a multi-year student residence permit (carte de séjour).',
      ], links: [GuideLink('Foreigners in France (ANEF)', 'https://administration-etrangers-en-france.interieur.gouv.fr/')]),
      GuideSection('After graduation', [
        'Master’s-level graduates can usually get a temporary residence permit to look for a job or create a company.',
      ], links: [GuideLink('Campus France', 'https://www.campusfrance.org/en')]),
    ],
  ),
  Guide(
    id: 'work',
    title: 'Work & jobs',
    summary: 'The 964-hour limit, contracts, minimum wage and taxes.',
    warning: 'Going over 964 hours a year can lead to your residence permit being withdrawn or not renewed.',
    sections: [
      GuideSection('How much you can work', [
        'With a validated VLS-TS or student residence permit, you can work up to 964 hours a year (60% of full time) without a separate work permit.',
        'That’s about 20 hours a week on average. Landed counts your hours per calendar year.',
        'Auto-entrepreneur (self-employed) status isn’t allowed on a student permit.',
      ], links: [GuideLink('Service-Public: student work', 'https://www.service-public.gouv.fr/particuliers/vosdroits/F2713')]),
      GuideSection('Pay', [
        'You’re entitled to the SMIC (minimum wage) and a payslip (fiche de paie).',
        'Your employer must declare you to the préfecture before you start.',
      ]),
    ],
  ),
  Guide(
    id: 'money',
    title: 'Money & banking',
    summary: 'Bank accounts, CAF housing aid, budgeting and scams.',
    sections: [
      GuideSection('Banking and aid', [
        'A French bank account (with a RIB) is needed for rent, CAF payments and wages.',
        'CAF housing aid (APL/ALS) can reduce your rent each month.',
      ], links: [GuideLink('CAF', 'https://www.caf.fr/')]),
      GuideSection('Scams', [
        'Calls or texts claiming to be the préfecture, police or Ameli demanding payment are scams.',
      ], links: [GuideLink('Cybermalveillance.gouv.fr', 'https://www.cybermalveillance.gouv.fr/')]),
    ],
  ),
  Guide(
    id: 'housing',
    title: 'Housing',
    summary: 'CROUS residences, guarantors, deposits and rental scams.',
    sections: [
      GuideSection('Finding a place', [
        'CROUS student residences are the cheapest. Apply early.',
        'No French guarantor? The free Visale guarantee may help.',
        'Never pay before visiting (in person or live video) and signing a lease.',
      ], links: [GuideLink('Visale guarantee', 'https://www.visale.fr/'), GuideLink('CROUS', 'https://www.crous.fr/')]),
      GuideSection('Deposits and insurance', [
        'For unfurnished flats the deposit is capped at one month’s rent (excluding charges), and two months for furnished ones.',
        'Do a careful move-in inventory (état des lieux) with photos.',
      ]),
    ],
  ),
  Guide(
    id: 'health',
    title: 'Health & wellbeing',
    summary: 'Ameli, choosing a doctor, top-up insurance and mental health.',
    sections: [
      GuideSection('Getting care', [
        'Register with Ameli so your care is reimbursed. Declare a regular doctor (médecin traitant).',
        'A top-up insurance (mutuelle) covers what social security doesn’t; check if you’re eligible for free cover.',
      ], links: [GuideLink('Ameli for foreign students', 'https://etudiant-etranger.ameli.fr/')]),
      GuideSection('Mental health', [
        'University health services (SSU) offer free psychological support.',
        '3114: national suicide prevention line, free, 24/7.',
      ]),
    ],
  ),
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Who to call and what to do if something goes wrong.',
    sections: [
      GuideSection('Numbers to know', [
        '112: any emergency.',
        '15: medical emergency (SAMU).',
        '17: police. 18: fire.',
        '114: emergency by text for people who can’t speak.',
        '3114: suicide prevention line.',
      ]),
      GuideSection('Lost passport or permit', [
        'Report it at a police station, contact your embassy or consulate, and tell the préfecture.',
      ]),
    ],
  ),
  generalStudyGuide,
  generalCommunityGuide,
  generalFoodGuide,
];

const _answers = <Answer>[
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit', '964', 'heures'],
      'With a validated VLS-TS or student residence permit you can work up to 964 hours a year (60% of full time) without a separate work permit. That’s about 20 hours a week on average.',
      url: 'https://www.service-public.gouv.fr/particuliers/vosdroits/F2713', guideId: 'work'),
  Answer('How do I validate my VLS-TS?', ['vls-ts', 'validate visa', 'validation', 'ofii', 'anef'],
      'Validate it online within 3 months of arriving. Until then you can’t work or travel and come back.',
      url: 'https://administration-etrangers-en-france.interieur.gouv.fr/', guideId: 'visa'),
  Answer('What can I do after graduating?', ['after graduation', 'aps', 'job search permit', 'post study', 'recherche d’emploi'],
      'Master’s-level graduates can usually get a temporary residence permit to look for a job or create a company. Apply before your student permit expires.',
      guideId: 'visa'),
  Answer('How do I get housing aid?', ['caf', 'apl', 'housing aid', 'rent help'],
      'Apply to the CAF soon after moving in. Many students get monthly help with rent. You need a French bank account.',
      url: 'https://www.caf.fr/', guideId: 'money'),
  Answer('I don’t have a French guarantor', ['guarantor', 'garant', 'visale'],
      'The free Visale guarantee can act as your guarantor for many rentals. CROUS residences don’t usually need one.',
      url: 'https://www.visale.fr/', guideId: 'housing'),
  Answer('How do I open a bank account?', ['bank account', 'open bank', 'banking', 'bank', 'rib'],
      'Bring your passport, visa and proof of address. You’ll get a RIB with your account details for rent, CAF and wages.',
      guideId: 'money'),
  Answer('How do I see a doctor?', ['doctor', 'médecin', 'medecin', 'ill', 'sick', 'unwell', 'ameli'],
      'Register with Ameli, declare a médecin traitant and use your university health service. In an emergency call 15 or 112.',
      url: 'https://etudiant-etranger.ameli.fr/', guideId: 'health'),
  Answer('I’m struggling with my mental health', ['mental health', 'stress', 'anxious', 'anxiety', 'depressed', 'homesick', 'overwhelmed'],
      'You’re not alone. Your university health service offers free psychological support. Call 3114 any time. In an emergency call 15 or 112.',
      guideId: 'health'),
  Answer('How do I avoid rental scams?', ['rental scam', 'housing scam', 'landlord scam', 'deposit', 'caution'],
      'Never pay before visiting and signing a lease. Deposits are capped at one month’s rent for unfurnished flats and two for furnished ones.',
      guideId: 'housing'),
  Answer('What are the emergency numbers?', ['emergency', '112', '15', '17', '18', 'police', 'ambulance', 'fire', 'samu'],
      '112 for any emergency, 15 for SAMU (medical), 17 police, 18 fire, 114 by text.',
      guideId: 'emergency'),
];

const frPack = CountryPack(
  code: 'FR',
  name: 'France',
  flag: '🇫🇷',
  currencyCode: 'EUR',
  currencySymbol: '€',
  symbolAfter: true,
  studentVisaName: 'VLS-TS étudiant',
  defaultBudget: 1000,
  work: WorkRule(
    period: LimitPeriod.yearHours,
    limit: 964,
    summary: 'Up to 964 hours a year (60% of full time) with a validated VLS-TS or student residence permit.',
    breaksNote: 'Landed counts hours per calendar year. Your exact 12-month period may start when your permit was issued.',
    officialUrl: 'https://www.service-public.gouv.fr/particuliers/vosdroits/F2713',
  ),
  emergency: [
    EmergencyNumber('112', 'Emergency', 'Any emergency', primary: true),
    EmergencyNumber('15', 'SAMU', 'Medical emergency'),
    EmergencyNumber('17', 'Police', 'Emergency'),
    EmergencyNumber('18', 'Fire', 'Pompiers'),
    EmergencyNumber('3114', 'Suicide prevention', 'Free, 24/7'),
  ],
  arrivalTasks: _tasks,
  guides: _guides,
  answers: [..._answers, ...generalAnswers],
  cities: ['Paris', 'Lyon', 'Toulouse', 'Lille', 'Marseille'],
);
