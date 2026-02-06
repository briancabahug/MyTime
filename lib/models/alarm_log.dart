import 'package:hive/hive.dart';
import 'package:my_time/models/timeline_entry.dart';

part 'alarm_log.g.dart';

@HiveType(typeId: 5)
enum AlarmStatus {
  @HiveField(0)
  done,
  @HiveField(1)
  missed,
  @HiveField(2)
  skipped,
}

@HiveType(typeId: 6)
class AlarmLog extends TimelineEntry {
  @HiveField(8) // Starting from 8 as TimelineEntry uses 0-7
  final String alarmId;
  @HiveField(9)
  final AlarmStatus status;
  @HiveField(10)
  final String? notes;

  AlarmLog({
    required String id,
    required DateTime timestamp,
    required this.alarmId,
    required this.status,
    this.notes,
  }) : super(
          id: id,
          timestamp: timestamp,
          type: EntryType.alarmLog,
          content: notes ?? status.toString(),
        );
}
