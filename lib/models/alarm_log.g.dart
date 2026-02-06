// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmLogAdapter extends TypeAdapter<AlarmLog> {
  @override
  final int typeId = 6;

  @override
  AlarmLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmLog(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      alarmId: fields[8] as String,
      status: fields[9] as AlarmStatus,
      notes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmLog obj) {
    writer
      ..writeByte(11)
      ..writeByte(8)
      ..write(obj.alarmId)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.mediaType)
      ..writeByte(6)
      ..write(obj.mediaPath)
      ..writeByte(7)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlarmStatusAdapter extends TypeAdapter<AlarmStatus> {
  @override
  final int typeId = 5;

  @override
  AlarmStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AlarmStatus.done;
      case 1:
        return AlarmStatus.missed;
      case 2:
        return AlarmStatus.skipped;
      default:
        return AlarmStatus.done;
    }
  }

  @override
  void write(BinaryWriter writer, AlarmStatus obj) {
    switch (obj) {
      case AlarmStatus.done:
        writer.writeByte(0);
        break;
      case AlarmStatus.missed:
        writer.writeByte(1);
        break;
      case AlarmStatus.skipped:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
