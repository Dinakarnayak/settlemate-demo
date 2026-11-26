import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import 'country.dart';
import 'general.dart';

List<TaskItem> _tasks() => [
      TaskItem(id: 'au-vevo', title: 'Check your visa conditions on VEVO', detail: 'See your exact conditions, including work limits, and save a copy for employers.', url: 'https://immi.homeaffairs.gov.au/visas/already-have-a-visa/check-visa-details-and-conditions/check-conditions-online'),
      TaskItem(id: 'au-address', title: 'Give your university your address', detail: 'You must keep your provider updated with your residential address.'),
      TaskItem(id: 'au-oshc', title: 'Activate your health cover (OSHC)', detail: 'Download your insurer’s app and get your membership card.'),
      TaskItem(id: 'au-sim', title: 'Get an Australian phone number', detail: 'Prepaid plans are easy to start with.'),
      TaskItem(id: 'au-bank', title: 'Open a bank account', detail: 'Many banks let you start online before or soon after arrival.'),
      TaskItem(id: 'au-tfn', title: 'Apply for a Tax File Number (TFN)', detail: 'Free from the ATO. Give it to your employer so you aren’t taxed at the highest rate.', url: 'https://www.ato.gov.au/individuals-and-families/tax-file-number'),
      TaskItem(id: 'au-transport', title: 'Get a transport card', detail: 'Check whether international students get concession fares in your state.'),
      TaskItem(id: 'au-lease', title: 'Check your bond is lodged', detail: 'In most states, your landlord must lodge your rental bond with a government authority.'),
      TaskItem(id: 'au-emergency', title: 'Save emergency numbers', detail: '000 for emergencies, Lifeline 13 11 14, and your campus security number.'),
      TaskItem(id: 'au-club', title: 'Join one club or society', detail: 'Clubs week (O-Week) is the best time to sign up.'),
    ];

