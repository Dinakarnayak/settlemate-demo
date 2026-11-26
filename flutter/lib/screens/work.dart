import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'guide.dart';

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
    final limit = s.profile.weeklyLimit;
    final h = s.hoursInWeek(week);
    final over = h > limit;
    final near = !over && h >= limit - 3;
    final col = over ? AppColors.coral : near ? AppColors.sun : AppColors.blue;
    final weekShifts = s.shiftsInWeek(week);
    final pay = s.payInWeek(week);
    final isThisWeek = weekStart(s.now) == week;
    final end = week.add(const Duration(days: 6));

    final (msg, bg, fg) = over
        ? ('${fmtHours(h - limit)} over your $limit-hour limit. In term time this can breach your visa conditions.', AppColors.coralSoft, AppColors.coral)
        : near
            ? ('Only ${fmtHours(limit - h)} left this week. Plan your next shift carefully.', AppColors.sunSoft, AppColors.sunText)
            : ('You’re within your term-time limit.', AppColors.mintSoft, AppColors.mint);

    return ListView(padding: pagePad, children: [
      ScreenTitle('Work hours', 'Monday to Sunday · all jobs count together',
          trailing: IconButton(
            tooltip: 'Work rules',
            onPressed: () => openGuide(context, s, 'work'),
            icon: const Icon(Icons.menu_book_rounded),
          )),
      Row(children: [
        IconButton(
          tooltip: 'Previous week',
          onPressed: () => setState(() => week = week.subtract(const Duration(days: 7))),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Column(children: [
            Text(isThisWeek ? 'This week' : 'Week of ${fmtDate(week)}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${fmtDate(week, weekday: true)} – ${fmtDate(end, weekday: true)}', style: smallText),
          ]),
        ),
        IconButton(
          tooltip: 'Next week',
          onPressed: () => setState(() => week = week.add(const Duration(days: 7))),
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ]),
      const SizedBox(height: 8),
      SoftCard(
        child: Column(children: [
          Row(children: [
            ProgressRing(
              value: limit == 0 ? 0 : h / limit,
              color: col,
              track: AppColors.line,
              size: 140,
              stroke: 14,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(fmtHours(h), style: bigNumber(size: 34)),
                Text('of ${limit}h', style: smallText),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Your weekly limit', style: smallText.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, children: [
                  for (final v in [20, 10])
                    ChoiceChip(
                      label: Text('${v}h'),
                      selected: limit == v,
                      onSelected: (_) => s.updateProfile((p) {
                        p.weeklyLimit = v;
                        p.degreeLevel = v == 20;
                      }),
                    ),
                ]),
                const SizedBox(height: 8),
                Text('${weekShifts.length} shift${weekShifts.length == 1 ? '' : 's'}', style: smallText),
                if (pay > 0) Text('≈ ${gbp(pay)} before tax', style: smallText.copyWith(fontWeight: FontWeight.w700)),
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
        ]),
      ),
      _WeekBars(store: s, week: week),
      SectionHeader('Shifts', action: 'Log shift', onAction: () => showAddShift(context, s, initialDate: isThisWeek ? null : week)),
      if (weekShifts.isEmpty)
        const SoftCard(child: EmptyState(Icons.work_outline_rounded, 'No shifts this week. Tap “Log shift” after each one.'))
      else
        SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(children: [
            for (final sh in weekShifts)
              Dismissible(
                key: ValueKey(sh.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete_rounded, color: AppColors.coral),
                ),
                onDismissed: (_) => s.removeShift(sh),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: const IconBubble(Icons.badge_rounded, bg: AppColors.blueSoft, fg: AppColors.blue, size: 42),
                  title: Text(sh.job, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${fmtDate(sh.date, weekday: true)}${sh.rate != null ? ' · ${gbp(sh.rate!)}/h' : ''}'),
                  trailing: Text(fmtHours(sh.hours), style: bigNumber(size: 20)),
                ),
              ),
          ]),
        ),
      const Text('Swipe a shift left to delete it. Rules are simplified: check your eVisa for your exact conditions.',
          style: smallText, textAlign: TextAlign.center),
    ]);
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
                  dayName(week.add(Duration(days: i))).substring(0, 1),
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
            Text('Log a shift', style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 14),
            TextField(
              controller: job,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Job', hintText: 'e.g. Café, Warehouse'),
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
                  decoration: const InputDecoration(labelText: 'Hours', suffixText: 'h'),
                  onChanged: (_) => set(() {}),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: rate,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Pay per hour', prefixText: '£ ', hintText: 'optional'),
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
                    ? 'This takes that week to ${fmtHours(s.profile.weeklyLimit - left)}, over your ${s.profile.weeklyLimit}h limit. Only do this in an official vacation.'
                    : '${fmtHours(left)} left that week after this shift.',
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
                    set(() => error = e);
                  } else {
                    Navigator.pop(c);
                  }
                },
                child: const Text('Save shift'),
              ),
            ),
          ]),
        );
      }));
}
