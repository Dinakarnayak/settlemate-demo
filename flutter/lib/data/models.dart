// Plain data models. Everything here is stored only on the device, inside the
// encrypted vault (see vault.dart). Nothing is sent to a server.

String newId() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Monday of the week containing [d]. UK student work limits use Monday–Sunday weeks.
DateTime weekStart(DateTime d) => dateOnly(d).subtract(Duration(days: d.weekday - 1));

String isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime? parseDate(Object? v) => v is String && v.isNotEmpty ? DateTime.tryParse(v) : null;

double _num(Object? v, [double fallback = 0]) => v is num ? v.toDouble() : fallback;

class Profile {
  Profile({
    this.name = '',
    this.university = '',
    this.city = '',
    this.homeCountry = '',
    this.degreeLevel = true,
    this.weeklyLimit = 20,
    this.monthlyBudget = 800,
    this.visaExpiry,
    this.courseEnd,
    this.onboarded = false,
    this.studyCountry = 'GB',
    this.language = 'en',
    this.currency = '',
  });

  String name;
  String university;
  String city;
  String homeCountry;
  bool degreeLevel; // degree level or above (some countries set a lower limit below it)

  /// Work limit in the study country's unit: hours per week/fortnight/year, or days per year.
  int weeklyLimit;
  double monthlyBudget;
  DateTime? visaExpiry;
  DateTime? courseEnd;
  bool onboarded;

  /// ISO code of the country they study in ('XX' for one without a pack).
  String studyCountry;

  /// App language code: en, hi, zh, es, ar, fr.
  String language;

  /// Currency symbol chosen by the student when studying in an unsupported country.
  String currency;

  String get firstName => name.trim().split(RegExp(r'\s+')).first;
  String get cityOrUk => city.trim();

  Map<String, Object?> toJson() => {
        'name': name,
        'university': university,
        'city': city,
        'homeCountry': homeCountry,
        'degreeLevel': degreeLevel,
        'weeklyLimit': weeklyLimit,
        'monthlyBudget': monthlyBudget,
        'visaExpiry': visaExpiry == null ? null : isoDate(visaExpiry!),
        'courseEnd': courseEnd == null ? null : isoDate(courseEnd!),
        'onboarded': onboarded,
        'studyCountry': studyCountry,
        'language': language,
        'currency': currency,
      };

  factory Profile.fromJson(Map<String, Object?> j) => Profile(
        name: j['name'] as String? ?? '',
        university: j['university'] as String? ?? '',
        city: j['city'] as String? ?? '',
        homeCountry: j['homeCountry'] as String? ?? '',
        degreeLevel: j['degreeLevel'] as bool? ?? true,
        weeklyLimit: (j['weeklyLimit'] as num?)?.toInt() ?? 20,
        monthlyBudget: _num(j['monthlyBudget'], 800),
        visaExpiry: parseDate(j['visaExpiry']),
        courseEnd: parseDate(j['courseEnd']),
        onboarded: j['onboarded'] as bool? ?? false,
        studyCountry: j['studyCountry'] as String? ?? 'GB',
        language: j['language'] as String? ?? 'en',
        currency: j['currency'] as String? ?? '',
      );
}

class TaskItem {
  TaskItem({required this.id, required this.title, this.detail = '', this.url, this.done = false, this.custom = false});
  final String id;
  String title;
  String detail;
  String? url;
  bool done;
  bool custom;

  Map<String, Object?> toJson() => {'id': id, 'title': title, 'detail': detail, 'url': url, 'done': done, 'custom': custom};
  factory TaskItem.fromJson(Map<String, Object?> j) => TaskItem(
        id: j['id'] as String? ?? newId(),
        title: j['title'] as String? ?? '',
        detail: j['detail'] as String? ?? '',
        url: j['url'] as String?,
        done: j['done'] as bool? ?? false,
        custom: j['custom'] as bool? ?? false,
      );
}

