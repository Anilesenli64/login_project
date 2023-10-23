import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/user_detail_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/user_list_controller.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../widgets/user_list_widget.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final AuthService _authService = AuthService();
  final UserListController _userListController = UserListController();

  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _userListController.fetchUsers(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: const SizedBox(),
        title: const Text(
          'User List',
          style: TextStyle(
            color: Colors.orangeAccent,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.orangeAccent,
            ),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<UserModel> users = snapshot.data ?? [];

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserListWidget(user: user);
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orangeAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _usersFuture = _userListController.fetchUsers(1);
                          });
                        },
                        child: const Text("Geri"),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orangeAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _usersFuture = _userListController.fetchUsers(2);
                          });
                        },
                        child: const Text("İleri"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> logout() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Çıkış Yap'),
          content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'yu kapat
              },
              child: const Text(
                'İptal',
                style: TextStyle(
                  color: Colors.orangeAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // Remove the stored token
                await prefs.remove('token');

                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Kullanıcı dışarı tıklayarak kapatamaz
                  builder: (BuildContext context) {
                    // Bekleme süresi (örneğin 5 saniye)
                    const Duration waitDuration = Duration(seconds: 1);

                    // Belirtilen süre sonunda iletişim kutusunu kapatmak için bir Future oluşturun
                    Future.delayed(waitDuration, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ));
                    });

                    return Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(
                              color: Colors.orangeAccent,
                            ), // Bekleme göstergesi
                            SizedBox(height: 16.0),
                            // İstediğiniz içerik
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Evet',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
