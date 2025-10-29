import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String _visitorTokenKey = 'visitorToken';
  static const String _authTokenKey = 'authToken';

  static Future<void> setVisitorToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_visitorTokenKey, token);
  }

  static Future<String?> getVisitorToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_visitorTokenKey);
  }

  static Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }
}

