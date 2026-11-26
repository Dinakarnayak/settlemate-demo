import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets.dart';

const deadlineIcons = <String, IconData>{
  'Visa': Icons.badge_rounded,
  'Tuition': Icons.account_balance_rounded,
  'Assignment': Icons.edit_note_rounded,
  'Exam': Icons.quiz_rounded,
  'Bill': Icons.receipt_rounded,
  'Rent': Icons.home_rounded,
  'Other': Icons.event_rounded,
};

(Color, Color) urgencyColours(int days) => days < 0
    ? (AppColors.coral, Colors.white)
    : days <= 7
        ? (AppColors.coralSoft, AppColors.coral)
        : days <= 30
            ? (AppColors.sunSoft, AppColors.sunText)
            : (AppColors.mintSoft, AppColors.mint);

class DeadlineTile extends StatelessWidget {
  const DeadlineTile({super.key, required this.d, required this.store, this.compact = false});
  final Deadline d;
  final AppStore store;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final days = d.daysLeft(store.now);
    final (bg, fg) = urgencyColours(days);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: IconBubble(deadlineIcons[d.kind] ?? Icons.event_rounded, bg: bg, fg: fg, size: 42),
      title: Text(d.title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            decoration: d.done ? TextDecoration.lineThrough : null,
            color: d.done ? AppColors.mute : AppColors.ink,
          )),
      subtitle: Text('${d.kind} · ${fmtDate(d.date, weekday: true, year: true)}'),
      trailing: compact
          ? Pill(daysLeftText(days), bg: bg, fg: fg)
          : Checkbox(
              value: d.done,
              onChanged: (_) => store.toggleDeadline(d),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
    );
  }
}

class DeadlinesScreen extends StatelessWidget {
  const DeadlinesScreen({super.key, required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final s = store;
        final up = s.upcoming;
        final late = s.overdue;
        final done = s.deadlines.where((d) => d.done).toList()..sort((a, b) => b.date.compareTo(a.date));
        Widget group(String title, List<Deadline> items) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SectionHeader(title),
              SoftCard(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(children: [
                  for (final d in items)
                    Dismissible(
                      key: ValueKey(d.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete_rounded, color: AppColors.coral),
                      ),
                      onDismissed: (_) => s.removeDeadline(d),
                      child: DeadlineTile(d: d, store: s),
                    ),
                ]),
              ),
            ]);
        return Scaffold(
          appBar: AppBar(title: const Text('Deadlines')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showAddDeadline(context, s),
            backgroundColor: AppColors.coral,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add deadline', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 100), children: [
            const Banner2(
              'Visa expiry, tuition, rent and assignment dates in one place. They’re stored only on this phone.',
              bg: AppColors.blueSoft,
              fg: AppColors.blue,
              icon: Icons.lock_rounded,
            ),
            if (late.isNotEmpty) group('Overdue', late),
            if (up.isNotEmpty) group('Coming up', up),
            if (up.isEmpty && late.isEmpty)
              const SoftCard(child: EmptyState(Icons.event_available_rounded, 'No deadlines yet. Add your visa expiry, tuition instalments and assignments.')),
            if (done.isNotEmpty) group('Done', done),
            const Text('Swipe left to delete.', style: smallText, textAlign: TextAlign.center),
          ]),
        );
      },
    );
  }
}

Future<void> showAddDeadline(BuildContext context, AppStore s) {
  final title = TextEditingController();
  var kind = 'Assignment';
  DateTime? date;
  String? error;
  return showSheet(context, (c) => StatefulBuilder(builder: (c, set) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Add a deadline', style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 14),
            TextField(
              controller: title,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'What’s due?', hintText: 'e.g. CO7091 report'),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final k in deadlineKinds)
                ChoiceChip(
                  avatar: Icon(deadlineIcons[k], size: 16),
                  label: Text(k),
                  selected: kind == k,
                  onSelected: (_) => set(() => kind = k),
                ),
            ]),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final d = await pickDate(c, initial: date ?? s.now.add(const Duration(days: 7)));
                if (d != null) set(() => date = d);
              },
              icon: const Icon(Icons.event_rounded),
              label: Text(date == null ? 'Choose date' : fmtDate(date!, weekday: true, year: true)),
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
                  if (title.text.trim().isEmpty || date == null) {
                    set(() => error = 'Add a title and a date.');
                    return;
                  }
                  s.addDeadline(title.text, date!, kind);
                  Navigator.pop(c);
                },
                child: const Text('Save deadline'),
              ),
            ),
          ]),
        );
      }));
}
