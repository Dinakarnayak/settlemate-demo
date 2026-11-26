import 'dart:async';

import 'package:flutter/foundation.dart';

import '../content/arrival.dart';
import 'models.dart';
import 'vault.dart';

/// The whole app state. Loaded from, and saved to, the encrypted vault.
class AppStore extends ChangeNotifier {
  AppStore(this.vault, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final Vault vault;
  final DateTime Function() _clock;
  DateTime get now => _clock();

  Profile profile = Profile();
  Settings settings = Settings();
  List<TaskItem> tasks = defaultArrivalTasks();
  List<Shift> shifts = [];
  List<Expense> expenses = [];
  List<Deadline> deadlines = [];
  List<Note> notes = [];
  Set<String> savedGuides = {};
  int xp = 0;
  int streak = 0;
  DateTime? lastOpened;

  bool loaded = false;
  String? loadError;
  String? lastMessage;
  Timer? _saveTimer;

  // ------------------------------------------------------------------ persistence
  Future<void> load() async {
    try {
      final j = await vault.load();
      if (j != null) _fromJson(j);
    } on Object catch (e) {
      loadError = e is VaultException ? e.message : 'Saved data couldn’t be opened.';
    }
    _touchStreak();
    loaded = true;
    notifyListeners();
  }

  Map<String, Object?> toJson() => {
        'schema': 1,
        'profile': profile.toJson(),
        'settings': settings.toJson(),
        'tasks': [for (final t in tasks) t.toJson()],
        'shifts': [for (final s in shifts) s.toJson()],
        'expenses': [for (final e in expenses) e.toJson()],
        'deadlines': [for (final d in deadlines) d.toJson()],
        'notes': [for (final n in notes) n.toJson()],
        'savedGuides': savedGuides.toList(),
        'xp': xp,
        'streak': streak,
        'lastOpened': lastOpened == null ? null : isoDate(lastOpened!),
      };

  List<Map<String, Object?>> _list(Object? v) =>
      v is List ? [for (final e in v) if (e is Map) e.cast<String, Object?>()] : const [];

  void _fromJson(Map<String, Object?> j) {
    profile = j['profile'] is Map ? Profile.fromJson((j['profile'] as Map).cast()) : Profile();
    settings = j['settings'] is Map ? Settings.fromJson((j['settings'] as Map).cast()) : Settings();
    final t = _list(j['tasks']);
    tasks = t.isEmpty ? defaultArrivalTasks() : t.map(TaskItem.fromJson).toList();
    shifts = _list(j['shifts']).map(Shift.fromJson).toList();
    expenses = _list(j['expenses']).map(Expense.fromJson).toList();
    deadlines = _list(j['deadlines']).map(Deadline.fromJson).toList();
    notes = _list(j['notes']).map(Note.fromJson).toList();
    savedGuides = {for (final g in (j['savedGuides'] as List? ?? const [])) if (g is String) g};
    xp = (j['xp'] as num?)?.toInt() ?? 0;
    streak = (j['streak'] as num?)?.toInt() ?? 0;
    lastOpened = parseDate(j['lastOpened']);
  }

  /// Saves shortly after the last change, so typing doesn't write on every key.
  void _changed([String? message]) {
    if (message != null) lastMessage = message;
    notifyListeners();
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), flush);
  }

  Future<void> flush() async {
    _saveTimer?.cancel();
    _saveTimer = null;
    if (loadError != null) return; // never overwrite data we couldn't read
    await vault.save(toJson());
  }

  /// Replaces everything with a restored backup.
  Future<void> restore(Map<String, Object?> data) async {
    _fromJson(data);
    loadError = null;
    await flush();
    lastMessage = 'Backup restored';
    notifyListeners();
  }

  /// Deletes every piece of personal data and the encryption key.
  Future<void> eraseEverything() async {
    _saveTimer?.cancel();
    await vault.wipe();
    profile = Profile();
    settings = Settings();
    tasks = defaultArrivalTasks();
    shifts = [];
    expenses = [];
    deadlines = [];
    notes = [];
    savedGuides = {};
    xp = 0;
    streak = 0;
    lastOpened = null;
    loadError = null;
    notifyListeners();
  }

  /// Used when the saved data can't be decrypted and the student chooses to start again.
  Future<void> startFresh() => eraseEverything();

  String? takeMessage() {
    final m = lastMessage;
    lastMessage = null;
    return m;
  }

  // ------------------------------------------------------------------ XP & streak
  int get level => xp ~/ 100 + 1;
  int get xpIntoLevel => xp % 100;

  void _addXp(int n, String why) {
    final before = level;
    xp += n;
    lastMessage = level > before ? 'Level up! You’re now level $level' : '+$n XP · $why';
  }

  void _touchStreak() {
    final today = dateOnly(now);
    final last = lastOpened == null ? null : dateOnly(lastOpened!);
    if (last == today) return;
    streak = (last != null && today.difference(last).inDays == 1) ? streak + 1 : 1;
    lastOpened = today;
    if (loaded || profile.onboarded) _saveTimer = Timer(const Duration(milliseconds: 400), flush);
  }

  // ------------------------------------------------------------------ profile & settings
  void completeOnboarding(Profile p) {
    profile = p..onboarded = true;
    if (p.visaExpiry != null) _upsertVisaDeadline(p.visaExpiry!);
    _changed('Welcome to Landed, ${p.firstName.isEmpty ? 'friend' : p.firstName}!');
  }

  void updateProfile(void Function(Profile p) edit) {
    edit(profile);
    if (profile.visaExpiry != null) _upsertVisaDeadline(profile.visaExpiry!);
    _changed('Profile saved');
  }

  void _upsertVisaDeadline(DateTime date) {
    final i = deadlines.indexWhere((d) => d.kind == 'Visa' && d.title == 'Student visa expires');
    if (i >= 0) {
      deadlines[i].date = date;
    } else {
      deadlines.add(Deadline(id: newId(), title: 'Student visa expires', date: date, kind: 'Visa'));
    }
  }

  void updateSettings(void Function(Settings s) edit) {
    edit(settings);
    _changed();
  }

  // ------------------------------------------------------------------ arrival tasks
  int get doneCount => tasks.where((t) => t.done).length;
  double get arrivalProgress => tasks.isEmpty ? 0 : doneCount / tasks.length;
  TaskItem? get nextTask {
    for (final t in tasks) {
      if (!t.done) return t;
    }
    return null;
  }

  void toggleTask(TaskItem t) {
    t.done = !t.done;
    if (t.done) {
      _addXp(10, 'task done');
      _changed();
    } else {
      xp = (xp - 10).clamp(0, 1 << 30);
      _changed();
    }
  }

  void addTask(String title, String detail) {
    if (title.trim().isEmpty) return;
    tasks.add(TaskItem(id: newId(), title: title.trim(), detail: detail.trim(), custom: true));
    _changed('Task added');
  }

  void removeTask(TaskItem t) {
    tasks.remove(t);
    _changed('Task removed');
  }

  void resetChecklist() {
    tasks = defaultArrivalTasks();
    _changed('Checklist reset');
  }

  // ------------------------------------------------------------------ work
  List<Shift> shiftsInWeek(DateTime anyDay) {
    final start = weekStart(anyDay);
    final end = start.add(const Duration(days: 7));
    return shifts.where((s) => !s.date.isBefore(start) && s.date.isBefore(end)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  double hoursInWeek(DateTime anyDay) => shiftsInWeek(anyDay).fold(0, (a, s) => a + s.hours);
  double payInWeek(DateTime anyDay) => shiftsInWeek(anyDay).fold(0, (a, s) => a + s.pay);
  double get hoursThisWeek => hoursInWeek(now);

  /// Hours left before the limit if a shift of [extra] hours were added on [day].
  double hoursLeftAfter(DateTime day, double extra) => profile.weeklyLimit - hoursInWeek(day) - extra;

  List<String> get jobNames {
    final seen = <String>{};
    return [for (final s in shifts.reversed) if (seen.add(s.job)) s.job];
  }

  double? lastRateFor(String job) {
    for (final s in shifts.reversed) {
      if (s.job == job && s.rate != null) return s.rate;
    }
    return null;
  }

  String? addShift({required String job, required DateTime date, required double hours, double? rate}) {
    if (hours <= 0 || hours > 24) return 'Enter between 0.5 and 24 hours.';
    final s = Shift(id: newId(), job: job.trim().isEmpty ? 'Shift' : job.trim(), date: dateOnly(date), hours: hours, rate: rate);
    shifts.add(s);
    final left = hoursLeftAfter(date, 0);
    _addXp(2, 'shift logged');
    if (left < 0) lastMessage = 'Logged. That week is ${fmtHours(-left)} over your ${profile.weeklyLimit}h limit.';
    _changed();
    return null;
  }

  void removeShift(Shift s) {
    shifts.remove(s);
    _changed('Shift removed');
  }

  // ------------------------------------------------------------------ money
  List<Expense> expensesInMonth(DateTime anyDay) =>
      expenses.where((e) => e.date.year == anyDay.year && e.date.month == anyDay.month).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  double spentInMonth(DateTime anyDay) => expensesInMonth(anyDay).fold(0, (a, e) => a + e.amount);
  double get spentThisMonth => spentInMonth(now);
  double get leftThisMonth => profile.monthlyBudget - spentThisMonth;

  Map<String, double> byCategory(DateTime anyDay) {
    final m = <String, double>{};
    for (final e in expensesInMonth(anyDay)) {
      m[e.category] = (m[e.category] ?? 0) + e.amount;
    }
    final sorted = m.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return {for (final e in sorted) e.key: e.value};
  }

  /// Simple daily allowance for the rest of the month.
  double get dailyAllowance {
    final n = now;
    final daysInMonth = DateTime(n.year, n.month + 1, 0).day;
    final remainingDays = daysInMonth - n.day + 1;
    return leftThisMonth / remainingDays;
  }

  String? addExpense({required String category, required double amount, required DateTime date, String note = ''}) {
    if (amount <= 0 || amount > 100000) return 'Enter an amount above £0.';
    expenses.add(Expense(id: newId(), date: dateOnly(date), category: category, amount: amount, note: note.trim()));
    _changed('Added ${gbp(amount)} to $category');
    return null;
  }

  void removeExpense(Expense e) {
    expenses.remove(e);
    _changed('Removed');
  }

  void setBudget(double v) {
    if (v <= 0) return;
    profile.monthlyBudget = v;
    _changed('Budget set to ${gbp(v)}');
  }

  // ------------------------------------------------------------------ deadlines
  List<Deadline> get upcoming {
    final today = dateOnly(now);
    return deadlines.where((d) => !d.done && !dateOnly(d.date).isBefore(today)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<Deadline> get overdue {
    final today = dateOnly(now);
    return deadlines.where((d) => !d.done && dateOnly(d.date).isBefore(today)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  int? get visaDaysLeft => profile.visaExpiry == null ? null : dateOnly(profile.visaExpiry!).difference(dateOnly(now)).inDays;

  void addDeadline(String title, DateTime date, String kind) {
    if (title.trim().isEmpty) return;
    deadlines.add(Deadline(id: newId(), title: title.trim(), date: dateOnly(date), kind: kind));
    _changed('Deadline added');
  }

  void toggleDeadline(Deadline d) {
    d.done = !d.done;
    if (d.done) _addXp(5, 'deadline done');
    _changed();
  }

  void removeDeadline(Deadline d) {
    deadlines.remove(d);
    _changed('Deadline removed');
  }

  // ------------------------------------------------------------------ notes & saved guides
  void saveNote(Note n) {
    n.updated = now;
    if (!notes.contains(n)) notes.insert(0, n);
    _changed('Note saved');
  }

  void removeNote(Note n) {
    notes.remove(n);
    _changed('Note deleted');
  }

  bool isSaved(String guideId) => savedGuides.contains(guideId);
  void toggleSaved(String guideId) {
    if (!savedGuides.remove(guideId)) {
      savedGuides.add(guideId);
      _changed('Saved to your guides');
    } else {
      _changed('Removed from saved');
    }
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }
}

String gbp(double v) {
  final neg = v < 0;
  final a = v.abs();
  final s = a % 1 == 0 ? a.toStringAsFixed(0) : a.toStringAsFixed(2);
  return '${neg ? '−' : ''}£$s';
}

String fmtHours(double v) => '${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)}h';
