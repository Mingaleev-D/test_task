import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task/core/app_constants.dart';

class SharedUtils {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.accessToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.accessToken);
  }
}
