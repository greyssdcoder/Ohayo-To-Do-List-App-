import 'package:flutter/material.dart';

// No persistence yet — toggles here reset on navigation until you wire
// up shared_preferences or a settings table in SQLite.
class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  static const accent = Color.fromRGBO(128, 57, 41, 1.0);

  bool _notifications = true;
  bool _sound = true;
  bool _reminderBeforeDue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accent,
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          SwitchListTile(
            activeColor: accent,
            title: const Text("Enable Notifications"),
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          SwitchListTile(
            activeColor: accent,
            title: const Text("Notification Sound"),
            value: _sound,
            onChanged: _notifications ? (value) => setState(() => _sound = value) : null,
          ),
          SwitchListTile(
            activeColor: accent,
            title: const Text("Remind Me Before Due Date"),
            value: _reminderBeforeDue,
            onChanged: _notifications ? (value) => setState(() => _reminderBeforeDue = value) : null,
          ),
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text("About", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline, color: accent),
            title: Text("App Version"),
            subtitle: Text("1.0.0"),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
            title: const Text("Clear All Tasks"),
            subtitle: const Text("Not yet connected to your task list"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text("Clear All Tasks?"),
                  content: const Text("This will be wired up once tasks are stored in the database."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}