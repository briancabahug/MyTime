import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_time/models/alarm_log.dart';
import 'package:my_time/models/timeline_entry.dart';
import 'dart:io';

void main() {
  group('AlarmLog Tests', () {
    late Box<AlarmLog> alarmLogBox;
    late Directory tempDir;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);

      // Register adapters for types used in AlarmLog and its superclass
      Hive.registerAdapter(EntryTypeAdapter());
      Hive.registerAdapter(MediaTypeAdapter());
      Hive.registerAdapter(TimelineEntryAdapter()); // Registering TimelineEntry adapter
      Hive.registerAdapter(AlarmStatusAdapter());
      Hive.registerAdapter(AlarmLogAdapter());
      alarmLogBox = await Hive.openBox<AlarmLog>('alarmLogBox');
    });

    tearDownAll(() async {
      await alarmLogBox.clear();
      await alarmLogBox.close();
      await Hive.deleteFromDisk();
      await tempDir.delete(recursive: true);
    });

    setUp(() async {
      await alarmLogBox.clear();
    });

    test('AlarmLog can be created and stored', () async {
      final now = DateTime.now();
      final alarmLog = AlarmLog(
        id: 'log1',
        timestamp: now,
        alarmId: 'alarm_id_123',
        status: AlarmStatus.done,
        notes: 'Alarm completed successfully',
      );

      await alarmLogBox.put('log1', alarmLog);
      final retrievedLog = alarmLogBox.get('log1');

      expect(retrievedLog, isNotNull);
      expect(retrievedLog?.id, 'log1');
      expect(retrievedLog?.timestamp.toIso8601String(), now.toIso8601String());
      expect(retrievedLog?.type, EntryType.alarmLog); // Inherited from TimelineEntry
      expect(retrievedLog?.alarmId, 'alarm_id_123');
      expect(retrievedLog?.status, AlarmStatus.done);
      expect(retrievedLog?.notes, 'Alarm completed successfully');
      expect(retrievedLog?.content, 'Alarm completed successfully'); // Content from superclass
    });

    test('AlarmLog handles notes as content when not null', () async {
      final now = DateTime.now();
      final alarmLog = AlarmLog(
        id: 'log2',
        timestamp: now,
        alarmId: 'alarm_id_456',
        status: AlarmStatus.missed,
        notes: 'Forgot to take medicine',
      );

      await alarmLogBox.put('log2', alarmLog);
      final retrievedLog = alarmLogBox.get('log2');

      expect(retrievedLog?.content, 'Forgot to take medicine');
    });

    test('AlarmLog uses status.toString() as content when notes are null', () async {
      final now = DateTime.now();
      final alarmLog = AlarmLog(
        id: 'log3',
        timestamp: now,
        alarmId: 'alarm_id_789',
        status: AlarmStatus.skipped,
      ); // notes are null

      await alarmLogBox.put('log3', alarmLog);
      final retrievedLog = alarmLogBox.get('log3');

      expect(retrievedLog?.content, AlarmStatus.skipped.toString());
    });

    test('AlarmStatus enum values are correctly stored and retrieved', () async {
      final now = DateTime.now();
      final log1 = AlarmLog(id: 'log4', timestamp: now, alarmId: 'a1', status: AlarmStatus.done);
      final log2 = AlarmLog(id: 'log5', timestamp: now, alarmId: 'a2', status: AlarmStatus.missed);
      final log3 = AlarmLog(id: 'log6', timestamp: now, alarmId: 'a3', status: AlarmStatus.skipped);

      await alarmLogBox.put('l1', log1);
      await alarmLogBox.put('l2', log2);
      await alarmLogBox.put('l3', log3);

      expect(alarmLogBox.get('l1')?.status, AlarmStatus.done);
      expect(alarmLogBox.get('l2')?.status, AlarmStatus.missed);
      expect(alarmLogBox.get('l3')?.status, AlarmStatus.skipped);
    });
  });
}
