import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fonebook/models/country.dart';
import 'package:http/http.dart' as http;

class CountryApi {
  final String apiUrl;

  CountryApi(this.apiUrl);

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
}