class Shift {
  Shift({required this.id, required this.job, required this.date, required this.hours, this.rate});
  final String id;
  String job;
  DateTime date;
  double hours;
  double? rate; // optional £ per hour, to estimate pay

  double get pay => rate == null ? 0 : rate! * hours;

  Map<String, Object?> toJson() => {'id': id, 'job': job, 'date': isoDate(date), 'hours': hours, 'rate': rate};
  factory Shift.fromJson(Map<String, Object?> j) => Shift(
        id: j['id'] as String? ?? newId(),
        job: j['job'] as String? ?? 'Shift',
        date: parseDate(j['date']) ?? DateTime.now(),
        hours: _num(j['hours']),
        rate: (j['rate'] as num?)?.toDouble(),
      );
}

const expenseCategories = [
  'Rent',
  'Bills',
  'Groceries',
  'Eating out',
  'Transport',
  'Phone',
  'Study',
  'Fun',
  'Send home',
  'Other',
];

class Expense {
  Expense({required this.id, required this.date, required this.category, required this.amount, this.note = ''});
  final String id;
  DateTime date;
  String category;
  double amount;
  String note;

  Map<String, Object?> toJson() => {'id': id, 'date': isoDate(date), 'category': category, 'amount': amount, 'note': note};
  factory Expense.fromJson(Map<String, Object?> j) => Expense(
        id: j['id'] as String? ?? newId(),
        date: parseDate(j['date']) ?? DateTime.now(),
        category: j['category'] as String? ?? 'Other',
        amount: _num(j['amount']),
        note: j['note'] as String? ?? '',
      );
}

const deadlineKinds = ['Visa', 'Tuition', 'Assignment', 'Exam', 'Bill', 'Rent', 'Other'];

class Deadline {
  Deadline({required this.id, required this.title, required this.date, this.kind = 'Other', this.done = false});
  final String id;
  String title;
  DateTime date;
  String kind;
  bool done;

  int daysLeft(DateTime now) => dateOnly(date).difference(dateOnly(now)).inDays;

  Map<String, Object?> toJson() => {'id': id, 'title': title, 'date': isoDate(date), 'kind': kind, 'done': done};
  factory Deadline.fromJson(Map<String, Object?> j) => Deadline(
        id: j['id'] as String? ?? newId(),
        title: j['title'] as String? ?? '',
        date: parseDate(j['date']) ?? DateTime.now(),
        kind: j['kind'] as String? ?? 'Other',
        done: j['done'] as bool? ?? false,
      );
}

/// A private note: document numbers stay out of the app on purpose, but students
/// can keep reminders such as "BRP replaced by eVisa, share code in UKVI account".
class Note {
  Note({required this.id, required this.title, this.body = '', DateTime? updated}) : updated = updated ?? DateTime.now();
  final String id;
  String title;
  String body;
  DateTime updated;

  Map<String, Object?> toJson() => {'id': id, 'title': title, 'body': body, 'updated': updated.toIso8601String()};
  factory Note.fromJson(Map<String, Object?> j) => Note(
        id: j['id'] as String? ?? newId(),
        title: j['title'] as String? ?? '',
        body: j['body'] as String? ?? '',
        updated: parseDate(j['updated']),
      );
}

class Settings {
  Settings({this.appLock = false, this.hideInRecents = true, this.lockAfterSeconds = 30});
  bool appLock;
  bool hideInRecents;
  int lockAfterSeconds;

  Map<String, Object?> toJson() => {'appLock': appLock, 'hideInRecents': hideInRecents, 'lockAfterSeconds': lockAfterSeconds};
  factory Settings.fromJson(Map<String, Object?> j) => Settings(
        appLock: j['appLock'] as bool? ?? false,
        hideInRecents: j['hideInRecents'] as bool? ?? true,
        lockAfterSeconds: (j['lockAfterSeconds'] as num?)?.toInt() ?? 30,
      );
}
