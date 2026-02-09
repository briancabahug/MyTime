# Test and Debug Notes

This document outlines how to run tests, check code coverage, and utilize the basic debug screen implemented in the project.

## How to Run Tests

To execute unit tests for the data models, navigate to the project root directory and use the `flutter test` command.

### Run All Tests:
```bash
flutter test
```

### Run Specific Test File:
To run tests for a particular file (e.g., `timeline_entry_test.dart`):
```bash
flutter test test/models/timeline_entry_test.dart
```
Replace `test/models/timeline_entry_test.dart` with the path to the desired test file.

## How to Check Code Coverage

Code coverage measures the percentage of your code that is executed by tests.

1.  **Run Tests with Coverage Generation**:
    Execute your tests and generate a `lcov.info` file in the `coverage/` directory:
    ```bash
    flutter test --coverage
    ```

2.  **Install `lcov` (if not already installed)**:
    `lcov` is a utility used to process code coverage data.
    *   **macOS**:
        ```bash
        brew install lcov
        ```
    *   **Linux (Debian/Ubuntu)**:
        ```bash
        sudo apt-get install lcov
        ```

3.  **Generate an HTML Report**:
    Convert the `lcov.info` file into a human-readable HTML report. This will create an `html` directory inside your `coverage` directory.
    ```bash
    genhtml coverage/lcov.info -o coverage/html
    ```

4.  **View the Report**:
    Open the `index.html` file in your web browser.
    *   **macOS**:
        ```bash
        open coverage/html/index.html
        ```
    *   **Linux**:
        ```bash
        xdg-open coverage/html/index.html
        ```
    *   Alternatively, navigate to `coverage/html/index.html` manually in your browser.

## How to Use the Debug Screen

The `DebugScreen` provides basic information about the app's state and utility functions.

### Accessing the Debug Screen:
The `DebugScreen` is currently a standalone widget (`lib/screens/debug_screen.dart`). To use it, you would typically integrate it into your application's navigation. For example, you might add a button in a development-only settings menu that navigates to this screen.

A simple way to temporarily view it during development is to replace your app's `home` property in `lib/main.dart` (or wherever your app's root is defined) with `DebugScreen()`:

```dart
// In lib/main.dart (for temporary viewing)
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(...),
      home: const DebugScreen(), // Temporarily set DebugScreen as the home screen
    );
  }
}
```
**Remember to revert this change before committing or deploying.**

### Features of the Debug Screen:
*   **App Version/Build Number**: Displays placeholder values for the application version and build. These would typically be dynamically fetched in a real application.
*   **Hive Status**: Shows whether Hive is initialized and the path it's using for storage.
*   **Clear All Hive Data**: A button that, upon confirmation, will delete all data stored by Hive on the device. **Use with caution**, as this action is irreversible.
    *   Tapping this button will present a confirmation dialog to prevent accidental data loss.
    *   After clearing, a `SnackBar` message will confirm the action.
*   **Box Contents Viewer**: View all records in each Hive box with expandable details.
*   **Add/Edit/Delete Records**: CRUD operations on Hive box records.
    *   For typed boxes (TimelineEntry, Alarm, AlarmLog, DailySummary, WeeklySummary), a sample JSON format is displayed to guide input.
    *   Dialogs are scrollable to accommodate longer content on smaller screens.

## Data Models

The data models are the core of the application's data layer. They are defined in `lib/models/` and use Hive for persistence.

### Refactoring
- **`TimeOfDay` Model**: The `TimeOfDay` model was moved from `lib/models/alarm.dart` to its own file `lib/models/time_of_day.dart`. This was done to improve code organization and consistency.