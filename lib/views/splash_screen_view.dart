import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simüle edilen bir bekleme süresi (örneğin 3 saniye)
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MyApp(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(size: 150),
      ),
    );
  }
}
