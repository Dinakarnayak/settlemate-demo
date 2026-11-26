import 'package:flutter/material.dart';

import '../content/countries/countries.dart';
import '../data/models.dart';
import '../data/store.dart';
import '../l10n/l10n.dart';
import '../theme.dart';
import '../widgets.dart';
import 'guide.dart';

String periodWord(WorkRule r) => switch (r.period) {
      LimitPeriod.week => t('this week'),
      LimitPeriod.fortnight => t('this fortnight'),
      _ => t('this year'),
    };

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key, required this.store});
  final AppStore store;

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late DateTime week = weekStart(widget.store.now);

  @override
  Widget build(BuildContext context) {
    final s = widget.store;
    final rule = s.rule;
    final limit = s.workLimit;
    final used = s.usedInPeriod(week);
    final over = used > limit;
    final nearGap = rule.isDays ? 10 : rule.period == LimitPeriod.yearHours ? 60 : rule.period == LimitPeriod.fortnight ? 6 : 3;
    final near = !over && used >= limit - nearGap;
    final col = over ? AppColors.coral : near ? AppColors.sun : AppColors.blue;
    final weekShifts = s.shiftsInWeek(week);
    final pay = s.payInWeek(week);
    final isThisWeek = weekStart(s.now) == week;
    final end = week.add(const Duration(days: 6));
    final (pStart, pEnd) = s.periodRange(week);
    final periodText = switch (rule.period) {
      LimitPeriod.week => t('Monday to Sunday'),
      LimitPeriod.fortnight => '${fmtDate(pStart)} – ${fmtDate(pEnd.subtract(const Duration(days: 1)))}',
      _ => '${pStart.year}',
    };

    final (msg, bg, fg) = over
        ? (t('{x} over your limit. In term time this can breach your visa conditions.', {'x': s.units(used - limit)}), AppColors.coralSoft, AppColors.coral)
        : near
            ? (t('Only {x} left. Plan your next shift carefully.', {'x': s.units(limit - used)}), AppColors.sunSoft, AppColors.sunText)
            : (t('You’re within your term-time limit.'), AppColors.mintSoft, AppColors.mint);

    final chips = <int>{
      s.defaultLimit(s.pack, true),
      if (rule.belowDegreeLimit != null) rule.belowDegreeLimit!.round(),
      s.profile.weeklyLimit,
    }.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView(padding: pagePad, children: [
      ScreenTitle(t('Work hours'), '${s.pack.flag} ${t(rule.isDays ? 'Days worked count towards your yearly limit' : 'All jobs count together')}',
          trailing: IconButton(
            tooltip: t('Work rules'),
            onPressed: () => openGuide(context, s, 'work'),
            icon: const Icon(Icons.menu_book_rounded),
          )),
      Banner2(rule.summary, bg: AppColors.blueSoft, fg: AppColors.blue, icon: Icons.gavel_rounded),
      Row(children: [
        IconButton(
          tooltip: t('Previous week'),
          onPressed: () => setState(() => week = week.subtract(const Duration(days: 7))),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Column(children: [
            Text(isThisWeek ? t('This week') : t('Week of {d}', {'d': fmtDate(week)}), style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${fmtDate(week, weekday: true)} – ${fmtDate(end, weekday: true)}', style: smallText),
          ]),
        ),
        IconButton(
          tooltip: t('Next week'),
          onPressed: () => setState(() => week = week.add(const Duration(days: 7))),
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ]),
      const SizedBox(height: 8),
      SoftCard(
        child: Column(children: [
          Row(children: [
            ProgressRing(
              value: limit == 0 ? 0 : used / limit,
              color: col,
              track: AppColors.line,
              size: 140,
              stroke: 14,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                FittedBox(child: Text(rule.isDays ? used.toString().replaceAll('.0', '') : fmtHours(used), style: bigNumber(size: 34))),
                Text(rule.isDays ? t('of {n} days', {'n': '${limit.round()}'}) : t('of {n}h', {'n': '${limit.round()}'}), style: smallText),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t('Limit per {p}', {'p': t(rule.periodName)}), style: smallText.copyWith(fontWeight: FontWeight.w600)),
                Text(periodText, style: smallText.copyWith(fontSize: 12)),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final v in chips)
                    ChoiceChip(
                      label: Text(rule.isDays ? '$v' : '${v}h'),
                      selected: s.profile.weeklyLimit == v,
                      onSelected: (_) => s.updateProfile((p) => p.weeklyLimit = v),
                    ),
                  ActionChip(label: Text(t('Custom')), onPressed: () => _customLimit(context, s)),
                ]),
                const SizedBox(height: 8),
                Text(t('{n} shifts this week', {'n': '${weekShifts.length}'}), style: smallText),
                if (pay > 0) Text(t('≈ {x} before tax', {'x': s.money(pay)}), style: smallText.copyWith(fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
            child: Text(msg, style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          if (rule.breaksNote != null) ...[
            const SizedBox(height: 8),
            Text(rule.breaksNote!, style: smallText),
          ],
        ]),
      ),
      _WeekBars(store: s, week: week),
      SectionHeader(t('Shifts'), action: t('Log shift'), onAction: () => showAddShift(context, s, initialDate: isThisWeek ? null : week)),
      if (weekShifts.isEmpty)
        SoftCard(child: EmptyState(Icons.work_outline_rounded, t('No shifts this week. Tap “Log shift” after each one.')))
      else
        SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(children: [
            for (final sh in weekShifts)
              Dismissible(
                key: ValueKey(sh.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: const Icon(Icons.delete_rounded, color: AppColors.coral),
                ),
                onDismissed: (_) => s.removeShift(sh),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: const IconBubble(Icons.badge_rounded, bg: AppColors.blueSoft, fg: AppColors.blue, size: 42),
                  title: Text(sh.job, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${fmtDate(sh.date, weekday: true)}${sh.rate != null ? ' · ${s.money(sh.rate!)}/h' : ''}'),
                  trailing: Text(fmtHours(sh.hours), style: bigNumber(size: 20)),
                ),
              ),
          ]),
        ),
      LinkText(t('Official rules'), rule.officialUrl),
      Text(t('Swipe a shift to delete it. Rules are simplified: check your own visa conditions.'), style: smallText, textAlign: TextAlign.center),
    ]);
  }

  Future<void> _customLimit(BuildContext context, AppStore s) async {
    final c = TextEditingController(text: '${s.profile.weeklyLimit}');
    final v = await showDialog<int>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(t('Your limit per {p}', {'p': t(s.rule.periodName)})),
        content: TextField(
          controller: c,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(suffixText: s.rule.isDays ? t('days') : t('hours')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: Text(t('Cancel'))),
          FilledButton(onPressed: () => Navigator.pop(d, int.tryParse(c.text.trim())), child: Text(t('Save'))),
        ],
      ),
    );
    if (v != null && v > 0 && v < 5000) s.updateProfile((p) => p.weeklyLimit = v);
  }
}

