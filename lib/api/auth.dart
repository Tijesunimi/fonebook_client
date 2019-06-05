import 'dart:async';
import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fonebook/models/user.dart';

class AuthApi {
  final String apiUrl;

  AuthApi(this.apiUrl);

  Future<Map<Object, dynamic>> doFacebookAuth() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        debugPrint("Error");
        return null;
        break;
      case FacebookLoginStatus.cancelledByUser:
        debugPrint("Cancelled By User");
        return null;
        break;
      case FacebookLoginStatus.loggedIn:
        final token = facebookLoginResult.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        debugPrint(profile.toString());
        return profile;
        break;
    }
    return null;
  }

  Future<User> loginSocial(Map<Object, dynamic> user) async {
    final response = await http.post("$apiUrl/loginsocial", body: json.encode(user), headers: {
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      var user = json.decode(response.body);
      return User.fromJson(user);
    }

    return null;
  }

  Future<User> registerUser(User user) async {
    final response = await http.post("$apiUrl/register", body: json.encode(user.toJson()), headers: {
      'Content-Type': 'application/json'
    });

    switch (response.statusCode) {
      case 422:
      case 400:
        debugPrint("Validation error");
        var errors = json.decode(response.body);
        debugPrint(errors.toString());
        return null;
        break;
      case 200:
        debugPrint("Success");
        var user = json.decode(response.body);
        return User.fromJson(user);
        break;
    }
  }

  Future<User> confirmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      final response = await http.get("$apiUrl/profile", headers: {
        'Authorization': prefs.get('token')
      });

      if (response.statusCode == 200) {
        var user = json.decode(response.body);
        return User.fromJson(user);
      }
    }

    throw Exception('Could not confirm token');
  }
}