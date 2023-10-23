import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UsersService {
  Future<List<UserModel>> fetchUsers(int page) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> usersData = data['data'];

      return List<UserModel>.from(
          usersData.map((user) => UserModel.fromJson(user)));
    } else {
      throw Exception(
          'Failed to load user data. Status code: ${response.statusCode}');
    }
  }
}
