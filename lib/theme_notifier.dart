import 'package:flutter/material.dart';

// Simple global notifier for the app's accent color. No persistence yet
// (resets on app restart) — swap this for shared_preferences later if
// you want the picked color to survive a restart.
class AppTheme {
  static final ValueNotifier<Color> accentColor =
  ValueNotifier<Color>(const Color(0xFF6C63FF));
  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);
}