import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const KEY_SETTINGS_MOCK = 'settings-mock';

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool(key);
    return val == null ? false : val;
  }

  static void setBool(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }
}
