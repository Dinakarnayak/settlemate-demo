import 'dart:io';

import 'package:flutter/material.dart';

import '../data/store.dart';
import '../services/places.dart';
import '../theme.dart';
import '../widgets.dart';

class FoodNearScreen extends StatefulWidget {
  const FoodNearScreen({super.key, required this.store});
  final AppStore store;

  @override
  State<FoodNearScreen> createState() => _FoodNearScreenState();
}

class _FoodNearScreenState extends State<FoodNearScreen> {
  List<Place>? places;
  String? error;
  bool loading = false;
  int radius = 1500;
  String kind = 'All';
  String? cuisine;
  bool halalOnly = false;
  bool vegOnly = false;
  bool newOnly = false;
  double? lat;
  double? lon;

  String? get homeCuisine => countryCuisine[widget.store.profile.homeCountry.trim().toLowerCase()];

  Future<void> _search() async {
    setState(() {
      loading = true;
      error = null;
    });
    if (lat == null) {
      final loc = await PlacesService.approximateLocation();
      if (loc.error != null) {
        setState(() {
          loading = false;
          error = loc.error;
        });
        return;
      }
      lat = loc.lat;
      lon = loc.lon;
    }
    try {
      final r = await PlacesService.nearby(lat!, lon!, radiusM: radius);
      setState(() {
        places = r;
        loading = false;
      });
    } on HttpException catch (e) {
      setState(() {
        loading = false;
        error = e.message;
      });
    } on Object catch (e) {
      setState(() {
        loading = false;
        error = 'Something went wrong: $e';
      });
    }
  }

