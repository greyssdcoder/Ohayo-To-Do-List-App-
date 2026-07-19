
import 'package:flutter/material.dart';
import 'package:ohayo/theme_notifier.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  double _fontSize = 16;


  final List<Color> _themeOptions = const [
    Color(0xFF6C63FF), // indigo (default)
    Color(0xFF00BFA5), // teal
    Color(0xFFFF6B6B), // coral
    Color(0xFFFFA726), // amber
    Color(0xFF4CAF50), // green
    Color(0xFF3F5B7A), // blue
  ];

  @override
  Widget build(BuildContext context) {
    // Rebuilds when the accent color changes so the selected swatch
    // (and everything using AppTheme.accentColor) stays in sync.
    return ValueListenableBuilder<Color>(
      valueListenable: AppTheme.accentColor,
      builder: (context, accent, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF121212) : Colors.white;
        final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;
        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: surface,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
            title: Text("Display", style: TextStyle(color: textColor)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
               Text("Font Size", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
               Text("Theme Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _themeOptions.map((color) {
                  final selected = accent.value == color.value;
                  return GestureDetector(
                    // This is the actual "make it work" part — updating
                    // the shared notifier is what changes the accent
                    // color everywhere else in the app, including
                    // homeScreen.dart, immediately.
                    onTap: () => AppTheme.accentColor.value = color,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selected ? Border.all(color: Colors.black, width: 2) : null,
                      ),
                      child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              ValueListenableBuilder<bool>(
                valueListenable: AppTheme.isDarkMode,
                builder: (context, isDark, _) {
                  return SwitchListTile(
                    activeColor: accent,
                    title: const Text("Dark Mode"),
                    subtitle: const Text("Switches the whole app's theme"),
                    value: isDark,
                    onChanged: (value) => AppTheme.isDarkMode.value = value,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
 
