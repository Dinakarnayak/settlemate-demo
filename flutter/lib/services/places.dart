import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

/// Nearby food from OpenStreetMap (free, no account, no API key).
///
/// Privacy: the location is requested only when the student taps "Find food
/// near me", is rounded to about 1 km before it leaves the phone, and is never
/// stored. OpenStreetMap has no menu prices; each place links to its maps
/// listing for menus, prices and reviews.
class Place {
  Place({
    required this.name,
    required this.kind,
    required this.lat,
    required this.lon,
    required this.distanceKm,
    this.cuisine = const [],
    this.openingHours,
    this.website,
    this.phone,
    this.address,
    this.halal = false,
    this.vegetarian = false,
    this.vegan = false,
    this.newOnMap = false,
    this.takeaway = false,
  });

  final String name;
  final String kind; // Restaurant, Café, Takeaway, Grocery
  final double lat;
  final double lon;
  final double distanceKm;
  final List<String> cuisine;
  final String? openingHours;
  final String? website;
  final String? phone;
  final String? address;
  final bool halal;
  final bool vegetarian;
  final bool vegan;
  final bool newOnMap;
  final bool takeaway;

  String get cuisineText => cuisine.map((c) => c.replaceAll('_', ' ')).map((c) => c[0].toUpperCase() + c.substring(1)).join(', ');

  String get distanceText => distanceKm < 1 ? '${(distanceKm * 1000 / 10).round() * 10} m' : '${distanceKm.toStringAsFixed(1)} km';

  /// Rough walking time at 5 km/h.
  String get walkText {
    final mins = (distanceKm / 5 * 60).round();
    return mins < 60 ? '$mins min walk' : '${(mins / 60).toStringAsFixed(1)} h walk';
  }
}

class LocationResult {
  LocationResult.ok(this.lat, this.lon) : error = null;
  LocationResult.fail(this.error)
      : lat = 0,
        lon = 0;
  final double lat;
  final double lon;
  final String? error;
}

class PlacesService {
  static const endpoint = 'https://overpass-api.de/api/interpreter';

