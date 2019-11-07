import 'dart:ui';

import 'package:its_12_oclock/locales/locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const KEY_SETTINGS_MOCK = 'settings-mock';
  static const _key_locale = 'settings-locale';

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool(key);
    return val == null ? false : val;
  }

  static void setBool(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  static Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String languageCode = prefs.getString(_key_locale);
    if (languageCode == null) {
      return Locales.en;
    }
    return Locale(languageCode);
  }

  static void setLocale(Locale val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key_locale, val.languageCode);
  }
}
