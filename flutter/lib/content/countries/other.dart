import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import 'country.dart';
import 'general.dart';

/// For students in any country without a checked country pack yet.
/// Gives general tools and advice without country-specific legal claims.
List<TaskItem> _tasks() => [
      TaskItem(id: 'xx-permit', title: 'Check your visa or residence permit', detail: 'Read the conditions carefully, especially work limits and expiry dates, and add the expiry to Deadlines.'),
      TaskItem(id: 'xx-register', title: 'Register with the authorities if required', detail: 'Many countries require you to register your address or immigration status soon after arrival. Ask your international office.'),
      TaskItem(id: 'xx-enrol', title: 'Finish university enrolment', detail: 'Collect your student ID and confirm your course status.'),
      TaskItem(id: 'xx-insurance', title: 'Sort out health insurance', detail: 'Find out how healthcare works and what your insurance covers.'),
      TaskItem(id: 'xx-sim', title: 'Get a local SIM', detail: 'Banks and services often need a local number.'),
      TaskItem(id: 'xx-bank', title: 'Open a bank account', detail: 'Ask what documents you need before you go.'),
      TaskItem(id: 'xx-tax', title: 'Get a tax or social security number if you’ll work', detail: 'Most countries require one before you’re paid.'),
      TaskItem(id: 'xx-emergency', title: 'Save emergency numbers', detail: 'Find the local emergency number (112 works in many countries) and your embassy’s contact details.'),
      TaskItem(id: 'xx-club', title: 'Join one student club', detail: 'The quickest way to make friends and feel at home.'),
    ];

const _guides = <Guide>[
  Guide(
    id: 'visa',
    title: 'Visa basics',
    summary: 'Questions to ask about your visa, wherever you study.',
    warning: 'Landed doesn’t have checked rules for this country yet. Always confirm with your university’s international office and the official immigration website.',
    sections: [
      GuideSection('Questions to ask your international office', [
        'Do I need to register my address or immigration status after arriving?',
        'How many hours can I work during term and during holidays?',
        'What happens if I change course, fail a module or take a break?',
        'Can I stay and work after graduating?',
      ]),
    ],
  ),
  Guide(
    id: 'work',
    title: 'Work basics',
    summary: 'Staying within your work limits, wherever you are.',
    sections: [
      GuideSection('Before you take a job', [
        'Check your visa’s work conditions. Many countries limit hours during term.',
        'Set your own limit in Landed’s Work tab so you get warnings.',
        'Get a written contract and keep your payslips.',
      ]),
    ],
  ),
  Guide(
    id: 'money',
    title: 'Money basics',
    summary: 'Budgeting, banking and scams.',
    sections: [
      GuideSection('Avoid scams', [
        'Calls claiming to be immigration, police or your embassy demanding payment are almost always scams.',
        'Never share bank codes, and never move money for someone else.',
      ]),
    ],
  ),
  Guide(
    id: 'housing',
    title: 'Housing basics',
    summary: 'Avoiding rental scams anywhere.',
    sections: [
      GuideSection('Before you pay', [
        'Never pay before viewing the place (in person or live video) and seeing a written agreement.',
        'Be wary of very low prices and landlords who are “abroad”.',
        'Take dated photos when you move in and out.',
      ]),
    ],
  ),
  Guide(
    id: 'health',
    title: 'Health basics',
    summary: 'Getting care and support.',
    sections: [
      GuideSection('Getting care', [
        'Find your campus health service and how to see a doctor before you need one.',
        'Your university counselling service is usually free.',
      ]),
    ],
  ),
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Be ready before something happens.',
    sections: [
      GuideSection('Be prepared', [
        '112 reaches emergency services in many countries, including all of the EU. Check the local number.',
        'Save your embassy’s contact details and your campus security number.',
      ]),
    ],
  ),
  generalStudyGuide,
  generalCommunityGuide,
  generalFoodGuide,
];

const _answers = <Answer>[
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit'],
      'It depends on the country and your visa. Check your visa conditions and ask your international office, then set your limit in the Work tab so Landed can warn you.',
      guideId: 'work'),
  Answer('What can I do after graduating?', ['after graduation', 'post study', 'graduate visa', 'stay after'],
      'Many countries offer a post-study work permit. Ask your international office early about the rules and deadlines.',
      guideId: 'visa'),
  Answer('How do I open a bank account?', ['bank account', 'open bank', 'banking', 'bank'],
      'Ask your international office which banks students use and what documents you need: usually your passport, visa and proof of address.',
      guideId: 'money'),
  Answer('How do I see a doctor?', ['doctor', 'ill', 'sick', 'unwell', 'clinic'],
      'Start with your campus health service. In an emergency call the local emergency number (112 works in many countries).',
      guideId: 'health'),
  Answer('What are the emergency numbers?', ['emergency', '112', 'police', 'ambulance', 'fire'],
      '112 works in many countries, including all of the EU. Check the local number and save your embassy’s contact details.',
      guideId: 'emergency'),
];

const otherPack = CountryPack(
  code: 'XX',
  name: 'Another country',
  flag: '🌍',
  currencyCode: 'USD',
  currencySymbol: '\$',
  studentVisaName: 'Student visa',
  fullySupported: false,
  work: WorkRule(
    period: LimitPeriod.week,
    limit: 20,
    summary: 'Set the weekly limit from your visa conditions. Landed doesn’t have checked rules for this country yet.',
    officialUrl: 'https://www.google.com/search?q=international+student+work+hours+limit',
  ),
  emergency: [
    EmergencyNumber('112', 'Emergency', 'Works in many countries, check locally', primary: true),
  ],
  arrivalTasks: _tasks,
  guides: _guides,
  answers: [..._answers, ...generalAnswers],
);
