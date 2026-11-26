import 'package:flutter/material.dart';

import '../data/store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'assistant.dart';
import 'deadlines.dart';
import 'money.dart';
import 'work.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.store, required this.go, required this.openSettings});
  final AppStore store;
  final void Function(int) go;
  final VoidCallback openSettings;

  String _greeting(DateTime now) => now.hour < 12
      ? 'Good morning'
      : now.hour < 18
          ? 'Good afternoon'
          : 'Good evening';

  @override
  Widget build(BuildContext context) {
    final s = store;
    final p = s.profile;
    final h = s.hoursThisWeek;
    final next = s.nextTask;
    final tt = Theme.of(context).textTheme;
    final visa = s.visaDaysLeft;
    final up = s.upcoming.take(3).toList();
    final late = s.overdue;

    return ListView(padding: pagePad, children: [
      Row(children: [
        Semantics(
          button: true,
          label: 'Profile and settings',
          child: GestureDetector(
            onTap: openSettings,
            child: Transform.rotate(
              angle: -0.1,
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.sun, borderRadius: BorderRadius.circular(16)),
                child: Text(p.firstName.isEmpty ? '👋' : p.firstName.characters.first.toUpperCase(), style: bigNumber(size: 20)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_greeting(s.now), style: smallText),
            Text(p.firstName.isEmpty ? 'Welcome!' : 'Hey ${p.firstName}!', style: tt.headlineMedium?.copyWith(fontSize: 24)),
          ]),
        ),
        Pill('${s.streak}-day streak', bg: AppColors.sunSoft, fg: AppColors.sunText, icon: Icons.local_fire_department_rounded),
        IconButton(tooltip: 'Settings', onPressed: openSettings, icon: const Icon(Icons.settings_rounded)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Pill('Level ${s.level}', bg: AppColors.blueSoft, fg: AppColors.blue),
        const SizedBox(width: 10),
        Expanded(child: Meter(value: s.xpIntoLevel / 100, color: AppColors.blue, track: AppColors.line)),
        const SizedBox(width: 10),
        Text('${100 - s.xpIntoLevel} XP to go', style: smallText),
      ]),
      const SizedBox(height: 14),

      // ---------------------------------------------------------- alerts
      if (late.isNotEmpty)
        Banner2('${late.length} deadline${late.length == 1 ? ' is' : 's are'} overdue: ${late.first.title}.',
            bg: AppColors.coralSoft, fg: AppColors.coral, icon: Icons.error_rounded),
      if (visa != null && visa <= 90)
        Banner2(
          visa < 0
              ? 'Your visa expiry date has passed. Check your UKVI account and speak to your international student team today.'
              : 'Your visa expires ${daysLeftText(visa)}. Plan your next step, such as a Graduate visa, early.',
          bg: AppColors.coralSoft,
          fg: AppColors.coral,
          icon: Icons.badge_rounded,
        ),
      if (h > p.weeklyLimit)
        Banner2('You’ve logged ${fmtHours(h)} this week, over your ${p.weeklyLimit}h term-time limit.',
            bg: AppColors.coralSoft, fg: AppColors.coral, icon: Icons.warning_rounded),

      // ---------------------------------------------------------- hero
      Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(26)),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Next arrival task', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              Text(next?.title ?? 'All settled in!', style: bigNumber(size: 21, color: Colors.white).copyWith(height: 1.15)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => go(1),
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.coral),
                child: Text(next == null ? 'View checklist' : 'Let’s do it'),
              ),
            ]),
          ),
          ProgressRing(
            value: s.arrivalProgress,
            color: Colors.white,
            track: Colors.white30,
            child: Text('${s.doneCount}/${s.tasks.length}', style: bigNumber(size: 22, color: Colors.white)),
          ),
        ]),
      ),

      // ---------------------------------------------------------- tiles
      Row(children: [
        Expanded(
          child: _Tile(
            color: AppColors.tileBlue,
            icon: Icons.schedule_rounded,
            big: fmtHours(h),
            label: h > p.weeklyLimit ? 'Over your limit!' : '${fmtHours(p.weeklyLimit - h)} left this week',
            value: p.weeklyLimit == 0 ? 0 : h / p.weeklyLimit,
            barColor: h > p.weeklyLimit ? AppColors.coral : AppColors.ink,
            onTap: () => go(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Tile(
            color: AppColors.tileSun,
            icon: Icons.account_balance_wallet_rounded,
            big: gbp(s.leftThisMonth),
            label: s.leftThisMonth < 0 ? 'over budget' : 'left this month',
            value: p.monthlyBudget == 0 ? 0 : s.spentThisMonth / p.monthlyBudget,
            barColor: s.leftThisMonth < 0 ? AppColors.coral : AppColors.ink,
            onTap: () => go(3),
          ),
        ),
      ]),
      const SizedBox(height: 14),

      // ---------------------------------------------------------- quick actions
      Row(children: [
        _Quick(Icons.more_time_rounded, 'Log shift', AppColors.blueSoft, AppColors.blue, () => showAddShift(context, s)),
        _Quick(Icons.add_card_rounded, 'Add spend', AppColors.sunSoft, AppColors.sunText, () => showAddExpense(context, s)),
        _Quick(Icons.event_rounded, 'Deadline', AppColors.coralSoft, AppColors.coral, () => showAddDeadline(context, s)),
        _Quick(Icons.auto_awesome_rounded, 'Ask', AppColors.mintSoft, AppColors.mint, () => showAssistant(context, s)),
      ]),
      const SizedBox(height: 14),

      // ---------------------------------------------------------- deadlines
      SectionHeader('Coming up',
          action: 'See all',
          onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DeadlinesScreen(store: s)))),
      SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: up.isEmpty
            ? const EmptyState(Icons.event_available_rounded, 'No deadlines yet. Add your visa expiry, tuition dates and assignments.')
            : Column(children: [for (final d in up) DeadlineTile(d: d, store: s, compact: true)]),
      ),

      // ---------------------------------------------------------- privacy
      SoftCard(
        color: AppColors.mintSoft,
        onTap: openSettings,
        child: const Row(children: [
          Icon(Icons.verified_user_rounded, color: AppColors.mint),
          SizedBox(width: 12),
          Expanded(
            child: Text('Private by design: your data is encrypted on this phone. No ads, no trackers.',
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
          ),
          Icon(Icons.chevron_right_rounded),
        ]),
      ),
      const Text('Guidance is simplified. Check your own visa conditions on GOV.UK.', style: smallText, textAlign: TextAlign.center),
    ]);
  }
}

class _Quick extends StatelessWidget {
  const _Quick(this.icon, this.label, this.bg, this.fg, this.onTap);
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(children: [
                  Icon(icon, color: fg),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ),
        ),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.color,
    required this.icon,
    required this.big,
    required this.label,
    required this.value,
    required this.onTap,
    this.barColor = AppColors.ink,
  });
  final Color color;
  final IconData icon;
  final String big;
  final String label;
  final double value;
  final VoidCallback onTap;
  final Color barColor;

  @override
  Widget build(BuildContext context) => Material(
        color: color,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: Colors.white60, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 22, color: AppColors.ink),
              ),
              const SizedBox(height: 14),
              FittedBox(child: Text(big, style: bigNumber(size: 28))),
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Meter(value: value, color: barColor),
            ]),
          ),
        ),
      );
}