const _guides = <Guide>[
  Guide(
    id: 'visa',
    title: 'Student visa (subclass 500)',
    summary: 'Keeping your visa conditions, health cover and post-study options.',
    warning: 'General information, not legal advice. For your situation, talk to your international student support team or a registered migration agent.',
    sections: [
      GuideSection('Keep your conditions', [
        'Stay enrolled in a registered course and make satisfactory progress and attendance.',
        'Keep Overseas Student Health Cover for your whole stay.',
        'Tell your provider your address within 7 days of arriving and whenever it changes.',
      ], links: [
        GuideLink('Student visa (Home Affairs)', 'https://immi.homeaffairs.gov.au/visas/getting-a-visa/visa-listing/student-500'),
        GuideLink('Check your conditions (VEVO)', 'https://immi.homeaffairs.gov.au/visas/already-have-a-visa/check-visa-details-and-conditions/check-conditions-online'),
      ]),
      GuideSection('After your course', [
        'The Temporary Graduate visa (subclass 485) lets eligible graduates live and work in Australia after study. Check age limits and the length for your qualification.',
      ], links: [GuideLink('Temporary Graduate visa', 'https://immi.homeaffairs.gov.au/visas/getting-a-visa/visa-listing/temporary-graduate-485')]),
    ],
  ),
  Guide(
    id: 'work',
    title: 'Work & jobs',
    summary: 'The 48-hour fortnight, pay rates, tax file numbers and your rights.',
    warning: 'Working more than your visa allows can lead to cancellation. Check VEVO for your exact conditions.',
    sections: [
      GuideSection('How much you can work', [
        'Most student visa holders can work up to 48 hours per fortnight while their course is in session.',
        'A fortnight is 14 days starting on a Monday. Landed checks this week plus last week.',
        'You can work unlimited hours during official course breaks. Master’s by research and PhD students have no limit once the course starts.',
      ], links: [GuideLink('Student visa work conditions', 'https://immi.homeaffairs.gov.au/visas/getting-a-visa/visa-listing/student-500')]),
      GuideSection('Your rights at work', [
        'You have the same workplace rights as everyone else, including minimum wage and payslips.',
        'Being paid cash below the award rate is illegal. The Fair Work Ombudsman helps for free.',
      ], links: [GuideLink('Fair Work Ombudsman', 'https://www.fairwork.gov.au/')]),
      GuideSection('Tax', [
        'Get a Tax File Number and give it to your employer.',
        'Lodge a tax return after 30 June each year.',
      ], links: [GuideLink('Tax File Number (ATO)', 'https://www.ato.gov.au/individuals-and-families/tax-file-number')]),
    ],
  ),
  Guide(
    id: 'money',
    title: 'Money & banking',
    summary: 'Banking, budgeting, superannuation and scams.',
    sections: [
      GuideSection('Banking', [
        'Many banks let you open an account online. Bring your passport to verify.',
        'Employers pay superannuation (retirement savings) for you. You may be able to claim it when you leave Australia.',
      ]),
      GuideSection('Scams', [
        'Calls claiming to be Home Affairs, the ATO or police demanding payment are scams.',
        'Report scams to Scamwatch.',
      ], links: [GuideLink('Scamwatch', 'https://www.scamwatch.gov.au/')]),
    ],
  ),
  Guide(
    id: 'housing',
    title: 'Housing',
    summary: 'Leases, bonds, your rights as a renter and rental scams.',
    sections: [
      GuideSection('Before you pay', [
        'Never pay before inspecting the property (in person or live video) and seeing a written lease.',
        'Your bond should be lodged with your state’s bond authority. Ask for the receipt.',
        'Rules differ by state. Your state’s tenants’ union or fair trading office can help.',
      ], links: [GuideLink('Study Australia: accommodation', 'https://www.studyaustralia.gov.au/en/plan-your-move/accommodation-options')]),
      GuideSection('Living there', [
        'Complete the condition report carefully with photos when you move in.',
        'Ask for repairs in writing.',
      ]),
    ],
  ),
  Guide(
    id: 'health',
    title: 'Health & wellbeing',
    summary: 'Your OSHC cover, GPs, healthdirect and mental health support.',
    sections: [
      GuideSection('Getting care', [
        'Your OSHC helps pay for GP visits and hospital care. Check what your policy covers.',
        'healthdirect gives free health advice: 1800 022 222.',
      ], links: [GuideLink('healthdirect', 'https://www.healthdirect.gov.au/')]),
      GuideSection('Mental health', [
        'Your university counselling service is free.',
        'Lifeline: 13 11 14, any time.',
      ], links: [GuideLink('Lifeline', 'https://www.lifeline.org.au/')]),
    ],
  ),
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Who to call and what to do if something goes wrong.',
    sections: [
      GuideSection('Numbers to know', [
        '000: police, ambulance or fire. 112 also works from mobiles.',
        '131 444: police, non-emergency (most states).',
        '13 11 14: Lifeline crisis support.',
        '1800 022 222: healthdirect.',
      ]),
      GuideSection('Lost passport', [
        'Report it to the police, contact your embassy or consulate, and tell your university.',
      ]),
    ],
  ),
  generalStudyGuide,
  generalCommunityGuide,
  generalFoodGuide,
];

