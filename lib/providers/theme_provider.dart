import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'Dark';
    _themeMode = _stringToThemeMode(theme);
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    _themeMode = _stringToThemeMode(theme);
    notifyListeners();
  }

  ThemeMode _stringToThemeMode(String theme) {
    switch (theme) {
      case 'Light':
        return ThemeMode.light;
      case 'System':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
}