import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = true;
  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    loadTheme();
  }

  void loadTheme() {
    final box = Hive.box('settings');
    isDarkMode = box.get('darkMode', defaultValue: true);
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    Hive.box('settings').put('darkMode', isDarkMode);

    notifyListeners();
  }
}
