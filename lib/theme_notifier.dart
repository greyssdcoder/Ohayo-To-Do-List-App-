import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static final ValueNotifier<Color> accentColor =
  ValueNotifier<Color>(const Color(0xFF6C63FF));
  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);

  // Call once at app startup to restore the saved color/dark mode.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedColor = prefs.getInt('accentColor');
    final savedDark = prefs.getBool('isDarkMode');
    if (savedColor != null) accentColor.value = Color(savedColor);
    if (savedDark != null) isDarkMode.value = savedDark;

    // Auto-save any time either value changes.
    accentColor.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('accentColor', accentColor.value.value);
    });
    isDarkMode.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDarkMode', isDarkMode.value);
    });
  }
}