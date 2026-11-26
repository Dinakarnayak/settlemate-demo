import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import 'country.dart';
import 'general.dart';

List<TaskItem> _tasks() => [
      TaskItem(id: 'nz-conditions', title: 'Check your visa conditions', detail: 'Check your work rights on your visa. Older visas may still say 20 hours.', url: 'https://www.immigration.govt.nz/study/study-visas/working-on-a-student-visa/'),
      TaskItem(id: 'nz-enrol', title: 'Finish enrolment', detail: 'Confirm your course and collect your student ID.'),
      TaskItem(id: 'nz-insurance', title: 'Check your medical and travel insurance', detail: 'International students must have appropriate insurance for their whole stay.'),
      TaskItem(id: 'nz-sim', title: 'Get a New Zealand SIM', detail: 'Prepaid plans are easy to start with.'),
      TaskItem(id: 'nz-bank', title: 'Open a bank account', detail: 'Bring your passport, visa and proof of address.'),
      TaskItem(id: 'nz-ird', title: 'Apply for an IRD number', detail: 'You need an IRD (tax) number to be paid correctly.', url: 'https://www.ird.govt.nz/managing-my-tax/ird-numbers'),
      TaskItem(id: 'nz-bond', title: 'Check your bond is lodged', detail: 'Landlords must lodge your bond with Tenancy Services.', url: 'https://www.tenancy.govt.nz/'),
      TaskItem(id: 'nz-gp', title: 'Enrol with a doctor', detail: 'Use your campus health centre or enrol with a local GP.'),
      TaskItem(id: 'nz-emergency', title: 'Save emergency numbers', detail: '111 for emergencies, Healthline 0800 611 116, text or call 1737.'),
      TaskItem(id: 'nz-club', title: 'Join one club', detail: 'Clubs week at the start of semester is the best time.'),
    ];

const _guides = <Guide>[
  Guide(
    id: 'visa',
    title: 'Student visa',
    summary: 'Your visa conditions, insurance and post-study work.',
    warning: 'General information, not legal advice. For your situation, talk to your international office or a licensed immigration adviser.',
    sections: [
      GuideSection('Keep your conditions', [
        'Stay enrolled, attend, and make satisfactory progress.',
        'Keep appropriate medical and travel insurance for your whole stay.',
      ], links: [GuideLink('Immigration New Zealand: study', 'https://www.immigration.govt.nz/study/')]),
      GuideSection('After your study', [
        'Eligible graduates can apply for a Post-Study Work Visa. The length depends on your qualification.',
      ], links: [GuideLink('Immigration New Zealand', 'https://www.immigration.govt.nz/')]),
    ],
  ),
  Guide(
    id: 'work',
    title: 'Work & jobs',
    summary: 'Weekly hours, holidays, IRD numbers and your rights.',
    warning: 'Working more than your visa allows can affect your visa. Check your conditions.',
    sections: [
      GuideSection('How much you can work', [
        'Eligible students can work up to 25 hours a week during study (from November 2025).',
        'If your visa was issued with a 20-hour limit, you need a variation of conditions to work 25.',
        'Most student visas allow full-time work during scheduled breaks.',
      ], links: [GuideLink('Working on a student visa', 'https://www.immigration.govt.nz/study/study-visas/working-on-a-student-visa/')]),
      GuideSection('Pay and rights', [
        'You’re entitled to the minimum wage, holiday pay and a written employment agreement.',
        'Get an IRD number so you’re taxed correctly.',
      ], links: [GuideLink('Employment New Zealand', 'https://www.employment.govt.nz/'), GuideLink('IRD numbers', 'https://www.ird.govt.nz/managing-my-tax/ird-numbers')]),
    ],
  ),
  Guide(
    id: 'money',
    title: 'Money & banking',
    summary: 'Banking, budgeting and avoiding scams.',
    sections: [
      GuideSection('Banking', [
        'Bring your passport, visa and proof of address to open an account.',
      ]),
      GuideSection('Scams', [
        'Calls claiming to be Immigration NZ, IRD or police demanding payment are scams.',
        'Netsafe gives free help with online scams.',
      ], links: [GuideLink('Netsafe', 'https://netsafe.org.nz/')]),
    ],
  ),
  Guide(
    id: 'housing',
    title: 'Housing',
    summary: 'Bonds, tenancy agreements, your rights and rental scams.',
    sections: [
      GuideSection('Before you pay', [
        'Never pay before viewing and seeing a written tenancy agreement.',
        'Your bond must be lodged with Tenancy Services. You’ll get confirmation.',
      ], links: [GuideLink('Tenancy Services', 'https://www.tenancy.govt.nz/')]),
      GuideSection('Living there', [
        'Do a property inspection report with photos when you move in.',
        'Rentals must meet healthy homes standards for heating and insulation.',
      ]),
    ],
  ),
  Guide(
    id: 'health',
    title: 'Health & wellbeing',
    summary: 'Doctors, Healthline, insurance and mental health support.',
    sections: [
      GuideSection('Getting care', [
        'Use your campus health centre or enrol with a GP. Check what your insurance covers.',
        'Healthline: 0800 611 116, free health advice any time.',
      ]),
      GuideSection('Mental health', [
        'Your university counselling service is free.',
        'Need to talk? Call or text 1737 any time, free.',
      ], links: [GuideLink('1737', 'https://1737.org.nz/')]),
    ],
  ),
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Who to call and what to do if something goes wrong.',
    sections: [
      GuideSection('Numbers to know', [
        '111: police, ambulance, fire.',
        '105: police, non-emergency.',
        '0800 611 116: Healthline.',
        '1737: call or text for mental health support.',
      ]),
      GuideSection('Lost passport', [
        'Report it to the police, contact your embassy or consulate, and tell your international office.',
      ]),
    ],
  ),
  generalStudyGuide,
  generalCommunityGuide,
  generalFoodGuide,
];

