import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import 'country.dart';
import 'general.dart';

List<TaskItem> _tasks() => [
      TaskItem(id: 'ca-permit', title: 'Check your study permit', detail: 'Check your name, dates and the conditions printed on it, including whether you can work off campus.', url: 'https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/study-permit.html'),
      TaskItem(id: 'ca-sin', title: 'Get a Social Insurance Number (SIN)', detail: 'You need a SIN to work. Your study permit must show you’re allowed to work.', url: 'https://www.canada.ca/en/employment-social-development/services/sin.html'),
      TaskItem(id: 'ca-enrol', title: 'Enrol and stay full time', detail: 'Off-campus work rights depend on studying full time at a designated learning institution.'),
      TaskItem(id: 'ca-sim', title: 'Get a Canadian phone number', detail: 'Compare prepaid and monthly plans; student deals are common in September.'),
      TaskItem(id: 'ca-bank', title: 'Open a bank account', detail: 'Many banks have newcomer or student packages. Bring your passport and study permit.'),
      TaskItem(id: 'ca-health', title: 'Sort out health coverage', detail: 'Coverage depends on your province. Check whether you’re on the provincial plan or your school’s insurance.'),
      TaskItem(id: 'ca-lease', title: 'Understand your lease', detail: 'Rental rules are set by each province. Read the lease and keep copies of payments.'),
      TaskItem(id: 'ca-winter', title: 'Get ready for winter', detail: 'Buy a warm coat, boots and gloves before the first freeze; second-hand stores are cheap.'),
      TaskItem(id: 'ca-emergency', title: 'Save emergency numbers', detail: '911 for emergencies, 988 for mental health crisis support.'),
      TaskItem(id: 'ca-club', title: 'Join one student club', detail: 'Cultural clubs and intramural sports are an easy way to make friends.'),
    ];

const _guides = <Guide>[
  Guide(
    id: 'visa',
    title: 'Study permit & visas',
    summary: 'Keeping your study permit valid, travel and the Post-Graduation Work Permit.',
    warning: 'General information, not legal advice. For your situation, contact your school’s international office or a licensed consultant (RCIC).',
    sections: [
      GuideSection('Keep your permit valid', [
        'Stay enrolled and make progress in your program. Tell your school if you take a break.',
        'Apply to extend your study permit before it expires.',
        'Your study permit isn’t a visa: to re-enter Canada after travel you may also need a valid visitor visa or eTA.',
      ], links: [GuideLink('Study permit (IRCC)', 'https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/study-permit.html')]),
      GuideSection('After graduation: PGWP', [
        'Eligible graduates can apply for a Post-Graduation Work Permit. The length depends on your program; master’s graduates can often get up to 3 years.',
        'Check eligibility before you choose a program: not every program qualifies.',
      ], links: [GuideLink('Work after graduation (IRCC)', 'https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/work/after-graduation.html')]),
    ],
  ),
  Guide(
    id: 'work',
    title: 'Work & jobs',
    summary: 'Off-campus limits, on-campus jobs, co-ops, SIN and taxes.',
    warning: 'Working more than allowed can cost you your status and future permits. When unsure, ask your international office.',
    sections: [
      GuideSection('How much you can work', [
        'If eligible, you can work off campus up to 24 hours a week during academic terms.',
        'During scheduled breaks (such as summer or winter holidays) you can work full time.',
        'On-campus work has separate rules. Check the conditions on your permit.',
      ], links: [GuideLink('Work off campus (IRCC)', 'https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/work/work-off-campus.html')]),
      GuideSection('SIN and taxes', [
        'Get a Social Insurance Number before you start work.',
        'File a tax return each spring. You may get money back, and some benefits need a return.',
      ], links: [GuideLink('Canada Revenue Agency', 'https://www.canada.ca/en/revenue-agency.html')]),
    ],
  ),
  Guide(
    id: 'money',
    title: 'Money & banking',
    summary: 'Banking, budgeting and avoiding scams.',
    sections: [
      GuideSection('Banking', [
        'Most big banks have student or newcomer accounts. Compare monthly fees.',
        'A student credit card used lightly and paid in full helps build credit history.',
      ]),
      GuideSection('Scams', [
        'Calls claiming to be IRCC, the CRA or police demanding payment are scams. Hang up.',
        'Report fraud to the Canadian Anti-Fraud Centre.',
      ], links: [GuideLink('Canadian Anti-Fraud Centre', 'https://antifraudcentre-centreantifraude.ca/')]),
    ],
  ),
  Guide(
    id: 'housing',
    title: 'Housing',
    summary: 'Leases, deposits, tenant rights by province and rental scams.',
    sections: [
      GuideSection('Before you pay', [
        'Never pay before viewing the place (in person or on a live video call) and seeing a written lease.',
        'Tenant rules, including deposits, are set by each province. Look up your province’s landlord and tenant board.',
        'Be wary of very low rents and landlords who are “abroad”.',
      ]),
      GuideSection('Living there', [
        'Take dated photos when you move in and out. Ask for repairs in writing.',
        'Check heating is included or budget for it in winter.',
      ]),
    ],
  ),
  Guide(
    id: 'health',
    title: 'Health & wellbeing',
    summary: 'Provincial health plans, school insurance, clinics and mental health.',
    sections: [
      GuideSection('Getting care', [
        'Health coverage depends on your province: some cover international students, others require school insurance.',
        'Walk-in clinics treat non-emergencies without an appointment.',
        'Many provinces have a free health advice line: try 811 in most provinces.',
      ]),
      GuideSection('Mental health', [
        'Your school’s counselling service is free.',
        'Call or text 988 any time for suicide crisis support.',
      ]),
    ],
  ),
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Who to call and what to do if something goes wrong.',
    sections: [
      GuideSection('Numbers to know', [
        '911: police, ambulance or fire.',
        '988: suicide crisis helpline (call or text).',
        '811: health advice in most provinces.',
      ]),
      GuideSection('Lost passport or permit', [
        'Report it to the police, contact your embassy or consulate, and apply to replace your study permit through IRCC.',
      ]),
    ],
  ),
  generalStudyGuide,
  generalCommunityGuide,
  generalFoodGuide,
];

