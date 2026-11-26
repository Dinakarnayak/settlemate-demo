import 'package:flutter/material.dart';

import '../content/countries/countries.dart';
import '../data/models.dart';
import '../data/store.dart';
import '../l10n/l10n.dart';
import '../theme.dart';
import '../widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.store});
  final AppStore store;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const pages = 5;
  final _pages = PageController();
  int page = 0;
  final name = TextEditingController();
  final uni = TextEditingController();
  final city = TextEditingController();
  final home = TextEditingController();
  final currency = TextEditingController();
  late final budget = TextEditingController(text: packFor(country).defaultBudget.toStringAsFixed(0));
  bool degree = true;
  DateTime? visa;
  late String country = widget.store.profile.studyCountry;
  bool budgetEdited = false;

  CountryPack get pack => packFor(country);

  @override
  void dispose() {
    for (final c in [name, uni, city, home, budget, currency]) {
      c.dispose();
    }
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (page < pages - 1) {
      _pages.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    } else {
      final p = pack;
      widget.store.completeOnboarding(Profile(
        name: name.text.trim(),
        university: uni.text.trim(),
        city: city.text.trim(),
        homeCountry: home.text.trim(),
        degreeLevel: degree,
        weeklyLimit: widget.store.defaultLimit(p, degree),
        monthlyBudget: parseAmount(budget.text) ?? p.defaultBudget,
        visaExpiry: visa,
        studyCountry: country,
        language: currentLanguage,
        currency: p.fullySupported ? '' : currency.text.trim(),
      ));
    }
  }

  void _pickCountry(String code) => setState(() {
        country = code;
        if (!budgetEdited) budget.text = packFor(code).defaultBudget.toStringAsFixed(0);
      });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final p = pack;
    final r = p.work;
    final limitText = r.isDays
        ? t('Work limit: {n} days a year.', {'n': '${r.limit.round()}'})
        : t('Work limit: {n} hours per {p}.', {'n': '${widget.store.defaultLimit(p, degree)}', 'p': t(r.periodName)});
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(children: [
              for (var i = 0; i < pages; i++)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(color: i <= page ? AppColors.coral : AppColors.line, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
            ]),
          ),
          Expanded(
            child: PageView(
              controller: _pages,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => page = i),
              children: [
                // ------------------------------------------------ welcome + language
                _page([
                  const SizedBox(height: 10),
                  Center(
                    child: Transform.rotate(
                      angle: -0.12,
                      child: Container(
                        width: 88,
                        height: 88,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(28)),
                        child: const Icon(Icons.flight_land_rounded, color: Colors.white, size: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(t('Welcome to Landed'), style: tt.headlineMedium?.copyWith(fontSize: 30), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(t('Everything you need, from the day you land.'),
                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, color: AppColors.mute)),
                  const SizedBox(height: 18),
                  Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 6, children: [
                    for (final l in appLanguages)
                      ChoiceChip(
                        key: ValueKey('lang-${l.code}'),
                        label: Text(l.native),
                        selected: currentLanguage == l.code,
                        onSelected: (_) {
                          setCurrentLanguage(l.code);
                          widget.store.setLanguage(l.code);
                        },
                      ),
                  ]),
                  const SizedBox(height: 22),
                  _Promise(Icons.lock_rounded, t('Private by design'), t('Everything you enter is encrypted and stays on this phone.')),
                  _Promise(Icons.money_off_rounded, t('Free, no ads'), t('No adverts, no trackers, no selling your data. Ever.')),
                  _Promise(Icons.public_rounded, t('Wherever you study'), t('Rules, checklists and emergency numbers for your study country.')),
                  _Promise(Icons.verified_rounded, t('Official sources'), t('Guides link to government and trusted sources.')),
                ]),
                // ------------------------------------------------ study country
                _page([
                  Text(t('Where are you studying?'), style: tt.headlineMedium),
                  const SizedBox(height: 6),
                  Text(t('Landed sets work rules, money, guides and emergency numbers for this country. You can change it later.'),
                      style: const TextStyle(color: AppColors.mute)),
                  const SizedBox(height: 16),
                  for (final c in countryPacks)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: country == c.code ? AppColors.coralSoft : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          key: ValueKey('country-${c.code}'),
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _pickCountry(c.code),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: country == c.code ? AppColors.coral : AppColors.line, width: country == c.code ? 2 : 1.5),
                            ),
                            child: Row(children: [
                              Text(c.flag, style: const TextStyle(fontSize: 26)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(c.fullySupported ? c.name : t('Another country'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                  Text(c.fullySupported ? '${c.currencyCode} · ${c.studentVisaName}' : t('General tools, no country-specific rules yet'),
                                      style: smallText),
                                ]),
                              ),
                              if (country == c.code) const Icon(Icons.check_circle_rounded, color: AppColors.coral),
                            ]),
                          ),
                        ),
                      ),
                    ),
                ]),
                // ------------------------------------------------ about you
                _page([
                  Text(t('About you'), style: tt.headlineMedium),
                  const SizedBox(height: 6),
                  Text(t('All optional. It personalises the app and never leaves your phone.'), style: const TextStyle(color: AppColors.mute)),
                  const SizedBox(height: 20),
                  TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: t('First name'))),
                  const SizedBox(height: 12),
                  TextField(controller: uni, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: t('University'))),
                  const SizedBox(height: 12),
                  TextField(
                    controller: city,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: t('City'), hintText: p.cities.isEmpty ? null : t('e.g. {c}', {'c': p.cities.first})),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: home, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: t('Home country'), hintText: t('e.g. India'))),
                ]),
                // ------------------------------------------------ visa
                _page([
                  Text(t('Your visa'), style: tt.headlineMedium),
                  const SizedBox(height: 6),
                  Text(t('Used for your work limit and visa countdown.'), style: const TextStyle(color: AppColors.mute)),
                  const SizedBox(height: 20),
                  if (r.belowDegreeLimit != null) ...[
                    Text(t('Course level'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(value: true, label: Text(t('Degree or above')), icon: const Icon(Icons.school_rounded)),
                        ButtonSegment(value: false, label: Text(t('Below degree'))),
                      ],
                      selected: {degree},
                      onSelectionChanged: (v) => setState(() => degree = v.first),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Banner2('$limitText ${r.summary}', bg: AppColors.blueSoft, fg: AppColors.blue, icon: Icons.gavel_rounded),
                  Text(t('Visa expiry date'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final d = await pickDate(context, initial: visa ?? DateTime.now().add(const Duration(days: 365)), first: DateTime(2020));
                      if (d != null) setState(() => visa = d);
                    },
                    icon: const Icon(Icons.event_rounded),
                    label: Text(visa == null ? t('Add date (optional)') : fmtDate(visa!, year: true)),
                  ),
                ]),
                // ------------------------------------------------ budget
                _page([
                  Text(t('Your budget'), style: tt.headlineMedium),
                  const SizedBox(height: 6),
                  Text(t('Roughly how much do you plan to spend each month, including rent?'), style: const TextStyle(color: AppColors.mute)),
                  const SizedBox(height: 20),
                  if (!p.fullySupported) ...[
                    TextField(
                      controller: currency,
                      maxLength: 4,
                      decoration: InputDecoration(labelText: t('Currency symbol'), hintText: t('e.g. ¥, ₩, R')),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextField(
                    controller: budget,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: bigNumber(size: 30),
                    onChanged: (_) => budgetEdited = true,
                    decoration: InputDecoration(
                      prefixText: '${p.fullySupported ? p.currencySymbol : (currency.text.trim().isEmpty ? '' : currency.text.trim())} ',
                      suffixText: t('a month'),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Banner2(
                    t('Tip: turn on App lock in Settings to protect Landed with your fingerprint, face or PIN.'),
                    bg: AppColors.mintSoft,
                    fg: AppColors.mint,
                    icon: Icons.fingerprint_rounded,
                  ),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(children: [
              if (page > 0)
                TextButton(
                  onPressed: () => _pages.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic),
                  child: Text(t('Back')),
                ),
              const Spacer(),
              FilledButton(
                key: const ValueKey('onboarding-next'),
                onPressed: _next,
                child: Text(page == 0 ? t('Get started') : page == pages - 1 ? t('Start using Landed') : t('Next')),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _page(List<Widget> children) => ListView(padding: const EdgeInsets.fromLTRB(22, 22, 22, 22), children: children);
}

class _Promise extends StatelessWidget {
  const _Promise(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(children: [
          IconBubble(icon, bg: AppColors.coralSoft, fg: AppColors.coral, size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              Text(body, style: smallText.copyWith(fontSize: 14)),
            ]),
          ),
        ]),
      );
}
