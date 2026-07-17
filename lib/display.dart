import 'package:flutter/material.dart';

// No persistence yet — these controls update local widget state only,
// so changes reset when you leave the screen. Hook this up to
// shared_preferences or your SQLite settings table later.
class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  static const accent = Color.fromRGBO(128, 57, 41, 1.0);

  double _fontSize = 16;
  bool _darkPreview = false;
  int _selectedColorIndex = 0;

  final List<Color> _themeOptions = const [
    Color(0xFF836664),
    Color(0xFFCA5750),
    Color(0xFF4C6663),
    Color(0xFF3F5B7A),
    Color(0xFF6B4C7A),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accent,
        title: const Text("Display", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Font Size", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Slider(
            value: _fontSize,
            min: 12,
            max: 24,
            divisions: 6,
            activeColor: accent,
            label: _fontSize.round().toString(),
            onChanged: (value) => setState(() => _fontSize = value),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Preview: Finish CpEPC 120 lab",
                style: TextStyle(fontSize: _fontSize),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text("Theme Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: List.generate(_themeOptions.length, (index) {
              final selected = _selectedColorIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = index),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _themeOptions[index],
                    shape: BoxShape.circle,
                    border: selected ? Border.all(color: Colors.black, width: 2) : null,
                  ),
                  child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          SwitchListTile(
            activeColor: accent,
            title: const Text("Dark Mode Preview"),
            subtitle: const Text("Visual only for now — not yet wired to the app theme"),
            value: _darkPreview,
            onChanged: (value) => setState(() => _darkPreview = value),
          ),
        ],
      ),
    );
  }
}