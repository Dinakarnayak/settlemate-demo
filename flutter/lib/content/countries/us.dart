import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import 'country.dart';
import 'general.dart';

List<TaskItem> _tasks() => [
      TaskItem(id: 'us-i94', title: 'Download your I-94 record', detail: 'Your I-94 shows your legal entry. Check your name, dates and “D/S” status are correct.', url: 'https://i94.cbp.dhs.gov/'),
      TaskItem(id: 'us-checkin', title: 'Check in with your international office', detail: 'Your school’s Designated School Official (DSO) must register you in SEVIS after you arrive.'),
      TaskItem(id: 'us-enrol', title: 'Enrol full time', detail: 'F-1 students must keep a full course load each term.'),
      TaskItem(id: 'us-sim', title: 'Get a US phone number', detail: 'Prepaid or low-cost plans are easiest without a US credit history.'),
      TaskItem(id: 'us-bank', title: 'Open a bank account', detail: 'Bring your passport, I-20 and proof of address. Many banks near campus have student accounts.'),
      TaskItem(id: 'us-insurance', title: 'Sort out health insurance', detail: 'Most universities require health insurance. Learn how to find in-network doctors.'),
      TaskItem(id: 'us-ssn', title: 'Get a Social Security number (if you get a job)', detail: 'You need a job offer first, usually on campus. Your international office gives you a letter.', url: 'https://www.ssa.gov/ssnumber/'),
      TaskItem(id: 'us-lease', title: 'Read your lease before signing', detail: 'Check the length, deposit, who pays utilities and how to get the deposit back.'),
      TaskItem(id: 'us-emergency', title: 'Save emergency numbers', detail: '911 for emergencies, 988 for mental health crisis support, plus your campus police number.'),
      TaskItem(id: 'us-club', title: 'Join one student organization', detail: 'Cultural associations and clubs are the quickest way to make friends.'),
    ];

