import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/controllers/single_user_controller.dart';

import '../models/user_model.dart';

class UserDetailPage extends StatefulWidget {
  final int userId;
  const UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final SingleUserController _userListController = SingleUserController();

  late Future<UserModel> _singleUserFuture;

  @override
  void initState() {
    super.initState();
    _singleUserFuture = _userListController.fetchUsers(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: _singleUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            UserModel user = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.orangeAccent.withOpacity(0.8),
              ),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
