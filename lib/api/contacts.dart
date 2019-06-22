import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fonebook/models/contact.dart';
import 'package:fonebook/models/user.dart';
import 'package:fonebook/db.dart';

class ContactsApi {
  final String apiUrl;
  final User currentUser;

  ContactsApi(this.apiUrl, this.currentUser);

  Future<List<MainContact>> getContactsFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get("$apiUrl/contacts",
        headers: {'Authorization': prefs.get('token')});

    if (response.statusCode == 200) {
      var contactsJson = json.decode(response.body);
      return contactsJson
          .map<MainContact>((c) => MainContact.fromJson(c))
          .toList();
    } else {
      throw Exception('Could not fetch contacts');
    }
  }

  Future<List<MainContact>> getContactsFromPhone() async {
    if (!await SimplePermissions.checkPermission(Permission.ReadContacts)) {
      var permissionStatus =
          await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (permissionStatus != PermissionStatus.authorized) {
        throw Exception('Contact permission is required');
      }
    }

    final contacts = await ContactsService.getContacts();
    return contacts.map((c) => convertToServerContact(c)).toList();
  }

  Future<List<MainContact>> getContactsFromLocal() async {
    final db = DatabaseHelper.instance;
    return await db.fetchContacts();
  }

  Future<bool> syncContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final db = DatabaseHelper.instance;
    var contacts = await db.fetchUserContacts();

    final response = await http.post("$apiUrl/sync",
        body: json.encode({'contacts': contacts}),
        headers: {
          'Authorization': prefs.get('token'),
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200) {
      var contactsJson = json.decode(response.body);
      print(contactsJson);
      return true;
    } else {
      print(json.decode(response.body));
      return false;
    }
  }

  Future<List<MainContact>> syncContactsLocal() async {
    var phoneContacts = await getContactsFromPhone();
    var serverContacts = await getContactsFromServer();
    phoneContacts.addAll(serverContacts);

    final db = DatabaseHelper.instance;
    await db.syncContacts(phoneContacts);
    return phoneContacts;
  }

  List<MainContact> convertContactsToServerList(List<Contact> phoneContacts) {
    List<MainContact> contacts = List<MainContact>();
    phoneContacts.forEach((contact) {
      contacts.add(convertToServerContact(contact));
    });
    return contacts;
  }

  MainContact convertToServerContact(Contact contact) {
    var phones = {};
    contact.phones.forEach((phone) {
      phones[phone.label] = phone.value;
    });

    var emails = {};
    contact.emails.forEach((email) {
      emails[email.label] = email.value;
    });

    var addresses = {};
    contact.postalAddresses.forEach((address) {
      addresses[address.label] = "${address.street ?? ""} ${address.city ?? ""} ${address.country ?? ""} ${address.postcode ?? ""}".trim();
    });

    return MainContact(
        //contact.avatar.length > 0 ? Image.memory(contact.avatar) : null,
        contact.identifier,
        "",
        ContactName(contact.givenName, contact.familyName, contact.middleName,
            contact.displayName, contact.prefix, contact.suffix),
        contact.company ?? "",
        phones,
        emails,
        addresses,
        "",
        contact.note ?? "",
        null,
        {});
  }
}
