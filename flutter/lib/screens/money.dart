import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'guide.dart';

const categoryStyle = <String, (IconData, Color, Color)>{
  'Rent': (Icons.home_rounded, AppColors.coralSoft, AppColors.coral),
  'Bills': (Icons.bolt_rounded, AppColors.sunSoft, AppColors.sunText),
  'Groceries': (Icons.shopping_cart_rounded, AppColors.mintSoft, AppColors.mint),
  'Eating out': (Icons.ramen_dining_rounded, AppColors.pinkSoft, AppColors.pink),
  'Transport': (Icons.train_rounded, AppColors.blueSoft, AppColors.blue),
  'Phone': (Icons.phone_iphone_rounded, AppColors.blueSoft, AppColors.blue),
  'Study': (Icons.school_rounded, AppColors.sunSoft, AppColors.sunText),
  'Fun': (Icons.celebration_rounded, AppColors.pinkSoft, AppColors.pink),
  'Send home': (Icons.flight_takeoff_rounded, AppColors.mintSoft, AppColors.mint),
  'Other': (Icons.more_horiz_rounded, AppColors.line, AppColors.mute),
};

(IconData, Color, Color) styleFor(String c) => categoryStyle[c] ?? categoryStyle['Other']!;

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key, required this.store});
  final AppStore store;

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  late DateTime month = DateTime(widget.store.now.year, widget.store.now.month);

  @override
  Widget build(BuildContext context) {
    final s = widget.store;
    final budget = s.profile.monthlyBudget;
    final spent = s.spentInMonth(month);
    final left = budget - spent;
    final isThisMonth = month.year == s.now.year && month.month == s.now.month;
    final cats = s.byCategory(month);
    final list = s.expensesInMonth(month);
    final over = left < 0;

    return ListView(padding: pagePad, children: [
      ScreenTitle('Money', 'Your budget in pounds, private to this phone',
          trailing: IconButton(
            tooltip: 'Money guide',
            onPressed: () => openGuide(context, s, 'money'),
            icon: const Icon(Icons.menu_book_rounded),
          )),
      Row(children: [
        IconButton(
          tooltip: 'Previous month',
          onPressed: () => setState(() => month = DateTime(month.year, month.month - 1)),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(child: Text(fmtMonth(month), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700))),
        IconButton(
          tooltip: 'Next month',
          onPressed: () => setState(() => month = DateTime(month.year, month.month + 1)),
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ]),
      const SizedBox(height: 8),
      Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: over ? AppColors.coral : AppColors.tileSun, borderRadius: BorderRadius.circular(26)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(over ? 'Over budget by' : 'Left this month',
              style: TextStyle(fontWeight: FontWeight.w700, color: over ? Colors.white70 : AppColors.ink)),
          const SizedBox(height: 6),
          Text(gbp(left.abs()), style: bigNumber(size: 44, color: over ? Colors.white : AppColors.ink)),
          const SizedBox(height: 12),
          Meter(value: budget == 0 ? 0 : spent / budget, color: over ? Colors.white : AppColors.ink, track: over ? Colors.white30 : null),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Text('${gbp(spent)} spent of ${gbp(budget)}',
                  style: TextStyle(fontWeight: FontWeight.w600, color: over ? Colors.white : AppColors.ink)),
            ),
            TextButton(
              onPressed: () => _editBudget(context, s),
              style: TextButton.styleFrom(foregroundColor: over ? Colors.white : AppColors.ink),
              child: const Text('Edit budget'),
            ),
          ]),
          if (isThisMonth && !over)
            Text('About ${gbp(s.dailyAllowance.floorToDouble())} a day for the rest of the month',
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.sunText)),
        ]),
      ),
      if (cats.isNotEmpty) ...[
        const SectionHeader('Where it went'),
        SoftCard(
          child: Column(children: [
            for (final e in cats.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  IconBubble(styleFor(e.key).$1, bg: styleFor(e.key).$2, fg: styleFor(e.key).$3, size: 38),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w700))),
                        Text(gbp(e.value), style: const TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 6),
                      Meter(value: spent == 0 ? 0 : e.value / spent, color: styleFor(e.key).$3, track: AppColors.line),
                    ]),
                  ),
                ]),
              ),
          ]),
        ),
      ],
      SectionHeader('Spending', action: 'Add', onAction: () => showAddExpense(context, s, initialDate: isThisMonth ? null : month)),
      if (list.isEmpty)
        const SoftCard(child: EmptyState(Icons.receipt_long_rounded, 'Nothing logged this month. Tap “Add” when you spend.'))
      else
        SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(children: [
            for (final e in list)
              Dismissible(
                key: ValueKey(e.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete_rounded, color: AppColors.coral),
                ),
                onDismissed: (_) => s.removeExpense(e),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: IconBubble(styleFor(e.category).$1, bg: styleFor(e.category).$2, fg: styleFor(e.category).$3, size: 42),
                  title: Text(e.note.isEmpty ? e.category : e.note, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${e.category} · ${fmtDate(e.date, weekday: true)}'),
                  trailing: Text(gbp(e.amount), style: bigNumber(size: 18)),
                ),
              ),
          ]),
        ),
      const Text('Swipe an item left to delete it.', style: smallText, textAlign: TextAlign.center),
    ]);
  }

  Future<void> _editBudget(BuildContext context, AppStore s) async {
    final c = TextEditingController(text: s.profile.monthlyBudget.toStringAsFixed(0));
    final v = await showDialog<double>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Monthly budget'),
        content: TextField(
          controller: c,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(prefixText: '£ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(d, parseAmount(c.text)), child: const Text('Save')),
        ],
      ),
    );
    if (v != null) s.setBudget(v);
  }
}

Future<void> showAddExpense(BuildContext context, AppStore s, {DateTime? initialDate}) {
  final amount = TextEditingController();
  final note = TextEditingController();
  var category = 'Groceries';
  var date = initialDate ?? dateOnly(s.now);
  String? error;

  return showSheet(context, (c) => StatefulBuilder(builder: (c, set) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Add spending', style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 14),
            TextField(
              controller: amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: bigNumber(size: 28),
              decoration: const InputDecoration(prefixText: '£ ', hintText: '0.00'),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final cat in expenseCategories)
                ChoiceChip(
                  avatar: Icon(styleFor(cat).$1, size: 16, color: styleFor(cat).$3),
                  label: Text(cat),
                  selected: category == cat,
                  onSelected: (_) => set(() => category = cat),
                ),
            ]),
            const SizedBox(height: 12),
            TextField(
              controller: note,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Note', hintText: 'optional, e.g. Weekly shop'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final d = await pickDate(c, initial: date);
                if (d != null) set(() => date = d);
              },
              icon: const Icon(Icons.event_rounded),
              label: Text(fmtDate(date, weekday: true, year: true)),
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final e = s.addExpense(category: category, amount: parseAmount(amount.text) ?? 0, date: date, note: note.text);
                  if (e != null) {
                    set(() => error = e);
                  } else {
                    Navigator.pop(c);
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ]),
        );
      }));
}
