import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> signup(String email, String password, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save user details in shared preferences
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('name', name);
    await prefs.setBool('isLoggedIn', true);
    return true;
  }

  Future<bool> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve user details from shared preferences
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail == email && savedPassword == password) {
      await prefs.setBool('isLoggedIn', true);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}
