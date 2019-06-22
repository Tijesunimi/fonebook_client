import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

class Config extends InheritedWidget {
  final String env;
  final String appName;
  final String appTagLine;
  final String apiBaseUrl;

  Config({
    @required this.env,
    @required this.appName,
    @required this.appTagLine,
    @required this.apiBaseUrl,
    @required Widget child
  }) : super(child: child);

  User _loggedInUser;

  User get loggedInUser => _loggedInUser;

  set loggedInUser(user) {
    _loggedInUser = user;
  }

  static Config of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Config);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}