import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/intro.dart';
import 'screens/home.dart';
import 'screens/contact.dart';
import 'screens/category.dart';

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
      onGenerateRoute: (settings) {
        switch(settings.name) {
          case 'intro':
            return MaterialPageRoute(builder: (_) => IntroPage());
          case 'login':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case 'register':
            return MaterialPageRoute(builder: (_) => RegisterPage());
          case 'home':
            final Map<String, dynamic> args = settings.arguments;
            return MaterialPageRoute(builder: (_) => Homepage(args['isNewLogin']));
          case 'contact':
            final Map<String, dynamic> args = settings.arguments;
            return MaterialPageRoute(builder: (_) => Contact(contact: args['contact']));
          case 'category':
          case 'contact':
            final Map<String, dynamic> args = settings.arguments;
            return MaterialPageRoute(builder: (_) => Category(category: args['category'], contacts: args['contacts']));
        }
      },
      home: FutureBuilder<User>(
          future: authApi.confirmToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              config.loggedInUser = snapshot.data;
              return Homepage(false);
            } else if (snapshot.hasError) {
              return IntroPage();
            }

            return Material();
          }),
    );
  }
}
