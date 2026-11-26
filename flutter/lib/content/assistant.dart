/// Offline helper. Runs entirely on the phone: questions are matched against
/// these answers locally and never sent anywhere.
library;

class Answer {
  const Answer(this.question, this.keywords, this.text, {this.url, this.linkLabel = 'Official guidance', this.guideId});
  final String question;
  final List<String> keywords;
  final String text;
  final String? url;
  final String linkLabel;
  final String? guideId;
}

const answers = <Answer>[
  // ---------------- visa
  Answer('How do I get a share code?', ['share code', 'prove status', 'prove my status', 'right to work', 'right to rent'],
      'Sign in to your UKVI account on GOV.UK, choose why you need it (work, renting or other), and it gives you a code valid for 90 days.',
      url: 'https://www.gov.uk/view-prove-immigration-status', guideId: 'visa'),
  Answer('What is an eVisa?', ['evisa', 'e-visa', 'ukvi account', 'brp', 'biometric residence'],
      'Your immigration status is now online, linked to your passport, instead of a physical card. You view it and get share codes in your UKVI account.',
      url: 'https://www.gov.uk/evisa', guideId: 'visa'),
  Answer('I have a new passport. What do I do?', ['new passport', 'passport changed', 'renewed passport', 'update ukvi'],
      'Update your UKVI account with the new passport so your eVisa links to it. Do this before you travel.',
      url: 'https://www.gov.uk/update-ukvi-account', guideId: 'visa'),
  Answer('When does my visa expire?', ['visa expire', 'visa expiry', 'visa end', 'how long visa'],
      'Your expiry date is in your UKVI account. Add it in Profile and Landed will count down and remind you on the home screen.',
      url: 'https://www.gov.uk/view-prove-immigration-status', guideId: 'visa'),
  Answer('How long is the Graduate visa?', ['graduate visa', 'graduate route', 'post study', 'psw', 'after graduation visa'],
      'Applications made from 1 January 2027 get 18 months for bachelor’s and master’s graduates (2 years if you apply before then). PhD graduates get 3 years. Apply from inside the UK before your Student visa expires.',
      url: 'https://www.gov.uk/graduate-visa', guideId: 'visa'),
  Answer('Can I start a business on a Student visa?', ['business', 'self employed', 'self-employed', 'freelance', 'startup', 'start-up', 'side hustle', 'sell online'],
      'No. Student visa holders can’t be self-employed, freelance or run a business. You can research and plan. The Graduate visa allows self-employment.',
      url: 'https://www.gov.uk/student-visa', guideId: 'careers'),
  Answer('Can I travel outside the UK?', ['travel abroad', 'travel outside', 'holiday abroad', 'go home', 'leave the uk', 'vacation travel'],
      'Usually yes, during holidays. Make sure your eVisa is linked to the passport you travel with and check your university’s attendance rules.',
      url: 'https://www.gov.uk/evisa', guideId: 'visa'),
  Answer('Can my family visit or join me?', ['family visit', 'dependant', 'dependent', 'spouse', 'partner join', 'parents visit'],
      'Visitors apply for a Standard Visitor visa if needed. Most taught master’s and undergraduate students can no longer bring dependants. Check the rules for your course.',
      url: 'https://www.gov.uk/student-visa/family-members', guideId: 'visa'),

  // ---------------- work
  Answer('How many hours can I work?', ['how many hours', 'hours can i work', 'work limit', '20 hours', '10 hours', 'term time'],
      'Usually up to 20 hours a week in term time at degree level or above, or 10 below degree level. Weeks run Monday to Sunday and all jobs count together. Your exact limit is on your eVisa.',
      url: 'https://ukcisa.org.uk/student-advice/working/student-work/', guideId: 'work'),
  Answer('Can I work full time in the holidays?', ['full time', 'full-time', 'holidays', 'vacation', 'christmas work', 'summer work'],
      'Yes, during your university’s official vacations. Master’s students: the summer dissertation period usually counts as term time.',
      url: 'https://ukcisa.org.uk/student-advice/working/student-work/', guideId: 'work'),
  Answer('Do I need a National Insurance number?', ['national insurance', 'ni number', 'nin'],
      'Yes, for work. Apply online on GOV.UK. You can start work before it arrives if your employer checks your right to work.',
      url: 'https://www.gov.uk/apply-national-insurance-number', guideId: 'work'),
  Answer('What is the minimum wage?', ['minimum wage', 'living wage', 'hourly rate', 'pay rate'],
      'Every worker is entitled to at least the National Minimum Wage for their age. Check the current rates on GOV.UK.',
      url: 'https://www.gov.uk/national-minimum-wage-rates', guideId: 'work'),
  Answer('My tax looks wrong', ['tax code', 'emergency tax', 'too much tax', 'tax refund', 'payslip', 'p45', 'p60'],
      'Check the tax code on your payslip. If you’re on an emergency code for months, use the HMRC app or contact HMRC. You may get a refund.',
      url: 'https://www.gov.uk/check-income-tax-current-year', guideId: 'work'),
  Answer('Can I volunteer?', ['volunteer', 'volunteering', 'unpaid', 'internship', 'placement'],
      'Genuine volunteering for a charity is allowed and doesn’t count as work. Unpaid internships and “voluntary work” with set duties do count towards your hours.',
      url: 'https://ukcisa.org.uk/student-advice/working/student-work/', guideId: 'work'),
  Answer('Is this job offer a scam?', ['job scam', 'fake job', 'money mule', 'pay for job', 'easy money'],
      'Warning signs: you’re asked to pay first, to move money through your account, or to share bank codes. Real employers never do this.',
      url: 'https://crimestoppers-uk.org/keeping-safe/community-family-safety/money-mules', guideId: 'work'),
  Answer('Where can I find part-time jobs?', ['find job', 'part time job', 'part-time job', 'job search', 'jobs near'],
      'Start with your university’s careers service and Students’ Union job board, which list student-friendly jobs. Tell employers your term-time limit up front.',
      guideId: 'work'),

  // ---------------- money
  Answer('How do I open a bank account?', ['bank account', 'open bank', 'banking', 'bank'],
      'Most banks need your passport, eVisa or share code and proof of address (often a university letter). App-based banks are often quickest. See Set up → Banks.',
      url: 'https://www.moneyhelper.org.uk/en/everyday-money/banking', guideId: 'money'),
  Answer('How do I send money home cheaply?', ['send money', 'transfer money', 'money transfer', 'exchange rate', 'remittance'],
      'Compare the total cost: the fee and the exchange rate. Use an FCA-regulated provider and check the amount your family receives.',
      url: 'https://register.fca.org.uk/', guideId: 'money'),
  Answer('I got a call from the Home Office asking for money', ['home office call', 'police call', 'embassy call', 'scam call', 'pay fine', 'deported'],
      'That is a scam. Government bodies don’t demand payment by phone, gift cards or crypto. Hang up, don’t pay, and report it to Report Fraud on 0300 123 2040.',
      url: 'https://www.reportfraud.police.uk/', guideId: 'money'),
  Answer('How do I report a scam text?', ['scam text', 'phishing', 'spam text', '7726', 'suspicious message'],
      'Forward scam texts to 7726 for free. Report losses to your bank straight away and to Report Fraud.',
      url: 'https://www.reportfraud.police.uk/', guideId: 'money'),
  Answer('I’m running out of money', ['no money', 'running out', 'hardship', 'can’t afford', 'cant afford', 'broke', 'debt'],
      'Talk to your university’s money advice team about hardship funds. MoneyHelper and Citizens Advice give free advice. Set a budget in the Money tab to see your daily allowance.',
      url: 'https://www.moneyhelper.org.uk/en', guideId: 'money'),
  Answer('Do I pay council tax?', ['council tax'],
      'Full-time students are usually exempt. Send your student certificate to your local council. If you live with non-students, the household may get a discount instead.',
      url: 'https://www.gov.uk/council-tax/discounts-for-full-time-students'),
  Answer('Do I need a TV Licence?', ['tv licence', 'tv license', 'iplayer'],
      'You need one to watch live TV on any device or use BBC iPlayer. Not needed for other streaming services only.',
      url: 'https://www.tvlicensing.co.uk/check-if-you-need-one'),

  // ---------------- housing
  Answer('How do I avoid rental scams?', ['rental scam', 'housing scam', 'landlord scam', 'fake landlord', 'room scam'],
      'Never pay before viewing (in person or live video) and seeing a written agreement. Be wary of very low prices, landlords “abroad”, and pressure to pay today.',
      guideId: 'housing'),
  Answer('How much deposit can a landlord take?', ['deposit', 'holding deposit', 'how much deposit'],
      'In England, up to 5 weeks’ rent for most tenancies, and it must be protected in a government scheme within 30 days.',
      url: 'https://www.gov.uk/tenancy-deposit-protection', guideId: 'housing'),
  Answer('Can a landlord ask for 6 months’ rent upfront?', ['rent in advance', 'rent upfront', 'months upfront', 'advance rent', 'guarantor'],
      'In England, since 1 May 2026 landlords can’t require more than one month’s rent in advance, or take payment before the agreement is signed. Ask your university about guarantor schemes if you don’t have a UK guarantor.',
      url: 'https://www.gov.uk/guidance/renters-rights-act-overview-for-tenants', guideId: 'housing'),
  Answer('Can my landlord evict me?', ['evict', 'eviction', 'section 21', 'section 8', 'kicked out', 'notice to leave'],
      'In England, “no-fault” section 21 evictions ended on 1 May 2026. A landlord needs a legal reason and a court order. Get advice from Shelter or your university straight away.',
      url: 'https://england.shelter.org.uk/housing_advice/eviction', guideId: 'housing'),
  Answer('My flat has damp or mould', ['damp', 'mould', 'mold', 'repairs', 'heating broken', 'landlord not fixing'],
      'Report it to your landlord in writing with photos. Landlords must deal with serious hazards. If they don’t, contact your council’s private housing team.',
      url: 'https://england.shelter.org.uk/housing_advice/repairs', guideId: 'housing'),
  Answer('Where can I find accommodation?', ['find accommodation', 'find a room', 'flat', 'housing', 'room to rent', 'halls'],
      'Start with your university’s accommodation service, which often lists accredited landlords. View before paying anything.',
      guideId: 'housing'),

  // ---------------- health
  Answer('How do I register with a GP?', ['gp', 'doctor', 'register doctor', 'family doctor'],
      'Find a GP near your home on the NHS website and fill in their registration form. It’s free; you don’t need proof of address or immigration status.',
      url: 'https://www.nhs.uk/nhs-services/gps/how-to-register-with-a-gp-surgery/', guideId: 'health'),
  Answer('I feel ill. Where do I go?', ['ill', 'sick', 'unwell', 'fever', 'pain', 'nhs 111', '111'],
      'Emergency: call 999. Urgent but not an emergency: call 111 or use 111 online. Minor illness: ask a pharmacist, no appointment needed.',
      url: 'https://111.nhs.uk/', guideId: 'health'),
  Answer('How much is a prescription?', ['prescription', 'medicine cost', 'ppc'],
      'In England there’s a fixed charge per item. If you need lots, a prescription prepayment certificate can save money.',
      url: 'https://www.nhs.uk/nhs-services/prescriptions/who-can-get-free-prescriptions/', guideId: 'health'),
  Answer('I’m struggling with my mental health', ['mental health', 'stress', 'anxious', 'anxiety', 'depressed', 'lonely', 'homesick', 'overwhelmed'],
      'You’re not alone, and help is free. Contact your university’s wellbeing or counselling service. You can call Samaritans on 116 123 any time, or text SHOUT to 85258. In an emergency call 999.',
      url: 'https://studentspace.org.uk/', linkLabel: 'Student Space', guideId: 'health'),
  Answer('How do I find a dentist?', ['dentist', 'dental', 'tooth'],
      'Search for NHS dentists taking patients on the NHS website. For urgent dental pain out of hours, call 111.',
      url: 'https://www.nhs.uk/service-search/find-a-dentist', guideId: 'health'),

  // ---------------- transport
  Answer('How do I save on trains?', ['railcard', 'train', 'rail', 'cheap train'],
      'Get a 16–25 Railcard (full-time students over 25 can too) or a 26–30 Railcard to save a third. Book early and check split tickets.',
      url: 'https://www.16-25railcard.co.uk', guideId: 'transport'),
  Answer('Can I drive with my licence from home?', ['drive', 'driving licence', 'driving license', 'car'],
      'Usually for up to 12 months from becoming resident in Great Britain, depending on your country. Check GOV.UK for your licence.',
      url: 'https://www.gov.uk/driving-nongb-licence', guideId: 'transport'),
  Answer('What about buses?', ['bus', 'bus pass', 'coach'],
      'Most city bus companies sell student term or annual passes. Coaches are often the cheapest way between cities and to airports.',
      guideId: 'transport'),

  // ---------------- phone
  Answer('Which SIM should I get?', ['sim', 'phone plan', 'mobile', 'data plan', 'network'],
      'A 30-day SIM-only plan is flexible. Compare data, international minutes and coverage. See Set up → SIM cards for options.',
      url: 'https://www.ofcom.org.uk/mobile-coverage-checker', guideId: 'phone'),

  // ---------------- study
  Answer('Can I use AI tools for my assignments?', ['ai tools', 'chatgpt', 'ai assignment', 'plagiarism', 'academic integrity'],
      'It depends on your university and module rules, so check your handbook. Never submit work written by someone else, and reference properly.',
      guideId: 'study'),
  Answer('I’m going to miss a deadline', ['extension', 'miss deadline', 'late submission', 'mitigating', 'extenuating'],
      'Ask for an extension or apply for extenuating circumstances before the deadline if possible. Your department and Students’ Union advice centre can help.',
      guideId: 'study'),
  Answer('What happens if I miss classes?', ['attendance', 'miss class', 'missed lectures', 'engagement'],
      'Universities monitor engagement for sponsored students. If you’re ill or need time away, tell your department so it’s recorded properly.',
      guideId: 'study'),

  // ---------------- community
  Answer('How do I make friends?', ['make friends', 'friends', 'society', 'societies', 'club', 'meet people'],
      'Join one society or regular activity and go every week. National and cultural societies, sports and volunteering are great starts.',
      guideId: 'community'),
  Answer('Is it safe to buy from marketplace groups?', ['marketplace', 'buy second hand', 'selling', 'buy sell', 'facebook marketplace'],
      'Meet in a public place, check the item before paying, and never pay a deposit for something you haven’t seen.',
      guideId: 'community'),
  Answer('Where can I worship?', ['mosque', 'temple', 'church', 'gurdwara', 'synagogue', 'prayer', 'faith', 'chaplaincy'],
      'Your university chaplaincy or multi-faith centre can point you to local places of worship and faith societies.',
      guideId: 'community'),

  // ---------------- food
  Answer('Where can I buy food from home?', ['indian food', 'chinese food', 'african food', 'home food', 'spices', 'world food', 'grocery'],
      'Check supermarket world-food aisles and local international grocers. Use Discover → Nearby to search maps for your city.',
      guideId: 'food'),
  Answer('How can I save money on food?', ['cheap food', 'save money food', 'food budget', 'meal prep', 'food bank', 'pantry'],
      'Shop at discount supermarkets, buy own-brand, look for yellow stickers, and batch cook. Many Students’ Unions run free food pantries.',
      guideId: 'food'),
  Answer('Do I get student discounts?', ['student discount', 'discount', 'totum', 'unidays'],
      'Often 10% in shops and restaurants with your student ID; just ask. Discount apps unlock online deals.',
      guideId: 'food'),

  // ---------------- emergency
  Answer('What are the emergency numbers?', ['emergency', '999', '112', '101', 'police', 'ambulance', 'fire'],
      '999 or 112 for emergencies, 111 for urgent medical advice, 101 for non-emergency police.',
      url: 'https://www.emergencysms.org.uk/', linkLabel: 'Register for emergency texts', guideId: 'emergency'),
  Answer('I lost my passport', ['lost passport', 'stolen passport', 'passport lost', 'passport stolen'],
      'Report it to the police, contact your embassy or high commission for an emergency travel document, then update your UKVI account with the new passport.',
      url: 'https://www.gov.uk/government/publications/foreign-embassies-in-the-uk', linkLabel: 'Embassies in the UK', guideId: 'emergency'),
  Answer('I lost my phone or bank card', ['lost phone', 'stolen phone', 'lost card', 'stolen card'],
      'Freeze your card in your banking app or call your bank. Call your network to block your SIM. Change passwords on important accounts.',
      guideId: 'emergency'),

  // ---------------- careers
  Answer('How do I write a UK CV?', ['cv', 'resume', 'résumé', 'cover letter'],
      'Two pages, achievements over duties, no photo or date of birth. Your careers service will review it for free.',
      guideId: 'careers'),
  Answer('Which employers can sponsor a visa?', ['sponsor', 'sponsorship', 'skilled worker', 'work visa'],
      'Only employers on the Home Office register of licensed sponsors can sponsor a Skilled Worker visa.',
      url: 'https://www.gov.uk/government/publications/register-of-licensed-sponsors-workers', guideId: 'careers'),

  // ---------------- app & privacy
  Answer('Is my data private?', ['privacy', 'private', 'my data', 'data safe', 'who can see', 'security', 'encrypted'],
      'Yes. Everything you enter stays on this phone, encrypted with AES-256. There are no ads or trackers, and this helper runs offline. You can back up with a passphrase or erase everything in Settings.',
      linkLabel: ''),
];

