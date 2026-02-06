// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklySummaryAdapter extends TypeAdapter<WeeklySummary> {
  @override
  final int typeId = 8;

  @override
  WeeklySummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklySummary(
      startDate: fields[0] as DateTime,
      endDate: fields[1] as DateTime,
      weeklyNotes: fields[2] as String?,
      totalLogsForWeek: fields[3] as int,
      totalAlarmsMissed: fields[4] as int,
      totalAlarmsCompleted: fields[5] as int,
      dailyLogsCount: (fields[6] as Map).cast<int, int>(),
      dailyActiveHours: (fields[7] as Map).cast<int, Duration>(),
    );
  }

  @override
  void write(BinaryWriter writer, WeeklySummary obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.endDate)
      ..writeByte(2)
      ..write(obj.weeklyNotes)
      ..writeByte(3)
      ..write(obj.totalLogsForWeek)
      ..writeByte(4)
      ..write(obj.totalAlarmsMissed)
      ..writeByte(5)
      ..write(obj.totalAlarmsCompleted)
      ..writeByte(6)
      ..write(obj.dailyLogsCount)
      ..writeByte(7)
      ..write(obj.dailyActiveHours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklySummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
