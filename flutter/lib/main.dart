import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';

import 'data/store.dart';
import 'data/vault.dart';
import 'l10n/l10n.dart';
import 'screens/assistant.dart';
import 'screens/checklist.dart';
import 'screens/explore.dart';
import 'screens/home.dart';
import 'screens/money.dart';
import 'screens/onboarding.dart';
import 'screens/settings.dart';
import 'screens/work.dart';
import 'services/auth.dart';
import 'services/security.dart';
import 'theme.dart';
import 'widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    for (final f in ['Fredoka', 'PlusJakartaSans']) {
      yield LicenseEntryWithLineBreaks([f], await rootBundle.loadString('assets/fonts/OFL-$f.txt'));
    }
  });
  final dir = await getApplicationSupportDirectory();
  final store = AppStore(Vault(SecureKeyStore(), FileBlobStore('${dir.path}/landed.vault')));
  final auth = AuthService();
  runApp(LandedApp(store: store, auth: auth));
  await store.load();
  await ScreenPrivacy.setSecure(store.settings.hideInRecents);
  await auth.init();
}

class LandedApp extends StatelessWidget {
  const LandedApp({super.key, required this.store, required this.auth});
  final AppStore store;
  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        setCurrentLanguage(store.profile.language);
        return MaterialApp(
          title: 'Landed',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          locale: Locale(currentLanguage),
          supportedLocales: [for (final l in appLanguages) Locale(l.code)],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Builder(builder: (context) {
          if (!store.loaded) return const _Splash();
          if (store.loadError != null) return _Recovery(store: store);
          if (!store.profile.onboarded) return OnboardingScreen(store: store);
          return LockGate(store: store, child: Shell(store: store, auth: auth));
          }),
        );
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.coral,
        body: Center(child: Text('Landed', style: bigNumber(size: 44, color: Colors.white))),
      );
}

/// Shown if the encrypted data can't be opened (for example the key was lost).
class _Recovery extends StatelessWidget {
  const _Recovery({required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Icon(Icons.lock_reset_rounded, size: 64, color: AppColors.coral),
              const SizedBox(height: 16),
              Text(t('Your saved data can’t be opened'), style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text('${store.loadError}\n\n${t('If you have an encrypted backup, start fresh and then restore it from Settings.')}',
                  textAlign: TextAlign.center, style: const TextStyle(color: AppColors.mute, height: 1.4)),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (await confirm(context, t('Start fresh?'), t('The unreadable data will be deleted.'), yes: t('Start fresh'))) {
                    await store.startFresh();
                  }
                },
                child: Text(t('Start fresh')),
              ),
            ]),
          ),
        ),
      );
}

/// Locks the app with the phone's biometrics or PIN when App lock is on.
class LockGate extends StatefulWidget {
  const LockGate({super.key, required this.store, required this.child});
  final AppStore store;
  final Widget child;

  @override
  State<LockGate> createState() => _LockGateState();
}

class _LockGateState extends State<LockGate> with WidgetsBindingObserver {
  late bool locked = widget.store.settings.appLock;
  DateTime? _leftAt;
  bool _authing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (locked) WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      widget.store.flush();
      if (!_authing) _leftAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final left = _leftAt;
      _leftAt = null;
      final s = widget.store.settings;
      if (s.appLock && !_authing && left != null && DateTime.now().difference(left).inSeconds >= s.lockAfterSeconds) {
        setState(() => locked = true);
        _unlock();
      }
    }
  }

  Future<void> _unlock() async {
    if (_authing) return;
    _authing = true;
    final ok = await DeviceAuth.unlock(t('Unlock Landed'));
    _authing = false;
    if (ok && mounted) setState(() => locked = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!locked) return widget.child;
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock_rounded, color: Colors.white, size: 56),
            const SizedBox(height: 16),
            Text(t('Landed is locked'), style: bigNumber(size: 26, color: Colors.white)),
            const SizedBox(height: 8),
            Text(t('Your data is encrypted on this phone.'), style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: _unlock, icon: const Icon(Icons.fingerprint_rounded), label: Text(t('Unlock'))),
          ]),
        ),
      ),
    );
  }
}

/// Main layout: the current tab, a floating dark pill nav and the "Ask" button.
class Shell extends StatefulWidget {
  const Shell({super.key, required this.store, required this.auth});
  final AppStore store;
  final AuthService auth;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;

  static const _tabs = [
    (Icons.home_rounded, 'Home'),
    (Icons.flag_rounded, 'Arrival'),
    (Icons.schedule_rounded, 'Work'),
    (Icons.account_balance_wallet_rounded, 'Money'),
    (Icons.explore_rounded, 'Explore'),
  ];

  @override
  void initState() {
    super.initState();
    widget.store.addListener(_showMessage);
  }

  @override
  void dispose() {
    widget.store.removeListener(_showMessage);
    super.dispose();
  }

  void _showMessage() {
    final m = widget.store.takeMessage();
    if (m == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(m),
        duration: const Duration(milliseconds: 1800),
        margin: const EdgeInsets.fromLTRB(40, 0, 40, 110),
      ));
  }

  void go(int i) => setState(() => tab = i);

  void _settings() =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsScreen(store: widget.store, auth: widget.auth)));

  @override
  Widget build(BuildContext context) {
    final s = widget.store;
    return PopScope(
      canPop: tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) go(0);
      },
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: s,
            builder: (context, _) => switch (tab) {
              0 => HomeScreen(store: s, go: go, openSettings: _settings),
              1 => ChecklistScreen(store: s),
              2 => WorkScreen(store: s),
              3 => MoneyScreen(store: s),
              _ => ExploreScreen(store: s),
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 76),
          child: FloatingActionButton.extended(
            key: const ValueKey('ask-fab'),
            onPressed: () => showAssistant(context, s),
            backgroundColor: AppColors.blue,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: Text(t('Ask'), style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 30, offset: Offset(0, 12))],
            ),
            child: Row(children: [
              for (var i = 0; i < _tabs.length; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: tab == i,
                    label: t(_tabs[i].$2),
                    child: GestureDetector(
                      key: ValueKey('tab-${_tabs[i].$2}'),
                      onTap: () => go(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 54,
                        decoration: BoxDecoration(
                          color: tab == i ? AppColors.coral : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(_tabs[i].$1, size: 22, color: tab == i ? Colors.white : const Color(0xFFB9BCD2)),
                          Text(t(_tabs[i].$2),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: tab == i ? Colors.white : const Color(0xFFB9BCD2),
                              )),
                        ]),
                      ),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
