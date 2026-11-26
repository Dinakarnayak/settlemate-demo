import '../arrival.dart';
import '../assistant.dart';
import '../guides.dart';
import '../referrals.dart';
import 'country.dart';

const gbPack = CountryPack(
  code: 'GB',
  name: 'United Kingdom',
  flag: '🇬🇧',
  currencyCode: 'GBP',
  currencySymbol: '£',
  studentVisaName: 'Student visa',
  defaultBudget: 800,
  work: WorkRule(
    period: LimitPeriod.week,
    limit: 20,
    belowDegreeLimit: 10,
    summary: 'Term time: up to 20 hours a week at degree level (10 below degree level). Monday–Sunday, all jobs count together.',
    breaksNote: 'Full time is allowed during your university’s official vacations.',
    officialUrl: 'https://ukcisa.org.uk/student-advice/working/student-work/',
  ),
  emergency: [
    EmergencyNumber('999', 'Emergency', 'Police, ambulance, fire', primary: true),
    EmergencyNumber('111', 'NHS 111', 'Urgent medical advice'),
    EmergencyNumber('101', 'Police', 'Non-emergency'),
    EmergencyNumber('116123', 'Samaritans', 'Free, 24/7 support'),
    EmergencyNumber('03001232040', 'Report Fraud', 'Scams and fraud'),
  ],
  arrivalTasks: ukArrivalTasks,
  guides: ukGuides,
  answers: ukAnswers,
  providers: providers,
  cities: ['London', 'Manchester', 'Birmingham', 'Leicester', 'Glasgow', 'Edinburgh', 'Leeds', 'Nottingham'],
);
