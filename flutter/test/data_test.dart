import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:landed/content/assistant.dart';
import 'package:landed/content/countries/countries.dart';
import 'package:landed/data/models.dart';
import 'package:landed/data/store.dart';
import 'package:landed/data/vault.dart';
import 'package:landed/services/places.dart';

void main() {
  group('Vault', () {
    test('saves encrypted and loads back', () async {
      final blobs = MemoryBlobStore();
      final vault = Vault(MemoryKeyStore(), blobs);
      await vault.save({'secret': 'visa expires 2027-09-30'});
      expect(blobs.data, isNotNull);
      expect(blobs.data!.contains('visa'), isFalse, reason: 'plaintext must not be stored');
      expect((await vault.load())!['secret'], 'visa expires 2027-09-30');
    });

    test('fails closed without the key', () async {
      final keys = MemoryKeyStore();
      final blobs = MemoryBlobStore();
      await Vault(keys, blobs).save({'a': 1});
      await keys.deleteKey();
      expect(() => Vault(keys, blobs).load(), throwsA(isA<VaultException>()));
    });

    test('wipe removes data and key', () async {
      final keys = MemoryKeyStore();
      final blobs = MemoryBlobStore();
      final v = Vault(keys, blobs);
      await v.save({'a': 1});
      await v.wipe();
      expect(blobs.data, isNull);
      expect(keys.key, isNull);
    });
  });

  group('Backup', () {
    test('round trip with passphrase', () async {
      final text = await Backup.create({'x': 42}, 'correct horse');
      expect(text.startsWith(Backup.prefix), isTrue);
      expect((await Backup.open(text, 'correct horse'))['x'], 42);
    });

    test('wrong passphrase is rejected', () async {
      final text = await Backup.create({'x': 42}, 'correct horse');
      expect(() => Backup.open(text, 'wrong horse!'), throwsA(isA<VaultException>()));
    });

    test('short passphrase is rejected', () async {
      expect(() => Backup.create({'x': 1}, 'short'), throwsA(isA<VaultException>()));
    });
  });

  group('AppStore', () {
    // Wednesday 26 November 2026
    final now = DateTime(2026, 11, 26, 10);
    AppStore make() => AppStore(Vault(MemoryKeyStore(), MemoryBlobStore()), clock: () => now);

    test('weeks run Monday to Sunday', () {
      expect(weekStart(DateTime(2026, 11, 26)), DateTime(2026, 11, 23));
      expect(weekStart(DateTime(2026, 11, 29)), DateTime(2026, 11, 23));
      expect(weekStart(DateTime(2026, 11, 30)), DateTime(2026, 11, 30));
    });

    test('counts hours per week across jobs', () async {
      final s = make();
      await s.load();
      s.addShift(job: 'Café', date: DateTime(2026, 11, 23), hours: 8);
      s.addShift(job: 'Warehouse', date: DateTime(2026, 11, 29), hours: 7.5);
      s.addShift(job: 'Café', date: DateTime(2026, 11, 30), hours: 6); // next week
      expect(s.hoursThisWeek, 15.5);
      expect(s.hoursLeftAfter(now, 6), -1.5);
      expect(s.addShift(job: 'x', date: now, hours: 0), isNotNull);
      await s.flush();
    });

    test('budget and categories', () async {
      final s = make();
      await s.load();
      s.setBudget(1000);
      s.addExpense(category: 'Rent', amount: 500, date: DateTime(2026, 11, 1));
      s.addExpense(category: 'Groceries', amount: 40.5, date: DateTime(2026, 11, 20));
      s.addExpense(category: 'Groceries', amount: 10, date: DateTime(2026, 10, 20)); // last month
      expect(s.spentThisMonth, 540.5);
      expect(s.leftThisMonth, 459.5);
      expect(s.byCategory(now).keys.first, 'Rent');
      await s.flush();
    });

    test('visa expiry becomes a deadline and persists', () async {
      final keys = MemoryKeyStore();
      final blobs = MemoryBlobStore();
      final s = AppStore(Vault(keys, blobs), clock: () => now);
      await s.load();
      s.completeOnboarding(Profile(name: 'Dinakar', visaExpiry: DateTime(2028, 9, 30)));
      await s.flush();

      final again = AppStore(Vault(keys, blobs), clock: () => now);
      await again.load();
      expect(again.profile.firstName, 'Dinakar');
      expect(again.upcoming.single.kind, 'Visa');
      expect(again.visaDaysLeft, greaterThan(600));
    });

    test('profile photo is kept in the encrypted vault and erased with everything', () async {
      final keys = MemoryKeyStore();
      final blobs = MemoryBlobStore();
      final s = AppStore(Vault(keys, blobs), clock: () => now);
      await s.load();
      s.setPhoto(Uint8List.fromList([137, 80, 78, 71, 1, 2, 3]));
      await s.flush();
      final again = AppStore(Vault(keys, blobs), clock: () => now);
      await again.load();
      expect(again.photo, [137, 80, 78, 71, 1, 2, 3]);
      await again.eraseEverything();
      expect(again.photo, isNull);
    });

    test('erase everything resets to a fresh state', () async {
      final s = make();
      await s.load();
      s.completeOnboarding(Profile(name: 'A'));
      s.addExpense(category: 'Fun', amount: 5, date: now);
      await s.eraseEverything();
      expect(s.profile.onboarded, isFalse);
      expect(s.expenses, isEmpty);
    });

    test('gbp formatting', () {
      expect(gbp(5), '£5');
      expect(gbp(5.5), '£5.50');
      expect(gbp(-3), '−£3');
    });
  });

  group('Offline helper', () {
    test('finds the right answers', () {
      expect(searchAnswers('how many hours can I work in term time', ukAnswers).first.answer.guideId, 'work');
      expect(searchAnswers('how do I get a share code for my landlord', ukAnswers).first.answer.question, contains('share code'));
      expect(searchAnswers('register with a doctor', ukAnswers).first.answer.guideId, 'health');
      expect(searchAnswers('landlord wants 6 months rent upfront', ukAnswers).first.answer.guideId, 'housing');
      expect(searchAnswers('xyzzy plugh', ukAnswers), isEmpty);
    });

    test('every answer has keywords and text', () {
      expect(ukAnswers.length, greaterThanOrEqualTo(50));
      for (final a in ukAnswers) {
        expect(a.keywords, isNotEmpty);
        expect(a.text, isNotEmpty);
      }
    });
  });

  group('Food near me', () {
    final now = DateTime(2026, 11, 26);
    final json = <String, Object?>{
      'elements': [
        {
          'type': 'node', 'lat': 52.6215, 'lon': -1.1250, 'version': 1, 'timestamp': '2026-10-01T10:00:00Z',
          'tags': {'amenity': 'restaurant', 'name': 'Spice Route', 'cuisine': 'indian;vegetarian', 'diet:halal': 'yes', 'opening_hours': 'Mo-Su 12:00-22:00'},
        },
        {
          'type': 'way', 'center': {'lat': 52.6300, 'lon': -1.1300}, 'version': 9, 'timestamp': '2019-01-01T10:00:00Z',
          'tags': {'shop': 'supermarket', 'name': 'Big Shop'},
        },
        {'type': 'node', 'lat': 52.62, 'lon': -1.12, 'tags': {'amenity': 'cafe'}}, // no name: skipped
      ],
    };

    test('parses, sorts by distance and flags new places', () {
      final places = PlacesService.parse(json, 52.62, -1.12, now: now);
      expect(places.length, 2);
      expect(places.first.name, 'Spice Route');
      expect(places.first.kind, 'Restaurant');
      expect(places.first.cuisine, contains('indian'));
      expect(places.first.halal, isTrue);
      expect(places.first.newOnMap, isTrue);
      expect(places.last.kind, 'Grocery');
      expect(places.last.newOnMap, isFalse);
    });

    test('distance is sensible', () {
      // Leicester to Loughborough is roughly 15 km.
      final d = PlacesService.distanceKm(52.6369, -1.1398, 52.7721, -1.2062);
      expect(d, inInclusiveRange(14, 17));
    });

    test('query asks for named food places only', () {
      final q = PlacesService.buildQuery(52.62, -1.12, 1500);
      expect(q, contains('around:1500,52.62,-1.12'));
      expect(q, contains('restaurant|cafe|fast_food'));
    });
  });

  group('Country packs', () {
    test('every pack is complete and consistent', () {
      expect(countryPacks.length, 9);
      for (final p in countryPacks) {
        final ids = p.guides.map((g) => g.id).toSet();
        expect(ids.length, p.guides.length, reason: '${p.code} has duplicate guide ids');
        for (final need in ['visa', 'work', 'money', 'housing', 'health', 'emergency']) {
          expect(ids, contains(need), reason: '${p.code} missing $need guide');
        }
        for (final a in p.answers) {
          if (a.guideId != null) expect(ids, contains(a.guideId), reason: '${p.code}: "${a.question}" links to missing guide ${a.guideId}');
        }
        final tasks = p.arrivalTasks();
        expect(tasks, isNotEmpty);
        expect(tasks.map((t) => t.id).toSet().length, tasks.length, reason: '${p.code} has duplicate task ids');
        expect(p.emergency.where((e) => e.primary).length, 1, reason: '${p.code} needs one primary emergency number');
        expect(searchAnswers('how many hours can I work', p.answers), isNotEmpty, reason: '${p.code} answers work hours');
        expect(searchAnswers('is my data private', p.answers), isNotEmpty);
        for (final g in p.guides) {
          for (final sec in g.sections) {
            for (final l in sec.links) {
              expect(l.url.startsWith('https://'), isTrue, reason: '${p.code} link ${l.url}');
            }
          }
        }
      }
    });

    test('currency formatting', () {
      expect(packFor('US').money(12.5), '\$12.50');
      expect(packFor('DE').money(800), '800 €');
      expect(packFor('GB').money(-3), '−£3');
      expect(packFor('ZZ').code, 'XX');
    });

    final now = DateTime(2026, 11, 26, 10); // Thursday
    AppStore make(String country) {
      final s = AppStore(Vault(MemoryKeyStore(), MemoryBlobStore()), clock: () => now);
      s.profile.studyCountry = country;
      s.profile.weeklyLimit = s.defaultLimit(packFor(country), true);
      return s;
    }

    test('Australia counts a fortnight (last week + this week)', () {
      final s = make('AU');
      expect(s.workLimit, 48);
      s.addShift(job: 'A', date: DateTime(2026, 11, 17), hours: 20); // last week
      s.addShift(job: 'A', date: DateTime(2026, 11, 24), hours: 20); // this week
      s.addShift(job: 'A', date: DateTime(2026, 11, 10), hours: 20); // two weeks ago, not counted
      expect(s.usedNow, 40);
      expect(s.hoursLeftAfter(now, 10), -2);
    });

    test('Germany counts days: up to 4 hours is half a day', () {
      final s = make('DE');
      expect(s.workLimit, 140);
      s.addShift(job: 'A', date: DateTime(2026, 1, 5), hours: 3); // half
      s.addShift(job: 'A', date: DateTime(2026, 1, 6), hours: 8); // full
      s.addShift(job: 'A', date: DateTime(2026, 1, 7), hours: 2); // same day becomes 6h => full
      s.addShift(job: 'A', date: DateTime(2026, 1, 7), hours: 4);
      s.addShift(job: 'A', date: DateTime(2025, 12, 30), hours: 8); // last year
      expect(s.usedNow, 2.5);
      expect(s.units(2.5), '2.5 days');
    });

    test('France counts hours per year', () {
      final s = make('FR');
      expect(s.workLimit, 964);
      s.addShift(job: 'A', date: DateTime(2026, 3, 1), hours: 10);
      s.addShift(job: 'A', date: DateTime(2026, 11, 2), hours: 5);
      expect(s.usedNow, 15);
    });

    test('switching country updates limit and checklist', () {
      final s = make('GB');
      s.setStudyCountry('CA');
      expect(s.pack.code, 'CA');
      expect(s.workLimit, 24);
      expect(s.tasks.first.id, startsWith('ca-'));
      expect(s.money(10), 'CA\$10');
    });
  });
}
