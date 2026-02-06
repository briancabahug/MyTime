import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_time/models/weekly_summary.dart';
import 'package:my_time/models/duration_adapter.dart'; // Import DurationAdapter
import 'package:my_time/models/timeline_entry.dart'; // For EntryType
import 'dart:io';

void main() {
  group('WeeklySummary Tests', () {
    late Box<WeeklySummary> weeklySummaryBox;
    late Directory tempDir;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);

      // Register adapters for types used in WeeklySummary
      Hive.registerAdapter(DurationAdapter());
      Hive.registerAdapter(EntryTypeAdapter()); // Needed for dailyActiveHours map key
      Hive.registerAdapter(WeeklySummaryAdapter());
      weeklySummaryBox = await Hive.openBox<WeeklySummary>('weeklySummaryBox');
    });

    tearDownAll(() async {
      await weeklySummaryBox.clear();
      await weeklySummaryBox.close();
      await Hive.deleteFromDisk();
      await tempDir.delete(recursive: true);
    });

    setUp(() async {
      await weeklySummaryBox.clear();
    });

    test('WeeklySummary can be created and stored with default values', () async {
      final startDate = DateTime(2023, 1, 1);
      final endDate = DateTime(2023, 1, 7);
      final summary = WeeklySummary(startDate: startDate, endDate: endDate);

      await weeklySummaryBox.put('weeklySummary1', summary);
      final retrievedSummary = weeklySummaryBox.get('weeklySummary1');

      expect(retrievedSummary, isNotNull);
      expect(retrievedSummary?.startDate.toIso8601String(), startDate.toIso8601String());
      expect(retrievedSummary?.endDate.toIso8601String(), endDate.toIso8601String());
      expect(retrievedSummary?.weeklyNotes, isNull);
      expect(retrievedSummary?.totalLogsForWeek, 0);
      expect(retrievedSummary?.totalAlarmsMissed, 0);
      expect(retrievedSummary?.totalAlarmsCompleted, 0);
      expect(retrievedSummary?.dailyLogsCount, isEmpty);
      expect(retrievedSummary?.dailyActiveHours, isEmpty);
    });

    test('WeeklySummary can be created and stored with custom values', () async {
      final startDate = DateTime(2023, 1, 8);
      final endDate = DateTime(2023, 1, 14);
      final summary = WeeklySummary(
        startDate: startDate,
        endDate: endDate,
        weeklyNotes: 'A busy week',
        totalLogsForWeek: 50,
        totalAlarmsMissed: 3,
        totalAlarmsCompleted: 10,
        dailyLogsCount: {1: 10, 2: 8, 3: 12, 4: 9, 5: 7, 6: 4, 7: 0},
        dailyActiveHours: {
          1: const Duration(hours: 6),
          3: const Duration(hours: 8, minutes: 30),
          5: const Duration(hours: 5, minutes: 15),
        },
      );

      await weeklySummaryBox.put('weeklySummary2', summary);
      final retrievedSummary = weeklySummaryBox.get('weeklySummary2');

      expect(retrievedSummary, isNotNull);
      expect(retrievedSummary?.startDate.toIso8601String(), startDate.toIso8601String());
      expect(retrievedSummary?.endDate.toIso8601String(), endDate.toIso8601String());
      expect(retrievedSummary?.weeklyNotes, 'A busy week');
      expect(retrievedSummary?.totalLogsForWeek, 50);
      expect(retrievedSummary?.totalAlarmsMissed, 3);
      expect(retrievedSummary?.totalAlarmsCompleted, 10);
      expect(retrievedSummary?.dailyLogsCount, {1: 10, 2: 8, 3: 12, 4: 9, 5: 7, 6: 4, 7: 0});
      expect(retrievedSummary?.dailyActiveHours[1]?.inHours, const Duration(hours: 6).inHours);
      expect(retrievedSummary?.dailyActiveHours[3]?.inMinutes, const Duration(hours: 8, minutes: 30).inMinutes);
      expect(retrievedSummary?.dailyActiveHours[5]?.inMinutes, const Duration(hours: 5, minutes: 15).inMinutes);
    });
  });
}
