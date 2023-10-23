import 'package:flutter_application_1/models/user_model.dart';
import 'package:riverpod/riverpod.dart';
import '../services/users_service.dart';

class UserListController {
  final UsersService _userService = UsersService();

  Future<List<UserModel>> fetchUsers(int page) async {
    return _userService.fetchUsers(page);
  }
}

//final userListControllerProvider = Provider<UserListController>((ref) {
  //return UserListController();
//});

