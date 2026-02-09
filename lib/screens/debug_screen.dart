import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:my_time/models/alarm.dart' as app_models; // Alias our alarm model
import 'package:my_time/models/alarm_log.dart';
import 'package:my_time/models/daily_summary.dart';
import 'package:my_time/models/timeline_entry.dart';
import 'package:my_time/models/weekly_summary.dart';
import 'package:my_time/models/duration_adapter.dart'; // Import DurationAdapter
import 'dart:convert'; // For JSON encoding/decoding

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _hivePath = 'Fetching...';
  List<Map<String, dynamic>> _hiveBoxesInfo = [];
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    await _getHivePath();
    await _getHiveBoxesInfo();
  }

  Future<void> _getHivePath() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      if (mounted) {
        setState(() {
          _hivePath = appDocumentDir.path;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hivePath = 'Error: ${e.toString()}';
        });
      }
    }
  }

  // Helper function to format model objects for display
  Map<String, dynamic> _formatModelForDisplay(dynamic obj) {
    if (obj == null) return {'value': 'null'};
    if (obj is TimelineEntry) {
      return {
        'id': obj.id,
        'timestamp': obj.timestamp.toIso8601String(),
        'type': obj.type.toString().split('.').last,
        'title': obj.title,
        'content': obj.content,
        'mediaType': obj.mediaType.toString().split('.').last,
        'mediaPath': obj.mediaPath,
        'tags': obj.tags,
      };
    } else if (obj is app_models.Alarm) {
      return {
        'id': obj.id,
        'title': obj.title,
        'time': obj.time.toString(),
        'recurrenceDays': obj.recurrenceDays,
        'isActive': obj.isActive,
      };
    } else if (obj is AlarmLog) {
      return {
        'id': obj.id,
        'timestamp': obj.timestamp.toIso8601String(),
        'alarmId': obj.alarmId,
        'status': obj.status.toString().split('.').last,
        'notes': obj.notes,
        'content': obj.content, // Inherited from TimelineEntry
      };
    } else if (obj is DailySummary) {
      return {
        'date': obj.date.toIso8601String(),
        'summaryNotes': obj.summaryNotes,
        'totalLogsCreated': obj.totalLogsCreated,
        'alarmsMissed': obj.alarmsMissed,
        'alarmsCompleted': obj.alarmsCompleted,
        'activeHours': obj.activeHours.inMinutes, // Display in minutes
        'noteTypeBreakdown': obj.noteTypeBreakdown.map((k, v) => MapEntry(k.toString().split('.').last, v)),
      };
    } else if (obj is WeeklySummary) {
      return {
        'startDate': obj.startDate.toIso8601String(),
        'endDate': obj.endDate.toIso8601String(),
        'weeklyNotes': obj.weeklyNotes,
        'totalLogsForWeek': obj.totalLogsForWeek,
        'totalAlarmsMissed': obj.totalAlarmsMissed,
        'totalAlarmsCompleted': obj.totalAlarmsCompleted,
        'dailyLogsCount': obj.dailyLogsCount,
        'dailyActiveHours': obj.dailyActiveHours.map((k, v) => MapEntry(k.toString(), v.inMinutes)),
      };
    } else if (obj is app_models.TimeOfDay) {
      return {
        'hour': obj.hour,
        'minute': obj.minute,
      };
    }
    // Fallback for other types or primitives
    return {'value': obj.toString(), 'runtimeType': obj.runtimeType.toString()};
  }

  Future<void> _getHiveBoxesInfo() async {
    // Ensure all adapters are registered before opening boxes
    // This is crucial if Hive has not been fully initialized elsewhere
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(EntryTypeAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(MediaTypeAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TimelineEntryAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(app_models.AlarmAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(app_models.TimeOfDayAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(AlarmStatusAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(AlarmLogAdapter());
    if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(DailySummaryAdapter());
    if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(WeeklySummaryAdapter());
    if (!Hive.isAdapterRegistered(9)) Hive.registerAdapter(DurationAdapter());

    final List<String> boxNamesToDisplay = [
      'timelineEntryBox',
      'alarmBox',
      'alarmLogBox',
      'dailySummaryBox',
      'weeklySummaryBox',
    ];

    int totalRecordsCount = 0;
    List<Map<String, dynamic>> currentBoxesInfo = [];

    for (String boxName in boxNamesToDisplay) {
      try {
        // Open box only if not already open
        if (!Hive.isBoxOpen(boxName)) {
          // Hive.openBox returns Future<Box<dynamic>>
          await Hive.openBox(boxName);
        }
        final box = Hive.box(boxName);
        final count = box.length;
        currentBoxesInfo.add({'name': boxName, 'count': count});
        totalRecordsCount += count;
      } catch (e) {
        currentBoxesInfo.add({'name': '$boxName (Error)', 'count': 0, 'error': e.toString()});
      }
    }

    if (mounted) {
      setState(() {
        _hiveBoxesInfo = currentBoxesInfo;
        _totalRecords = totalRecordsCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Information'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoTile('App Version', '1.0.0+1 (Placeholder)'),
          _buildInfoTile('Build Number', '1 (Placeholder)'),
          _buildInfoTile('Hive Path', _hivePath),
          _buildInfoTile('Total Hive Boxes Open', _hiveBoxesInfo.length.toString()),
          _buildInfoTile('Total Records Across Boxes', _totalRecords.toString()),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Hive Boxes:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ..._hiveBoxesInfo.map((info) => ListTile(
            title: Text(info['name']),
            trailing: Text('Records: ${info['count']}'),
            onTap: info['error'] != null
                ? null
                : () {
                    _showBoxContents(context, info['name']);
                  },
          )),
          const Divider(),
          ListTile(
            title: const Text('Clear All Hive Data'),
            subtitle: const Text('This will delete all local app data.'),
            trailing: const Icon(Icons.warning_amber),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Data Deletion'),
                  content: const Text('Are you sure you want to clear all Hive data? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await Hive.deleteFromDisk();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All Hive data cleared.')),
                );
                _loadDebugInfo(); // Reload info after clearing
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }

  void _showBoxContents(BuildContext context, String boxName) {
    final box = Hive.box(boxName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Contents of $boxName'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _showAddRecordDialog(context, boxName);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () {
                      _confirmClearBox(context, boxName);
                    },
                  ),
                ],
              ),
              body: box.isEmpty
                  ? const Center(child: Text('Box is empty.'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final key = box.keyAt(index);
                        final value = box.getAt(index);
                        final formattedValue = _formatModelForDisplay(value);

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ExpansionTile(
                            title: Text('Key: $key'),
                            subtitle: Text('Type: ${value.runtimeType}'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...formattedValue.entries.map((entry) => Text('${entry.key}: ${entry.value}')),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            _showEditRecordDialog(context, boxName, key, value);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            _confirmDeleteRecord(context, boxName, key);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ), // Corrected closing parenthesis for Padding
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    ).whenComplete(() {
      _loadDebugInfo(); // Reload info after changes in box contents
    });
  }

  void _showAddRecordDialog(BuildContext context, String boxName) {
    // This implementation now tries to infer the type and ask for a JSON string for models
    // For primitive types or unsupported models, it falls back to basic string input.
    final boxType = _getBoxType(boxName);
    TextEditingController keyController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Add Record to $boxName'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                TextField(
                  controller: keyController,
                  decoration: const InputDecoration(labelText: 'Key (optional, will auto-generate if empty)'),
                ),
                const SizedBox(height: 10),
                if (boxType == dynamic) ...[
                  TextField(
                    controller: valueController,
                    decoration: const InputDecoration(labelText: 'Value (String/int/bool)'),
                  ),
                ] else ...[
                  Text('Enter value as JSON for $boxType:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getSampleJsonFormat(boxName),
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'JSON for $boxType',
                      errorText: errorMessage,
                    ),
                  ),
                ],
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final box = Hive.box(boxName);
                  try {
                    dynamic valueToAdd;
                    if (boxType == dynamic) { // Handling primitive types
                      // Simple type inference, can be expanded
                      if (valueController.text.toLowerCase() == 'true') {
                        valueToAdd = true;
                      } else if (valueController.text.toLowerCase() == 'false') {
                        valueToAdd = false;
                      } else if (int.tryParse(valueController.text) != null) {
                        valueToAdd = int.parse(valueController.text);
                      } else {
                        valueToAdd = valueController.text;
                      }
                    } else { // Handling custom model types via JSON
                      final jsonMap = json.decode(valueController.text);
                      valueToAdd = _deserializeModel(boxName, jsonMap);
                    }

                    if (keyController.text.isEmpty) {
                      await box.add(valueToAdd);
                    } else {
                      await box.put(keyController.text, valueToAdd);
                    }
                    Navigator.of(context).pop();
                    _loadDebugInfo(); // Refresh stats
                    _showBoxContents(context, boxName); // Refresh box view
                  } catch (e) {
                    setState(() {
                      errorMessage = e.toString();
                    });
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditRecordDialog(BuildContext context, String boxName, dynamic key, dynamic currentValue) {
    final boxType = _getBoxType(boxName);
    TextEditingController valueController = TextEditingController();
    String? errorMessage;

    // Pre-fill value controller
    if (boxType != dynamic && currentValue != null) {
      valueController.text = json.encode(_formatModelForDisplay(currentValue));
    } else {
      valueController.text = currentValue?.toString() ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Edit Record (Key: $key)'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                if (boxType == dynamic) ...[
                  TextField(
                    controller: valueController,
                    decoration: const InputDecoration(labelText: 'Value (String/int/bool)'),
                  ),
                ] else ...[
                  Text('Edit value as JSON for $boxType:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getSampleJsonFormat(boxName),
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'JSON for $boxType',
                      errorText: errorMessage,
                    ),
                  ),
                ],
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final box = Hive.box(boxName);
                  try {
                    dynamic valueToUpdate;
                    if (boxType == dynamic) { // Handling primitive types
                      if (valueController.text.toLowerCase() == 'true') {
                        valueToUpdate = true;
                      } else if (valueController.text.toLowerCase() == 'false') {
                        valueToUpdate = false;
                      } else if (int.tryParse(valueController.text) != null) {
                        valueToUpdate = int.parse(valueController.text);
                      } else {
                        valueToUpdate = valueController.text;
                      }
                    } else { // Handling custom model types via JSON
                      final jsonMap = json.decode(valueController.text);
                      valueToUpdate = _deserializeModel(boxName, jsonMap);
                    }
                    await box.put(key, valueToUpdate);
                    Navigator.of(context).pop();
                    _loadDebugInfo(); // Refresh stats
                    _showBoxContents(context, boxName); // Refresh box view
                  } catch (e) {
                    setState(() {
                      errorMessage = e.toString();
                    });
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteRecord(BuildContext context, String boxName, dynamic key) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete record with key "$key" from "$boxName"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      final box = Hive.box(boxName);
      await box.delete(key);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Record "$key" deleted from "$boxName".')),
      );
      _loadDebugInfo(); // Refresh stats
      Navigator.of(context).pop(); // Close current box content view
      _showBoxContents(context, boxName); // Re-open to refresh
    }
  }

  Future<void> _confirmClearBox(BuildContext context, String boxName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Clear Box'),
        content: Text('Are you sure you want to clear all records from "$boxName"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Clear')),
        ],
      ),
    );

    if (confirm == true) {
      final box = Hive.box(boxName);
      await box.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Box "$boxName" cleared.')),
      );
      _loadDebugInfo(); // Refresh stats
      Navigator.of(context).pop(); // Close current box content view
    }
  }

  // Helper to get the expected type of a box based on its name
  String _getSampleJsonFormat(String boxName) {
    switch (boxName) {
      case 'timelineEntryBox':
        return '''Sample format:
{
  "id": "optional-auto-generated",
  "timestamp": "2024-01-15T10:30:00.000",
  "type": "quickNote|reflection|alarmLog",
  "title": "Optional title",
  "content": "Required content text",
  "mediaType": "none|image|video|audio",
  "mediaPath": "/optional/path/to/media",
  "tags": ["tag1", "tag2"]
}''';
      case 'alarmBox':
        return '''Sample format:
{
  "id": "optional-auto-generated",
  "title": "Wake up",
  "time": {"hour": 7, "minute": 30},
  "recurrenceDays": [0,1,2,3,4],
  "isActive": true
}
Note: recurrenceDays: 0=Mon, 1=Tue, ..., 6=Sun''';
      case 'alarmLogBox':
        return '''Sample format:
{
  "id": "optional-auto-generated",
  "timestamp": "2024-01-15T07:35:00.000",
  "alarmId": "alarm-id-reference",
  "status": "done|missed|skipped",
  "notes": "Optional notes"
}''';
      case 'dailySummaryBox':
        return '''Sample format:
{
  "date": "2024-01-15T00:00:00.000",
  "summaryNotes": "Optional notes",
  "totalLogsCreated": 5,
  "alarmsMissed": 1,
  "alarmsCompleted": 4,
  "activeHours": 480,
  "noteTypeBreakdown": {"quickNote": 3, "reflection": 2}
}
Note: activeHours in minutes, type: quickNote|reflection|alarmLog''';
      case 'weeklySummaryBox':
        return '''Sample format:
{
  "startDate": "2024-01-15T00:00:00.000",
  "endDate": "2024-01-21T23:59:59.000",
  "weeklyNotes": "Optional notes",
  "totalLogsForWeek": 35,
  "totalAlarmsMissed": 3,
  "totalAlarmsCompleted": 32,
  "dailyLogsCount": {"1": 5, "2": 6, "3": 4},
  "dailyActiveHours": {"1": 480, "2": 420}
}
Note: Keys 1-7 for Mon-Sun, activeHours in minutes''';
      default:
        return 'Enter valid JSON object';
    }
  }

  Type _getBoxType(String boxName) {
    switch (boxName) {
      case 'timelineEntryBox':
        return TimelineEntry;
      case 'alarmBox':
        return app_models.Alarm;
      case 'alarmLogBox':
        return AlarmLog;
      case 'dailySummaryBox':
        return DailySummary;
      case 'weeklySummaryBox':
        return WeeklySummary;
      default:
        return dynamic; // For untyped boxes or unknown types
    }
  }

  // Helper to deserialize JSON to a model object
  dynamic _deserializeModel(String boxName, Map<String, dynamic> jsonMap) {
    switch (boxName) {
      case 'timelineEntryBox':
        return TimelineEntry(
          id: jsonMap['id'] ?? UniqueKey().toString(), // Generate ID if not provided
          timestamp: DateTime.parse(jsonMap['timestamp']),
          type: EntryType.values.firstWhere((e) => e.toString().split('.').last == jsonMap['type']),
          title: jsonMap['title'],
          content: jsonMap['content'],
          mediaType: MediaType.values.firstWhere((e) => e.toString().split('.').last == jsonMap['mediaType']),
          mediaPath: jsonMap['mediaPath'],
          tags: List<String>.from(jsonMap['tags'] ?? []),
        );
      case 'alarmBox':
        return app_models.Alarm(
          id: jsonMap['id'] ?? UniqueKey().toString(),
          title: jsonMap['title'],
          time: app_models.TimeOfDay(hour: jsonMap['time']['hour'], minute: jsonMap['time']['minute']),
          recurrenceDays: List<int>.from(jsonMap['recurrenceDays'] ?? []),
          isActive: jsonMap['isActive'] ?? true,
        );
      case 'alarmLogBox':
        return AlarmLog(
          id: jsonMap['id'] ?? UniqueKey().toString(),
          timestamp: DateTime.parse(jsonMap['timestamp']),
          alarmId: jsonMap['alarmId'],
          status: AlarmStatus.values.firstWhere((e) => e.toString().split('.').last == jsonMap['status']),
          notes: jsonMap['notes'],
        );
      case 'dailySummaryBox':
        return DailySummary(
          date: DateTime.parse(jsonMap['date']),
          summaryNotes: jsonMap['summaryNotes'],
          totalLogsCreated: jsonMap['totalLogsCreated'] ?? 0,
          alarmsMissed: jsonMap['alarmsMissed'] ?? 0,
          alarmsCompleted: jsonMap['alarmsCompleted'] ?? 0,
          activeHours: Duration(minutes: jsonMap['activeHours'] ?? 0),
          noteTypeBreakdown: (jsonMap['noteTypeBreakdown'] as Map<String, dynamic>? ?? {})
              .map((k, v) => MapEntry(EntryType.values.firstWhere((e) => e.toString().split('.').last == k), v as int)),
        );
      case 'weeklySummaryBox':
        return WeeklySummary(
          startDate: DateTime.parse(jsonMap['startDate']),
          endDate: DateTime.parse(jsonMap['endDate']),
          weeklyNotes: jsonMap['weeklyNotes'],
          totalLogsForWeek: jsonMap['totalLogsForWeek'] ?? 0,
          totalAlarmsMissed: jsonMap['totalAlarmsMissed'] ?? 0,
          totalAlarmsCompleted: jsonMap['totalAlarmsCompleted'] ?? 0,
          dailyLogsCount: (jsonMap['dailyLogsCount'] as Map<String, dynamic>? ?? {}).map((k, v) => MapEntry(int.parse(k), v as int)),
          dailyActiveHours: (jsonMap['dailyActiveHours'] as Map<String, dynamic>? ?? {})
              .map((k, v) => MapEntry(int.parse(k), Duration(minutes: v as int))),
        );
      default:
        throw Exception('Unsupported box type for deserialization: $boxName');
    }
  }
}
