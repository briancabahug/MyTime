import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

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
          _buildInfoTile('Hive Initialized', Hive.isInitialized ? 'Yes' : 'No'),
          _buildInfoTile('Hive Path', Hive.isInitialized ? Hive.path ?? 'Not Available' : 'Not Initialized'),
          // Add more debug information as needed
          const Divider(),
          ListTile(
            title: const Text('Clear All Hive Data'),
            subtitle: const Text('This will delete all local app data.'),
            trailing: const Icon(Icons.warning_amber),
            onTap: () async {
              // Confirmation dialog
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
}
