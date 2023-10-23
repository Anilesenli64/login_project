import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authService = Provider((ref) => AuthService());

class AuthService {
  Future<bool> performLogin(String email, String password) async {
    if (!EmailValidator.validate(email)) {
      return false;
    }

    const String apiUrl = 'https://reqres.in/api/login';

    final Map<String, String> data = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];

      // Save token locally
      await _saveTokenLocally(token);
      return true;
    } else {
      // Handle error
      print('Login failed. Status code: ${response.statusCode}');
      return false;
    }
  }

  Future<void> _saveTokenLocally(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
