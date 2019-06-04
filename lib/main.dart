import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/intro.dart';

void main() => runApp(Fonebook());

class Fonebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fonebook',
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