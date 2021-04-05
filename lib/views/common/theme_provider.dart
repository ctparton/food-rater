import 'package:flutter/material.dart';

/// A class to provide a theme to all widgets in the widget tree
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void switchTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    // Updates descendent widgets with the selected theme if switched
    notifyListeners();
  }
}

/// The light and dark theme definitions for the app
class CustomThemes {
  static final darkTheme = ThemeData(
      accentColor: Colors.green[400],
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[400],
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.green),
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: ColorScheme.dark());

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[400],
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.green));
}
