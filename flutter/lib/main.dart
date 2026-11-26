import 'package:flutter/material.dart';

import 'screens.dart';
import 'state.dart';
import 'theme.dart';

void main() => runApp(const LandedApp());

class LandedApp extends StatefulWidget {
  const LandedApp({super.key});

  @override
  State<LandedApp> createState() => _LandedAppState();
}

class _LandedAppState extends State<LandedApp> {
  final state = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landed',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: Shell(state: state),
    );
  }
}

/// Main layout: the current tab, a floating dark pill nav and the "Ask" button.
class Shell extends StatefulWidget {
  const Shell({super.key, required this.state});
  final AppState state;

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
    (Icons.explore_rounded, 'Discover'),
  ];

  @override
  void initState() {
    super.initState();
    widget.state.addListener(_showMessage);
  }

  @override
  void dispose() {
    widget.state.removeListener(_showMessage);
    super.dispose();
  }

  void _showMessage() {
    final m = widget.state.takeMessage();
    if (m == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(m, style: const TextStyle(fontWeight: FontWeight.w700)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(milliseconds: 1600),
        margin: const EdgeInsets.fromLTRB(40, 0, 40, 110),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ));
  }

  void go(int i) => setState(() => tab = i);

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final screens = [
      HomeScreen(state: s, go: go),
      ArrivalScreen(state: s),
      WorkScreen(state: s),
      MoneyScreen(state: s),
      DiscoverScreen(state: s),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: s,
          builder: (context, _) => screens[tab],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 76),
        child: FloatingActionButton.extended(
          onPressed: () => showAssistant(context),
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.auto_awesome_rounded),
          label: const Text('Ask', style: TextStyle(fontWeight: FontWeight.w700)),
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
          child: Row(
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => go(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 54,
                      decoration: BoxDecoration(
                        color: tab == i ? AppColors.coral : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_tabs[i].$1, size: 22, color: tab == i ? Colors.white : const Color(0xFFB9BCD2)),
                          Text(
                            _tabs[i].$2,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: tab == i ? Colors.white : const Color(0xFFB9BCD2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
