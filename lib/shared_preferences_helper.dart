import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const themeKey = 'theme_key';
  static const localeKey = 'locale_key';
  static const bundleKey = 'bundle_key';

  void setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(themeKey, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(themeKey) ?? false;
  }

  void setLocale(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(localeKey, value);
  }

  Future<String> getLocale() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(localeKey) ?? 'en';
  }

  static void setBundle(int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(bundleKey, value);
  }

  static Future<int> getBundle() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(bundleKey) ?? 0;
  }
}
