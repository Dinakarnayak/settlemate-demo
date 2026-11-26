/// Built-in guides. All text is written for Landed and links go to official or
/// non-profit sources. Rules change, so each guide shows when it was last checked.
library;

const guidesLastChecked = '26 November 2026';

class GuideLink {
  const GuideLink(this.label, this.url);
  final String label;
  final String url;
}

class GuideSection {
  const GuideSection(this.heading, this.points, {this.links = const []});
  final String heading;
  final List<String> points;
  final List<GuideLink> links;
}

class Guide {
  const Guide({
    required this.id,
    required this.title,
    required this.summary,
    required this.sections,
    this.warning,
  });
  final String id;
  final String title;
  final String summary;
  final List<GuideSection> sections;
  final String? warning;

  /// Text used by search.
  String get searchText =>
      [title, summary, for (final s in sections) ...[s.heading, ...s.points]].join(' ').toLowerCase();
}

const guides = <Guide>[
  // ------------------------------------------------------------------ Visa
  Guide(
    id: 'visa',
    title: 'Visa & immigration',
    summary: 'eVisa, share codes, keeping your Student visa conditions and what comes after.',
    warning: 'This is general information, not legal advice. For your own case, speak to your university’s international student advice team or a regulated immigration adviser.',
    sections: [
      GuideSection('Your eVisa', [
        'Your immigration status is digital. You prove it with your UKVI account, not a card.',
        'Keep your UKVI account details up to date, especially if you get a new passport.',
        'A share code lets a landlord or employer check your status. Codes for work and renting are different.',
      ], links: [
        GuideLink('View and prove your status', 'https://www.gov.uk/view-prove-immigration-status'),
        GuideLink('Update your UKVI account', 'https://www.gov.uk/update-ukvi-account'),
      ]),
      GuideSection('Keeping your Student visa conditions', [
        'Attend your course. Universities must report students who stop engaging.',
        'Stay within your term-time work limit: usually 20 hours a week at degree level or above, 10 below degree level.',
        'You cannot be self-employed, freelance or run a business, work as a professional sportsperson or entertainer, or fill a permanent full-time job.',
        'Tell your university if you change course, suspend studies or leave early. It can affect your visa.',
      ], links: [
        GuideLink('Student visa: your rights', 'https://www.gov.uk/student-visa'),
        GuideLink('UKCISA advice for students', 'https://www.ukcisa.org.uk/student-advice/'),
      ]),
      GuideSection('After your course: Graduate visa', [
        'If you complete an eligible UK degree, you can apply for the Graduate visa from inside the UK before your Student visa expires.',
        'Applications made from 1 January 2027 get 18 months for bachelor’s and master’s graduates, instead of 2 years. PhD graduates get 3 years.',
        'On the Graduate visa you can work, look for work and be self-employed.',
      ], links: [
        GuideLink('Graduate visa on GOV.UK', 'https://www.gov.uk/graduate-visa'),
      ]),
      GuideSection('Travelling', [
        'Carry your passport. Check your eVisa is linked to the passport you travel with.',
        'If you’re asked about your status at the border, you can be checked using your passport.',
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Work
  Guide(
    id: 'work',
    title: 'Work & part-time jobs',
    summary: 'Hour limits, NI numbers, payslips, minimum wage and spotting fake jobs.',
    warning: 'Breaking your work conditions can lead to your visa being cancelled. If unsure, ask your international student team before you accept a shift.',
    sections: [
      GuideSection('Your weekly limit', [
        'Weeks run Monday to Sunday. Paid and unpaid work both count, and so do hours across all your jobs.',
        'You can’t average hours across weeks. 25 hours one week and 15 the next breaks the rule.',
        'You may work full time during your university’s official vacations. Ask for a letter with your term dates; employers often need it.',
        'Master’s students: the summer dissertation period is usually term time.',
      ], links: [
        GuideLink('UKCISA: student work', 'https://ukcisa.org.uk/student-advice/working/student-work/'),
      ]),
      GuideSection('Before you start', [
        'Apply for a National Insurance number. You can start work while waiting if your employer has checked your right to work.',
        'Employers check your right to work using a share code.',
        'Ask for a written contract and check the hourly rate.',
      ], links: [
        GuideLink('Apply for an NI number', 'https://www.gov.uk/apply-national-insurance-number'),
        GuideLink('Prove your right to work', 'https://www.gov.uk/prove-right-to-work'),
      ]),
      GuideSection('Pay and tax', [
        'You are entitled to at least the National Minimum Wage for your age.',
        'Check every payslip: hours, pay rate, tax code and National Insurance.',
        'If your tax code is wrong (an emergency code like 1257L W1/M1 for months), contact HMRC. You may be due a refund.',
      ], links: [
        GuideLink('Minimum wage rates', 'https://www.gov.uk/national-minimum-wage-rates'),
        GuideLink('Check your tax (HMRC app)', 'https://www.gov.uk/check-income-tax-current-year'),
      ]),
      GuideSection('Fake jobs and scams', [
        'Never pay for a job, training or a “DBS check” to a stranger.',
        'Be wary of jobs moving money through your bank account. This is money muling and is a crime.',
        'Real employers don’t ask for your bank PIN or one-time codes.',
      ], links: [
        GuideLink('Money mules (Crimestoppers)', 'https://crimestoppers-uk.org/keeping-safe/community-family-safety/money-mules'),
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Money
  Guide(
    id: 'money',
    title: 'Money & banking',
    summary: 'Bank accounts, budgeting in pounds, sending money home and avoiding scams.',
    sections: [
      GuideSection('Opening an account', [
        'App-based banks are often quickest to open. High-street banks may need an appointment.',
        'Usually needed: passport, eVisa or share code, and proof of UK address such as a university letter.',
        'Turn on app notifications so you see every payment.',
      ], links: [
        GuideLink('MoneyHelper: banking', 'https://www.moneyhelper.org.uk/en/everyday-money/banking'),
      ]),
      GuideSection('Budgeting', [
        'List fixed costs first: rent, bills, phone, transport passes.',
        'Use Landed’s Money tab to set a monthly budget and log spending. It shows a daily allowance.',
        'Your university likely has a hardship fund and free money advice.',
      ], links: [
        GuideLink('MoneyHelper budget planner', 'https://www.moneyhelper.org.uk/en/everyday-money/budgeting/budget-planner'),
      ]),
      GuideSection('Sending money home', [
        'Compare the exchange rate as well as the fee. The rate is where most hidden costs are.',
        'Use providers regulated by the Financial Conduct Authority (FCA).',
      ], links: [
        GuideLink('Check a firm on the FCA register', 'https://register.fca.org.uk/'),
      ]),
      GuideSection('Scams that target international students', [
        'Calls claiming to be the Home Office, police or your embassy demanding payment are scams. Hang up.',
        'Your bank will never ask you to move money to a “safe account”.',
        'Forward scam texts to 7726 and report fraud to Report Fraud on 0300 123 2040.',
      ], links: [
        GuideLink('Report Fraud', 'https://www.reportfraud.police.uk/'),
        GuideLink('Take Five to Stop Fraud', 'https://www.takefive-stopfraud.org.uk/'),
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Housing
  Guide(
    id: 'housing',
    title: 'Housing & renting',
    summary: 'Avoiding rental scams, deposits, your rights as a renter and fixing problems.',
    sections: [
      GuideSection('Avoid rental scams', [
        'Never pay a deposit or rent before viewing the property (in person or on a live video call) and seeing a written agreement.',
        'Be suspicious of prices far below others nearby, “landlords abroad”, or pressure to pay today.',
        'Use your university’s accommodation service or accredited landlord schemes where possible.',
      ]),
      GuideSection('Money you can be asked for', [
        'Letting fees are banned in England. Most other charges are not allowed.',
        'A deposit is capped at 5 weeks’ rent (if annual rent is under £50,000).',
        'From 1 May 2026, landlords in England can’t ask for more than one month’s rent in advance, or take payment before the agreement is signed.',
      ], links: [
        GuideLink('Tenant fees and deposits', 'https://www.gov.uk/government/publications/tenant-fees-act-2019-guidance'),
        GuideLink('Renters’ Rights Act: tenants', 'https://www.gov.uk/guidance/renters-rights-act-overview-for-tenants'),
      ]),
      GuideSection('Your deposit', [
        'Your landlord must protect it in a government-approved scheme within 30 days and tell you which one.',
        'Take dated photos of everything on move-in and move-out.',
        'If there’s a dispute, the scheme offers free resolution.',
      ], links: [
        GuideLink('Tenancy deposit protection', 'https://www.gov.uk/tenancy-deposit-protection'),
      ]),
      GuideSection('Your rights (England)', [
        'Since 1 May 2026 most private tenancies are rolling (periodic), and “no-fault” section 21 evictions have ended.',
        'Rent can only go up once a year, with notice.',
        'Your landlord must fix serious damp, mould and safety hazards. Report problems in writing.',
        'Halls and lodgings (living with your landlord) have different rules.',
      ], links: [
        GuideLink('Shelter: private renting', 'https://england.shelter.org.uk/housing_advice/private_renting'),
      ]),
      GuideSection('Right to rent', [
        'Landlords in England must check your right to rent, usually with a share code from your UKVI account.',
      ], links: [
        GuideLink('Prove your right to rent', 'https://www.gov.uk/prove-right-to-rent'),
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Health
  Guide(
    id: 'health',
    title: 'Health & wellbeing',
    summary: 'GP registration, NHS 111, pharmacies, dentists and mental health support.',
    sections: [
      GuideSection('Using the NHS', [
        'If you paid the Immigration Health Surcharge, you can use the NHS like UK residents.',
        'Register with a GP near where you live. It’s free and you don’t need proof of address.',
        'Prescriptions in England cost a fixed charge per item. A prepayment certificate can save money.',
      ], links: [
        GuideLink('Find a GP', 'https://www.nhs.uk/service-search/find-a-gp'),
        GuideLink('NHS prescription charges', 'https://www.nhs.uk/nhs-services/prescriptions/who-can-get-free-prescriptions/'),
      ]),
      GuideSection('Which service?', [
        'Life-threatening emergency: call 999 or go to A&E.',
        'Urgent but not life-threatening: call 111 or use 111 online.',
        'Minor illness: a pharmacist can advise without an appointment.',
      ], links: [
        GuideLink('NHS 111 online', 'https://111.nhs.uk/'),
        GuideLink('Find a pharmacy', 'https://www.nhs.uk/service-search/pharmacy/find-a-pharmacy'),
      ]),
      GuideSection('Mental health', [
        'Your university has free counselling and wellbeing services.',
        'Samaritans: call 116 123, free, any time.',
        'Shout: text SHOUT to 85258 for free text support.',
        'In a mental health crisis, call 111 and choose the mental health option, or 999 in an emergency.',
      ], links: [
        GuideLink('Samaritans', 'https://www.samaritans.org/'),
        GuideLink('Student Space', 'https://studentspace.org.uk/'),
      ]),
      GuideSection('Dentist and eyes', [
        'NHS dental care has set charges. Finding a dentist taking patients can take time, so start early.',
      ], links: [
        GuideLink('Find a dentist', 'https://www.nhs.uk/service-search/find-a-dentist'),
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Study
  Guide(
    id: 'study',
    title: 'Study & university life',
    summary: 'Attendance, academic integrity, deadlines and support services.',
    sections: [
      GuideSection('Doing well', [
        'Put every deadline in Landed’s Deadlines tab so they show on your home screen.',
        'Use your library’s free academic skills and writing support.',
        'If illness or a crisis affects your work, ask about extenuating circumstances or extensions before the deadline.',
      ]),
      GuideSection('Academic integrity', [
        'Always reference sources. Check your university’s rules on AI tools before using them in assessed work.',
        'Never pay someone to write your work. Essay mills are illegal in England and can cost you your degree and visa.',
      ]),
      GuideSection('Attendance', [
        'Your university monitors engagement and must report sponsored students who stop attending.',
        'If you need time off, ask first. Your visa may be affected by long absences.',
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Transport
  Guide(
    id: 'transport',
    title: 'Getting around',
    summary: 'Railcards, buses, coaches, cycling and getting to airports cheaply.',
    sections: [
      GuideSection('Trains', [
        'A 16–25 Railcard (also for full-time students over 25) or 26–30 Railcard saves a third on most fares.',
        'Book early and compare split tickets for long journeys.',
        'If your train is late, you may be able to claim Delay Repay.',
      ], links: [
        GuideLink('16–25 Railcard', 'https://www.16-25railcard.co.uk'),
        GuideLink('National Rail journey planner', 'https://www.nationalrail.co.uk/'),
      ]),
      GuideSection('Buses and coaches', [
        'Most city bus companies sell student term or annual passes.',
        'Coaches are often the cheapest way between cities and to airports.',
      ]),
      GuideSection('Driving', [
        'You can usually drive in Great Britain on a valid licence from your country for up to 12 months from when you became resident.',
      ], links: [
        GuideLink('Driving in GB on a foreign licence', 'https://www.gov.uk/driving-nongb-licence'),
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Food & deals
  Guide(
    id: 'food',
    title: 'Food & saving money',
    summary: 'Cheap groceries, student discounts, home-country food and cutting waste.',
    sections: [
      GuideSection('Groceries', [
        'Discount supermarkets are usually cheapest for basics. Own-brand items save a lot.',
        'Look for yellow-sticker reductions late in the day.',
        'World-food aisles and local international grocers often sell rice, spices and lentils in big bags for less.',
      ]),
      GuideSection('Student discounts', [
        'Ask in shops and restaurants. Many give 10% with a student ID.',
        'A TOTUM card or student discount apps unlock online deals. Check the cost before paying for a card.',
      ]),
      GuideSection('Free and low-cost food', [
        'Apps that sell surplus food from shops and cafés can save money.',
        'Your Students’ Union may run a food pantry. Ask without embarrassment; it’s for everyone.',
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Phone & internet
  Guide(
    id: 'phone',
    title: 'Phone & internet',
    summary: 'Choosing a SIM, avoiding long contracts and keeping your number safe.',
    sections: [
      GuideSection('Choosing a plan', [
        'SIM-only 30-day plans let you switch any month without a long contract.',
        'Check international calling bundles if you call home a lot, or use Wi-Fi calling apps.',
        'Smaller networks often use the big networks’ masts, so coverage can be the same for less.',
      ], links: [
        GuideLink('Ofcom: mobile coverage checker', 'https://www.ofcom.org.uk/mobile-coverage-checker'),
      ]),
      GuideSection('Keep your number safe', [
        'Set a SIM PIN and turn on two-step verification on important accounts.',
        'If your phone suddenly loses signal and you get “SIM changed” messages, call your network: it could be SIM-swap fraud.',
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Community
  Guide(
    id: 'community',
    title: 'Friends & community',
    summary: 'Societies, cultural groups, faith communities and staying safe meeting people.',
    sections: [
      GuideSection('Finding your people', [
        'Students’ Union societies include national and cultural societies, sports, faith and hobby groups.',
        'Volunteering is a great way to meet locals and build your CV. Check it counts as volunteering, not unpaid work.',
        'Language exchanges and international student events run every term.',
      ], links: [
        GuideLink('Do-it: volunteering', 'https://do-it.org/'),
      ]),
      GuideSection('Staying safe', [
        'Meet new people in public places first and tell a friend where you’re going.',
        'Never share your share code, bank details or passport photos in group chats.',
        'Marketplace sales: meet in public, check items before paying, and don’t pay deposits for things you haven’t seen.',
      ]),
      GuideSection('Feeling lonely', [
        'It’s very common, especially in the first term and over holidays. Your university’s wellbeing team can help.',
        'Many cities run free holiday events for students who stay over Christmas.',
      ]),
    ],
  ),

  // ------------------------------------------------------------------ Emergencies
  Guide(
    id: 'emergency',
    title: 'Emergencies',
    summary: 'Who to call, lost passport, crime and what to do if something goes wrong.',
    sections: [
      GuideSection('Numbers to know', [
        '999 or 112: police, ambulance, fire or coastguard in an emergency.',
        '111: urgent medical advice (NHS).',
        '101: police, non-emergency.',
        '0300 123 2040: Report Fraud.',
        'Text 999 is available if you register first and can’t speak on the phone.',
      ], links: [
        GuideLink('Register for emergency SMS', 'https://www.emergencysms.org.uk/'),
      ]),
      GuideSection('Lost or stolen passport', [
        'Report it to the police and contact your embassy or high commission for an emergency travel document.',
        'Once you have a new passport, update your UKVI account so your eVisa links to it.',
      ], links: [
        GuideLink('Embassies in the UK', 'https://www.gov.uk/government/publications/foreign-embassies-in-the-uk'),
        GuideLink('Update your UKVI account', 'https://www.gov.uk/update-ukvi-account'),
      ]),
      GuideSection('If you’re a victim of crime', [
        'Report it to the police. Victim Support is free and confidential.',
      ], links: [
        GuideLink('Victim Support', 'https://www.victimsupport.org.uk/'),
      ]),
    ],
  ),

  // ------------------------------------------------------------------ After graduation
  Guide(
    id: 'careers',
    title: 'Careers & after graduation',
    summary: 'CVs, graduate jobs, sponsorship and starting a business the right way.',
    sections: [
      GuideSection('Getting a job', [
        'Use your university careers service for CV and interview help. It stays free for a while after you graduate.',
        'UK CVs are usually 2 pages, with no photo, date of birth or marital status.',
        'For a Skilled Worker visa later, your employer must hold a sponsor licence.',
      ], links: [
        GuideLink('Register of licensed sponsors', 'https://www.gov.uk/government/publications/register-of-licensed-sponsors-workers'),
        GuideLink('Skilled Worker visa', 'https://www.gov.uk/skilled-worker-visa'),
      ]),
      GuideSection('Starting a business', [
        'On a Student visa you can’t be self-employed or run a business. You can plan, research and prototype.',
        'The Graduate visa allows self-employment. The Innovator Founder visa needs an endorsement.',
        'Your university’s enterprise team can help you plan safely.',
      ], links: [
        GuideLink('Innovator Founder visa', 'https://www.gov.uk/innovator-founder-visa'),
      ]),
    ],
  ),
];

Guide? guideById(String id) {
  for (final g in guides) {
    if (g.id == id) return g;
  }
  return null;
}
