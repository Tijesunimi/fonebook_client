import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Fonebook'),
        leading: Icon(Icons.menu),
      ),
      body: Center(
        child: Text('Welcome to fonebook app')
      ),
    );
  }
}