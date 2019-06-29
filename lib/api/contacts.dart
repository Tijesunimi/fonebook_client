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

  Future<dynamic> getContactsFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get("$apiUrl/contacts",
        headers: {'Authorization': prefs.get('token')});

    if (response.statusCode == 200) {
      var contactsJson = json.decode(response.body);
      return contactsJson;
    } else {
      return [];
      //throw Exception('Could not fetch contacts');
    }
  }

  Future<List<Contact>> getContactsFromPhone() async {
    if (!await SimplePermissions.checkPermission(Permission.ReadContacts)) {
      var permissionStatus =
          await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (permissionStatus != PermissionStatus.authorized) {
        throw Exception('Contact permission is required');
      }
    }

    final contacts = await ContactsService.getContacts();
    return contacts.toList();
  }

  Future<List<MainContact>> getContactsFromLocal() async {
    final db = DatabaseHelper.instance;
    return await db.fetchContacts();
  }

  /*
    Get contacts from all three sources and add to a single list using hierarchy:
    1 - Phone Contact (assumed to be the most updated)
    2 - Local Db Contact
    3 - Server Contact (assumed to be the least updated)
  */
  Future<Map<Object, dynamic>> fetchContactsAndCategories() async {
    var allContacts = Map<String, MainContact>();
    var categoriesList = List<String>();

    var localContacts = await getContactsFromLocal();
    localContacts.forEach((contact) {
      allContacts[contact.identifier] = contact;

      if (!categoriesList.contains(contact.category) && contact.category != null && contact.category.isNotEmpty)
        categoriesList.add(contact.category);
    });

    var phoneContacts = await getContactsFromPhone();
    phoneContacts.forEach((contact) {
      var contactToAdd = allContacts.containsKey(contact.identifier) ?
        getUpdatedMainContactFromPhoneContact(allContacts[contact.identifier], contact) :
        getNewMainContactFromPhoneContact(contact);

      allContacts[contact.identifier] = contactToAdd;
      if (!categoriesList.contains(contactToAdd.category) && contactToAdd.category != null && contactToAdd.category.isNotEmpty)
        categoriesList.add(contactToAdd.category);
    });

    var serverContacts = await getContactsFromServer();
    serverContacts.map((contact) {
      if (!allContacts.containsKey(contact['identifier'])) {
        var contactToAdd = MainContact.fromJson(contact);

        allContacts[contact['identifier']] = contactToAdd;
        if (!categoriesList.contains(contactToAdd.category) && contactToAdd.category != null && contactToAdd.category.isNotEmpty)
          categoriesList.add(contactToAdd.category);
      }
    });

    categoriesList.add('Uncategorized');
    categoriesList.sort((a, b) => a.compareTo(b));

    var contactsList = allContacts.values.toList();
    contactsList.sort((a, b) => a.names.display.compareTo(b.names.display));
    return {
      'categories': categoriesList,
      'contacts': contactsList
    };
  }

  Future<bool> syncContactsToServer(List<MainContact> contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

  MainContact getUpdatedMainContactFromPhoneContact(MainContact mainContact, Contact phoneContact)  {
    var phones = {};
    phoneContact.phones.forEach((phone) {
      phones[phone.label] = phone.value;
    });

    var emails = {};
    phoneContact.emails.forEach((email) {
      emails[email.label] = email.value;
    });

    var addresses = {};
    phoneContact.postalAddresses.forEach((address) {
      addresses[address.label] = "${address.street ?? ""} ${address.city ?? ""} ${address.country ?? ""} ${address.postcode ?? ""}".trim();
    });

    return MainContact(
      mainContact.identifier,
      mainContact.category,
      ContactName(phoneContact.givenName, phoneContact.familyName, phoneContact.middleName,
          phoneContact.displayName, phoneContact.prefix, phoneContact.suffix),
      phoneContact.company,
      phones,
      emails,
      addresses,
      mainContact.website,
      phoneContact.note,
      mainContact.birthDate,
      mainContact.custom
    );
  }

  MainContact getNewMainContactFromPhoneContact(Contact contact) {
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
        contact.company,
        phones,
        emails,
        addresses,
        "",
        contact.note,
        null,
        {});
  }
}
