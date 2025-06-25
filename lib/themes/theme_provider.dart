import 'package:flutter/material.dart';
import 'package:flutter_application_0/themes/dark_mode.dart';  
import 'package:flutter_application_0/themes/light_mode.dart'; 

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkMode; // Varsayılan tema koyu mod

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}