import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:landed/data/store.dart';
import 'package:landed/data/vault.dart';
import 'package:landed/main.dart';
import 'package:landed/services/auth.dart';

void main() {
  testWidgets('new users see onboarding, then the home screen', (tester) async {
    final store = AppStore(Vault(MemoryKeyStore(), MemoryBlobStore()));
    await store.load();
    await tester.pumpWidget(LandedApp(store: store, auth: AuthService()));
    await tester.pump();
    expect(find.text('Welcome to Landed'), findsOneWidget);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byKey(const ValueKey('onboarding-next')));
      await tester.pumpAndSettle();
    }
    expect(store.profile.onboarded, isTrue);
    expect(find.text('Next arrival task'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tab-Work')));
    await tester.pumpAndSettle();
    expect(find.text('Work hours'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tab-Money')));
    await tester.pumpAndSettle();
    expect(find.text('Left this month'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tab-Explore')));
    await tester.pumpAndSettle();
    expect(find.text('Visa & immigration'), findsOneWidget);
    await store.flush();
    await tester.pump(const Duration(seconds: 5));
  });
}
