import 'package:flutter/material.dart';

import '../data/store.dart';
import '../l10n/l10n.dart';
import '../theme.dart';
import '../widgets.dart';
import 'assistant.dart';
import 'deadlines.dart';
import 'money.dart';
import 'profile_photo.dart';
import 'work.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.store, required this.go, required this.openSettings});
  final AppStore store;
  final void Function(int) go;
  final VoidCallback openSettings;

  String _greeting(DateTime now) => now.hour < 12
      ? t('Good morning')
      : now.hour < 18
          ? t('Good afternoon')
          : t('Good evening');

  @override
  Widget build(BuildContext context) {
    final s = store;
    final p = s.profile;
    final used = s.usedNow;
    final limit = s.workLimit;
    final over = used > limit;
    final next = s.nextTask;
    final tt = Theme.of(context).textTheme;
    final visa = s.visaDaysLeft;
    final up = s.upcoming.take(3).toList();
    final late = s.overdue;

    return ListView(padding: pagePad, children: [
      Row(children: [
        Semantics(
          button: true,
          label: t('Profile and settings'),
          child: GestureDetector(
            onTap: openSettings,
            child: ProfileAvatar(store: s),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${_greeting(s.now)} · ${s.pack.flag} ${s.pack.fullySupported ? s.pack.name : ''}', style: smallText, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(p.firstName.isEmpty ? t('Welcome!') : t('Hey {name}!', {'name': p.firstName}), style: tt.headlineMedium?.copyWith(fontSize: 24)),
          ]),
        ),
        Pill(t('{n}-day streak', {'n': '${s.streak}'}), bg: AppColors.sunSoft, fg: AppColors.sunText, icon: Icons.local_fire_department_rounded),
        IconButton(tooltip: t('Settings'), onPressed: openSettings, icon: const Icon(Icons.settings_rounded)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Pill(t('Level {n}', {'n': '${s.level}'}), bg: AppColors.blueSoft, fg: AppColors.blue),
        const SizedBox(width: 10),
        Expanded(child: Meter(value: s.xpIntoLevel / 100, color: AppColors.blue, track: AppColors.line)),
        const SizedBox(width: 10),
        Text(t('{n} XP to go', {'n': '${100 - s.xpIntoLevel}'}), style: smallText),
      ]),
      const SizedBox(height: 14),

      // ---------------------------------------------------------- alerts
      if (late.isNotEmpty)
        Banner2(t('Overdue: {x}', {'x': late.first.title}),
            bg: AppColors.coralSoft, fg: AppColors.coral, icon: Icons.error_rounded),
      if (visa != null && visa <= 90)
        Banner2(
          visa < 0
              ? t('Your visa expiry date has passed. Speak to your international student office today.')
              : t('Your visa expires {when}. Plan your next step early.', {'when': daysLeftText(visa)}),
          bg: AppColors.coralSoft,
          fg: AppColors.coral,
          icon: Icons.badge_rounded,
        ),
      if (over)
        Banner2(t('You’re {x} over your work limit {p}.', {'x': s.units(used - limit), 'p': periodWord(s.rule)}),
            bg: AppColors.coralSoft, fg: AppColors.coral, icon: Icons.warning_rounded),

      // ---------------------------------------------------------- hero
      Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(26)),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t('Next arrival task'), style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              Text(next?.title ?? t('All settled in!'), style: bigNumber(size: 21, color: Colors.white).copyWith(height: 1.15)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => go(1),
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.coral),
                child: Text(next == null ? t('View checklist') : t('Let’s do it')),
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
            big: s.units(used),
            label: over ? t('Over your limit!') : t('{x} left {p}', {'x': s.units(limit - used), 'p': periodWord(s.rule)}),
            value: limit == 0 ? 0 : used / limit,
            barColor: over ? AppColors.coral : AppColors.ink,
            onTap: () => go(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Tile(
            color: AppColors.tileSun,
            icon: Icons.account_balance_wallet_rounded,
            big: s.money(s.leftThisMonth),
            label: s.leftThisMonth < 0 ? t('over budget') : t('left this month'),
            value: p.monthlyBudget == 0 ? 0 : s.spentThisMonth / p.monthlyBudget,
            barColor: s.leftThisMonth < 0 ? AppColors.coral : AppColors.ink,
            onTap: () => go(3),
          ),
        ),
      ]),
      const SizedBox(height: 14),

      // ---------------------------------------------------------- quick actions
      Row(children: [
        _Quick(Icons.more_time_rounded, t('Log shift'), AppColors.blueSoft, AppColors.blue, () => showAddShift(context, s)),
        _Quick(Icons.add_card_rounded, t('Add spend'), AppColors.sunSoft, AppColors.sunText, () => showAddExpense(context, s)),
        _Quick(Icons.event_rounded, t('Deadline'), AppColors.coralSoft, AppColors.coral, () => showAddDeadline(context, s)),
        _Quick(Icons.auto_awesome_rounded, t('Ask'), AppColors.mintSoft, AppColors.mint, () => showAssistant(context, s)),
      ]),
      const SizedBox(height: 14),

      // ---------------------------------------------------------- deadlines
      SectionHeader(t('Coming up'),
          action: t('See all'),
          onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DeadlinesScreen(store: s)))),
      SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: up.isEmpty
            ? EmptyState(Icons.event_available_rounded, t('No deadlines yet. Add your visa expiry, tuition dates and assignments.'))
            : Column(children: [for (final d in up) DeadlineTile(d: d, store: s, compact: true)]),
      ),

      // ---------------------------------------------------------- privacy
      SoftCard(
        color: AppColors.mintSoft,
        onTap: openSettings,
        child: Row(children: [
          const Icon(Icons.verified_user_rounded, color: AppColors.mint),
          const SizedBox(width: 12),
          Expanded(
            child: Text(t('Private by design: your data is encrypted on this phone. No ads, no trackers.'),
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
          ),
          const Icon(Icons.chevron_right_rounded),
        ]),
      ),
      Text(t('Guidance is simplified. Always check your own visa conditions on official websites.'), style: smallText, textAlign: TextAlign.center),
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
