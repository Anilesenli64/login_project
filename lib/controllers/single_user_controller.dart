import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/services/single_user_service.dart';

class SingleUserController {
  final SingleUserService _userService = SingleUserService();

  Future<UserModel> fetchUsers(int id) async {
    return _userService.fetchUser(id);
  }
}
