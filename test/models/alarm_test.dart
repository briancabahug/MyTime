import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_time/models/alarm.dart';
import 'dart:io';

void main() {
  group('Alarm Tests', () {
    late Box<Alarm> alarmBox;
    late Directory tempDir;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);

      Hive.registerAdapter(TimeOfDayAdapter());
      Hive.registerAdapter(AlarmAdapter());
      alarmBox = await Hive.openBox<Alarm>('alarmBox');
    });

    tearDownAll(() async {
      await alarmBox.clear();
      await alarmBox.close();
      await Hive.deleteFromDisk();
      await tempDir.delete(recursive: true);
    });

    setUp(() async {
      await alarmBox.clear();
    });

    test('TimeOfDay can be created and stored', () {
      final time = TimeOfDay(hour: 10, minute: 30);
      expect(time.hour, 10);
      expect(time.minute, 30);
      expect(time.toString(), '10:30');
    });

    test('Alarm can be created and stored', () async {
      final time = TimeOfDay(hour: 7, minute: 0);
      final alarm = Alarm(
        id: 'alarm1',
        title: 'Morning Meeting',
        time: time,
        recurrenceDays: [1, 2, 3, 4, 5], // Monday to Friday
        isActive: true,
      );

      await alarmBox.put('alarm1', alarm);
      final retrievedAlarm = alarmBox.get('alarm1');

      expect(retrievedAlarm, isNotNull);
      expect(retrievedAlarm?.id, 'alarm1');
      expect(retrievedAlarm?.title, 'Morning Meeting');
      expect(retrievedAlarm?.time.hour, 7);
      expect(retrievedAlarm?.time.minute, 0);
      expect(retrievedAlarm?.recurrenceDays, [1, 2, 3, 4, 5]);
      expect(retrievedAlarm?.isActive, isTrue);
    });

    test('Alarm handles default isActive correctly', () async {
      final time = TimeOfDay(hour: 12, minute: 0);
      final alarm = Alarm(
        id: 'alarm2',
        title: 'Lunch',
        time: time,
      ); // isActive defaults to true

      await alarmBox.put('alarm2', alarm);
      final retrievedAlarm = alarmBox.get('alarm2');

      expect(retrievedAlarm?.isActive, isTrue);
    });

    test('Alarm handles empty recurrenceDays correctly', () async {
      final time = TimeOfDay(hour: 20, minute: 0);
      final alarm = Alarm(
        id: 'alarm3',
        title: 'Evening Reminder',
        time: time,
        recurrenceDays: [],
        isActive: false,
      );

      await alarmBox.put('alarm3', alarm);
      final retrievedAlarm = alarmBox.get('alarm3');

      expect(retrievedAlarm?.recurrenceDays, isEmpty);
      expect(retrievedAlarm?.isActive, isFalse);
    });
  });
}
