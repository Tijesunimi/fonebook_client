import 'package:flutter/material.dart';

void main() => runApp(Fonebook());

class Fonebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fonebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
              title: Text("Fonebook"),
          ),
          body: Center(
              child: Text("Fonebook application"),
          ),
      ),
    );
  }
}