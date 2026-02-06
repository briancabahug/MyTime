import 'package:hive/hive.dart';

part 'timeline_entry.g.dart';

@HiveType(typeId: 0)
enum EntryType {
  @HiveField(0)
  quickNote,
  @HiveField(1)
  reflection,
  @HiveField(2)
  alarmLog,
}

@HiveType(typeId: 1)
enum MediaType {
  @HiveField(0)
  none,
  @HiveField(1)
  image,
  @HiveField(2)
  video,
  @HiveField(3)
  audio,
}

@HiveType(typeId: 2)
class TimelineEntry {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime timestamp;
  @HiveField(2)
  final EntryType type;
  @HiveField(3)
  final String? title;
  @HiveField(4)
  final String content;
  @HiveField(5)
  final MediaType mediaType;
  @HiveField(6)
  final String? mediaPath;
  @HiveField(7)
  final List<String> tags;

  TimelineEntry({
    required this.id,
    required this.timestamp,
    required this.type,
    this.title,
    required this.content,
    this.mediaType = MediaType.none,
    this.mediaPath,
    this.tags = const [],
  });
}
