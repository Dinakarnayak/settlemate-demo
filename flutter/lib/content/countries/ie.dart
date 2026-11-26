import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import 'country.dart';
import 'general.dart';

List<TaskItem> _tasks() => [
      TaskItem(id: 'ie-irp', title: 'Register for your IRP card', detail: 'Register your immigration permission (Stamp 2) and get your Irish Residence Permit.', url: 'https://www.irishimmigration.ie/registering-your-immigration-permission/'),
      TaskItem(id: 'ie-enrol', title: 'Finish enrolment', detail: 'Collect your student card and confirm your course is full time.'),
      TaskItem(id: 'ie-pps', title: 'Get a PPS number', detail: 'You need a Personal Public Service number to work. Apply through MyWelfare.', url: 'https://www.mywelfare.ie/'),
      TaskItem(id: 'ie-sim', title: 'Get an Irish SIM', detail: 'Prepaid and SIM-only plans are easy to start.'),
      TaskItem(id: 'ie-bank', title: 'Open a bank account', detail: 'Bring your passport, IRP or letter from your college and proof of address.'),
      TaskItem(id: 'ie-gp', title: 'Find a GP and check your insurance', detail: 'Private medical insurance is required for Stamp 2. Find a GP near you before you need one.'),
      TaskItem(id: 'ie-rtb', title: 'Check your tenancy is registered', detail: 'Most private tenancies must be registered with the Residential Tenancies Board.', url: 'https://www.rtb.ie/'),
      TaskItem(id: 'ie-leap', title: 'Get a student Leap Card', detail: 'Discounted public transport fares across Ireland.'),
      TaskItem(id: 'ie-emergency', title: 'Save emergency numbers', detail: '112 or 999 for emergencies, Samaritans 116 123.'),
      TaskItem(id: 'ie-society', title: 'Join one society', detail: 'Clubs and societies days in September are the best time.'),
    ];

const _guides = <Guide>[
  Guide(
    id: 'visa',
    title: 'Stamp 2 & immigration',
    summary: 'Registering your permission, keeping Stamp 2 and the Stamp 1G graduate route.',
    warning: 'General information, not legal advice. For your situation, contact your college’s international office or Immigration Service Delivery.',
    sections: [
      GuideSection('Stamp 2', [
        'Full-time students on an eligible course get Stamp 2 permission. Register it and carry your IRP card.',
        'Keep attending, keep private medical insurance and renew your permission before it expires.',
      ], links: [GuideLink('Irish Immigration: registering', 'https://www.irishimmigration.ie/registering-your-immigration-permission/')]),
      GuideSection('After your course: Stamp 1G', [
        'Eligible graduates can apply for Stamp 1G to stay and look for work: generally 12 months for a level 8 degree, and up to 24 months for level 9 and above.',
      ], links: [GuideLink('Irish Immigration', 'https://www.irishimmigration.ie/')]),
    ],
  ),
  Guide(
    id: 'work',
    title: 'Work & jobs',
    summary: 'Stamp 2 hours, holiday periods, PPS numbers and tax.',
    warning: 'Working more than Stamp 2 allows can affect your permission to stay.',
    sections: [
      GuideSection('How much you can work', [
        'With Stamp 2 you can work up to 20 hours a week in term time.',
        'You can work up to 40 hours a week during the holiday periods: 1 June to 30 September, and 15 December to 15 January.',
        'Self-employment isn’t allowed on Stamp 2.',
      ], links: [GuideLink('Irish Immigration', 'https://www.irishimmigration.ie/')]),
      GuideSection('PPS number and tax', [
        'Get a PPS number before starting work, and register your job with Revenue (myAccount) so you’re not on emergency tax.',
      ], links: [GuideLink('Revenue: jobs and pensions', 'https://www.revenue.ie/en/jobs-and-pensions/index.aspx')]),
    ],
  ),
  Guide(
    id: 'money',
    title: 'Money & banking',
    summary: 'Banking, budgeting and avoiding scams.',
    sections: [
      GuideSection('Banking', [
        'Banks may ask for your passport, IRP or college letter and proof of address.',
        'Turn on app notifications so you see every payment.',
      ]),
      GuideSection('Scams', [
        'Calls claiming to be immigration, Revenue or Gardaí demanding payment are scams.',
        'Report fraud to your bank and to An Garda Síochána.',
      ], links: [GuideLink('Citizens Information', 'https://www.citizensinformation.ie/')]),
    ],
  ),
  Guide(
    id: 'housing',
    title: 'Housing',
    summary: 'Finding a room, deposits, the RTB and rental scams.',
    sections: [
      GuideSection('Avoid scams', [
        'Never pay a deposit before viewing the property and meeting the landlord or agent.',
        'Be very wary of low rents, landlords “abroad” and pressure to pay today.',
      ]),
      GuideSection('Your rights', [
        'Most private tenancies must be registered with the Residential Tenancies Board (RTB), which also resolves disputes.',
        'Threshold gives free housing advice.',
      ], links: [GuideLink('Residential Tenancies Board', 'https://www.rtb.ie/'), GuideLink('Threshold', 'https://threshold.ie/')]),
    ],
  ),
  Guide(
    id: 'health',
    title: 'Health & wellbeing',
    summary: 'GPs, insurance, out-of-hours care and mental health.',
    sections: [
      GuideSection('Getting care', [
        'Register with a GP near you. Your college may have a student health service.',
        'Check what your private medical insurance covers.',
      ], links: [GuideLink('HSE', 'https://www2.hse.ie/')]),
      GuideSection('Mental health', [
        'Your college counselling service is free.',
        'Samaritans: 116 123, free, any time. Text 50808 for free text support.',
      ]),
    ],
  ),
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Who to call and what to do if something goes wrong.',
    sections: [
      GuideSection('Numbers to know', [
        '112 or 999: Gardaí, ambulance, fire.',
        '116 123: Samaritans.',
        '50808: free 24/7 text support.',
      ]),
      GuideSection('Lost passport or IRP', [
        'Report it to the Gardaí, contact your embassy, and apply to replace your IRP card.',
      ]),
    ],
  ),
  generalStudyGuide,
  generalCommunityGuide,
  generalFoodGuide,
];

