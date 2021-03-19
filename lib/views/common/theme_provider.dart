import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void switchTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}

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
