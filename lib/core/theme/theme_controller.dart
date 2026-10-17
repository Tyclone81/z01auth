import 'package:flutter/material.dart';

/// Reactive controller managing the high-contrast monochrome theme mode (Dark / Light).
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController._() : super(ThemeMode.dark);

  static final ThemeController instance = ThemeController._();

  bool get isDark => value == ThemeMode.dark;

  void toggleTheme() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  void setDark() {
    if (value != ThemeMode.dark) {
      value = ThemeMode.dark;
    }
  }

  void setLight() {
    if (value != ThemeMode.light) {
      value = ThemeMode.light;
    }
  }
}
