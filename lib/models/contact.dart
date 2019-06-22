import 'package:flutter/material.dart';
import 'dart:convert';

class MainContact {
  //final Image avatar;
  final String identifier;
  final String category;
  final ContactName names;
  final String company;
  final Map<Object, dynamic> phones;
  final Map<Object, dynamic> emails;
  final Map<Object, dynamic> addresses;
  final String website;
  final String notes;
  final DateTime birthDate;
  final Map<Object, dynamic> custom;
  final bool isServerManaged;

  MainContact(//this.avatar,
      this.identifier,
      this.category,
      this.names,
      this.company,
      this.phones,
      this.emails,
      this.addresses,
      this.website,
      this.notes,
      this.birthDate,
      this.custom,
      {this.isServerManaged:false});

  factory MainContact.fromJson(Map<String, dynamic> data) {
    return MainContact(
      //Image.network(data['avatar']),
      data['identifier'],
      data['category'],
      ContactName.fromJson(data['names']),
      data['company'] ?? "",
      data['phones'] ?? {},
      data['emails'] ?? {},
      data['addresses'] ?? {},
      data['website'] ?? "",
      data['notes'] ?? "",
      data['birth_date'] != null ? DateTime.parse(data['birth_date']) : null,
      data['custom'] ?? {},
      isServerManaged: data['is_country']
    );
  }

  factory MainContact.fromLocalJson(Map<String, dynamic> data) {
    return MainContact(
      //Image.network(data['avatar']),
      data['id'],
      data['category'],
      ContactName.fromJson(json.decode(data['names'])),
      data['company'] ?? "",
      data['phones'] != null ? json.decode(data['phones']) : {},
      data['emails'] != null ? json.decode(data['emails']) : {},
      data['addresses'] != null ? json.decode(data['addresses']) : {},
      data['website'] ?? "",
      data['notes'] ?? "",
      data['birth_date'] != null ? DateTime.parse(data['birth_date']) : null,
      data['custom'] != null ? json.decode(data['custom']) : {},
      isServerManaged: data['is_country'] ?? false
    );
  }

  Map<Object, dynamic> toJson() {
    return {
      'identifier': this.identifier,
      'category': this.category,
      'names': {
        'display': this.names.display,
        'first': this.names.first,
        'last': this.names.last,
        'middle': this.names.middle,
        'prefix': this.names.prefix,
        'suffix': this.names.suffix
      },
      'company': this.company,
      'phones': this.phones,
      'emails': this.emails,
      'addresses': this.addresses,
      'website': this.website,
      'notes': this.notes,
      'birth_date': this.birthDate == null ? null : this.birthDate.toString(),
      'custom': this.custom,
      'is_country': this.isServerManaged
    };
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'avatar': '',
      'id': this.identifier,
      'category': this.category,
      'names': json.encode({
        'display': this.names.display,
        'first': this.names.first,
        'last': this.names.last,
        'middle': this.names.middle,
        'prefix': this.names.prefix,
        'suffix': this.names.suffix
      }),
      'company': this.company,
      'phones': json.encode(this.phones),
      'emails': json.encode(this.emails),
      'addresses': json.encode(this.addresses),
      'website': this.website,
      'notes': this.notes,
      'birth_date': this.birthDate == null ? null : this.birthDate.toString(),
      'custom': json.encode(this.custom),
      'is_server_managed': this.isServerManaged
    };
  }
}

class ContactName {
  final String first;
  final String last;
  final String middle;
  final String display;
  final String prefix;
  final String suffix;

  ContactName(this.first, this.last, this.middle, this.display, this.prefix, this.suffix);

  factory ContactName.fromJson(Map<Object, dynamic> json) {
    return ContactName(
      json['first'] ?? "",
      json['last'] ?? "",
      json['middle'] ?? "",
      json['display'] ?? "",
      json['prefix'] ?? "",
      json['suffix'] ?? ""
    );
  }

  Map<Object, dynamic> toJson() {
    return {
      'first': this.first,
      'last': this.last,
      'middle': this.middle,
      'display': this.display,
      'prefix': this.prefix,
      'suffix': this.suffix
    };
  }

  String toFullName() {
    return "${this.prefix ?? ""} ${this.first ?? ""} ${this.middle ?? ""} ${this.last ?? ""} ${this.suffix ?? ""}".trim();
  }
}