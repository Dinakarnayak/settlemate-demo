import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:landed/data/store.dart';
import 'package:landed/data/vault.dart';
import 'package:landed/l10n/l10n.dart';
import 'package:landed/l10n/translations.dart';
import 'package:landed/main.dart';
import 'package:landed/services/auth.dart';

void main() {
  test('every interface string has all 5 translations with matching placeholders', () {
    final pattern = RegExp(r"\b(?:t|tr)\(\s*'((?:[^'\\]|\\.)*)'");
    final keys = <String>{};
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart') || f.path.endsWith('places.dart') || f.path.contains('l10n')) continue;
      for (final m in pattern.allMatches(f.readAsStringSync())) {
        keys.add(m.group(1)!.replaceAll(r"\'", "'"));
      }
    }
    expect(keys.length, greaterThan(250));
    final ph = RegExp(r'\{\w+\}');
    for (final lang in ['hi', 'zh', 'es', 'ar', 'fr']) {
      final map = translations[lang]!;
      for (final k in keys) {
        expect(map.containsKey(k), isTrue, reason: '[$lang] missing translation for "$k"');
        final want = ph.allMatches(k).map((m) => m[0]).toList()..sort();
        final got = ph.allMatches(map[k]!).map((m) => m[0]).toList()..sort();
        expect(got, want, reason: '[$lang] placeholders differ for "$k"');
      }
    }
  });

  test('t() fills placeholders and falls back to English', () {
    setCurrentLanguage('fr');
    expect(t('Level {n}', {'n': '3'}), 'Niveau 3');
    expect(t('Something untranslated'), 'Something untranslated');
    setCurrentLanguage('xx');
    expect(currentLanguage, 'en');
  });

  testWidgets('Arabic runs right-to-left', (tester) async {
    final store = AppStore(Vault(MemoryKeyStore(), MemoryBlobStore()));
    await store.load();
    store.profile.language = 'ar';
    await tester.pumpWidget(LandedApp(store: store, auth: AuthService()));
    await tester.pumpAndSettle();
    expect(find.text('مرحبًا بك في Landed'), findsOneWidget);
    final dir = Directionality.of(tester.element(find.text('مرحبًا بك في Landed')));
    expect(dir, TextDirection.rtl);
    setCurrentLanguage('en');
    await store.flush();
  });
}
