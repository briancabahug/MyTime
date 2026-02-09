import 'package:flutter/material.dart';
import 'package:my_time/screens/debug_screen.dart'; // Import DebugScreen
import 'package:hive_flutter/hive_flutter.dart'; // Import hive_flutter
import 'package:path_provider/path_provider.dart'; // Import path_provider for Hive initialization

import 'package:my_time/models/timeline_entry.dart';
import 'package:my_time/models/alarm.dart';
import 'package:my_time/models/alarm_log.dart';
import 'package:my_time/models/daily_summary.dart';
import 'package:my_time/models/weekly_summary.dart';
import 'package:my_time/models/duration_adapter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async operations before runApp

  // Initialize Hive
  await Hive.initFlutter(); // Uses path_provider internally

  // Register all adapters
  Hive.registerAdapter(EntryTypeAdapter());
  Hive.registerAdapter(MediaTypeAdapter());
  Hive.registerAdapter(TimelineEntryAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(AlarmAdapter());
  Hive.registerAdapter(AlarmStatusAdapter());
  Hive.registerAdapter(AlarmLogAdapter());
  Hive.registerAdapter(DailySummaryAdapter());
  Hive.registerAdapter(WeeklySummaryAdapter());
  Hive.registerAdapter(DurationAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const DebugScreen(), // TEMPORARY: Set DebugScreen as home
    );
  }
}
