import 'package:flutter/material.dart';

import 'state.dart';
import 'theme.dart';
import 'widgets.dart';

const _pad = EdgeInsets.fromLTRB(18, 8, 18, 160);
const _small = TextStyle(fontSize: 13, color: AppColors.mute);

Widget _title(BuildContext c, String t, String sub) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(t, style: Theme.of(c).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(sub, style: const TextStyle(color: AppColors.mute, fontSize: 15)),
        const SizedBox(height: 14),
      ],
    );

// ---------------------------------------------------------------- Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.state, required this.go});
  final AppState state;
  final void Function(int) go;

  @override
  Widget build(BuildContext context) {
    final s = state;
    final h = s.hoursThisWeek;
    final next = s.nextTask;
    final tt = Theme.of(context).textTheme;

    return ListView(padding: _pad, children: [
      Row(children: [
        Transform.rotate(
          angle: -0.1,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.sun, borderRadius: BorderRadius.circular(16)),
            child: Text('D', style: bigNumber(size: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Good morning', style: _small),
            Text('Hey Dinakar!', style: tt.headlineMedium?.copyWith(fontSize: 24)),
          ]),
        ),
        Pill('${s.streak}-day streak', bg: AppColors.sunSoft, fg: const Color(0xFF8A6100)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Pill('Level ${s.level} · ${s.xp} XP', bg: AppColors.blueSoft, fg: AppColors.blue),
        const SizedBox(width: 10),
        Expanded(child: Meter(value: (s.xp % 50) / 50, color: AppColors.blue, track: AppColors.line)),
        const SizedBox(width: 10),
        Text('${s.xpToNext} XP to go', style: _small),
      ]),
      const SizedBox(height: 14),

      // Hero: next arrival task + ring
      Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(26)),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Next arrival task',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13)),
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

      // Tiles
      Row(children: [
        Expanded(
          child: _Tile(
            color: AppColors.tileBlue,
            icon: Icons.schedule_rounded,
            big: hrs(h),
            label: h > s.weeklyLimit ? 'Over your limit!' : '${hrs(s.weeklyLimit - h)} left this week',
            value: h / s.weeklyLimit,
            barColor: h > s.weeklyLimit ? AppColors.coral : AppColors.ink,
            onTap: () => go(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Tile(
            color: AppColors.tileSun,
            icon: Icons.account_balance_wallet_rounded,
            big: gbp(s.left),
            label: 'left this month',
            value: s.spent / s.budget,
            onTap: () => go(3),
          ),
        ),
      ]),
      const SizedBox(height: 14),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('This week near you', style: tt.titleMedium),
        TextButton(onPressed: () => go(4), child: const Text('See all')),
      ]),
      SizedBox(
        height: 170,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var i = 0; i < AppState.events.length; i++)
              EventCard(
                title: AppState.events[i].title,
                when: AppState.events[i].when,
                a: eventColours[i][0],
                b: eventColours[i][1],
                url: AppState.events[i].url,
              ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      SoftCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Deals for you', style: tt.titleMedium),
          for (final d in AppState.deals.take(3)) DealRow(d),
        ]),
      ),
      SoftCard(
        color: AppColors.pinkSoft,
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tuition instalment', style: tt.titleMedium),
              const Text('Due 15 January', style: _small),
            ]),
          ),
          GestureDetector(
            onTap: () => openUrl(searchUrl('University of Leicester pay tuition fees')),
            child: const Pill('Pay fees ↗', bg: AppColors.pink, fg: Colors.white),
          ),
        ]),
      ),
      const Text('Prototype with sample data. Rules are simplified, so check your visa conditions on gov.uk.',
          style: _small, textAlign: TextAlign.center),
    ]);
  }
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
  Widget build(BuildContext context) {
    return Material(
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
}

class DealRow extends StatelessWidget {
  const DealRow(this.d, {super.key});
  final Deal d;

  static const _style = {
    'Groceries': (Icons.shopping_cart_rounded, AppColors.coralSoft, AppColors.coral),
    'Meals': (Icons.ramen_dining_rounded, AppColors.sunSoft, Color(0xFFD99A00)),
    'Travel': (Icons.train_rounded, AppColors.blueSoft, AppColors.blue),
    'Help': (Icons.help_rounded, AppColors.mintSoft, AppColors.mint),
  };

  @override
  Widget build(BuildContext context) {
    final st = _style[d.kind]!;
    return InkWell(
      onTap: () => openUrl(d.url ?? mapsUrl('${d.name} Leicester')),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: st.$2, borderRadius: BorderRadius.circular(16)),
          child: Icon(st.$1, color: st.$3),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(d.offer, style: _small),
          ]),
        ),
        Text('${d.where} ↗', style: _small.copyWith(fontWeight: FontWeight.w600)),
      ]),
    ),
    );
  }
}

