import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
    ThemeMode _themeMode = ThemeMode.system;

   ThemeMode get themeMode => _themeMode;

   set themeMode(ThemeMode mode) {
     _themeMode = mode;
     notifyListeners();
    }

    void toggleTheme(int mode) {
      switch (mode) {
        case 1:
          _themeMode = ThemeMode.light;
          break;
        case 2:
          _themeMode = ThemeMode.dark;
          break;
        case 3:
          _themeMode = ThemeMode.system;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      notifyListeners();
    }
}