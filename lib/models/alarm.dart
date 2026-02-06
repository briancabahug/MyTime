import 'package:hive/hive.dart';

part 'alarm.g.dart';

@HiveType(typeId: 4)
class TimeOfDay {
  @HiveField(0)
  final int hour;
  @HiveField(1)
  final int minute;

  TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

@HiveType(typeId: 3)
class Alarm {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final TimeOfDay time;
  @HiveField(3)
  final List<int> recurrenceDays; // 0 for Monday, 6 for Sunday
  @HiveField(4)
  bool isActive;

  Alarm({
    required this.id,
    required this.title,
    required this.time,
    this.recurrenceDays = const [],
    this.isActive = true,
  });
}
