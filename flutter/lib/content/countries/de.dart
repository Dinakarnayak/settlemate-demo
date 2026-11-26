import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import 'country.dart';
import 'general.dart';

List<TaskItem> _tasks() => [
      TaskItem(id: 'de-anmeldung', title: 'Register your address (Anmeldung)', detail: 'Register at your local Bürgeramt within two weeks of moving in. Bring your landlord’s confirmation (Wohnungsgeberbestätigung).'),
      TaskItem(id: 'de-insurance', title: 'Confirm your health insurance', detail: 'Health insurance is compulsory. Your university needs proof before you can enrol.'),
      TaskItem(id: 'de-enrol', title: 'Enrol at your university', detail: 'Pay the semester fee and collect your student ID, often with a public transport ticket included.'),
      TaskItem(id: 'de-permit', title: 'Get your residence permit', detail: 'Book an appointment with the foreigners’ office (Ausländerbehörde) before your entry visa expires.'),
      TaskItem(id: 'de-bank', title: 'Open a bank account (Girokonto)', detail: 'Needed for rent and wages. Your blocked account provider may offer one.'),
      TaskItem(id: 'de-sim', title: 'Get a German SIM', detail: 'You usually need ID verification. Prepaid (Prepaid-Karte) is simplest.'),
      TaskItem(id: 'de-tax', title: 'Find your tax ID (Steuer-ID)', detail: 'It’s posted to you after the Anmeldung. Employers need it.'),
      TaskItem(id: 'de-broadcast', title: 'Sort out the broadcasting fee', detail: 'Each household pays the Rundfunkbeitrag. Flatmates share one payment.', url: 'https://www.rundfunkbeitrag.de/'),
      TaskItem(id: 'de-emergency', title: 'Save emergency numbers', detail: '112 for fire and ambulance, 110 for police, 116 117 for a doctor out of hours.'),
      TaskItem(id: 'de-club', title: 'Join a Hochschulsport class or club', detail: 'University sport and student groups are cheap and a great way to meet people.'),
    ];

const _guides = <Guide>[
  Guide(
    id: 'visa',
    title: 'Residence permit & visas',
    summary: 'Your study residence permit, the foreigners’ office and staying after graduation.',
    warning: 'General information, not legal advice. For your case, ask your university’s international office or the Ausländerbehörde.',
    sections: [
      GuideSection('Your residence permit', [
        'Most students arrive with a national visa and then get a residence permit for study from the local foreigners’ office (Ausländerbehörde).',
        'Book the appointment early: waiting times can be long. Bring your passport, enrolment certificate, health insurance and proof of finances.',
        'Extend your permit before it expires, and keep showing you’re making progress in your studies.',
      ], links: [GuideLink('Make it in Germany: studying', 'https://www.make-it-in-germany.com/en/study-vocational-training/studies-in-germany')]),
      GuideSection('After graduation', [
        'Graduates can usually get a residence permit to look for a job matching their qualification. Ask the foreigners’ office about the current length and conditions.',
        'Once you find a qualified job, you can move to a work residence permit or an EU Blue Card.',
      ], links: [GuideLink('DAAD', 'https://www.daad.de/en/')]),
    ],
  ),
  Guide(
    id: 'work',
    title: 'Work & jobs',
    summary: 'The 140-day rule, student jobs, mini-jobs, minimum wage and tax.',
    warning: 'Working beyond your allowance without approval can put your residence permit at risk.',
    sections: [
      GuideSection('How much you can work', [
        'Students from outside the EU can work up to 140 full days or 280 half days a year. A day of up to 4 hours counts as half a day.',
        'Landed counts your days in each calendar year from the shifts you log.',
        'Student assistant jobs at the university (HiWi) are often treated separately. Self-employment and freelancing need special permission.',
      ], links: [GuideLink('Make it in Germany: study and work', 'https://www.make-it-in-germany.com/en/study-vocational-training/studies-in-germany/work')]),
      GuideSection('Pay and tax', [
        'You’re entitled to the statutory minimum wage.',
        'Your employer needs your tax ID. Students who earn little can often get tax back by filing a return.',
      ], links: [GuideLink('DAAD: side jobs', 'https://www.daad.de/en/study-and-research-in-germany/first-steps-germany/side-jobs/')]),
    ],
  ),
  Guide(
    id: 'money',
    title: 'Money & banking',
    summary: 'Blocked accounts, Girokonto, the semester fee and scams.',
    sections: [
      GuideSection('Banking', [
        'Your blocked account (Sperrkonto) releases a fixed amount each month into a normal account.',
        'Many payments in Germany are by bank transfer or direct debit, so a Girokonto is essential.',
      ]),
      GuideSection('Regular costs', [
        'Rent, health insurance, the semester fee and the broadcasting fee (Rundfunkbeitrag) are the big fixed costs.',
        'Your semester ticket often covers local public transport.',
      ]),
      GuideSection('Scams', [
        'Calls claiming to be police, the embassy or immigration demanding payment are scams.',
        'Report fraud to the police (110 in an emergency, or online police reporting in your state).',
      ]),
    ],
  ),
  Guide(
    id: 'housing',
    title: 'Housing',
    summary: 'WGs, dorms, deposits (Kaution) and rental scams.',
    sections: [
      GuideSection('Finding a place', [
        'Apply early for a Studierendenwerk dorm: they’re usually the cheapest.',
        'Shared flats (WG) are common. Expect to be “interviewed” by flatmates.',
        'Never pay a deposit before viewing (in person or live video) and signing a contract.',
      ], links: [GuideLink('Studierendenwerke', 'https://www.studierendenwerke.de/en/')]),
      GuideSection('Contracts and deposits', [
        'A deposit (Kaution) is usually capped at three months’ basic rent (Kaltmiete) and can often be paid in instalments.',
        'You need the landlord’s confirmation to register your address.',
      ]),
    ],
  ),
  Guide(
    id: 'health',
    title: 'Health & wellbeing',
    summary: 'Health insurance, finding a doctor, 116 117 and mental health.',
    sections: [
      GuideSection('Getting care', [
        'Show your insurance card at the doctor’s (Hausarzt). Book appointments by phone or online.',
        'Out of hours, call the medical on-call service 116 117.',
        'Pharmacies (Apotheke) take turns staying open at night.',
      ], links: [GuideLink('116117', 'https://www.116117.de/en/index.php')]),
      GuideSection('Mental health', [
        'Your Studierendenwerk offers free psychological counselling.',
        'TelefonSeelsorge: 0800 111 0 111, free and anonymous.',
      ]),
    ],
  ),
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Who to call and what to do if something goes wrong.',
    sections: [
      GuideSection('Numbers to know', [
        '112: fire and ambulance.',
        '110: police.',
        '116 117: doctor on call out of hours.',
        '0800 111 0 111: TelefonSeelsorge crisis line.',
      ]),
      GuideSection('Lost passport or permit', [
        'Report it to the police, contact your embassy, then tell the foreigners’ office.',
      ]),
    ],
  ),
  generalStudyGuide,
  generalCommunityGuide,
  generalFoodGuide,
];

