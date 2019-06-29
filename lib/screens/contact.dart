import 'package:flutter/material.dart';

import 'package:fonebook/ui_elements/buttons/floating_button_with_text.dart';

import 'package:fonebook/models/contact.dart';

class Contact extends StatelessWidget {
  final MainContact contact;

  Contact({this.contact});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView(
        children: getContactDetails(),
      ),
      floatingActionButton: FloatingActionButtonWithText(
        text: 'Edit',
        icon: Icons.edit
      ),
    );
  }

  List<Widget> getContactDetails() {
    print(contact.toJson());
    List<Widget> contactDetails = [
      Container(
        margin: EdgeInsets.only(top: 40.0, bottom: 40.0),
        child: Icon(Icons.contacts, size: 70.0),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          contact.names.toFullName(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0
          ),
        ),
      ),
    ];

    if (contact.phones.length > 0) {
      contactDetails.add(getSubHeading('PHONES'));
      contactDetails.addAll(getMapTiles(contact.phones, Icons.phone));
    }

    if (contact.emails.length > 0) {
      contactDetails.add(getSubHeading('EMAILS'));
      contactDetails.addAll(getMapTiles(contact.emails, Icons.mail_outline));
    }

    if (contact.addresses.length > 0) {
      contactDetails.add(getSubHeading('ADDRESSES'));
      contactDetails.addAll(getMapTiles(contact.addresses, Icons.home));
    }

    if (contact.birthDate != null) {
      contactDetails.add(getSubHeading('BIRTHDAY'));
      contactDetails.add(getSingleTile(contact.birthDate.toString(), Icons.date_range));
    }

    if (contact.company != null && contact.company.isNotEmpty) {
      contactDetails.add(getSubHeading('COMPANY'));
      contactDetails.add(getSingleTile(contact.company, Icons.work));
    }

    if (contact.website != null && contact.website.isNotEmpty) {
      contactDetails.add(getSubHeading('WEBSITE'));
      contactDetails.add(getSingleTile(contact.website, Icons.link));
    }

    if (contact.notes != null && contact.notes.isNotEmpty) {
      contactDetails.add(getSubHeading('NOTES'));
      contactDetails.add(getSingleTile(contact.notes, Icons.note));
    }

    if (contact.custom != null && contact.custom.length > 0) {
      contactDetails.add(getSubHeading('OTHER DETAILS'));
      contactDetails.addAll(getMapTiles(contact.custom, Icons.bookmark));
    }

    return contactDetails;
  }

  Widget getSubHeading(String title) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.0
        ),
      ),
    );
  }

  Widget getSingleTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
    );
  }

  List<Widget> getMapTiles(Map<Object, dynamic> list, IconData icon) {
    List<ListTile> tiles = List();
    list.forEach((key, value) {
      tiles.add(ListTile(
        leading: Icon(icon),
        title: Text(value.toString()),
        subtitle: Text("${key.toString()[0].toUpperCase()}${key.toString().substring(1)}"),
      ));
    });
    return tiles;
  }
}