import 'package:hive/hive.dart';

part 'time_of_day.g.dart';

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
