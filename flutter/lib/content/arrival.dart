import '../data/models.dart';

/// The default arrival checklist, roughly in the order most students need it.
List<TaskItem> defaultArrivalTasks() => [
      TaskItem(
        id: 'evisa',
        title: 'Check your eVisa and save a share code',
        detail: 'Sign in to your UKVI account, check your details are right and keep a share code for landlords and employers.',
        url: 'https://www.gov.uk/view-prove-immigration-status',
      ),
      TaskItem(
        id: 'sim',
        title: 'Get a UK SIM card',
        detail: 'A UK number is needed for bank security codes, GP and job sign-ups. SIM-only monthly or pay-as-you-go plans are usually cheapest.',
        url: 'https://www.ofcom.org.uk/phones-and-broadband/mobile-phones',
      ),
      TaskItem(
        id: 'enrol',
        title: 'Finish university enrolment',
        detail: 'Complete online enrolment and collect your student ID. Your university uses this to report you have started your course.',
      ),
      TaskItem(
        id: 'bank',
        title: 'Open a UK bank account',
        detail: 'Many banks let you open an account in an app with your passport, eVisa and proof of address (often a university letter).',
        url: 'https://www.moneyhelper.org.uk/en/everyday-money/banking',
      ),
      TaskItem(
        id: 'gp',
        title: 'Register with a GP',
        detail: 'Registering is free and you don’t need proof of address or immigration status. Do it before you get ill.',
        url: 'https://www.nhs.uk/nhs-services/gps/how-to-register-with-a-gp-surgery/',
      ),
      TaskItem(
        id: 'deposit',
        title: 'Check your deposit is protected',
        detail: 'If you rent privately, your landlord must protect your deposit in a government scheme within 30 days.',
        url: 'https://www.gov.uk/tenancy-deposit-protection',
      ),
      TaskItem(
        id: 'counciltax',
        title: 'Claim your council tax exemption',
        detail: 'Full-time students usually don’t pay council tax. Send your student certificate to your local council.',
        url: 'https://www.gov.uk/council-tax/discounts-for-full-time-students',
      ),
      TaskItem(
        id: 'ni',
        title: 'Apply for a National Insurance number',
        detail: 'You can start work before it arrives if you can prove your right to work, but apply early.',
        url: 'https://www.gov.uk/apply-national-insurance-number',
      ),
      TaskItem(
        id: 'railcard',
        title: 'Get a 16–25 or 26–30 Railcard',
        detail: 'Saves a third on most rail fares. Full-time students aged 26+ can usually get the 16–25 card too.',
        url: 'https://www.16-25railcard.co.uk',
      ),
      TaskItem(
        id: 'tvlicence',
        title: 'Check if you need a TV Licence',
        detail: 'You need one to watch live TV or use BBC iPlayer, even on a laptop or phone.',
        url: 'https://www.tvlicensing.co.uk/check-if-you-need-one',
      ),
      TaskItem(
        id: 'emergency',
        title: 'Save emergency and embassy contacts',
        detail: '999 for emergencies, 111 for urgent health advice, 101 for non-emergency police, plus your embassy or high commission.',
        url: 'https://www.gov.uk/government/publications/foreign-embassies-in-the-uk',
      ),
      TaskItem(
        id: 'society',
        title: 'Join one society or club',
        detail: 'Your Students’ Union lists hundreds. One regular activity is the quickest way to make friends.',
      ),
    ];
