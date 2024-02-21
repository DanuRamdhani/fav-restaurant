import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrightnessProvider extends ChangeNotifier {
  bool isDark = false;
  static const nightMode = 'nightMode';

  Future<void> setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    isDark = !isDark;
    prefs.setBool(nightMode, isDark);
    notifyListeners();
  }

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final isDarkMode = prefs.getBool(nightMode) ?? false;
    isDark = isDarkMode;
    notifyListeners();
  }
}
