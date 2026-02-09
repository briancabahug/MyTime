import 'package:hive/hive.dart';
import 'package:my_time/models/time_of_day.dart';

part 'alarm.g.dart';

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
