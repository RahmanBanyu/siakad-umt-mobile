import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  // Helper
  static Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  // TOKEN
  static Future<void> saveToken(String token) async {
    final sp = await _prefs();
    await sp.setString("token", token);
    print("TOKEN SAAT INI: ${sp.getString("token")}");
  }

  static Future<String?> getToken() async {
    final sp = await _prefs();
    return sp.getString("token");
  }

  // USER ID
  static Future<void> saveUserId(int userId) async {
    final sp = await _prefs();
    await sp.setInt("user_id", userId);
    print("USER ID SAAT INI: ${sp.getInt("user_id")}");
  }

  static Future<int?> getUserId() async {
    final sp = await _prefs();
    return sp.getInt("user_id");
  }

  // NIM
  static Future<void> setNim(String nim) async {
    final sp = await _prefs();
    await sp.setString("nim", nim);
  }

  static Future<String?> getNim() async {
    final sp = await _prefs();
    return sp.getString("nim");
  }

  // NAMA
  static Future<void> setName(String name) async {
    final sp = await _prefs();
    await sp.setString("name", name);
  }

  static Future<String?> getName() async {
    final sp = await _prefs();
    return sp.getString("name");
  }

  // CLEAR ALL
  static Future<void> clearAll() async {
    final sp = await _prefs();
    await sp.remove("token");
    await sp.remove("user_id");
    await sp.remove("nim");
    await sp.remove("name");
  }
}
