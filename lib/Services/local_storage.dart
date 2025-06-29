// lib/services/local_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Save username and password
  static Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(username, password);
  }

  // Retrieve password by username
  static Future<String?> getPassword(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(username);
  }
}
