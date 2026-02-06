// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailySummaryAdapter extends TypeAdapter<DailySummary> {
  @override
  final int typeId = 7;

  @override
  DailySummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySummary(
      date: fields[0] as DateTime,
      summaryNotes: fields[1] as String?,
      totalLogsCreated: fields[2] as int,
      alarmsMissed: fields[3] as int,
      alarmsCompleted: fields[4] as int,
      activeHours: fields[5] as Duration,
      noteTypeBreakdown: (fields[6] as Map).cast<EntryType, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailySummary obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.summaryNotes)
      ..writeByte(2)
      ..write(obj.totalLogsCreated)
      ..writeByte(3)
      ..write(obj.alarmsMissed)
      ..writeByte(4)
      ..write(obj.alarmsCompleted)
      ..writeByte(5)
      ..write(obj.activeHours)
      ..writeByte(6)
      ..write(obj.noteTypeBreakdown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
