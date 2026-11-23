import 'package:flutter/foundation.dart';

class ArrivalTask {
  ArrivalTask(this.title, this.detail, {this.done = false});
  final String title;
  final String detail;
  bool done;
}

class Shift {
  Shift(this.job, this.hours, this.day);
  final String job;
  final double hours;
  final String day;
}

class Deal {
  const Deal(this.name, this.kind, this.offer, this.where);
  final String name;
  final String kind;
  final String offer;
  final String where;
}

class EventItem {
  const EventItem(this.title, this.when);
  final String title;
  final String when;
}

class Group {
  const Group(this.name, this.members);
  final String name;
  final int members;
}

/// All app data in one place. Sample data for the prototype; later this
/// would come from a backend such as Firebase or Supabase.
class AppState extends ChangeNotifier {
  int xp = 20;
  int streak = 5;
  int weeklyLimit = 20;
  double budget = 650;
  String dealFilter = 'All';
  String? lastMessage; // short message shown as a snackbar, e.g. "+10 XP"

  final tasks = <ArrivalTask>[
    ArrivalTask('Get a UK SIM card', 'Pick a student plan, needed for bank codes', done: true),
    ArrivalTask('Open a UK bank account', 'Bring your university enrolment letter', done: true),
    ArrivalTask('Check your eVisa and share code', 'Sign in to your UKVI account and save a share code'),
    ArrivalTask('Register with a GP', 'Use the NHS "Find a GP" service near you'),
    ArrivalTask('Apply for a National Insurance number', 'Needed before you start a part-time job'),
    ArrivalTask('Get council tax exemption', 'Send your student certificate to the council'),
    ArrivalTask('Buy a 16–25 Railcard', 'Saves a third on most train tickets'),
  ];

  final shifts = <Shift>[
    Shift('Warehouse', 8, 'Mon'),
    Shift('Café', 5, 'Wed'),
    Shift('Warehouse', 4, 'Fri'),
  ];

  final spending = <String, double>{
    'Rent': 380,
    'Food': 62.4,
    'Transport': 18,
    'Fun': 24,
    'Send home': 0,
  };

  final Set<String> joinedGroups = {'Indian Students Leicester'};

  static const deals = <Deal>[
    Deal('Patel Brothers Grocery', 'Groceries', '10% off with student ID', '0.4 mi'),
    Deal('Golden Dragon Supermarket', 'Groceries', 'Rice 10kg £14.50', '0.9 mi'),
    Deal('Campus Kitchen', 'Meals', '£3.50 lunch deal', 'On campus'),
    Deal('Spice Route Café', 'Meals', 'Thali £6, Mon–Thu', '0.6 mi'),
    Deal('16–25 Railcard', 'Travel', '⅓ off rail fares', 'Online'),
    Deal('City bus term pass', 'Travel', 'Student term ticket', 'City buses'),
    Deal('Money advice drop-in', 'Help', 'Free, at the student hub', 'Campus'),
  ];

  static const events = <EventItem>[
    EventItem('International welcome social', 'Fri · 7pm · Students’ Union'),
    EventItem('Free pizza study night', 'Wed · 6pm · Library'),
    EventItem('Christmas market trip', 'Sat · 11am · Meet at campus'),
    EventItem('Five-a-side football', 'Sun · 2pm · Sports park'),
  ];

  static const groups = <Group>[
    Group('Indian Students Leicester', 1240),
    Group('Chinese Students Society', 980),
    Group('Nigerian Students Network', 410),
    Group('Nepali Students UK', 350),
    Group('MSc AI 2026 cohort', 86),
    Group('Sunday cricket', 64),
  ];

  // ---- derived values ----
  int get level => xp ~/ 50 + 1;
  int get xpToNext => 50 - xp % 50;
  int get doneCount => tasks.where((t) => t.done).length;
  double get arrivalProgress => doneCount / tasks.length;
  double get hoursThisWeek => shifts.fold(0, (a, s) => a + s.hours);
  double get spent => spending.values.fold(0, (a, v) => a + v);
  double get left => budget - spent;
  ArrivalTask? get nextTask {
    for (final t in tasks) {
      if (!t.done) return t;
    }
    return null;
  }

  List<Deal> get filteredDeals =>
      dealFilter == 'All' ? deals : deals.where((d) => d.kind == dealFilter).toList();

  // ---- actions ----
  void _addXp(int n, String why) {
    final before = level;
    xp += n;
    lastMessage = level > before ? 'Level up! You’re now level $level' : '+$n XP · $why';
  }

  void toggleTask(ArrivalTask t) {
    t.done = !t.done;
    if (t.done) {
      _addXp(10, 'task done');
    } else {
      xp = (xp - 10).clamp(0, 1 << 30);
    }
    notifyListeners();
  }

  void addShift(String job, double hours) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    shifts.add(Shift(job.isEmpty ? 'Shift' : job, hours, days[shifts.length % 7]));
    _addXp(2, 'shift logged');
    notifyListeners();
  }

  void removeShift(int i) {
    shifts.removeAt(i);
    notifyListeners();
  }

  void setLimit(int v) {
    weeklyLimit = v;
    notifyListeners();
  }

  void setBudget(double v) {
    if (v > 0) {
      budget = v;
      notifyListeners();
    }
  }

  void addSpending(String category, double amount) {
    spending[category] = (spending[category] ?? 0) + amount;
    lastMessage = 'Added £${amount.toStringAsFixed(amount % 1 == 0 ? 0 : 2)} to $category';
    notifyListeners();
  }

  void setFilter(String f) {
    dealFilter = f;
    notifyListeners();
  }

  void toggleGroup(String name) {
    if (joinedGroups.contains(name)) {
      joinedGroups.remove(name);
    } else {
      joinedGroups.add(name);
      _addXp(5, 'joined a group');
    }
    notifyListeners();
  }

  String? takeMessage() {
    final m = lastMessage;
    lastMessage = null;
    return m;
  }
}

String gbp(double v) => '£${v.toStringAsFixed(v % 1 == 0 ? 0 : 2)}';
String hrs(double v) => '${v % 1 == 0 ? v.toInt() : v}h';
