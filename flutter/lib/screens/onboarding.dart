import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.store});
  final AppStore store;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pages = PageController();
  int page = 0;
  final name = TextEditingController();
  final uni = TextEditingController();
  final city = TextEditingController();
  final home = TextEditingController();
  final budget = TextEditingController(text: '800');
  bool degree = true;
  DateTime? visa;

  @override
  void dispose() {
    for (final c in [name, uni, city, home, budget]) {
      c.dispose();
    }
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (page < 3) {
      _pages.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    } else {
      widget.store.completeOnboarding(Profile(
        name: name.text.trim(),
        university: uni.text.trim(),
        city: city.text.trim(),
        homeCountry: home.text.trim(),
        degreeLevel: degree,
        weeklyLimit: degree ? 20 : 10,
        monthlyBudget: parseAmount(budget.text) ?? 800,
        visaExpiry: visa,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(children: [
              for (var i = 0; i < 4; i++)
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
                _page([
                  const SizedBox(height: 30),
                  Center(
                    child: Transform.rotate(
                      angle: -0.12,
                      child: Container(
                        width: 96,
                        height: 96,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(30)),
                        child: const Icon(Icons.flight_land_rounded, color: Colors.white, size: 52),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Welcome to Landed', style: tt.headlineMedium?.copyWith(fontSize: 32), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Everything you need, from the day you land.',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: AppColors.mute)),
                  const SizedBox(height: 28),
                  const _Promise(Icons.lock_rounded, 'Private by design', 'Everything you enter is encrypted and stays on this phone.'),
                  const _Promise(Icons.money_off_rounded, 'Free, no ads', 'No adverts, no trackers, no selling your data. Ever.'),
                  const _Promise(Icons.wifi_off_rounded, 'Works offline', 'Checklists, trackers, guides and the helper all work without internet.'),
                  const _Promise(Icons.verified_rounded, 'Official sources', 'Guides link to GOV.UK, the NHS and trusted charities.'),
                ]),
                _page([
                  Text('About you', style: tt.headlineMedium),
                  const SizedBox(height: 6),
                  const Text('All optional. It personalises the app and never leaves your phone.', style: TextStyle(color: AppColors.mute)),
                  const SizedBox(height: 20),
                  TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'First name')),
                  const SizedBox(height: 12),
                  TextField(controller: uni, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'University')),
                  const SizedBox(height: 12),
                  TextField(controller: city, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'UK city', hintText: 'e.g. Leicester')),
                  const SizedBox(height: 12),
                  TextField(controller: home, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Home country', hintText: 'e.g. India')),
                ]),
                _page([
                  Text('Your visa', style: tt.headlineMedium),
                  const SizedBox(height: 6),
                  const Text('Used for your work-hour limit and visa countdown.', style: TextStyle(color: AppColors.mute)),
                  const SizedBox(height: 20),
                  const Text('Course level', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('Degree or above'), icon: Icon(Icons.school_rounded)),
                      ButtonSegment(value: false, label: Text('Below degree')),
                    ],
                    selected: {degree},
                    onSelectionChanged: (v) => setState(() => degree = v.first),
                  ),
                  const SizedBox(height: 8),
                  Text('Term-time work limit: ${degree ? 20 : 10} hours a week. Your eVisa shows your exact conditions.', style: smallText),
                  const SizedBox(height: 22),
                  const Text('Visa expiry date', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final d = await pickDate(context, initial: visa ?? DateTime.now().add(const Duration(days: 365)), first: DateTime(2020));
                      if (d != null) setState(() => visa = d);
                    },
                    icon: const Icon(Icons.event_rounded),
                    label: Text(visa == null ? 'Add date (optional)' : fmtDate(visa!, year: true)),
                  ),
                  const SizedBox(height: 8),
                  const LinkText('Find it in your UKVI account', 'https://www.gov.uk/view-prove-immigration-status'),
                ]),
                _page([
                  Text('Your budget', style: tt.headlineMedium),
                  const SizedBox(height: 6),
                  const Text('Roughly how much do you plan to spend each month, including rent?', style: TextStyle(color: AppColors.mute)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: budget,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: bigNumber(size: 30),
                    decoration: const InputDecoration(prefixText: '£ ', suffixText: 'a month'),
                  ),
                  const SizedBox(height: 22),
                  const Banner2(
                    'Tip: turn on App lock in Settings to protect Landed with your fingerprint, face or PIN.',
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
                  child: const Text('Back'),
                ),
              const Spacer(),
              FilledButton(
                key: const ValueKey('onboarding-next'),
                onPressed: _next,
                child: Text(page == 0 ? 'Get started' : page == 3 ? 'Start using Landed' : 'Next'),
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
