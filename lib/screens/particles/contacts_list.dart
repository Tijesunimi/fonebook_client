import 'package:flutter/material.dart';

import 'package:fonebook/models/contact.dart';

class ContactsList extends StatelessWidget {
  final List<MainContact> contacts;

  ContactsList(this.contacts);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(contacts[index].names.display),
          leading: Icon(Icons.contacts),
          onTap: () {
            Navigator.of(context).pushNamed(
                'contact',
                arguments: {
                  'contact': contacts[index]
                }
            );
          },
        );
      },
    );
  }
}