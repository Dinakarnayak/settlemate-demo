// Content that applies wherever a student studies.
import '../assistant.dart';
import '../guides.dart';

const generalStudyGuide = Guide(
  id: 'study',
  title: 'Study & university life',
  summary: 'Attendance, academic integrity, deadlines and support services.',
  sections: [
    GuideSection('Doing well', [
      'Put every deadline in Landed’s Deadlines so they show on your home screen.',
      'Use your library’s free academic skills and writing support.',
      'If illness or a crisis affects your work, ask about extensions or special circumstances before the deadline.',
    ]),
    GuideSection('Academic integrity', [
      'Always reference your sources. Check your university’s rules on AI tools before using them in assessed work.',
      'Never pay someone to write your work. It can cost you your degree and, for international students, your visa.',
    ]),
    GuideSection('Attendance and your visa', [
      'Student visas usually depend on you studying full time and making progress. Universities may report students who stop attending.',
      'If you need time off, change course or plan to leave early, talk to the international student office first.',
    ]),
  ],
);

const generalCommunityGuide = Guide(
  id: 'community',
  title: 'Friends & community',
  summary: 'Clubs, cultural groups, faith communities and staying safe meeting people.',
  sections: [
    GuideSection('Finding your people', [
      'Join one student club or society and go every week: national and cultural groups, sports, faith and hobby clubs.',
      'Volunteering and language exchanges are great ways to meet locals. Check volunteering is allowed on your visa.',
      'Your international student office runs events every term, especially in the first weeks.',
    ]),
    GuideSection('Staying safe', [
      'Meet new people in public places first and tell a friend where you’re going.',
      'Never share passport photos, visa documents or bank details in group chats.',
      'Marketplace sales: meet in public, check items before paying, and don’t pay deposits for things you haven’t seen.',
    ]),
    GuideSection('Feeling lonely or homesick', [
      'It’s very common, especially in the first term and over holidays. Your university’s counselling or wellbeing service is free.',
      'Keep a routine with sleep, food and one social activity a week. It really helps.',
    ]),
  ],
);

const generalFoodGuide = Guide(
  id: 'food',
  title: 'Food & saving money',
  summary: 'Cheap groceries, food from home, student discounts and cutting waste.',
  sections: [
    GuideSection('Groceries', [
      'Discount supermarkets and own-brand products are usually cheapest for basics.',
      'International and world-food shops often sell rice, spices and lentils in big bags for less.',
      'Use Explore → Food near me to find grocers and restaurants around you.',
    ]),
    GuideSection('Student discounts', [
      'Ask in shops, cinemas and restaurants: many give a discount with your student card.',
      'Many universities and student unions run free or low-cost food pantries. They’re for everyone.',
    ]),
    GuideSection('Cooking on a budget', [
      'Batch cook and freeze portions. Plan meals before you shop.',
      'Food-saving apps sell surplus food from shops and cafés cheaply.',
    ]),
  ],
);

/// Answers that are true in any country.
const generalAnswers = <Answer>[
  Answer('Is my data private?', ['privacy', 'private', 'my data', 'data safe', 'who can see', 'security', 'encrypted'],
      'Yes. Everything you enter stays on this phone, encrypted with AES-256. There are no ads or trackers, and this helper runs offline. You can back up with a passphrase or erase everything in Settings.',
      linkLabel: ''),
  Answer('How do I make friends?', ['make friends', 'friends', 'society', 'societies', 'club', 'meet people', 'lonely'],
      'Join one club or society and go every week. National and cultural groups, sports and volunteering are great starts. Your international office runs welcome events too.',
      guideId: 'community'),
  Answer('Is it safe to buy from marketplace groups?', ['marketplace', 'buy second hand', 'selling', 'buy sell'],
      'Meet in a public place, check the item before paying, and never pay a deposit for something you haven’t seen.',
      guideId: 'community'),
  Answer('Where can I worship?', ['mosque', 'temple', 'church', 'gurdwara', 'synagogue', 'prayer', 'faith', 'chaplaincy'],
      'Your university chaplaincy or multi-faith centre can point you to local places of worship and faith societies. Explore → Nearby can search maps too.',
      guideId: 'community'),
  Answer('Can I use AI tools for my assignments?', ['ai tools', 'chatgpt', 'ai assignment', 'plagiarism', 'academic integrity'],
      'It depends on your university and module rules, so check your handbook. Never submit work written by someone else, and reference properly.',
      guideId: 'study'),
  Answer('I’m going to miss a deadline', ['extension', 'miss deadline', 'late submission', 'mitigating', 'extenuating', 'special circumstances'],
      'Ask for an extension or special consideration before the deadline if you can. Your department and student advice service can help.',
      guideId: 'study'),
  Answer('What happens if I miss classes?', ['attendance', 'miss class', 'missed lectures', 'engagement'],
      'Student visas usually require you to study full time. If you’re ill or need time away, tell your department and international office so it’s recorded properly.',
      guideId: 'study'),
  Answer('How can I save money on food?', ['cheap food', 'save money food', 'food budget', 'meal prep', 'food bank', 'pantry', 'groceries'],
      'Shop at discount supermarkets, buy own-brand and batch cook. Many universities run free food pantries. Try Explore → Food near me.',
      guideId: 'food'),
  Answer('Where can I buy food from home?', ['indian food', 'chinese food', 'african food', 'home food', 'spices', 'world food', 'halal'],
      'Use Explore → Food near me and filter by your cuisine, or check supermarket world-food aisles and international grocers.',
      guideId: 'food'),
  Answer('Do I get student discounts?', ['student discount', 'discount', 'isic'],
      'Often yes with your student card; just ask. An international student card (ISIC) unlocks some discounts too.',
      guideId: 'food'),
  Answer('I lost my phone or bank card', ['lost phone', 'stolen phone', 'lost card', 'stolen card'],
      'Freeze your card in your banking app or call your bank. Call your mobile network to block the SIM, and change passwords on important accounts.',
      guideId: 'emergency'),
  Answer('I lost my passport', ['lost passport', 'stolen passport', 'passport lost', 'passport stolen'],
      'Report it to the police and contact your country’s embassy or consulate for an emergency travel document. Then tell your university’s international office, as your visa record may need updating.',
      guideId: 'emergency'),
  Answer('How do I write a CV or résumé?', ['cv', 'resume', 'résumé', 'cover letter'],
      'Keep it to 1–2 pages, focus on achievements, and follow local norms (many countries expect no photo or date of birth). Your careers service will review it for free.'),
  Answer('Is this job offer a scam?', ['job scam', 'fake job', 'money mule', 'pay for job', 'easy money'],
      'Warning signs: you’re asked to pay first, to move money through your bank account, or to share bank codes. Real employers never do this.',
      guideId: 'work'),
  Answer('I got a call from immigration asking for money', ['immigration call', 'police call', 'embassy call', 'scam call', 'pay fine', 'deported'],
      'That’s almost certainly a scam. Government agencies don’t demand payment by phone, gift cards or crypto. Hang up, don’t pay, and report it.',
      guideId: 'money'),
];

const generalSuggestedQuestions = [
  'How many hours can I work?',
  'How do I open a bank account?',
  'How do I see a doctor?',
  'What can I do after graduating?',
  'Is my data private?',
];