const _answers = <Answer>[
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit', '48 hours', 'fortnight'],
      'Most student visa holders can work up to 48 hours per fortnight while their course is in session, and unlimited hours during official breaks. A fortnight is 14 days starting on a Monday. Check VEVO for your exact conditions.',
      url: 'https://immi.homeaffairs.gov.au/visas/already-have-a-visa/check-visa-details-and-conditions/check-conditions-online', guideId: 'work'),
  Answer('What can I do after graduating?', ['485', 'temporary graduate', 'after graduation', 'post study', 'graduate visa'],
      'The Temporary Graduate visa (subclass 485) lets eligible graduates stay and work. Check the age limit and how long you’d get for your qualification.',
      url: 'https://immi.homeaffairs.gov.au/visas/getting-a-visa/visa-listing/temporary-graduate-485', guideId: 'visa'),
  Answer('How do I get a Tax File Number?', ['tfn', 'tax file number', 'tax number'],
      'Apply free online with the ATO once you’re in Australia, and give it to your employer so you aren’t taxed at the top rate.',
      url: 'https://www.ato.gov.au/individuals-and-families/tax-file-number', guideId: 'work'),
  Answer('Am I being paid fairly?', ['minimum wage', 'pay rate', 'cash job', 'underpaid', 'award', 'payslip'],
      'You have the same rights as any worker, including the minimum wage and payslips. If you’re underpaid, the Fair Work Ombudsman helps for free.',
      url: 'https://www.fairwork.gov.au/', guideId: 'work'),
  Answer('How do I open a bank account?', ['bank account', 'open bank', 'banking', 'bank'],
      'Many banks let you apply online and verify with your passport in a branch. Compare account fees.',
      guideId: 'money'),
  Answer('What is OSHC?', ['oshc', 'health cover', 'insurance'],
      'Overseas Student Health Cover is required for your whole stay. It helps pay for doctor visits and hospital care. Get your insurer’s app and card.',
      guideId: 'health'),
  Answer('How do I see a doctor?', ['doctor', 'gp', 'ill', 'sick', 'unwell', 'clinic'],
      'Book a GP (use your OSHC card) or your campus health service. For advice call healthdirect on 1800 022 222. In an emergency call 000.',
      url: 'https://www.healthdirect.gov.au/', guideId: 'health'),
  Answer('I’m struggling with my mental health', ['mental health', 'stress', 'anxious', 'anxiety', 'depressed', 'homesick', 'overwhelmed'],
      'You’re not alone. Your university counselling service is free. Call Lifeline on 13 11 14 any time. In an emergency call 000.',
      url: 'https://www.lifeline.org.au/', linkLabel: 'Lifeline', guideId: 'health'),
  Answer('How do I avoid rental scams?', ['rental scam', 'housing scam', 'landlord scam', 'bond', 'deposit', 'lease'],
      'Never pay before inspecting and seeing a written lease. Your bond should be lodged with your state’s bond authority. Ask for the receipt.',
      guideId: 'housing'),
  Answer('What are the emergency numbers?', ['emergency', '000', '112', 'police', 'ambulance', 'fire'],
      '000 for police, ambulance or fire (112 also works from mobiles). Lifeline 13 11 14. healthdirect 1800 022 222.',
      guideId: 'emergency'),
  Answer('How do I report a scam?', ['scam', 'fraud', 'phishing', 'report fraud'],
      'Report it to Scamwatch, and call your bank straight away if you paid anything.',
      url: 'https://www.scamwatch.gov.au/', guideId: 'money'),
];

const auPack = CountryPack(
  code: 'AU',
  name: 'Australia',
  flag: '🇦🇺',
  currencyCode: 'AUD',
  currencySymbol: 'A\$',
  studentVisaName: 'Student visa (500)',
  defaultBudget: 1800,
  work: WorkRule(
    period: LimitPeriod.fortnight,
    limit: 48,
    summary: 'Up to 48 hours per fortnight while your course is in session. A fortnight is 14 days starting on a Monday.',
    breaksNote: 'Unlimited hours during official course breaks.',
    officialUrl: 'https://immi.homeaffairs.gov.au/visas/getting-a-visa/visa-listing/student-500',
  ),
  emergency: [
    EmergencyNumber('000', 'Emergency', 'Police, ambulance, fire', primary: true),
    EmergencyNumber('131444', 'Police', 'Non-emergency (most states)'),
    EmergencyNumber('131114', 'Lifeline', 'Crisis support, 24/7'),
    EmergencyNumber('1800022222', 'healthdirect', 'Health advice'),
  ],
  arrivalTasks: _tasks,
  guides: _guides,
  answers: [..._answers, ...generalAnswers],
  cities: ['Sydney', 'Melbourne', 'Brisbane', 'Adelaide', 'Perth'],
);
