import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/views/splash_screen_view.dart';
import 'package:flutter_application_1/views/user_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedToken = prefs.getString('token');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: savedToken != null ? UserListView() : SplashScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          body: MyLoginForm(),
        ),
      ),
    );
  }
}

class MyLoginForm extends StatefulWidget {
  @override
  _MyLoginFormState createState() => _MyLoginFormState();
}

class _MyLoginFormState extends State<MyLoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<bool> _performLogin() async {
    if (!EmailValidator.validate(emailController.text)) {
      return false;
    }

    bool success = await _authService.performLogin(
      emailController.text,
      passwordController.text,
    );

    return success;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Image.asset(
              'assets/images/Login-amico.png',
              width: 200,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
                border: InputBorder.none,
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.orangeAccent),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
                border: InputBorder.none,
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.orangeAccent),
              ),
              obscureText: true,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent),
              onPressed: () async {
                bool loginSuccess = await _performLogin();

                if (loginSuccess) {
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => UserListView(),
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
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      duration: Duration(seconds: 2),
                      content: Text("Bilgileriniz hatalı veya eksik."),
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text("Login"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
