import 'package:flutter/material.dart';

import 'package:fonebook/models/contact.dart';

import 'package:fonebook/screens/particles/contacts_list.dart';

class Category extends StatelessWidget {
  final String category;
  final List<MainContact> contacts;

  Category({this.category, this.contacts});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.category),
      ),
      body: ContactsList(contacts),
    );
  }
}