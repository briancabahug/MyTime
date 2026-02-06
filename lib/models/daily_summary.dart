import 'package:hive/hive.dart';
import 'package:my_time/models/timeline_entry.dart';

part 'daily_summary.g.dart';

@HiveType(typeId: 7)
class DailySummary {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final String? summaryNotes;
  @HiveField(2)
  final int totalLogsCreated;
  @HiveField(3)
  final int alarmsMissed;
  @HiveField(4)
  final int alarmsCompleted;
  @HiveField(5)
  final Duration activeHours;
  @HiveField(6)
  final Map<EntryType, int> noteTypeBreakdown;

  DailySummary({
    required this.date,
    this.summaryNotes,
    this.totalLogsCreated = 0,
    this.alarmsMissed = 0,
    this.alarmsCompleted = 0,
    this.activeHours = Duration.zero,
    this.noteTypeBreakdown = const {},
  });
}
