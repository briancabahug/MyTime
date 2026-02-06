import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_time/models/timeline_entry.dart';
import 'dart:io';

void main() {
  group('TimelineEntry Tests', () {
    late Box<TimelineEntry> timelineEntryBox;
    late Directory tempDir;

    setUpAll(() async {
      // Create a temporary directory for Hive testing
      tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);

      Hive.registerAdapter(EntryTypeAdapter());
      Hive.registerAdapter(MediaTypeAdapter());
      Hive.registerAdapter(TimelineEntryAdapter());
      timelineEntryBox = await Hive.openBox<TimelineEntry>('timelineEntryBox');
    });

    tearDownAll(() async {
      await timelineEntryBox.clear();
      await timelineEntryBox.close();
      await Hive.deleteFromDisk();
      await tempDir.delete(recursive: true); // Clean up the temporary directory
    });

    setUp(() async {
      await timelineEntryBox.clear();
    });

    test('TimelineEntry can be created and stored', () async {
      final entry = TimelineEntry(
        id: '1',
        timestamp: DateTime.now(),
        type: EntryType.quickNote,
        content: 'Test quick note',
      );

      await timelineEntryBox.put('entry1', entry);
      final retrievedEntry = timelineEntryBox.get('entry1');

      expect(retrievedEntry, isNotNull);
      expect(retrievedEntry?.id, '1');
      expect(retrievedEntry?.type, EntryType.quickNote);
      expect(retrievedEntry?.content, 'Test quick note');
    });

    test('TimelineEntry with all fields can be created and stored', () async {
      final now = DateTime.now();
      final entry = TimelineEntry(
        id: '2',
        timestamp: now,
        type: EntryType.reflection,
        title: 'Deep Thoughts',
        content: 'This is a long reflection with some interesting media.',
        mediaType: MediaType.image,
        mediaPath: '/path/to/image.jpg',
        tags: ['thought', 'media', 'test'],
      );

      await timelineEntryBox.put('entry2', entry);
      final retrievedEntry = timelineEntryBox.get('entry2');

      expect(retrievedEntry, isNotNull);
      expect(retrievedEntry?.id, '2');
      expect(retrievedEntry?.timestamp.toIso8601String(), now.toIso8601String());
      expect(retrievedEntry?.type, EntryType.reflection);
      expect(retrievedEntry?.title, 'Deep Thoughts');
      expect(retrievedEntry?.content, 'This is a long reflection with some interesting media.');
      expect(retrievedEntry?.mediaType, MediaType.image);
      expect(retrievedEntry?.mediaPath, '/path/to/image.jpg');
      expect(retrievedEntry?.tags, ['thought', 'media', 'test']);
    });

    test('TimelineEntry handles null/default values correctly', () async {
      final entry = TimelineEntry(
        id: '3',
        timestamp: DateTime.now(),
        type: EntryType.alarmLog,
        content: 'Alarm dismissed',
      ); // No title, media, or tags

      await timelineEntryBox.put('entry3', entry);
      final retrievedEntry = timelineEntryBox.get('entry3');

      expect(retrievedEntry, isNotNull);
      expect(retrievedEntry?.id, '3');
      expect(retrievedEntry?.title, isNull);
      expect(retrievedEntry?.mediaType, MediaType.none);
      expect(retrievedEntry?.mediaPath, isNull);
      expect(retrievedEntry?.tags, isEmpty);
    });

    test('EntryType enum values are correctly stored and retrieved', () async {
      final entry1 = TimelineEntry(id: '4', timestamp: DateTime.now(), type: EntryType.quickNote, content: 'qn');
      final entry2 = TimelineEntry(id: '5', timestamp: DateTime.now(), type: EntryType.reflection, content: 're');
      final entry3 = TimelineEntry(id: '6', timestamp: DateTime.now(), type: EntryType.alarmLog, content: 'al');

      await timelineEntryBox.put('e1', entry1);
      await timelineEntryBox.put('e2', entry2);
      await timelineEntryBox.put('e3', entry3);

      expect(timelineEntryBox.get('e1')?.type, EntryType.quickNote);
      expect(timelineEntryBox.get('e2')?.type, EntryType.reflection);
      expect(timelineEntryBox.get('e3')?.type, EntryType.alarmLog);
    });

    test('MediaType enum values are correctly stored and retrieved', () async {
      final entry1 = TimelineEntry(id: '7', timestamp: DateTime.now(), type: EntryType.quickNote, content: 'no', mediaType: MediaType.none);
      final entry2 = TimelineEntry(id: '8', timestamp: DateTime.now(), type: EntryType.quickNote, content: 'im', mediaType: MediaType.image);
      final entry3 = TimelineEntry(id: '9', timestamp: DateTime.now(), type: EntryType.quickNote, content: 'vi', mediaType: MediaType.video);
      final entry4 = TimelineEntry(id: '10', timestamp: DateTime.now(), type: EntryType.quickNote, content: 'au', mediaType: MediaType.audio);

      await timelineEntryBox.put('m1', entry1);
      await timelineEntryBox.put('m2', entry2);
      await timelineEntryBox.put('m3', entry3);
      await timelineEntryBox.put('m4', entry4);

      expect(timelineEntryBox.get('m1')?.mediaType, MediaType.none);
      expect(timelineEntryBox.get('m2')?.mediaType, MediaType.image);
      expect(timelineEntryBox.get('m3')?.mediaType, MediaType.video);
      expect(timelineEntryBox.get('m4')?.mediaType, MediaType.audio);
    });
  });
}