class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.store, required this.week});
  final AppStore store;
  final DateTime week;

  @override
  Widget build(BuildContext context) {
    final shifts = store.shiftsInWeek(week);
    final perDay = List<double>.filled(7, 0);
    for (final s in shifts) {
      perDay[s.date.weekday - 1] += s.hours;
    }
    final maxH = perDay.fold<double>(8, (a, b) => b > a ? b : a);
    final today = dateOnly(store.now);
    return SoftCard(
      child: SizedBox(
        height: 120,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                if (perDay[i] > 0) Text(fmtHours(perDay[i]), style: smallText.copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 6 + 70 * (perDay[i] / maxH),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: perDay[i] > 0 ? AppColors.blue : AppColors.line,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dayName(week.add(Duration(days: i))).characters.first,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: week.add(Duration(days: i)) == today ? AppColors.coral : AppColors.mute,
                  ),
                ),
              ]),
            ),
        ]),
      ),
    );
  }
}

Future<void> showAddShift(BuildContext context, AppStore s, {DateTime? initialDate}) {
  final jobs = s.jobNames;
  final job = TextEditingController(text: jobs.isEmpty ? '' : jobs.first);
  final hours = TextEditingController();
  final rate = TextEditingController(text: jobs.isEmpty ? '' : (s.lastRateFor(jobs.first)?.toString() ?? ''));
  var date = initialDate ?? dateOnly(s.now);
  String? error;

  return showSheet(context, (c) => StatefulBuilder(builder: (c, set) {
        final h = double.tryParse(hours.text) ?? 0;
        final left = s.hoursLeftAfter(date, h);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t('Log a shift'), style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 14),
            TextField(
              controller: job,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: t('Job'), hintText: t('e.g. Café, Warehouse')),
            ),
            if (jobs.length > 1) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, children: [
                for (final j in jobs.take(4))
                  ActionChip(
                    label: Text(j),
                    onPressed: () => set(() {
                      job.text = j;
                      rate.text = s.lastRateFor(j)?.toString() ?? '';
                    }),
                  ),
              ]),
            ],
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: hours,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: t('Hours'), suffixText: 'h'),
                  onChanged: (_) => set(() {}),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: rate,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: t('Pay per hour'), prefixText: '${s.currencySymbol} ', hintText: t('optional')),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final d = await pickDate(c, initial: date);
                if (d != null) set(() => date = d);
              },
              icon: const Icon(Icons.event_rounded),
              label: Text(fmtDate(date, weekday: true, year: true)),
            ),
            const SizedBox(height: 10),
            if (h > 0)
              Banner2(
                left < 0
                    ? t('This puts you {x} over your limit for that {p}. Only do this in an official break.', {'x': s.units(-left), 'p': t(s.rule.periodName)})
                    : t('{x} left that {p} after this shift.', {'x': s.units(left), 'p': t(s.rule.periodName)}),
                bg: left < 0 ? AppColors.coralSoft : AppColors.mintSoft,
                fg: left < 0 ? AppColors.coral : AppColors.mint,
                icon: left < 0 ? Icons.warning_rounded : Icons.check_circle_rounded,
              ),
            if (error != null) Text(error!, style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final e = s.addShift(job: job.text, date: date, hours: h, rate: parseAmount(rate.text));
                  if (e != null) {
                    set(() => error = t(e));
                  } else {
                    Navigator.pop(c);
                  }
                },
                child: Text(t('Save shift')),
              ),
            ),
          ]),
        );
      }));
}
