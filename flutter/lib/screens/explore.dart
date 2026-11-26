import 'package:flutter/material.dart';

import '../content/guides.dart';
import '../content/referrals.dart';
import '../data/models.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'deadlines.dart';
import 'food_near.dart';
import 'guide.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.store});
  final AppStore store;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _search = TextEditingController();
  String q = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.store;
    final query = q.trim().toLowerCase();
    final shown = query.isEmpty ? guides : guides.where((g) => g.searchText.contains(query)).toList();
    final saved = guides.where((g) => s.isSaved(g.id)).toList();

    return ListView(padding: pagePad, children: [
      const ScreenTitle('Explore', 'Guides, tools and help for life in the UK'),
      TextField(
        controller: _search,
        onChanged: (v) => setState(() => q = v),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          hintText: 'Search guides: deposit, GP, tax…',
          suffixIcon: q.isEmpty
              ? null
              : IconButton(
                  onPressed: () => setState(() {
                    _search.clear();
                    q = '';
                  }),
                  icon: const Icon(Icons.close_rounded)),
        ),
      ),
      const SizedBox(height: 14),
      if (query.isEmpty) ...[
        const SectionHeader('Your tools'),
        Row(children: [
          Expanded(
            child: _ToolCard(
              icon: Icons.event_note_rounded,
              title: 'Deadlines',
              subtitle: '${s.upcoming.length} coming up',
              bg: AppColors.coralSoft,
              fg: AppColors.coral,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DeadlinesScreen(store: s))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ToolCard(
              icon: Icons.sticky_note_2_rounded,
              title: 'Private notes',
              subtitle: '${s.notes.length} saved',
              bg: AppColors.blueSoft,
              fg: AppColors.blue,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotesScreen(store: s))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ToolCard(
              icon: Icons.sos_rounded,
              title: 'Emergency',
              subtitle: '999 · 111 · 101',
              bg: AppColors.pinkSoft,
              fg: AppColors.pink,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EmergencyScreen(store: s))),
            ),
          ),
        ]),
        const SizedBox(height: 14),
      ],
      SectionHeader(query.isEmpty ? 'Guides' : '${shown.length} guide${shown.length == 1 ? '' : 's'} found'),
      if (shown.isEmpty)
        const SoftCard(child: EmptyState(Icons.search_off_rounded, 'No guide matches. Try the Ask button for quick answers.'))
      else
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: .95,
          children: [for (final g in shown) GuideTile(guide: g, onTap: () => openGuide(context, s, g.id))],
        ),
      if (query.isEmpty && saved.isNotEmpty) ...[
        const SizedBox(height: 14),
        const SectionHeader('Saved'),
        SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(children: [
            for (final g in saved)
              ListTile(
                leading: Icon(styleForGuide(g.id).$1, color: styleForGuide(g.id).$3),
                title: Text(g.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => openGuide(context, s, g.id),
              ),
          ]),
        ),
      ],
      if (query.isEmpty) ...[
        const SizedBox(height: 14),
        const SectionHeader('Nearby'),
        SoftCard(
          color: AppColors.coral,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodNearScreen(store: s))),
          child: Row(children: [
            const IconBubble(Icons.ramen_dining_rounded, bg: Colors.white24, fg: Colors.white, size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Food near me', style: bigNumber(size: 20, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('Restaurants, cafés and grocers by distance, cuisine, halal and veggie. New places flagged.',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, height: 1.3)),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ]),
        ),
        _NearbyCard(profile: s.profile),
        const SectionHeader('Set up: banks & SIMs'),
        const _ProvidersCard(),
      ],
    ]);
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.icon, required this.title, required this.subtitle, required this.bg, required this.fg, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, color: fg, size: 26),
              const SizedBox(height: 14),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
              Text(subtitle, style: smallText.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ),
      );
}

class _NearbyCard extends StatelessWidget {
  const _NearbyCard({required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final city = profile.cityOrUk;
    final home = profile.homeCountry.trim();
    final items = <(IconData, String, String)>[
      if (home.isNotEmpty) (Icons.storefront_rounded, '$home groceries', '$home grocery store near $city'),
      (Icons.shopping_basket_rounded, 'World food shops', 'international grocery store near $city'),
      (Icons.local_pharmacy_rounded, 'Pharmacies', 'pharmacy near $city'),
      (Icons.local_hospital_rounded, 'GP surgeries', 'GP surgery near $city'),
      (Icons.account_balance_rounded, 'Bank branches', 'bank branch near $city'),
      (Icons.fitness_center_rounded, 'Cheap gyms', 'gym near $city'),
      (Icons.place_rounded, 'Places of worship', 'places of worship near $city'),
      (Icons.local_library_rounded, 'Libraries', 'public library near $city'),
    ];
    return SoftCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Opens your maps app. Landed never sees your location.', style: smallText.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final i in items)
            ActionChip(avatar: Icon(i.$1, size: 18, color: AppColors.coral), label: Text(i.$2), onPressed: () => openUrl(mapsUrl(i.$3))),
        ]),
      ]),
    );
  }
}

class _ProvidersCard extends StatelessWidget {
  const _ProvidersCard();

