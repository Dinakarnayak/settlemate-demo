import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../l10n/l10n.dart';
import '../l10n/l10n.dart' as l10n show t;
import '../theme.dart';
import '../widgets.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key, required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final s = store;
    final pct = (s.arrivalProgress * 100).round();
    return ListView(padding: pagePad, children: [
      ScreenTitle(t('Arrival checklist'), '${s.pack.flag} ${t('Your first weeks, in the right order. Each task earns 10 XP.')}',
          trailing: PopupMenuButton<String>(
            tooltip: t('More'),
            onSelected: (v) async {
              if (v == 'add') _addTask(context, s);
              if (v == 'reset' && await confirm(context, t('Reset checklist?'), t('This restores the default tasks for your study country and clears ticks.'), yes: t('Reset'))) {
                s.resetChecklist();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'add', child: Text(t('Add your own task'))),
              PopupMenuItem(value: 'reset', child: Text(t('Reset to default'))),
            ],
          )),
      SoftCard(
        color: AppColors.mintSoft,
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$pct%', style: bigNumber(color: AppColors.mint)),
              const SizedBox(height: 4),
              Text(pct == 100 ? t('You’re officially settled!') : t('{a} of {b} done, keep going', {'a': '${s.doneCount}', 'b': '${s.tasks.length}'}),
                  style: smallText.copyWith(fontWeight: FontWeight.w600)),
            ]),
          ),
          ProgressRing(value: s.arrivalProgress, color: AppColors.mint, track: AppColors.mint.withValues(alpha: .2), size: 72, stroke: 12),
        ]),
      ),
      for (final t in s.tasks) _TaskRow(task: t, store: s),
      const SizedBox(height: 6),
      Center(
        child: TextButton.icon(
          onPressed: () => _addTask(context, s),
          icon: const Icon(Icons.add_rounded),
          label: Text(t('Add your own task')),
        ),
      ),
    ]);
  }

  void _addTask(BuildContext context, AppStore s) {
    final title = TextEditingController();
    final detail = TextEditingController();
    showSheet(context, (c) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t('New task'), style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 14),
            TextField(controller: title, autofocus: true, textCapitalization: TextCapitalization.sentences, decoration: InputDecoration(labelText: t('Task'))),
            const SizedBox(height: 10),
            TextField(controller: detail, textCapitalization: TextCapitalization.sentences, decoration: InputDecoration(labelText: t('Details (optional)'))),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  s.addTask(title.text, detail.text);
                  Navigator.pop(c);
                },
                child: Text(t('Add task')),
              ),
            ),
          ]),
        ));
  }
}

String tr(String s) => l10n.t(s);

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.store});
  final TaskItem task;
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final t = task;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.done ? AppColors.mintSoft : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.done ? Colors.transparent : AppColors.line),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Semantics(
          button: true,
          checked: t.done,
          label: t.title,
          child: GestureDetector(
            key: ValueKey('task-${t.id}'),
            onTap: () => store.toggleTask(t),
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
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  decoration: t.done ? TextDecoration.lineThrough : null,
                  color: t.done ? AppColors.mute : AppColors.ink,
                )),
            if (t.detail.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(t.detail, style: smallText.copyWith(height: 1.35)),
            ],
            if (t.url != null) LinkText(tr('Open guide'), t.url!),
          ]),
        ),
        if (t.custom)
          IconButton(
            tooltip: tr('Delete task'),
            onPressed: () => store.removeTask(t),
            icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.mute),
          )
        else
          Pill('+10', bg: t.done ? Colors.transparent : AppColors.blueSoft, fg: t.done ? AppColors.mint : AppColors.blue),
      ]),
    );
  }
}