  List<Place> get filtered {
    final all = places ?? const <Place>[];
    return all.where((p) {
      if (kind != 'All' && p.kind != kind) return false;
      if (cuisine != null && !p.cuisine.contains(cuisine)) return false;
      if (halalOnly && !p.halal) return false;
      if (vegOnly && !(p.vegetarian || p.vegan)) return false;
      if (newOnly && !p.newOnMap) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = filtered;
    final cuisines = <String, int>{};
    for (final p in places ?? const <Place>[]) {
      for (final c in p.cuisine) {
        cuisines[c] = (cuisines[c] ?? 0) + 1;
      }
    }
    final topCuisines = (cuisines.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).take(10).map((e) => e.key).toList();
    if (homeCuisine != null && cuisines.containsKey(homeCuisine) && !topCuisines.contains(homeCuisine)) {
      topCuisines.insert(0, homeCuisine!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Food near me')),
      body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 40), children: [
        if (places == null && !loading) ...[
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: AppColors.coralSoft, borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.ramen_dining_rounded, color: AppColors.coral, size: 50),
            ),
          ),
          const SizedBox(height: 16),
          Text('Restaurants, cafés, takeaways and grocers around you',
              style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          const Banner2(
            'Your location is used once, rounded to about 1 km, to search OpenStreetMap. It isn’t stored or shared with anyone else.',
            bg: AppColors.mintSoft,
            fg: AppColors.mint,
            icon: Icons.privacy_tip_rounded,
          ),
          Wrap(spacing: 8, alignment: WrapAlignment.center, children: [
            for (final r in const [800, 1500, 3000])
              ChoiceChip(label: Text('${r / 1000} km'), selected: radius == r, onSelected: (_) => setState(() => radius = r)),
          ]),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _search,
            icon: const Icon(Icons.my_location_rounded),
            label: const Text('Find food near me'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => openUrl(mapsUrl('restaurants near ${widget.store.profile.cityOrUk}')),
            icon: const Icon(Icons.map_rounded),
            label: const Text('Search in maps instead'),
          ),
        ],
        if (loading)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Column(children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Finding places near you…', style: smallText),
            ]),
          ),
        if (error != null) ...[
          Banner2(error!, bg: AppColors.coralSoft, fg: AppColors.coral, icon: Icons.error_rounded),
          OutlinedButton(onPressed: _search, child: const Text('Try again')),
        ],
        if (places != null && !loading) ...[
          Row(children: [
            Expanded(child: Text('${list.length} of ${places!.length} places within ${radius / 1000} km', style: smallText.copyWith(fontWeight: FontWeight.w700))),
            PopupMenuButton<int>(
              tooltip: 'Distance',
              initialValue: radius,
              onSelected: (r) {
                setState(() => radius = r);
                _search();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 800, child: Text('Within 0.8 km')),
                PopupMenuItem(value: 1500, child: Text('Within 1.5 km')),
                PopupMenuItem(value: 3000, child: Text('Within 3 km')),
              ],
              child: const Pill('Distance', bg: AppColors.blueSoft, fg: AppColors.blue, icon: Icons.tune_rounded),
            ),
          ]),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final k in const ['All', 'Restaurant', 'Café', 'Takeaway', 'Grocery'])
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(label: Text(k), selected: kind == k, onSelected: (_) => setState(() => kind = k)),
                ),
            ]),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(label: const Text('New on the map'), selected: newOnly, onSelected: (v) => setState(() => newOnly = v)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(label: const Text('Halal'), selected: halalOnly, onSelected: (v) => setState(() => halalOnly = v)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(label: const Text('Vegetarian'), selected: vegOnly, onSelected: (v) => setState(() => vegOnly = v)),
              ),
              for (final c in topCuisines)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(c.replaceAll('_', ' ')),
                    selected: cuisine == c,
                    onSelected: (v) => setState(() => cuisine = v ? c : null),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 10),
          if (list.isEmpty)
            const SoftCard(child: EmptyState(Icons.search_off_rounded, 'Nothing matches these filters. Try a bigger distance or fewer filters.'))
          else
            for (final p in list.take(120)) _PlaceCard(place: p, onTap: () => _details(context, p)),
          const SizedBox(height: 6),
          const Text('Map data © OpenStreetMap contributors. Menus and prices aren’t in OpenStreetMap; open a place to see them on maps.',
              style: smallText, textAlign: TextAlign.center),
          const LinkText('OpenStreetMap copyright', 'https://www.openstreetmap.org/copyright'),
        ],
      ]),
    );
  }

  void _details(BuildContext context, Place p) {
    showSheet(context, (c) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text([p.kind, if (p.cuisine.isNotEmpty) p.cuisineText].join(' · '), style: smallText),
            const SizedBox(height: 12),
            _Badges(place: p),
            const SizedBox(height: 8),
            _info(Icons.directions_walk_rounded, '${p.distanceText} · ${p.walkText}'),
            if (p.address != null) _info(Icons.place_rounded, p.address!),
            _info(Icons.schedule_rounded, p.openingHours ?? 'Opening hours not listed'),
            if (p.phone != null) _info(Icons.call_rounded, p.phone!),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => openUrl(mapsUrl('${p.name} ${p.address ?? widget.store.profile.city}')),
                icon: const Icon(Icons.restaurant_menu_rounded),
                label: const Text('Menu, prices & reviews'),
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => openUrl('https://www.google.com/maps/dir/?api=1&destination=${p.lat},${p.lon}&travelmode=walking'),
                  icon: const Icon(Icons.directions_rounded),
                  label: const Text('Directions'),
                ),
              ),
              if (p.website != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => openUrl(p.website!.startsWith('http') ? p.website! : 'https://${p.website!}'),
                    icon: const Icon(Icons.language_rounded),
                    label: const Text('Website'),
                  ),
                ),
              ],
              if (p.phone != null) ...[
                const SizedBox(width: 8),
                IconButton.outlined(
                  tooltip: 'Call',
                  onPressed: () => openUrl('tel:${p.phone!.replaceAll(' ', '')}'),
                  icon: const Icon(Icons.call_rounded),
                ),
              ],
            ]),
          ]),
        ));
  }

  Widget _info(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 18, color: AppColors.mute),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(height: 1.3))),
        ]),
      );
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.onTap});
  final Place place;
  final VoidCallback onTap;

  static const _icons = {
    'Restaurant': (Icons.restaurant_rounded, AppColors.coralSoft, AppColors.coral),
    'Café': (Icons.local_cafe_rounded, AppColors.sunSoft, AppColors.sunText),
    'Takeaway': (Icons.takeout_dining_rounded, AppColors.pinkSoft, AppColors.pink),
    'Grocery': (Icons.shopping_basket_rounded, AppColors.mintSoft, AppColors.mint),
  };

  @override
  Widget build(BuildContext context) {
    final st = _icons[place.kind] ?? _icons['Restaurant']!;
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        IconBubble(st.$1, bg: st.$2, fg: st.$3, size: 46),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(place.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text([place.kind, if (place.cuisine.isNotEmpty) place.cuisineText].join(' · '),
                style: smallText, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            _Badges(place: place),
          ]),
        ),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(place.distanceText, style: bigNumber(size: 16)),
          const Icon(Icons.chevron_right_rounded, color: AppColors.mute),
        ]),
      ]),
    );
  }
}

class _Badges extends StatelessWidget {
  const _Badges({required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    final p = place;
    final items = [
      if (p.newOnMap) const Pill('New on map', bg: AppColors.coral, fg: Colors.white),
      if (p.halal) const Pill('Halal', bg: AppColors.mintSoft, fg: AppColors.mint),
      if (p.vegan) const Pill('Vegan', bg: AppColors.mintSoft, fg: AppColors.mint) else if (p.vegetarian) const Pill('Veggie options', bg: AppColors.mintSoft, fg: AppColors.mint),
      if (p.takeaway && p.kind != 'Takeaway') const Pill('Takeaway', bg: AppColors.pinkSoft, fg: AppColors.pink),
      if (p.openingHours != null) const Pill('Hours listed', bg: AppColors.blueSoft, fg: AppColors.blue),
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 6, runSpacing: 6, children: items);
  }
}
