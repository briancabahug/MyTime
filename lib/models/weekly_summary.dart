import 'package:hive/hive.dart';
import 'package:my_time/lib/models/daily_summary.dart'; // Import DailySummary for potential aggregation

part 'weekly_summary.g.dart';

@HiveType(typeId: 8)
class WeeklySummary {
  @HiveField(0)
  final DateTime startDate; // Start of the week, e.g., Monday
  @HiveField(1)
  final DateTime endDate;   // End of the week, e.g., Sunday
  @HiveField(2)
  final String? weeklyNotes;
  @HiveField(3)
  final int totalLogsForWeek;
  @HiveField(4)
  final int totalAlarmsMissed;
  @HiveField(5)
  final int totalAlarmsCompleted;
  @HiveField(6)
  final Map<int, int> dailyLogsCount; // Key: weekday (1-7 for Mon-Sun), Value: count
  @HiveField(7)
  final Map<int, Duration> dailyActiveHours; // Key: weekday, Value: active duration

  WeeklySummary({
    required this.startDate,
    required this.endDate,
    this.weeklyNotes,
    this.totalLogsForWeek = 0,
    this.totalAlarmsMissed = 0,
    this.totalAlarmsCompleted = 0,
    this.dailyLogsCount = const {},
    this.dailyActiveHours = const {},
  });
}
