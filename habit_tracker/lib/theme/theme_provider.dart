import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially, Light Mode
  ThemeData _themeData = lightMode;

  // Get Current Theme
  ThemeData get themeData => _themeData;

  // Is current theme dark mode
  bool get isDarkMode => _themeData == darkMode;

  // Set Theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Toggle Theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