const _answers = <Answer>[
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit', '24 hours', 'off campus', 'off-campus'],
      'If you’re eligible to work off campus, you can work up to 24 hours a week during academic terms and full time during scheduled breaks. Check the conditions on your study permit.',
      url: 'https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/work/work-off-campus.html', guideId: 'work'),
  Answer('What can I do after graduating?', ['pgwp', 'after graduation', 'post graduation', 'post study', 'work permit after'],
      'Eligible graduates can apply for a Post-Graduation Work Permit. Its length depends on your program; master’s graduates can often get up to 3 years. Check your program qualifies.',
      url: 'https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/work/after-graduation.html', guideId: 'visa'),
  Answer('How do I get a SIN?', ['sin', 'social insurance', 'tax number'],
      'Apply for a Social Insurance Number online or at Service Canada. Your study permit must show you’re allowed to work.',
      url: 'https://www.canada.ca/en/employment-social-development/services/sin.html', guideId: 'work'),
  Answer('How do I open a bank account?', ['bank account', 'open bank', 'banking', 'bank'],
      'Bring your passport and study permit. Most big banks have student or newcomer accounts. Compare monthly fees.',
      guideId: 'money'),
  Answer('Do I have to file taxes?', ['tax', 'taxes', 'tax return', 'cra'],
      'Usually yes, each spring. Many students get a refund, and some benefits need a tax return.',
      url: 'https://www.canada.ca/en/revenue-agency.html', guideId: 'work'),
  Answer('Can I travel outside Canada?', ['travel abroad', 'travel outside', 'go home', 'eta', 'visitor visa', 're-entry'],
      'Usually yes. Your study permit isn’t a travel document: check you have a valid visitor visa or eTA and passport to come back.',
      guideId: 'visa'),
  Answer('How do I see a doctor?', ['doctor', 'ill', 'sick', 'unwell', 'clinic', 'walk-in', '811'],
      'Use your campus clinic or a walk-in clinic. Many provinces have a free health line at 811. In an emergency call 911.',
      guideId: 'health'),
  Answer('I’m struggling with my mental health', ['mental health', 'stress', 'anxious', 'anxiety', 'depressed', 'homesick', 'overwhelmed'],
      'You’re not alone. Your school’s counselling service is free. You can call or text 988 any time. In an emergency call 911.',
      guideId: 'health'),
  Answer('How do I avoid rental scams?', ['rental scam', 'housing scam', 'landlord scam', 'deposit', 'lease'],
      'Never pay before viewing and seeing a written lease. Tenant rules depend on your province, so check your province’s landlord and tenant board.',
      guideId: 'housing'),
  Answer('What are the emergency numbers?', ['emergency', '911', '988', 'police', 'ambulance', 'fire'],
      '911 for police, ambulance or fire. 988 for suicide crisis support. 811 for health advice in most provinces.',
      guideId: 'emergency'),
  Answer('How do I report a scam?', ['scam', 'fraud', 'phishing', 'report fraud'],
      'Report it to the Canadian Anti-Fraud Centre and your bank straight away if you paid anything.',
      url: 'https://antifraudcentre-centreantifraude.ca/', guideId: 'money'),
];

const caPack = CountryPack(
  code: 'CA',
  name: 'Canada',
  flag: '🇨🇦',
  currencyCode: 'CAD',
  currencySymbol: 'CA\$',
  studentVisaName: 'Study permit',
  defaultBudget: 1600,
  work: WorkRule(
    period: LimitPeriod.week,
    limit: 24,
    summary: 'Off campus: up to 24 hours a week during academic terms, if your study permit allows it.',
    breaksNote: 'Full time during scheduled breaks such as summer and winter holidays.',
    officialUrl: 'https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/work/work-off-campus.html',
  ),
  emergency: [
    EmergencyNumber('911', 'Emergency', 'Police, ambulance, fire', primary: true),
    EmergencyNumber('988', 'Crisis line', 'Suicide crisis support, call or text'),
    EmergencyNumber('811', 'Health line', 'Health advice in most provinces'),
  ],
  arrivalTasks: _tasks,
  guides: _guides,
  answers: [..._answers, ...generalAnswers],
  cities: ['Toronto', 'Vancouver', 'Montreal', 'Ottawa', 'Calgary'],
);