const _guides = <Guide>[
  Guide(
    id: 'visa',
    title: 'F-1 status & visas',
    summary: 'Keeping your F-1 status, your I-20, travel and what comes after graduation.',
    warning: 'General information, not legal advice. For your situation, talk to your school’s DSO or an immigration attorney.',
    sections: [
      GuideSection('Keep your status', [
        'Enrol full time every term and make normal progress.',
        'Keep your passport valid and your I-20 up to date. Tell your DSO within 10 days if you move.',
        'Don’t work without the right authorization. Unauthorized work can end your F-1 status.',
      ], links: [GuideLink('Study in the States (DHS)', 'https://studyinthestates.dhs.gov/')]),
      GuideSection('Travel', [
        'Before leaving the US, get a travel signature on your I-20 from your DSO.',
        'Check your visa stamp is valid for re-entry. Renewing it means applying at a US consulate abroad.',
      ]),
      GuideSection('After graduation: OPT', [
        'Optional Practical Training lets eligible F-1 students work for up to 12 months in their field.',
        'STEM graduates may be able to extend OPT. Apply on time through USCIS with your DSO’s recommendation.',
      ], links: [GuideLink('OPT on USCIS', 'https://www.uscis.gov/working-in-the-united-states/students-and-exchange-visitors/optional-practical-training-opt-for-f-1-students')]),
    ],
  ),
  Guide(
    id: 'work',
    title: 'Work & jobs',
    summary: 'On-campus jobs, CPT, OPT, Social Security numbers and taxes.',
    warning: 'Working without authorization is a serious status violation. Ask your DSO before you accept any job.',
    sections: [
      GuideSection('On-campus jobs', [
        'F-1 students can usually work on campus up to 20 hours a week while school is in session, and full time during breaks.',
        'The 20 hours includes all your on-campus jobs together.',
      ], links: [GuideLink('Employer guidance (USCIS)', 'https://www.uscis.gov/i-9-central/complete-correct-form-i-9/completing-section-1-employee-information-and-attestation/foreign-academic-students')]),
      GuideSection('Off-campus work', [
        'Off-campus work needs authorization, such as Curricular Practical Training (CPT) through your school or OPT through USCIS.',
        'Freelancing and gig apps usually count as unauthorized work. Don’t take them without checking.',
      ]),
      GuideSection('Taxes', [
        'Get a Social Security number once you have a job offer.',
        'International students usually must file a federal tax form each year, even with no income. Your international office often provides free tax software.',
      ], links: [GuideLink('IRS: foreign students', 'https://www.irs.gov/individuals/international-taxpayers/foreign-students-and-scholars')]),
    ],
  ),
  Guide(
    id: 'money',
    title: 'Money & banking',
    summary: 'Bank accounts, credit history, sending money home and scams.',
    sections: [
      GuideSection('Banking', [
        'Many banks open student accounts with your passport, I-20 and proof of address.',
        'Building credit takes time. A secured credit card used lightly and paid in full can help.',
      ]),
      GuideSection('Scams', [
        'Calls claiming to be USCIS, the IRS or police demanding payment are scams. Government agencies don’t take gift cards or crypto.',
        'Report fraud to the Federal Trade Commission.',
      ], links: [GuideLink('Report fraud (FTC)', 'https://reportfraud.ftc.gov/')]),
    ],
  ),
  Guide(
    id: 'housing',
    title: 'Housing',
    summary: 'Leases, deposits, roommates and avoiding rental scams.',
    sections: [
      GuideSection('Before you sign', [
        'Never send money before seeing the place (in person or on a live video call) and the lease.',
        'Check the lease length, who pays utilities, and the rules for getting your security deposit back.',
        'Tenant rules vary by state and city. Your university’s off-campus housing office can help.',
      ], links: [GuideLink('Tenant rights (HUD)', 'https://www.hud.gov/topics/rental_assistance/tenantrights')]),
      GuideSection('Moving in and out', [
        'Take dated photos of everything on move-in and move-out.',
        'Ask your landlord for repairs in writing.',
      ]),
    ],
  ),
  Guide(
    id: 'health',
    title: 'Health & wellbeing',
    summary: 'Insurance, campus health centers, urgent care and mental health support.',
    sections: [
      GuideSection('Using your insurance', [
        'Start with your campus health center. It’s often the cheapest option.',
        'Urgent care clinics treat non-emergencies faster and cheaper than the emergency room.',
        'Learn your plan’s deductible and which doctors are “in network”.',
      ]),
      GuideSection('Mental health', [
        'Your university counseling center is free or low-cost.',
        'Call or text 988 for the Suicide & Crisis Lifeline, any time.',
      ], links: [GuideLink('988 Lifeline', 'https://988lifeline.org/')]),
    ],
  ),
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Who to call and what to do if something goes wrong.',
    sections: [
      GuideSection('Numbers to know', [
        '911: police, ambulance or fire.',
        '988: mental health crisis support (call or text).',
        'Save your campus police number too.',
      ]),
      GuideSection('Lost passport or documents', [
        'Report it to the police, contact your embassy or consulate, and tell your DSO.',
      ], links: [GuideLink('Foreign embassies in the US', 'https://www.state.gov/foreign-embassies/')]),
    ],
  ),
  generalStudyGuide,
  generalCommunityGuide,
  generalFoodGuide,
];