// ---------------------------------------------------------------- Arrival
class ArrivalScreen extends StatelessWidget {
  const ArrivalScreen({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final s = state;
    final pct = (s.arrivalProgress * 100).round();
    return ListView(padding: _pad, children: [
      _title(context, 'Arrival checklist', 'Your first weeks in the UK, in the right order. Each task earns 10 XP.'),
      SoftCard(
        color: AppColors.mintSoft,
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$pct%', style: bigNumber(color: AppColors.mint)),
              const SizedBox(height: 4),
              Text(pct == 100 ? 'You’re officially settled!' : 'settled in, keep going',
                  style: _small.copyWith(fontWeight: FontWeight.w600)),
            ]),
          ),
          ProgressRing(
            value: s.arrivalProgress,
            color: AppColors.mint,
            track: AppColors.mint.withValues(alpha: .2),
            size: 72,
            stroke: 12,
          ),
        ]),
      ),
      for (final t in s.tasks)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: t.done ? AppColors.mintSoft : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: t.done ? Colors.transparent : AppColors.line),
          ),
          child: Row(children: [
            GestureDetector(
              onTap: () => s.toggleTask(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: t.done ? AppColors.mint : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: t.done ? AppColors.mint : AppColors.line, width: 2.5),
                ),
                child: t.done ? const Icon(Icons.check_rounded, color: Colors.white, size: 20) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: t.done ? TextDecoration.lineThrough : null,
                      color: t.done ? AppColors.mute : AppColors.ink,
                    )),
                Text(t.detail, style: _small),
                if (t.url != null) LinkText('Open guide', t.url!),
              ]),
            ),
            Pill('+10', bg: t.done ? Colors.transparent : AppColors.blueSoft, fg: t.done ? AppColors.mint : AppColors.blue),
          ]),
        ),
    ]);
  }
}

// ---------------------------------------------------------------- Work
class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key, required this.state});
  final AppState state;

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final job = TextEditingController(text: 'Warehouse');
  final hours = TextEditingController(text: '4');

  @override
  void dispose() {
    job.dispose();
    hours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final h = s.hoursThisWeek;
    final over = h > s.weeklyLimit;
    final near = !over && h >= s.weeklyLimit - 3;
    final col = over ? AppColors.coral : near ? AppColors.sun : AppColors.blue;

    final (msg, bg, fg) = over
        ? ('You’re ${hrs(h - s.weeklyLimit)} over your limit. Working over it can breach your visa conditions.', AppColors.coralSoft, AppColors.coral)
        : near
            ? ('Only ${hrs(s.weeklyLimit - h)} left this week. Plan your next shift carefully.', AppColors.sunSoft, const Color(0xFF8A6100))
            : ('You’re safely within your limit.', AppColors.mintSoft, AppColors.mint);

    return ListView(padding: _pad, children: [
      _title(context, 'Work hours', 'This week, Monday to Sunday · term time'),
      SoftCard(
        child: Column(children: [
          Row(children: [
            ProgressRing(
              value: h / s.weeklyLimit,
              color: col,
              track: AppColors.line,
              size: 150,
              stroke: 14,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(hrs(h), style: bigNumber(size: 34)),
                Text('of ${s.weeklyLimit}h', style: _small),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Weekly limit', style: _small.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, children: [
                  for (final v in [20, 10])
                    ChoiceChip(
                      label: Text('${v}h'),
                      selected: s.weeklyLimit == v,
                      onSelected: (_) => s.setLimit(v),
                    ),
                ]),
                const SizedBox(height: 6),
                Text('${s.shifts.length} shifts logged', style: _small),
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
      SoftCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Log a shift', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(flex: 3, child: TextField(controller: job, decoration: const InputDecoration(hintText: 'Job'))),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: hours,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(suffixText: 'h'),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {
                final v = double.tryParse(hours.text);
                if (v != null && v > 0) s.addShift(job.text.trim(), v);
              },
              child: const Text('Add'),
            ),
          ]),
          const SizedBox(height: 8),
          for (var i = 0; i < s.shifts.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: s.shifts[i].job.toLowerCase().contains('caf') ? AppColors.tileSun : AppColors.tileBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(s.shifts[i].day, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
              title: Text(s.shifts[i].job, style: const TextStyle(fontWeight: FontWeight.w700)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(hrs(s.shifts[i].hours), style: const TextStyle(fontWeight: FontWeight.w700)),
                IconButton(
                  onPressed: () => s.removeShift(i),
                  icon: const Icon(Icons.close_rounded, color: AppColors.mute),
                  tooltip: 'Remove shift',
                ),
              ]),
            ),
        ]),
      ),
      const Text('University holidays count as vacation, when full-time work may be allowed. Check your own visa.',
          style: _small),
      const LinkText('Student visa work rules on gov.uk', 'https://www.gov.uk/student-visa'),
    ]);
  }
}

