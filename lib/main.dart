import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/intro.dart';
import 'screens/home.dart';

import 'config.dart';

import 'api/auth.dart';
import 'models/user.dart';

class Fonebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var config = Config.of(context);
    final AuthApi authApi = AuthApi(config.apiBaseUrl);

    debugPrint("App running on ${config.env} environment");

    return MaterialApp(
      title: config.appName,
      theme: ThemeData(
          primarySwatch: Colors.blue, primaryColor: Color(0xFF4aa0d5)),
      routes: {
        'intro': (context) => IntroPage(),
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage(),
        'home': (context) => Homepage()
      },
      home: FutureBuilder<User>(
          future: authApi.confirmToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Homepage();
            }
            return IntroPage();
          }),
    );
  }
}
