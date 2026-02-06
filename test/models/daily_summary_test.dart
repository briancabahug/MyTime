import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_time/models/daily_summary.dart';
import 'package:my_time/models/timeline_entry.dart'; // For EntryType
import 'package:my_time/models/duration_adapter.dart'; // Import DurationAdapter
import 'dart:io';

void main() {
  group('DailySummary Tests', () {
    late Box<DailySummary> dailySummaryBox;
    late Directory tempDir;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);

      // Register adapters for types used in DailySummary
      Hive.registerAdapter(EntryTypeAdapter()); // Required for Map<EntryType, int>
      Hive.registerAdapter(DurationAdapter()); // Register DurationAdapter
      Hive.registerAdapter(DailySummaryAdapter());
      dailySummaryBox = await Hive.openBox<DailySummary>('dailySummaryBox');
    });

    tearDownAll(() async {
      await dailySummaryBox.clear();
      await dailySummaryBox.close();
      await Hive.deleteFromDisk();
      await tempDir.delete(recursive: true);
    });

    setUp(() async {
      await dailySummaryBox.clear();
    });

    test('DailySummary can be created and stored with default values', () async {
      final date = DateTime(2023, 1, 1);
      final summary = DailySummary(date: date);

      await dailySummaryBox.put('summary1', summary);
      final retrievedSummary = dailySummaryBox.get('summary1');

      expect(retrievedSummary, isNotNull);
      expect(retrievedSummary?.date.toIso8601String(), date.toIso8601String());
      expect(retrievedSummary?.summaryNotes, isNull);
      expect(retrievedSummary?.totalLogsCreated, 0);
      expect(retrievedSummary?.alarmsMissed, 0);
      expect(retrievedSummary?.alarmsCompleted, 0);
      expect(retrievedSummary?.activeHours, Duration.zero);
      expect(retrievedSummary?.noteTypeBreakdown, isEmpty);
    });

    test('DailySummary can be created and stored with custom values', () async {
      final date = DateTime(2023, 1, 15);
      final summary = DailySummary(
        date: date,
        summaryNotes: 'A productive day',
        totalLogsCreated: 10,
        alarmsMissed: 1,
        alarmsCompleted: 5,
        activeHours: const Duration(hours: 8, minutes: 30),
        noteTypeBreakdown: {
          EntryType.quickNote: 7,
          EntryType.reflection: 2,
          EntryType.alarmLog: 1,
        },
      );

      await dailySummaryBox.put('summary2', summary);
      final retrievedSummary = dailySummaryBox.get('summary2');

      expect(retrievedSummary, isNotNull);
      expect(retrievedSummary?.date.toIso8601String(), date.toIso8601String());
      expect(retrievedSummary?.summaryNotes, 'A productive day');
      expect(retrievedSummary?.totalLogsCreated, 10);
      expect(retrievedSummary?.alarmsMissed, 1);
      expect(retrievedSummary?.alarmsCompleted, 5);
      expect(retrievedSummary?.activeHours.inMinutes, const Duration(hours: 8, minutes: 30).inMinutes);
      expect(retrievedSummary?.noteTypeBreakdown[EntryType.quickNote], 7);
      expect(retrievedSummary?.noteTypeBreakdown[EntryType.reflection], 2);
      expect(retrievedSummary?.noteTypeBreakdown[EntryType.alarmLog], 1);
    });

    test('DailySummary handles empty noteTypeBreakdown correctly', () async {
      final date = DateTime(2023, 1, 2);
      final summary = DailySummary(
        date: date,
        totalLogsCreated: 0,
        noteTypeBreakdown: {},
      );

      await dailySummaryBox.put('summary3', summary);
      final retrievedSummary = dailySummaryBox.get('summary3');

      expect(retrievedSummary?.noteTypeBreakdown, isEmpty);
    });
  });
}
