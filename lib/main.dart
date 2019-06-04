import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/intro.dart';
import 'config.dart';

class Fonebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var config = Config.of(context);

    debugPrint("App running on ${config.env} environment");

    return MaterialApp(
      title: config.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF4aa0d5)
      ),
      routes: {
        'intro': (context) => IntroPage(),
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage()
      },
      initialRoute: 'intro',
    );
  }
}