const _answers = <Answer>[
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit', '20 hours', '40 hours', 'stamp 2'],
      'With Stamp 2 you can work up to 20 hours a week in term time, and up to 40 hours a week from 1 June to 30 September and 15 December to 15 January.',
      url: 'https://www.irishimmigration.ie/', guideId: 'work'),
  Answer('What can I do after graduating?', ['stamp 1g', '1g', 'after graduation', 'post study', 'graduate'],
      'Eligible graduates can apply for Stamp 1G to stay and look for work: generally 12 months after a level 8 degree, up to 24 months for level 9 and above.',
      url: 'https://www.irishimmigration.ie/', guideId: 'visa'),
  Answer('How do I get a PPS number?', ['pps', 'pps number', 'tax number'],
      'Apply through MyWelfare. You need it to work and to register your job with Revenue.',
      url: 'https://www.mywelfare.ie/', guideId: 'work'),
  Answer('What is the IRP?', ['irp', 'gnib', 'residence permit', 'register immigration'],
      'The Irish Residence Permit card shows your immigration permission. Register when you arrive and renew it before it expires.',
      url: 'https://www.irishimmigration.ie/registering-your-immigration-permission/', guideId: 'visa'),
  Answer('How do I open a bank account?', ['bank account', 'open bank', 'banking', 'bank'],
      'Bring your passport, IRP or college letter and proof of address. Compare fees between banks.',
      guideId: 'money'),
  Answer('Am I on emergency tax?', ['emergency tax', 'tax', 'revenue', 'payslip'],
      'Register your job in Revenue’s myAccount with your PPS number so your employer gets your tax credits.',
      url: 'https://www.revenue.ie/en/jobs-and-pensions/index.aspx', guideId: 'work'),
  Answer('How do I see a doctor?', ['doctor', 'gp', 'ill', 'sick', 'unwell', 'clinic'],
      'Register with a GP or use your college health service. In an emergency call 112 or 999.',
      guideId: 'health'),
  Answer('I’m struggling with my mental health', ['mental health', 'stress', 'anxious', 'anxiety', 'depressed', 'homesick', 'overwhelmed'],
      'You’re not alone. Your college counselling is free. Call Samaritans on 116 123 or text 50808 any time.',
      guideId: 'health'),
  Answer('How do I avoid rental scams?', ['rental scam', 'housing scam', 'landlord scam', 'deposit', 'rtb'],
      'Never pay before viewing and meeting the landlord or agent. Most tenancies must be registered with the RTB. Threshold gives free advice.',
      url: 'https://www.rtb.ie/', guideId: 'housing'),
  Answer('What are the emergency numbers?', ['emergency', '112', '999', 'garda', 'police', 'ambulance', 'fire'],
      '112 or 999 for Gardaí, ambulance or fire. Samaritans 116 123.',
      guideId: 'emergency'),
];

const iePack = CountryPack(
  code: 'IE',
  name: 'Ireland',
  flag: '🇮🇪',
  currencyCode: 'EUR',
  currencySymbol: '€',
  studentVisaName: 'Stamp 2',
  defaultBudget: 1300,
  work: WorkRule(
    period: LimitPeriod.week,
    limit: 20,
    summary: 'Stamp 2: up to 20 hours a week in term time.',
    breaksNote: 'Up to 40 hours a week from 1 June to 30 September and 15 December to 15 January.',
    officialUrl: 'https://www.irishimmigration.ie/',
  ),
  emergency: [
    EmergencyNumber('112', 'Emergency', 'Gardaí, ambulance, fire', primary: true),
    EmergencyNumber('116123', 'Samaritans', 'Free, 24/7 support'),
  ],
  arrivalTasks: _tasks,
  guides: _guides,
  answers: [..._answers, ...generalAnswers],
  cities: ['Dublin', 'Cork', 'Galway', 'Limerick'],
);