const _answers = <Answer>[
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit', '20 hours', 'on campus job', 'on-campus'],
      'On F-1 status you can usually work on campus up to 20 hours a week while school is in session, and full time during breaks. Off-campus work needs CPT or OPT authorization first.',
      url: 'https://www.uscis.gov/i-9-central/complete-correct-form-i-9/completing-section-1-employee-information-and-attestation/foreign-academic-students', guideId: 'work'),
  Answer('What is CPT?', ['cpt', 'curricular practical training', 'internship', 'co-op'],
      'Curricular Practical Training lets you work off campus when it’s an integral part of your program, such as a required internship. Your DSO authorizes it on your I-20 before you start.',
      guideId: 'work'),
  Answer('What can I do after graduating?', ['opt', 'after graduation', 'post study', 'stem opt', 'graduate work', 'h-1b', 'h1b'],
      'Many F-1 graduates apply for Optional Practical Training (OPT), up to 12 months of work in their field, with a possible STEM extension. Talk to your DSO early, as deadlines are strict.',
      url: 'https://www.uscis.gov/working-in-the-united-states/students-and-exchange-visitors/optional-practical-training-opt-for-f-1-students', guideId: 'visa'),
  Answer('Do I need a Social Security number?', ['ssn', 'social security', 'tax number', 'itin'],
      'You need an SSN to be paid for a job. Get a job offer (usually on campus) and a letter from your international office first, then apply.',
      url: 'https://www.ssa.gov/ssnumber/', guideId: 'work'),
  Answer('Can I travel outside the US?', ['travel abroad', 'travel outside', 'go home', 'travel signature', 'leave the us', 're-entry'],
      'Usually yes. Get a travel signature on your I-20 from your DSO before you go, and check your passport and visa stamp are valid for re-entry.',
      guideId: 'visa'),
  Answer('What is my I-94?', ['i-94', 'i94', 'arrival record'],
      'Your I-94 is your electronic arrival record. Download it after each entry and check it says F-1 and “D/S”.',
      url: 'https://i94.cbp.dhs.gov/', guideId: 'visa'),
  Answer('How do I open a bank account?', ['bank account', 'open bank', 'banking', 'bank'],
      'Bring your passport, I-20 and proof of address to a bank near campus. Many offer student accounts with no monthly fee.',
      guideId: 'money'),
  Answer('Do I have to file taxes?', ['tax', 'taxes', 'tax return', '8843', 'irs'],
      'Most international students must file a federal form each year, even with no US income. Your international office often provides free tax software in spring.',
      url: 'https://www.irs.gov/individuals/international-taxpayers/foreign-students-and-scholars', guideId: 'work'),
  Answer('How do I see a doctor?', ['doctor', 'ill', 'sick', 'unwell', 'clinic', 'insurance', 'health center'],
      'Start with your campus health center. For urgent but non-life-threatening problems, an urgent care clinic is faster and cheaper than the ER. In an emergency call 911.',
      guideId: 'health'),
  Answer('I’m struggling with my mental health', ['mental health', 'stress', 'anxious', 'anxiety', 'depressed', 'homesick', 'overwhelmed'],
      'You’re not alone. Your university counseling center is free or low-cost. You can call or text 988 any time for support. In an emergency call 911.',
      url: 'https://988lifeline.org/', linkLabel: '988 Lifeline', guideId: 'health'),
  Answer('How do I avoid rental scams?', ['rental scam', 'housing scam', 'landlord scam', 'deposit', 'lease'],
      'Never send money before viewing the place and reading the lease. Be wary of very low rents and landlords who are “abroad”. Ask your off-campus housing office.',
      guideId: 'housing'),
  Answer('What are the emergency numbers?', ['emergency', '911', '988', 'police', 'ambulance', 'fire'],
      '911 for police, ambulance or fire. 988 for mental health crisis support. Save your campus police number too.',
      guideId: 'emergency'),
];

const usPack = CountryPack(
  code: 'US',
  name: 'United States',
  flag: '🇺🇸',
  currencyCode: 'USD',
  currencySymbol: '\$',
  studentVisaName: 'F-1 status',
  defaultBudget: 1500,
  work: WorkRule(
    period: LimitPeriod.week,
    limit: 20,
    summary: 'On-campus jobs: up to 20 hours a week while school is in session. Off-campus work needs CPT or OPT authorization.',
    breaksNote: 'Full time on campus during official school breaks.',
    officialUrl: 'https://www.uscis.gov/i-9-central/complete-correct-form-i-9/completing-section-1-employee-information-and-attestation/foreign-academic-students',
  ),
  emergency: [
    EmergencyNumber('911', 'Emergency', 'Police, ambulance, fire', primary: true),
    EmergencyNumber('988', 'Crisis Lifeline', 'Mental health support, call or text'),
  ],
  arrivalTasks: _tasks,
  guides: _guides,
  answers: [..._answers, ...generalAnswers],
  cities: ['New York', 'Boston', 'Los Angeles', 'Chicago', 'San Francisco'],
);
