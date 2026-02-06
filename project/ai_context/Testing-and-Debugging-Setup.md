## Testing and Debugging Setup

### Unit Tests Implemented:
- `TimelineEntry` model (Hive serialization/deserialization)
- `Alarm` model (Hive serialization/deserialization)
- `AlarmLog` model (Hive serialization/deserialization, `TimelineEntry` inheritance)
- `DailySummary` model (Hive serialization/deserialization, `Duration` handling)
- `WeeklySummary` model (Hive serialization/deserialization, `Duration` handling)

### Test Infrastructure Changes:
- Added `hive_flutter` and `path_provider` to `pubspec.yaml` (dependencies).
- Modified test `setUpAll`/`tearDownAll` for robust Hive initialization using `dart:io` temporary directories.
- Created `DurationAdapter` (`lib/models/duration_adapter.dart`) and registered it for `Duration` type serialization in Hive.
- Corrected import paths in `lib/models/daily_summary.dart` and `lib/models/weekly_summary.dart`.

### Debugging Tools:
- Implemented `DebugScreen` (`lib/screens/debug_screen.dart`) displaying app info, Hive status, and a "Clear All Hive Data" function.
- `DebugScreen` was temporarily set as the `home` widget in `lib/main.dart` for immediate viewing.

### Key Learnings/Fixes:
- `MissingPluginException` in unit tests for Flutter plugins (like `path_provider`) requires alternative non-Flutter-dependent setup (e.g., `dart:io` for temp directories).
- Custom `TypeAdapter` is required for non-primitive types like `Duration` with Hive.
- Consistent import paths (`package:my_time/models/...`) are crucial for `build_runner` and correct code resolution.