import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeType {
  light,
  dark,
  neonDreams2077,
  // Future themes:
  // halloween,
  // vhsCassette,
  // miami1988,
  // materialYouZen,
  // hipster,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_type';

  AppThemeType _currentTheme = AppThemeType.dark;
  bool _isInitialized = false;

  AppThemeType get currentTheme => _currentTheme;
  bool get isInitialized => _isInitialized;

  // Deprecated - keeping for backwards compatibility
  ThemeMode get themeMode =>
      _currentTheme == AppThemeType.light ? ThemeMode.light : ThemeMode.dark;

  bool get isDarkMode => _currentTheme != AppThemeType.light;
  bool get isCyberpunkTheme => _currentTheme == AppThemeType.neonDreams2077;

  ThemeProvider() {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex != null &&
          themeIndex >= 0 &&
          themeIndex < AppThemeType.values.length) {
        _currentTheme = AppThemeType.values[themeIndex];
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setTheme(AppThemeType theme) async {
    _currentTheme = theme;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      // Handle error silently, theme change still works for current session
    }
  }

  // Legacy method - keeping for backwards compatibility
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (themeMode == ThemeMode.light) {
      await setTheme(AppThemeType.light);
    } else {
      await setTheme(AppThemeType.dark);
    }
  }

  Future<void> toggleTheme() async {
    final nextIndex = (_currentTheme.index + 1) % AppThemeType.values.length;
    await setTheme(AppThemeType.values[nextIndex]);
  }

  String getThemeName(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.light:
        return 'Light';
      case AppThemeType.dark:
        return 'Dark';
      case AppThemeType.neonDreams2077:
        return 'Neon Dreams 2077 ⚡';
    }
  }

  String getThemeEmoji(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.light:
        return '☀️';
      case AppThemeType.dark:
        return '🌙';
      case AppThemeType.neonDreams2077:
        return '⚡';
    }
  }
}