  @override
  Widget build(BuildContext context) {
    final anyReferral = providers.any((p) => p.isReferral);
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final kind in ['Bank', 'SIM']) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
            child: Text(kind == 'Bank' ? 'Banks' : 'SIM cards', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.mute)),
          ),
          for (final p in providers.where((p) => p.kind == kind))
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: IconBubble(kind == 'Bank' ? Icons.account_balance_rounded : Icons.sim_card_rounded,
                  bg: kind == 'Bank' ? AppColors.mintSoft : AppColors.blueSoft, fg: kind == 'Bank' ? AppColors.mint : AppColors.blue, size: 40),
              title: Row(children: [
                Flexible(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                if (p.isReferral) ...[
                  const SizedBox(width: 6),
                  const Pill('Referral', bg: AppColors.sunSoft, fg: AppColors.sunText),
                ],
              ]),
              subtitle: Text(p.blurb),
              trailing: const Icon(Icons.open_in_new_rounded, size: 18),
              onTap: () => openUrl(p.url),
            ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: Text(
            '${anyReferral ? '$referralDisclosure ' : ''}These are examples, not recommendations. Compare plans and check any provider is FCA-regulated (banks) before signing up.',
            style: smallText.copyWith(fontSize: 12),
          ),
        ),
      ]),
    );
  }
}

// ------------------------------------------------------------------ Emergency
class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key, required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final calls = <(String, String, String, Color, Color)>[
      ('999', 'Emergency', 'Police, ambulance, fire', AppColors.coral, Colors.white),
      ('111', 'NHS 111', 'Urgent medical advice', AppColors.blue, Colors.white),
      ('101', 'Police', 'Non-emergency', AppColors.ink, Colors.white),
      ('116123', 'Samaritans', 'Free, 24/7 support', AppColors.mint, Colors.white),
      ('03001232040', 'Report Fraud', 'Scams and fraud', AppColors.sun, AppColors.ink),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency')),
      body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 40), children: [
        const Banner2('In danger right now? Call 999.', bg: AppColors.coralSoft, fg: AppColors.coral, icon: Icons.warning_rounded),
        for (final c in calls)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: c.$4,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => openUrl('tel:${c.$1}'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Icon(Icons.call_rounded, color: c.$5),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(c.$2, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: c.$5)),
                        Text(c.$3, style: TextStyle(color: c.$5.withValues(alpha: .8))),
                      ]),
                    ),
                    Text(c.$1 == '03001232040' ? '0300 123 2040' : c.$1 == '116123' ? '116 123' : c.$1,
                        style: bigNumber(size: 20, color: c.$5)),
                  ]),
                ),
              ),
            ),
          ),
        const SizedBox(height: 6),
        SoftCard(
          onTap: () => openGuide(context, store, 'emergency'),
          child: const Row(children: [
            Icon(Icons.menu_book_rounded, color: AppColors.coral),
            SizedBox(width: 12),
            Expanded(child: Text('Lost passport, stolen phone, victim of crime: what to do', style: TextStyle(fontWeight: FontWeight.w700))),
            Icon(Icons.chevron_right_rounded),
          ]),
        ),
        const LinkText('Find your embassy or high commission', 'https://www.gov.uk/government/publications/foreign-embassies-in-the-uk'),
        const LinkText('Register for emergency SMS (if you can’t speak)', 'https://www.emergencysms.org.uk/'),
      ]),
    );
  }
}

// ------------------------------------------------------------------ Notes
class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key, required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Private notes')),
        floatingActionButton: FloatingActionButton(
          tooltip: 'New note',
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          onPressed: () => _edit(context, null),
          child: const Icon(Icons.add_rounded),
        ),
        body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 100), children: [
          const Banner2(
            'Notes are encrypted on this phone. Don’t store passwords, bank or passport numbers here; use your bank app or a password manager for those.',
            bg: AppColors.blueSoft,
            fg: AppColors.blue,
            icon: Icons.lock_rounded,
          ),
          if (store.notes.isEmpty)
            const SoftCard(child: EmptyState(Icons.sticky_note_2_outlined, 'Keep things like your landlord’s contact, course codes or questions for your adviser.')),
          for (final n in store.notes)
            SoftCard(
              onTap: () => _edit(context, n),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.title.isEmpty ? 'Untitled' : n.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                if (n.body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(n.body, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(height: 1.35)),
                ],
                const SizedBox(height: 6),
                Text('Edited ${fmtDate(n.updated, year: true)}', style: smallText.copyWith(fontSize: 12)),
              ]),
            ),
        ]),
      ),
    );
  }

  void _edit(BuildContext context, Note? existing) {
    final title = TextEditingController(text: existing?.title ?? '');
    final body = TextEditingController(text: existing?.body ?? '');
    showSheet(context, (c) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: title,
              autofocus: existing == null,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(c).textTheme.titleMedium,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: body,
              minLines: 5,
              maxLines: 12,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Write anything…'),
            ),
            const SizedBox(height: 12),
            Row(children: [
              if (existing != null)
                TextButton.icon(
                  onPressed: () {
                    store.removeNote(existing);
                    Navigator.pop(c);
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColors.coral),
                  icon: const Icon(Icons.delete_rounded),
                  label: const Text('Delete'),
                ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  if (title.text.trim().isEmpty && body.text.trim().isEmpty) {
                    Navigator.pop(c);
                    return;
                  }
                  final n = existing ?? Note(id: newId(), title: '');
                  n.title = title.text.trim();
                  n.body = body.text.trim();
                  store.saveNote(n);
                  Navigator.pop(c);
                },
                child: const Text('Save'),
              ),
            ]),
          ]),
        ));
  }
}
