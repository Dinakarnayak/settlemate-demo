import 'package:flutter/material.dart';

import '../content/referrals.dart';
import '../data/models.dart';
import '../data/store.dart';
import '../l10n/l10n.dart';
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
    final pack = s.pack;
    final guides = pack.guides;
    final query = q.trim().toLowerCase();
    final shown = query.isEmpty ? guides : guides.where((g) => g.searchText.contains(query)).toList();
    final saved = guides.where((g) => s.isSaved(g.id)).toList();

    return ListView(padding: pagePad, children: [
      ScreenTitle(t('Explore'), t('Guides, tools and help for life in {c}', {'c': pack.fullySupported ? pack.name : t('your new country')})),
      if (!pack.fullySupported)
        Banner2(t('Landed doesn’t have checked rules for your country yet, so guides here are general. Always confirm with your university.')),
      TextField(
        controller: _search,
        onChanged: (v) => setState(() => q = v),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          hintText: t('Search guides: deposit, doctor, tax…'),
          suffixIcon: q.isEmpty
              ? null
              : IconButton(
                  tooltip: t('Clear'),
                  onPressed: () => setState(() {
                    _search.clear();
                    q = '';
                  }),
                  icon: const Icon(Icons.close_rounded)),
        ),
      ),
      const SizedBox(height: 14),
      if (query.isEmpty) ...[
        SectionHeader(t('Your tools')),
        Row(children: [
          Expanded(
            child: _ToolCard(
              icon: Icons.event_note_rounded,
              title: t('Deadlines'),
              subtitle: t('{n} coming up', {'n': '${s.upcoming.length}'}),
              bg: AppColors.coralSoft,
              fg: AppColors.coral,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DeadlinesScreen(store: s))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ToolCard(
              icon: Icons.sticky_note_2_rounded,
              title: t('Private notes'),
              subtitle: t('{n} saved', {'n': '${s.notes.length}'}),
              bg: AppColors.blueSoft,
              fg: AppColors.blue,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotesScreen(store: s))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ToolCard(
              icon: Icons.sos_rounded,
              title: t('Emergency'),
              subtitle: pack.emergency.map((e) => e.number).where((n) => n.length <= 4).take(3).join(' · '),
              bg: AppColors.pinkSoft,
              fg: AppColors.pink,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EmergencyScreen(store: s))),
            ),
          ),
        ]),
        const SizedBox(height: 14),
      ],
      SectionHeader(query.isEmpty ? t('Guides') : t('{n} found', {'n': '${shown.length}'})),
      if (shown.isEmpty)
        SoftCard(child: EmptyState(Icons.search_off_rounded, t('No guide matches. Try the Ask button for quick answers.')))
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
        SectionHeader(t('Saved')),
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
        SectionHeader(t('Nearby')),
        SoftCard(
          color: AppColors.coral,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodNearScreen(store: s))),
          child: Row(children: [
            const IconBubble(Icons.ramen_dining_rounded, bg: Colors.white24, fg: Colors.white, size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t('Food near me'), style: bigNumber(size: 20, color: Colors.white)),
                const SizedBox(height: 4),
                Text(t('Restaurants, cafés and grocers by distance, cuisine, halal and veggie. New places flagged.'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, height: 1.3)),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ]),
        ),
        _NearbyCard(profile: s.profile, place: s.placeName),
        if (pack.providers.isNotEmpty) ...[
          SectionHeader(t('Set up: banks & SIMs')),
          _ProvidersCard(list: pack.providers),
        ],
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(subtitle, style: smallText.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ),
      );
}

class _NearbyCard extends StatelessWidget {
  const _NearbyCard({required this.profile, required this.place});
  final Profile profile;
  final String place;

  @override
  Widget build(BuildContext context) {
    final near = place.isEmpty ? 'near me' : 'near $place';
    final home = profile.homeCountry.trim();
    final items = <(IconData, String, String)>[
      if (home.isNotEmpty) (Icons.storefront_rounded, t('{c} groceries', {'c': home}), '$home grocery store $near'),
      (Icons.shopping_basket_rounded, t('World food shops'), 'international grocery store $near'),
      (Icons.local_pharmacy_rounded, t('Pharmacies'), 'pharmacy $near'),
      (Icons.local_hospital_rounded, t('Doctors'), 'doctor clinic $near'),
      (Icons.account_balance_rounded, t('Banks'), 'bank $near'),
      (Icons.fitness_center_rounded, t('Gyms'), 'gym $near'),
      (Icons.place_rounded, t('Places of worship'), 'places of worship $near'),
      (Icons.local_library_rounded, t('Libraries'), 'public library $near'),
    ];
    return SoftCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t('Opens your maps app. Landed never sees your location.'), style: smallText.copyWith(fontWeight: FontWeight.w600)),
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
  const _ProvidersCard({required this.list});
  final List<Provider> list;

