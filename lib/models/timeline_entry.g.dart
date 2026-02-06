// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimelineEntryAdapter extends TypeAdapter<TimelineEntry> {
  @override
  final int typeId = 2;

  @override
  TimelineEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimelineEntry(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      type: fields[2] as EntryType,
      title: fields[3] as String?,
      content: fields[4] as String,
      mediaType: fields[5] as MediaType,
      mediaPath: fields[6] as String?,
      tags: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TimelineEntry obj) {
    writer
      ..writeByte(8)
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
      other is TimelineEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EntryTypeAdapter extends TypeAdapter<EntryType> {
  @override
  final int typeId = 0;

  @override
  EntryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EntryType.quickNote;
      case 1:
        return EntryType.reflection;
      case 2:
        return EntryType.alarmLog;
      default:
        return EntryType.quickNote;
    }
  }

  @override
  void write(BinaryWriter writer, EntryType obj) {
    switch (obj) {
      case EntryType.quickNote:
        writer.writeByte(0);
        break;
      case EntryType.reflection:
        writer.writeByte(1);
        break;
      case EntryType.alarmLog:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaTypeAdapter extends TypeAdapter<MediaType> {
  @override
  final int typeId = 1;

  @override
  MediaType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MediaType.none;
      case 1:
        return MediaType.image;
      case 2:
        return MediaType.video;
      case 3:
        return MediaType.audio;
      default:
        return MediaType.none;
    }
  }

  @override
  void write(BinaryWriter writer, MediaType obj) {
    switch (obj) {
      case MediaType.none:
        writer.writeByte(0);
        break;
      case MediaType.image:
        writer.writeByte(1);
        break;
      case MediaType.video:
        writer.writeByte(2);
        break;
      case MediaType.audio:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