// ---------------------------------------------------------------- Money
class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key, required this.state});
  final AppState state;

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  String cat = 'Food';
  final amount = TextEditingController(text: '5');

  static const colours = [AppColors.blue, AppColors.coral, AppColors.sun, AppColors.pink, AppColors.mint];
  static const quick = [
    ('Coffee', 3.0, 'Food'),
    ('Meal deal', 4.0, 'Food'),
    ('Groceries', 20.0, 'Food'),
    ('Bus', 2.0, 'Transport'),
    ('Cinema', 8.0, 'Fun'),
  ];

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final tt = Theme.of(context).textTheme;
    final cats = s.spending.keys.toList();
    final maxV = s.spending.values.fold<double>(1, (a, v) => v > a ? v : a);

    return ListView(padding: _pad, children: [
      _title(context, 'Money', 'This month’s budget'),
      SoftCard(
        color: s.left < 0 ? AppColors.coralSoft : AppColors.tileSun,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Left to spend', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(gbp(s.left), style: bigNumber(size: 40)),
              ]),
            ),
            SizedBox(
              width: 100,
              child: TextFormField(
                initialValue: s.budget.toStringAsFixed(0),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(labelText: 'Budget', prefixText: '£'),
                onFieldSubmitted: (v) => s.setBudget(double.tryParse(v) ?? s.budget),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Meter(value: s.spent / s.budget),
          const SizedBox(height: 6),
          Text('${gbp(s.spent)} spent', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
      SoftCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Quick add', style: tt.titleMedium),
          const SizedBox(height: 4),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final q in quick)
              ActionChip(
                label: Text('${q.$1} £${q.$2.toInt()}'),
                backgroundColor: AppColors.sunSoft,
                side: BorderSide.none,
                onPressed: () => s.addSpending(q.$3, q.$2),
              ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                value: cat,
                items: [for (final c in cats) DropdownMenuItem(value: c, child: Text(c))],
                onChanged: (v) => setState(() => cat = v ?? cat),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(prefixText: '£'),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {
                final v = double.tryParse(amount.text);
                if (v != null && v > 0) s.addSpending(cat, v);
              },
              child: const Text('Add'),
            ),
          ]),
        ]),
      ),
      SoftCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Where it went', style: tt.titleMedium),
          const SizedBox(height: 6),
          for (var i = 0; i < cats.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                SizedBox(width: 82, child: Text(cats[i], style: const TextStyle(fontSize: 14))),
                Expanded(child: Meter(value: s.spending[cats[i]]! / maxV, color: colours[i], track: AppColors.line)),
                SizedBox(
                  width: 70,
                  child: Text(gbp(s.spending[cats[i]]!),
                      textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
        ]),
      ),
      SoftCard(
        color: AppColors.blueSoft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Sending money home?', style: tt.titleMedium?.copyWith(color: AppColors.blue)),
          const Text('Compare rates and fees from regulated providers first. Landed never holds your money.',
              style: _small),
          const LinkText('Money guides on MoneyHelper', 'https://www.moneyhelper.org.uk/en'),
          LinkText('Compare transfer fees', searchUrl('compare international money transfer fees UK')),
        ]),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- Discover
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key, required this.state});
  final AppState state;

  static const _groupColours = [
    AppColors.tileSun, Color(0xFFFFC9DF), Color(0xFFB5EFD9), AppColors.tileBlue, Color(0xFFFFD2C7), AppColors.tileSun,
  ];

  @override
  Widget build(BuildContext context) {
    final s = state;
    final tt = Theme.of(context).textTheme;
    return ListView(padding: _pad, children: [
      _title(context, 'Discover', 'Deals, food, events and your people.'),
      SizedBox(
        height: 44,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (final k in ['All', 'Groceries', 'Meals', 'Travel', 'Help'])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text(k), selected: s.dealFilter == k, onSelected: (_) => s.setFilter(k)),
            ),
        ]),
      ),
      const SizedBox(height: 8),
      SoftCard(child: Column(children: [for (final d in s.filteredDeals) DealRow(d)])),
      Text('Events', style: tt.titleMedium),
      const SizedBox(height: 8),
      SizedBox(
        height: 170,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (var i = 0; i < AppState.events.length; i++)
            EventCard(
              title: AppState.events[i].title,
              when: AppState.events[i].when,
              a: eventColours[i][0],
              b: eventColours[i][1],
              url: AppState.events[i].url,
            ),
        ]),
      ),
      const SizedBox(height: 14),
      Text('Find your people', style: tt.titleMedium),
      const SizedBox(height: 8),
      SoftCard(
        child: Column(children: [
          for (var i = 0; i < AppState.groups.length; i++)
            Builder(builder: (context) {
              final g = AppState.groups[i];
              final joined = s.joinedGroups.contains(g.name);
              final initials = g.name.split(' ').take(2).map((w) => w[0]).join();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: _groupColours[i], borderRadius: BorderRadius.circular(14)),
                    child: Text(initials, style: bigNumber(size: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(g.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${g.members} members', style: _small),
                      LinkText('Find online', 'https://www.facebook.com/search/groups/?q=${Uri.encodeQueryComponent(g.name)}'),
                    ]),
                  ),
                  joined
                      ? FilledButton.tonal(onPressed: () => s.toggleGroup(g.name), child: const Text('Joined'))
                      : FilledButton(onPressed: () => s.toggleGroup(g.name), child: const Text('Join')),
                ]),
              );
            }),
        ]),
      ),
    ]);
  }
}

