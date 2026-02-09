## Debug Screen Enhancements

### Location
`lib/screens/debug_screen.dart`

### Recent Fixes & Features

#### 1. Syntax Fix (Line ~501)
- **Issue**: Malformed closing brackets in `_showEditRecordDialog` caused compile errors
- **Fix**: Changed `),` + `);` + `},` sequence to proper `);` + `},` closing for AlertDialog return statement inside StatefulBuilder

#### 2. JSON Sample Format Helper
- **Added**: `_getSampleJsonFormat(String boxName)` method (~line 557)
- **Purpose**: Returns sample JSON format strings for each Hive box type
- **Supported boxes**:
  - `timelineEntryBox` - TimelineEntry model
  - `alarmBox` - Alarm model (note: time is `{"hour": int, "minute": int}`)
  - `alarmLogBox` - AlarmLog model
  - `dailySummaryBox` - DailySummary (activeHours in minutes, noteTypeBreakdown keys: quickNote|reflection|alarmLog)
  - `weeklySummaryBox` - WeeklySummary (keys 1-7 for Mon-Sun, durations in minutes)
- **UI**: Sample displayed in grey monospace Container above JSON TextField in both Add/Edit dialogs

#### 3. Scrollable Dialogs
- **Issue**: "Button overflow" error on Android when dialog content too tall
- **Fix**: Wrapped dialog `content` in `SingleChildScrollView` for both:
  - `_showAddRecordDialog` (~line 338)
  - `_showEditRecordDialog` (~line 450)

### Dialog Structure Pattern
```dart
AlertDialog(
  title: ...,
  content: SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [...],
    ),
  ),
  actions: [...],
)
```

### Key Methods
- `_getBoxType(String boxName)` - Returns Type for box (dynamic for unknown)
- `_getSampleJsonFormat(String boxName)` - Returns sample JSON string
- `_deserializeModel(String boxName, Map<String, dynamic>)` - JSON to model conversion
- `_formatModelForDisplay(dynamic value)` - Model to JSON for editing
