import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData({
    required dynamic value,
    required String key,
  }) async {
    if(value is String) return await sharedPreferences.setString(key, value);
    if(value is int) return await sharedPreferences.setInt(key, value);
    if(value is bool) return await sharedPreferences.setBool(key, value);
    if(value is List<String>) {
      print('save data: $value');
      return await sharedPreferences.setStringList(key, value);
    }
    return await sharedPreferences.setDouble(key, value);
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }



  static List<String>? getStringList({
    required String key,
  }) {
    print('get data: ${sharedPreferences.getStringList(key)}');
    return sharedPreferences.getStringList(key);
  }



}