  /// Approximate location (city-block accuracy), rounded to ~1 km.
  static Future<LocationResult> approximateLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationResult.fail('Location is turned off on your phone.');
      }
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied) return LocationResult.fail('Location permission was not given.');
      if (p == LocationPermission.deniedForever) {
        return LocationResult.fail('Location is blocked for Landed. You can allow it in your phone’s app settings.');
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low, timeLimit: Duration(seconds: 25)),
      );
      double round(double v) => (v * 100).roundToDouble() / 100; // ~1 km
      return LocationResult.ok(round(pos.latitude), round(pos.longitude));
    } on TimeoutException {
      return LocationResult.fail('Couldn’t get your location in time. Try again near a window or with Wi-Fi on.');
    } on Object catch (e) {
      return LocationResult.fail('Couldn’t get your location ($e).');
    }
  }

  static String buildQuery(double lat, double lon, int radiusM) => '''
[out:json][timeout:25];
(
  nwr(around:$radiusM,$lat,$lon)["amenity"~"^(restaurant|cafe|fast_food|food_court)\$"]["name"];
  nwr(around:$radiusM,$lat,$lon)["shop"~"^(supermarket|convenience|greengrocer|butcher|bakery|deli)\$"]["name"];
);
out center meta 300;
''';

  static Future<List<Place>> nearby(double lat, double lon, {int radiusM = 1500, DateTime? now}) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
    client.userAgent = 'Landed student app (github.com/Dinakarnayak/settlemate-demo)';
    try {
      final req = await client.postUrl(Uri.parse(endpoint));
      req.headers.contentType = ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
      req.write('data=${Uri.encodeQueryComponent(buildQuery(lat, lon, radiusM))}');
      final res = await req.close().timeout(const Duration(seconds: 40));
      final body = await res.transform(utf8.decoder).join();
      if (res.statusCode == 429 || res.statusCode == 504) {
        throw const HttpException('The free map service is busy. Try again in a minute.');
      }
      if (res.statusCode != 200) throw HttpException('Map service error (${res.statusCode}).');
      return parse(jsonDecode(body) as Map<String, Object?>, lat, lon, now: now ?? DateTime.now());
    } on SocketException {
      throw const HttpException('No internet connection.');
    } on TimeoutException {
      throw const HttpException('The map service took too long. Try a smaller distance.');
    } finally {
      client.close(force: true);
    }
  }

  static List<Place> parse(Map<String, Object?> json, double lat, double lon, {required DateTime now}) {
    final out = <Place>[];
    final seen = <String>{};
    for (final raw in (json['elements'] as List? ?? const [])) {
      if (raw is! Map) continue;
      final e = raw.cast<String, Object?>();
      final tags = (e['tags'] as Map?)?.cast<String, Object?>() ?? const {};
      final name = tags['name'] as String?;
      if (name == null || name.trim().isEmpty) continue;
      final center = (e['center'] as Map?)?.cast<String, Object?>();
      final plat = ((e['lat'] ?? center?['lat']) as num?)?.toDouble();
      final plon = ((e['lon'] ?? center?['lon']) as num?)?.toDouble();
      if (plat == null || plon == null) continue;
      if (!seen.add('${name.toLowerCase()}|${plat.toStringAsFixed(4)}|${plon.toStringAsFixed(4)}')) continue;

      final amenity = tags['amenity'] as String?;
      final shop = tags['shop'] as String?;
      final kind = switch (amenity) {
        'restaurant' || 'food_court' => 'Restaurant',
        'cafe' => 'Café',
        'fast_food' => 'Takeaway',
        _ => shop != null ? 'Grocery' : 'Restaurant',
      };
      String? t(String k) {
        final v = tags[k];
        return v is String && v.trim().isNotEmpty ? v.trim() : null;
      }

      bool yes(String k) => const ['yes', 'only'].contains(t(k));

      // "New on the map": first added (version 1–2) within the last 6 months.
      final version = (e['version'] as num?)?.toInt() ?? 99;
      final stamp = DateTime.tryParse(e['timestamp'] as String? ?? '');
      final start = DateTime.tryParse(t('start_date') ?? '') ?? DateTime.tryParse(t('opening_date') ?? '');
      final recent = now.subtract(const Duration(days: 183));
      final isNew = (start != null && start.isAfter(recent)) || (version <= 2 && stamp != null && stamp.isAfter(recent));

      final street = [t('addr:housenumber'), t('addr:street')].whereType<String>().join(' ');
      out.add(Place(
        name: name.trim(),
        kind: kind,
        lat: plat,
        lon: plon,
        distanceKm: distanceKm(lat, lon, plat, plon),
        cuisine: (t('cuisine') ?? (shop != null && shop != 'supermarket' && shop != 'convenience' ? shop : ''))
            .split(RegExp(r'[;,]'))
            .map((c) => c.trim().toLowerCase())
            .where((c) => c.isNotEmpty)
            .toList(),
        openingHours: t('opening_hours'),
        website: t('website') ?? t('contact:website'),
        phone: t('phone') ?? t('contact:phone'),
        address: street.isEmpty ? t('addr:postcode') : [street, t('addr:postcode')].whereType<String>().join(', '),
        halal: yes('diet:halal'),
        vegetarian: yes('diet:vegetarian'),
        vegan: yes('diet:vegan'),
        newOnMap: isNew,
        takeaway: amenity == 'fast_food' || yes('takeaway'),
      ));
    }
    out.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return out;
  }

  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(lat2 - lat1);
    final dLon = rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }
}

/// Maps a home country to the cuisine tag students most likely want first.
const countryCuisine = <String, String>{
  'india': 'indian',
  'pakistan': 'pakistani',
  'bangladesh': 'bangladeshi',
  'sri lanka': 'sri_lankan',
  'nepal': 'nepalese',
  'china': 'chinese',
  'hong kong': 'chinese',
  'nigeria': 'african',
  'ghana': 'african',
  'kenya': 'african',
  'japan': 'japanese',
  'korea': 'korean',
  'south korea': 'korean',
  'thailand': 'thai',
  'vietnam': 'vietnamese',
  'malaysia': 'malaysian',
  'turkey': 'turkish',
  'italy': 'italian',
  'mexico': 'mexican',
  'lebanon': 'lebanese',
  'saudi arabia': 'arab',
  'iran': 'persian',
  'greece': 'greek',
  'spain': 'spanish',
  'france': 'french',
  'brazil': 'brazilian',
  'philippines': 'filipino',
  'indonesia': 'indonesian',
};
