import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences?> initializePrefs() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future storeData(String key, dynamic value) async {
    if (value is int) {
      await _preferences?.setInt(key, value);
    } else if (value is bool) {
      await _preferences?.setBool(key, value);
    } else if (value is double) {
      await _preferences?.setDouble(key, value);
    } else if (value is String) {
      await _preferences?.setString(key, value);
    }
  }

  static dynamic fetchData(String key) {
    return _preferences?.get(key);
  }

  static clearPrefs() {
    _preferences?.clear();
  }
}