// ---------------------------------------------------------------- Assistant
const _answers = <(RegExp, String, String)>[
  (RegExp(r'gp|doctor|nhs|ill|sick', caseSensitive: false),
      'Search "Find a GP" on the NHS website, pick a practice near your address and fill in their registration form. It’s free. For urgent advice, call NHS 111.', 'https://www.nhs.uk/service-search/find-a-gp'),
  (RegExp(r'hour|work|job|shift', caseSensitive: false),
      'Most degree-level students can work up to 20 hours a week in term time. Your Work tab tracks every shift and warns you before you reach your limit.', 'https://www.gov.uk/student-visa'),
  (RegExp(r'bank|account', caseSensitive: false),
      'Most UK banks let students open an account online. You usually need your passport or eVisa and a letter from your university confirming your address.', 'https://www.moneyhelper.org.uk/en'),
  (RegExp(r'rail|train|travel|bus', caseSensitive: false),
      'A 16–25 Railcard gives a third off most rail fares, and many city bus companies sell student term passes.', 'https://www.16-25railcard.co.uk'),
  (RegExp(r'money|budget|send|transfer', caseSensitive: false),
      'Set your monthly budget in the Money tab. To send money home, compare a few regulated providers first.', 'https://www.moneyhelper.org.uk/en'),
  (RegExp(r'friend|lonely|people|society', caseSensitive: false),
      'Try Discover → Find your people. Joining a society or a weekly event is the fastest way to make friends.', 'https://www.eventbrite.co.uk/d/united-kingdom--leicester/students/'),
];

void showAssistant(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (_) => const _Assistant(),
  );
}

class _Assistant extends StatefulWidget {
  const _Assistant();

  @override
  State<_Assistant> createState() => _AssistantState();
}

class _AssistantState extends State<_Assistant> {
  final input = TextEditingController();
  final msgs = <(bool, String, String?)>[
    (false, 'Hi Dinakar! I can help with GP, banking, work hours, travel, money and making friends. What do you need?', null),
  ];

  void ask(String q) {
    if (q.trim().isEmpty) return;
    String reply = 'I don’t have a demo answer for that yet. Here’s a web search to get you started.';
    String link = searchUrl('$q UK international student');
    for (final a in _answers) {
      if (a.$1.hasMatch(q)) {
        reply = a.$2;
        link = a.$3;
        break;
      }
    }
    setState(() {
      msgs.add((true, q, null));
      msgs.add((false, reply, link));
    });
    input.clear();
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .78,
        child: Column(children: [
          const SizedBox(height: 10),
          Container(width: 44, height: 5, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(3))),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
            child: Row(children: [
              Expanded(child: Text('Ask Landed', style: Theme.of(context).textTheme.titleMedium)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
            ]),
          ),
          Expanded(
            child: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
              for (final m in msgs)
                Align(
                  alignment: m.$1 ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .78),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: m.$1 ? AppColors.blue : Colors.white,
                      border: m.$1 ? null : Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m.$2, style: TextStyle(color: m.$1 ? Colors.white : AppColors.ink, fontSize: 15)),
                      if (m.$3 != null) LinkText('Open link', m.$3!),
                    ]),
                  ),
                ),
            ]),
          ),
          SizedBox(
            height: 48,
            child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [
              for (final q in ['How do I register with a GP?', 'How many hours can I work?', 'Cheapest way to travel?', 'How do I make friends?'])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(label: Text(q), onPressed: () => ask(q)),
                ),
            ]),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(hintText: 'Ask anything about UK life…'),
                    onSubmitted: ask,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.blue),
                  onPressed: () => ask(input.text),
                  child: const Text('Send'),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