const _answers = <Answer>[
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit', '140 days', '280', 'half days', 'how many days'],
      'Students from outside the EU can work up to 140 full days or 280 half days a year (up to 4 hours counts as a half day). Landed counts your days from the shifts you log.',
      url: 'https://www.make-it-in-germany.com/en/study-vocational-training/studies-in-germany/work', guideId: 'work'),
  Answer('What can I do after graduating?', ['after graduation', 'job seeker', 'blue card', 'post study', 'stay after'],
      'Graduates can usually get a residence permit to look for a qualified job, and then move to a work permit or EU Blue Card. Ask the foreigners’ office about current conditions.',
      guideId: 'visa'),
  Answer('What is the Anmeldung?', ['anmeldung', 'register address', 'bürgeramt', 'buergeramt', 'registration'],
      'Registering your address at the local Bürgeramt, usually within two weeks of moving in. You need your landlord’s confirmation. Many other steps need it.',
      guideId: 'visa'),
  Answer('How do I get a residence permit?', ['residence permit', 'aufenthaltstitel', 'ausländerbehörde', 'auslanderbehorde', 'foreigners office'],
      'Book an appointment with the foreigners’ office (Ausländerbehörde) before your entry visa expires. Bring your passport, enrolment certificate, health insurance and proof of finances.',
      guideId: 'visa'),
  Answer('How do I open a bank account?', ['bank account', 'girokonto', 'open bank', 'banking', 'bank', 'sperrkonto', 'blocked account'],
      'Open a Girokonto for rent and wages. Your blocked account (Sperrkonto) pays a fixed amount into it each month.',
      guideId: 'money'),
  Answer('Do I need a tax ID?', ['steuer-id', 'tax id', 'tax number', 'tax'],
      'Yes, employers need it. It’s posted to you after you register your address. Students often get tax back by filing a return.',
      guideId: 'work'),
  Answer('How do I see a doctor?', ['doctor', 'arzt', 'ill', 'sick', 'unwell', 'clinic', '116117'],
      'Book a GP (Hausarzt) and bring your insurance card. Out of hours, call 116 117. In an emergency call 112.',
      url: 'https://www.116117.de/en/index.php', guideId: 'health'),
  Answer('I’m struggling with my mental health', ['mental health', 'stress', 'anxious', 'anxiety', 'depressed', 'homesick', 'overwhelmed'],
      'You’re not alone. Your Studierendenwerk offers free counselling. TelefonSeelsorge is free and anonymous on 0800 111 0 111. In an emergency call 112.',
      guideId: 'health'),
  Answer('How do I avoid rental scams?', ['rental scam', 'housing scam', 'kaution', 'deposit', 'wg', 'flat'],
      'Never pay before viewing and signing a contract. Deposits are usually capped at three months’ basic rent. Studierendenwerk dorms are the safest start.',
      guideId: 'housing'),
  Answer('What are the emergency numbers?', ['emergency', '112', '110', 'police', 'ambulance', 'fire'],
      '112 for fire and ambulance, 110 for police, 116 117 for a doctor out of hours.',
      guideId: 'emergency'),
];

const dePack = CountryPack(
  code: 'DE',
  name: 'Germany',
  flag: '🇩🇪',
  currencyCode: 'EUR',
  currencySymbol: '€',
  symbolAfter: true,
  studentVisaName: 'Residence permit for study',
  defaultBudget: 1000,
  work: WorkRule(
    period: LimitPeriod.yearDays,
    limit: 140,
    summary: 'Up to 140 full days or 280 half days a year. A day of up to 4 hours counts as half a day.',
    breaksNote: 'Days are counted per calendar year. Some university assistant (HiWi) jobs are treated separately.',
    officialUrl: 'https://www.make-it-in-germany.com/en/study-vocational-training/studies-in-germany/work',
  ),
  emergency: [
    EmergencyNumber('112', 'Emergency', 'Fire and ambulance', primary: true),
    EmergencyNumber('110', 'Police', 'Emergency'),
    EmergencyNumber('116117', 'Doctor on call', 'Out-of-hours medical help'),
    EmergencyNumber('08001110111', 'TelefonSeelsorge', 'Free, anonymous crisis line'),
  ],
  arrivalTasks: _tasks,
  guides: _guides,
  answers: [..._answers, ...generalAnswers],
  cities: ['Berlin', 'Munich', 'Hamburg', 'Frankfurt', 'Cologne'],
);
