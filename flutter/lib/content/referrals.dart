/// Providers shown in the “Set up” section (banks and SIMs).
///
/// HOW TO ADD YOUR REFERRAL LINKS
/// Paste a link into `referralUrl` for any provider. When it's set, the app
/// opens that link instead of the official page and shows a clear
/// “Referral link” label, as UK advertising rules require.
///
/// Leave `referralUrl` as null to use the normal official page.
///
/// Check with your university's international student advice team before
/// earning referral rewards through the app while on a Student visa.
library;

class Provider {
  const Provider({
    required this.name,
    required this.kind,
    required this.blurb,
    required this.officialUrl,
    this.referralUrl,
  });

  final String name;
  final String kind; // 'Bank' or 'SIM'
  final String blurb;
  final String officialUrl;
  final String? referralUrl;

  bool get isReferral => referralUrl != null && referralUrl!.isNotEmpty;
  String get url => isReferral ? referralUrl! : officialUrl;
}

const referralDisclosure =
    'Referral link: Landed’s founder may receive a reward if you sign up. It doesn’t cost you anything extra, and you’re free to choose any provider.';

const providers = <Provider>[
  // ---------------------------------------------------------------- banks
  Provider(
    name: 'Lloyds Bank',
    kind: 'Bank',
    blurb: 'High-street bank with branches across the UK.',
    officialUrl: 'https://www.lloydsbank.com/current-accounts.html',
    referralUrl: null, // paste your Lloyds referral link here
  ),
  Provider(
    name: 'Monzo',
    kind: 'Bank',
    blurb: 'App-based bank, often quick to open.',
    officialUrl: 'https://monzo.com/',
    referralUrl: null,
  ),
  Provider(
    name: 'Starling Bank',
    kind: 'Bank',
    blurb: 'App-based bank with no monthly fee.',
    officialUrl: 'https://www.starlingbank.com/',
    referralUrl: null,
  ),
  Provider(
    name: 'Revolut',
    kind: 'Bank',
    blurb: 'App with multi-currency spending and transfers.',
    officialUrl: 'https://www.revolut.com/en-GB/',
    referralUrl: null,
  ),
  // ---------------------------------------------------------------- SIMs
  Provider(
    name: 'Lebara',
    kind: 'SIM',
    blurb: 'SIM-only plans with international minutes.',
    officialUrl: 'https://www.lebara.co.uk/',
    // Founder's Lebara Refer & Earn link, switched OFF at public launch until the
    // university's international student advice team confirms it's allowed:
    // referralUrl: 'https://aklam.io/yzJ6U79f',
    referralUrl: null,
  ),
  Provider(
    name: 'giffgaff',
    kind: 'SIM',
    blurb: 'Monthly SIM-only plans you can change or cancel any time.',
    officialUrl: 'https://www.giffgaff.com/',
    referralUrl: null,
  ),
  Provider(
    name: 'Lyca Mobile',
    kind: 'SIM',
    blurb: 'SIM-only plans with international calling bundles.',
    officialUrl: 'https://www.lycamobile.co.uk/',
    referralUrl: null,
  ),
];
