import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeMode? get themeMode => _themeMode;

  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  Future<void> switchTheme(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  UserPreferences() {
    SharedPreferences.getInstance().then((prefs) async {
      var value = prefs.getBool('isDarkMode') ?? false;
      _themeMode = value ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    });
  }
}
