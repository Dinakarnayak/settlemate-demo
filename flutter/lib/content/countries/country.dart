// A "country pack": everything that changes with the country you study in.
import '../../data/models.dart';
import '../assistant.dart';
import '../guides.dart';
import '../referrals.dart';

/// How a country limits student work during term time.
enum LimitPeriod {
  /// Hours per Monday–Sunday week (UK, USA, Canada, Ireland, New Zealand).
  week,

  /// Hours per 14 days starting on a Monday (Australia).
  fortnight,

  /// Working days per calendar year; up to 4 hours counts as half a day (Germany).
  yearDays,

  /// Hours per year (France).
  yearHours,
}

class WorkRule {
  const WorkRule({
    required this.period,
    required this.limit,
    this.belowDegreeLimit,
    required this.summary,
    this.breaksNote,
    required this.officialUrl,
  });

  final LimitPeriod period;

  /// Default limit for degree-level students (hours, or days for [LimitPeriod.yearDays]).
  final double limit;

  /// Lower limit for courses below degree level, where the country has one.
  final double? belowDegreeLimit;

  /// One-line description shown on the Work screen.
  final String summary;

  /// What changes during holidays.
  final String? breaksNote;
  final String officialUrl;

  bool get isDays => period == LimitPeriod.yearDays;

  String get periodName => switch (period) {
        LimitPeriod.week => 'week',
        LimitPeriod.fortnight => 'fortnight',
        LimitPeriod.yearDays || LimitPeriod.yearHours => 'year',
      };
}

class EmergencyNumber {
  const EmergencyNumber(this.number, this.title, this.subtitle, {this.primary = false});
  final String number;
  final String title;
  final String subtitle;
  final bool primary;
}

class CountryPack {
  const CountryPack({
    required this.code,
    required this.name,
    required this.flag,
    required this.currencyCode,
    required this.currencySymbol,
    this.symbolAfter = false,
    required this.studentVisaName,
    required this.work,
    required this.emergency,
    required this.arrivalTasks,
    required this.guides,
    required this.answers,
    this.providers = const [],
    this.defaultBudget = 1000,
    this.fullySupported = true,
    this.cities = const [],
  });

  final String code; // ISO 3166 alpha-2
  final String name;
  final String flag;
  final String currencyCode;
  final String currencySymbol;
  final bool symbolAfter; // e.g. "12 €" in France/Germany
  final String studentVisaName;
  final WorkRule work;
  final List<EmergencyNumber> emergency;
  final List<TaskItem> Function() arrivalTasks;
  final List<Guide> guides;
  final List<Answer> answers;
  final List<Provider> providers;
  final double defaultBudget;

  /// False for the general "other country" pack without checked local rules.
  final bool fullySupported;
  final List<String> cities;

  EmergencyNumber get mainEmergency => emergency.firstWhere((e) => e.primary, orElse: () => emergency.first);

  String money(double v) {
    final neg = v < 0;
    final a = v.abs();
    final s = a % 1 == 0 ? a.toStringAsFixed(0) : a.toStringAsFixed(2);
    final body = symbolAfter ? '$s $currencySymbol' : '$currencySymbol$s';
    return '${neg ? '−' : ''}$body';
  }
}
