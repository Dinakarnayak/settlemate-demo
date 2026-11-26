// Scripted tour of Landed, run on an Android emulator in GitHub Actions while
// the screen is recorded. It uses sample data in memory (no real user data).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:landed/data/models.dart';
import 'package:landed/data/store.dart';
import 'package:landed/data/vault.dart';
import 'package:landed/main.dart';
import 'package:landed/services/auth.dart';
import 'package:landed/services/security.dart';

Future<void> pause(WidgetTester t, [int ms = 1400]) async {
  final end = DateTime.now().add(Duration(milliseconds: ms));
  while (DateTime.now().isBefore(end)) {
    await t.pump(const Duration(milliseconds: 50));
  }
}

Future<void> tap(WidgetTester t, Finder f, [int ms = 1200]) async {
  await t.ensureVisible(f.first);
  await t.pump();
  await t.tap(f.first);
  await pause(t, ms);
}

Future<void> typeSlowly(WidgetTester t, Finder f, String text) async {
  await t.tap(f.first);
  for (var i = 1; i <= text.length; i++) {
    await t.enterText(f.first, text.substring(0, i));
    await t.pump(const Duration(milliseconds: 70));
  }
  await pause(t, 500);
}

Future<void> scroll(WidgetTester t, double dy, [int ms = 1000]) async {
  await t.drag(find.byType(Scrollable).last, Offset(0, -dy));
  await pause(t, ms);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Landed demo tour', (t) async {
    await ScreenPrivacy.setSecure(false); // allow screen recording for the demo
    final store = AppStore(Vault(MemoryKeyStore(), MemoryBlobStore()));
    await store.load();

    await t.pumpWidget(LandedApp(store: store, auth: AuthService()));
    await pause(t, 2500);

    // ---------------------------------------------------------------- onboarding
    await tap(t, find.byKey(const ValueKey('onboarding-next')));
    final fields = find.byType(TextField);
    await typeSlowly(t, fields.at(0), 'Dinakar');
    await typeSlowly(t, fields.at(1), 'University of Leicester');
    await typeSlowly(t, fields.at(2), 'Leicester');
    await typeSlowly(t, fields.at(3), 'India');
    await tap(t, find.byKey(const ValueKey('onboarding-next')));
    await pause(t, 1200);
    await tap(t, find.byKey(const ValueKey('onboarding-next')));
    await tap(t, find.byKey(const ValueKey('onboarding-next')), 2000);

    // Sample data so the screens look lived-in.
    final now = store.now;
    final monday = weekStart(now);
    store.updateProfile((p) => p.visaExpiry = DateTime(now.year + 1, 9, 30));
    for (final id in ['evisa', 'sim', 'enrol']) {
      store.toggleTask(store.tasks.firstWhere((x) => x.id == id));
    }
    store.addShift(job: 'Café', date: monday, hours: 6, rate: 12.21);
    store.addShift(job: 'Warehouse', date: monday.add(const Duration(days: 2)), hours: 8, rate: 12.21);
    store.addExpense(category: 'Rent', amount: 420, date: DateTime(now.year, now.month, 1));
    store.addExpense(category: 'Groceries', amount: 38.40, date: now, note: 'Weekly shop');
    store.addExpense(category: 'Transport', amount: 22, date: now, note: 'Bus pass top-up');
    store.addDeadline('CO7091 object detection report', now.add(const Duration(days: 8)), 'Assignment');
    store.addDeadline('Tuition instalment', now.add(const Duration(days: 40)), 'Tuition');
    await pause(t, 2500);

    // ---------------------------------------------------------------- home
    await scroll(t, 350, 1500);
    await scroll(t, 350, 1500);
    await scroll(t, -900, 1200);

    // ---------------------------------------------------------------- arrival
    await tap(t, find.byKey(const ValueKey('tab-Arrival')), 1500);
    await tap(t, find.byKey(const ValueKey('task-bank')), 1500);
    await scroll(t, 400, 1200);

    // ---------------------------------------------------------------- work
    await tap(t, find.byKey(const ValueKey('tab-Work')), 1800);
    await tap(t, find.text('Log shift'), 1200);
    await typeSlowly(t, find.widgetWithText(TextField, 'Hours'), '4');
    await pause(t, 1500);
    await tap(t, find.text('Save shift'), 2000);
    await scroll(t, 400, 1500);

    // ---------------------------------------------------------------- money
    await tap(t, find.byKey(const ValueKey('tab-Money')), 1800);
    await scroll(t, 300, 1500);
    await scroll(t, -300, 800);

    // ---------------------------------------------------------------- explore & guides
    await tap(t, find.byKey(const ValueKey('tab-Explore')), 1800);
    await tap(t, find.text('Housing & renting'), 1800);
    await scroll(t, 500, 1500);
    await t.pageBack();
    await pause(t, 1000);
    await scroll(t, 700, 1800);
    await scroll(t, -700, 800);

    // ---------------------------------------------------------------- ask
    await tap(t, find.byKey(const ValueKey('ask-fab')), 1200);
    await typeSlowly(t, find.widgetWithText(TextField, 'Type a question…'), 'How many hours can I work?');
    await tap(t, find.byIcon(Icons.send_rounded), 2500);
    await typeSlowly(t, find.byType(TextField).last, 'Is my data private?');
    await tap(t, find.byIcon(Icons.send_rounded), 3000);
    Navigator.of(t.element(find.byType(TextField).last)).pop();
    await pause(t, 800);

    // ---------------------------------------------------------------- settings & privacy
    await tap(t, find.byKey(const ValueKey('tab-Home')), 1000);
    await tap(t, find.byTooltip('Settings'), 1500);
    await scroll(t, 500, 1500);
    await scroll(t, 400, 1500);
    await tap(t, find.text('Privacy policy'), 2000);
    await scroll(t, 400, 2500);
    await t.pageBack();
    await pause(t, 800);
    await t.pageBack();
    await pause(t, 2000);
  });
}