  @override
  Widget build(BuildContext context) {
    final anyReferral = list.any((p) => p.isReferral);
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final kind in ['Bank', 'SIM']) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
            child: Text(kind == 'Bank' ? t('Banks') : t('SIM cards'), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.mute)),
          ),
          for (final p in list.where((p) => p.kind == kind))
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: IconBubble(kind == 'Bank' ? Icons.account_balance_rounded : Icons.sim_card_rounded,
                  bg: kind == 'Bank' ? AppColors.mintSoft : AppColors.blueSoft, fg: kind == 'Bank' ? AppColors.mint : AppColors.blue, size: 40),
              title: Row(children: [
                Flexible(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                if (p.isReferral) ...[
                  const SizedBox(width: 6),
                  Pill(t('Referral'), bg: AppColors.sunSoft, fg: AppColors.sunText),
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
            '${anyReferral ? '$referralDisclosure ' : ''}${t('These are examples, not recommendations. Compare plans and check any bank is properly regulated before signing up.')}',
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

  static const _colours = [
    (AppColors.coral, Colors.white),
    (AppColors.blue, Colors.white),
    (AppColors.ink, Colors.white),
    (AppColors.mint, Colors.white),
    (AppColors.sun, AppColors.ink),
  ];

  @override
  Widget build(BuildContext context) {
    final pack = store.pack;
    final home = store.profile.homeCountry.trim();
    return Scaffold(
      appBar: AppBar(title: Text('${t('Emergency')} ${pack.flag}')),
      body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 40), children: [
        Banner2(t('In danger right now? Call {n}.', {'n': pack.mainEmergency.number}), bg: AppColors.coralSoft, fg: AppColors.coral, icon: Icons.warning_rounded),
        if (!pack.fullySupported)
          Banner2(t('112 works in many countries, but not all. Check your local emergency number and save it in Private notes.')),
        for (var i = 0; i < pack.emergency.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: _colours[i % _colours.length].$1,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => openUrl('tel:${pack.emergency[i].number}'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Icon(Icons.call_rounded, color: _colours[i % _colours.length].$2),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(pack.emergency[i].title,
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _colours[i % _colours.length].$2)),
                        Text(pack.emergency[i].subtitle, style: TextStyle(color: _colours[i % _colours.length].$2.withValues(alpha: .8))),
                      ]),
                    ),
                    Text(pack.emergency[i].number, style: bigNumber(size: 18, color: _colours[i % _colours.length].$2)),
                  ]),
                ),
              ),
            ),
          ),
        const SizedBox(height: 6),
        SoftCard(
          onTap: () => openGuide(context, store, 'emergency'),
          child: Row(children: [
            const Icon(Icons.menu_book_rounded, color: AppColors.coral),
            const SizedBox(width: 12),
            Expanded(child: Text(t('Lost passport, stolen phone, crime: what to do'), style: const TextStyle(fontWeight: FontWeight.w700))),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
        LinkText(t('Find your embassy or consulate'),
            mapsUrl('${home.isEmpty ? '' : '$home '}embassy ${pack.fullySupported ? pack.name : ''}'.trim())),
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
        appBar: AppBar(title: Text(t('Private notes'))),
        floatingActionButton: FloatingActionButton(
          tooltip: t('New note'),
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          onPressed: () => _edit(context, null),
          child: const Icon(Icons.add_rounded),
        ),
        body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 100), children: [
          Banner2(
            t('Notes are encrypted on this phone. Don’t store passwords, bank or passport numbers here; use your bank app or a password manager for those.'),
            bg: AppColors.blueSoft,
            fg: AppColors.blue,
            icon: Icons.lock_rounded,
          ),
          if (store.notes.isEmpty)
            SoftCard(child: EmptyState(Icons.sticky_note_2_outlined, t('Keep things like your landlord’s contact, course codes or questions for your adviser.'))),
          for (final n in store.notes)
            SoftCard(
              onTap: () => _edit(context, n),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.title.isEmpty ? t('Untitled') : n.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                if (n.body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(n.body, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(height: 1.35)),
                ],
                const SizedBox(height: 6),
                Text(t('Edited {d}', {'d': fmtDate(n.updated, year: true)}), style: smallText.copyWith(fontSize: 12)),
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
              decoration: InputDecoration(hintText: t('Title')),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: body,
              minLines: 5,
              maxLines: 12,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: t('Write anything…')),
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
                  label: Text(t('Delete')),
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
                child: Text(t('Save')),
              ),
            ]),
          ]),
        ));
  }
}