class AnswerMatch {
  const AnswerMatch(this.answer, this.score);
  final Answer answer;
  final int score;
}

String _norm(String s) => ' ${s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9£ ]+'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim()} ';

/// Returns the best answers for [query], best first.
List<AnswerMatch> searchAnswers(String query, {int limit = 3}) {
  final q = _norm(query);
  if (q.trim().isEmpty) return const [];
  final words = q.trim().split(' ').where((w) => w.length > 2).toSet();
  final results = <AnswerMatch>[];
  for (final a in answers) {
    var score = 0;
    for (final k in a.keywords) {
      final nk = _norm(k);
      if (q.contains(nk)) score += 3 + nk.trim().split(' ').length * 2;
    }
    if (score == 0) {
      // fall back to word overlap with the question
      final qw = _norm(a.question).trim().split(' ').where((w) => w.length > 3);
      score = qw.where(words.contains).length;
      if (score < 2) score = 0;
    }
    if (score > 0) results.add(AnswerMatch(a, score));
  }
  results.sort((x, y) => y.score.compareTo(x.score));
  return results.take(limit).toList();
}

const suggestedQuestions = [
  'How many hours can I work?',
  'How do I get a share code?',
  'How do I register with a GP?',
  'How do I avoid rental scams?',
  'How long is the Graduate visa?',
  'Is my data private?',
];
