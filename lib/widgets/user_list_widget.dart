import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';

import '../views/user_detail_view.dart';

class UserListWidget extends StatelessWidget {
  final UserModel user;
  const UserListWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        tileColor: user.id % 2 == 0
            ? Colors.white54
            : Colors.orangeAccent.withOpacity(0.3),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserDetailPage(
                userId: user.id,
              ),
            ),
          );
        },
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          backgroundColor: Colors.orangeAccent.withOpacity(0.3),
          backgroundImage: NetworkImage(user.avatar),
        ),
      ),
    );
    ;
  }
}
