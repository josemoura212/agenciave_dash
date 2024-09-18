import 'package:agenciave_dash/core/ui/ui_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ThemeManager {
  final Signal<ThemeData> themeData;
  final Signal<bool> isDarkMode;

  ThemeManager(bool initialDarkMode)
      : themeData =
            Signal(initialDarkMode ? UiConfig.darkTheme : UiConfig.lightTheme),
        isDarkMode = Signal(initialDarkMode);

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    themeData.value =
        isDarkMode.value ? UiConfig.darkTheme : UiConfig.lightTheme;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode.value);
  }
}
