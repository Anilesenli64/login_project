import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class SingleUserService {
  Future<UserModel> fetchUser(int id) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> userData = responseData['data'];

      return UserModel(
        id: userData['id'],
        email: userData['email'],
        firstName: userData['first_name'],
        lastName: userData['last_name'],
        avatar: userData['avatar'],
      );
    } else {
      throw Exception(
          'Failed to load user data. Status code: ${response.statusCode}');
    }
  }
}
