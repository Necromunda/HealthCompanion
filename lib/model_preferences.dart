import 'package:flutter/material.dart';

import 'package:health_companion/shared_preferences_helper.dart';

class ModelPreferences extends ChangeNotifier {
  late bool _isDark;
  late String _locale;
  late SharedPreferencesHelper _preferences;

  bool get isDark => _isDark;

  String get locale => _locale;

  ModelPreferences() {
    _isDark = false;
    _locale = 'en';
    _preferences = SharedPreferencesHelper();
    getPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  set locale(String value) {
    _locale = value;
    _preferences.setLocale(value);
    notifyListeners();
  }

  void getPreferences() async {
    _isDark = await _preferences.getTheme();
    _locale = await _preferences.getLocale();
    notifyListeners();
  }
}
