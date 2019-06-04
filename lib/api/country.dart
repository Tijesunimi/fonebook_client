import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fonebook_client/models/country.dart';
import 'package:http/http.dart' as http;

final apiUrl = 'http://10.0.2.2:3000/api';

Future<List<Country>> fetchCountries() async {
  debugPrint("Attempt to fetch countries");
  final response = await http.get("$apiUrl/countries");
  debugPrint("Gotten response");

  if (response.statusCode == 200) {
    var countriesJson = json.decode(response.body);
    debugPrint(countriesJson.toString());

    var countries = new List<Country>();
    countriesJson.forEach((dynamic country) {
      countries.add(Country.fromJson(country));
    });
    return countries;
  } else {
    throw Exception('Could not fetch countries');
  }
}
