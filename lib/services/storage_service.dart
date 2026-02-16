import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:my_time/models/alarm.dart';
import 'package:my_time/models/alarm_log.dart';
import 'package:my_time/models/daily_summary.dart';
import 'package:my_time/models/duration_adapter.dart';
import 'package:my_time/models/time_of_day.dart';
import 'package:my_time/models/timeline_entry.dart';
import 'package:my_time/models/weekly_summary.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class StorageService {
  static const String timelineBoxName = 'timeline_entries';
  static const String alarmsBoxName = 'alarms';
  static const String alarmLogsBoxName = 'alarm_logs';
  static const String dailySummaryBoxName = 'daily_summaries';
  static const String weeklySummaryBoxName = 'weekly_summaries';

  static Future<void> init() async {
    if (!kIsWeb) {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    } else {
      // For web, Hive uses IndexedDB and doesn't need a path.
      // The name here is just for identification in the browser's developer tools.
      Hive.init('MyTimeDB');
    }

    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(TimelineEntryAdapter());
    Hive.registerAdapter(AlarmAdapter());
    Hive.registerAdapter(AlarmLogAdapter());
    Hive.registerAdapter(DailySummaryAdapter());
    Hive.registerAdapter(WeeklySummaryAdapter());

    await Hive.openBox<TimelineEntry>(timelineBoxName);
    await Hive.openBox<Alarm>(alarmsBoxName);
    await Hive.openBox<AlarmLog>(alarmLogsBoxName);
    await Hive.openBox<DailySummary>(dailySummaryBoxName);
    await Hive.openBox<WeeklySummary>(weeklySummaryBoxName);
  }

  static String _dateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Timeline Entry Methods
  static Box<TimelineEntry> _getTimelineBox() =>
      Hive.box<TimelineEntry>(timelineBoxName);

  static Future<void> saveEntry(TimelineEntry entry) async {
    await _getTimelineBox().put(entry.id, entry);
  }

  static Future<void> updateEntry(TimelineEntry entry) async {
    // Hive's put method works for both creation and updates.
    await _getTimelineBox().put(entry.id, entry);
  }

  static Future<void> deleteEntry(String entryId) async {
    await _getTimelineBox().delete(entryId);
  }

  static List<TimelineEntry> getEntriesForDay(DateTime date) {
    final box = _getTimelineBox();
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));
    return box.values
        .where((entry) =>
            entry.timestamp.isAtSameMomentAs(startDate) ||
            (entry.timestamp.isAfter(startDate) &&
                entry.timestamp.isBefore(endDate)))
        .toList();
  }

  // Alarm Methods
  static Box<Alarm> _getAlarmsBox() => Hive.box<Alarm>(alarmsBoxName);

  static Future<void> saveAlarm(Alarm alarm) async {
    await _getAlarmsBox().put(alarm.id, alarm);
  }

  static Future<void> deleteAlarm(String alarmId) async {
    await _getAlarmsBox().delete(alarmId);
  }

  static List<Alarm> getAllAlarms() {
    return _getAlarmsBox().values.toList();
  }

  // Alarm Log Methods
  static Box<AlarmLog> _getAlarmLogsBox() =>
      Hive.box<AlarmLog>(alarmLogsBoxName);

  static Future<void> saveAlarmLog(AlarmLog log) async {
    // Using add() for logs as they don't need a specific key.
    await _getAlarmLogsBox().add(log);
  }

  static List<AlarmLog> getAlarmLogsForDay(DateTime date) {
    final box = _getAlarmLogsBox();
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));
    return box.values
        .where((log) =>
            log.timestamp.isAtSameMomentAs(startDate) ||
            (log.timestamp.isAfter(startDate) &&
                log.timestamp.isBefore(endDate)))
        .toList();
  }

  // Summary Methods
  static Box<DailySummary> _getDailySummaryBox() =>
      Hive.box<DailySummary>(dailySummaryBoxName);
  static Box<WeeklySummary> _getWeeklySummaryBox() =>
      Hive.box<WeeklySummary>(weeklySummaryBoxName);

  static Future<void> saveDailySummary(DailySummary summary) async {
    await _getDailySummaryBox().put(_dateKey(summary.date), summary);
  }

  static DailySummary? getDailySummary(DateTime date) {
    return _getDailySummaryBox().get(_dateKey(date));
  }

  static Future<void> saveWeeklySummary(WeeklySummary summary) async {
    await _getWeeklySummaryBox().put(summary.yearAndWeek, summary);
  }

  static WeeklySummary? getWeeklySummary(int year, int weekNumber) {
    final key = '$year-$weekNumber';
    return _getWeeklySummaryBox().get(key);
  }
}