const _answers = <Answer>[
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit', '25 hours', '20 hours'],
      'Eligible students can work up to 25 hours a week during study and usually full time in scheduled breaks. If your visa still says 20 hours, apply for a variation of conditions.',
      url: 'https://www.immigration.govt.nz/study/study-visas/working-on-a-student-visa/', guideId: 'work'),
  Answer('What can I do after graduating?', ['post study', 'post-study work visa', 'after graduation', 'graduate visa'],
      'Eligible graduates can apply for a Post-Study Work Visa. How long you get depends on your qualification.',
      url: 'https://www.immigration.govt.nz/', guideId: 'visa'),
  Answer('How do I get an IRD number?', ['ird', 'ird number', 'tax number', 'tax'],
      'Apply online with Inland Revenue. Give it to your employer so you’re taxed correctly.',
      url: 'https://www.ird.govt.nz/managing-my-tax/ird-numbers', guideId: 'work'),
  Answer('How do I open a bank account?', ['bank account', 'open bank', 'banking', 'bank'],
      'Bring your passport, visa and proof of address. Compare fees between banks.',
      guideId: 'money'),
  Answer('How do I see a doctor?', ['doctor', 'gp', 'ill', 'sick', 'unwell', 'clinic', 'healthline'],
      'Use your campus health centre or a GP. Call Healthline on 0800 611 116 for advice. In an emergency call 111.',
      guideId: 'health'),
  Answer('I’m struggling with my mental health', ['mental health', 'stress', 'anxious', 'anxiety', 'depressed', 'homesick', 'overwhelmed'],
      'You’re not alone. Your university counselling is free. Call or text 1737 any time. In an emergency call 111.',
      url: 'https://1737.org.nz/', linkLabel: '1737', guideId: 'health'),
  Answer('How do I avoid rental scams?', ['rental scam', 'housing scam', 'landlord scam', 'bond', 'deposit'],
      'Never pay before viewing and seeing a written tenancy agreement. Your bond must be lodged with Tenancy Services.',
      url: 'https://www.tenancy.govt.nz/', guideId: 'housing'),
  Answer('What are the emergency numbers?', ['emergency', '111', '105', 'police', 'ambulance', 'fire'],
      '111 for police, ambulance or fire. 105 for non-emergency police. Healthline 0800 611 116.',
      guideId: 'emergency'),
];

const nzPack = CountryPack(
  code: 'NZ',
  name: 'New Zealand',
  flag: '🇳🇿',
  currencyCode: 'NZD',
  currencySymbol: 'NZ\$',
  studentVisaName: 'Student visa',
  defaultBudget: 1700,
  work: WorkRule(
    period: LimitPeriod.week,
    limit: 25,
    summary: 'Up to 25 hours a week during study for eligible students (older visas may say 20).',
    breaksNote: 'Most student visas allow full-time work during scheduled breaks.',
    officialUrl: 'https://www.immigration.govt.nz/study/study-visas/working-on-a-student-visa/',
  ),
  emergency: [
    EmergencyNumber('111', 'Emergency', 'Police, ambulance, fire', primary: true),
    EmergencyNumber('105', 'Police', 'Non-emergency'),
    EmergencyNumber('0800611116', 'Healthline', 'Free health advice'),
    EmergencyNumber('1737', 'Need to talk?', 'Call or text, free'),
  ],
  arrivalTasks: _tasks,
  guides: _guides,
  answers: [..._answers, ...generalAnswers],
  cities: ['Auckland', 'Wellington', 'Christchurch', 'Dunedin'],
);
