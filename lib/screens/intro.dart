import 'package:flutter/material.dart';

import 'package:fonebook/config.dart';

import 'package:fonebook/api/auth.dart';
import 'package:fonebook/api/country.dart';

import 'package:fonebook/models/country.dart';
import 'package:fonebook/models/user.dart';

import 'package:fonebook/ui_elements/buttons/social_button.dart';
import 'package:fonebook/ui_elements/forms/round_icon_dropdown.dart';
import 'package:fonebook/ui_elements/forms/round_icon_textbox.dart';

class IntroPage extends StatelessWidget {
  static final TextEditingController countryController = TextEditingController();
  static final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color backgroundColor = Colors.white12;
    final AuthApi authApi = AuthApi(Config.of(context).apiBaseUrl);

    // TODO: implement build
    return Scaffold(
      body: Builder(
        builder: (context) => SingleChildScrollView(
              child: new Container(
                //height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipPath(
                      clipper: HeaderClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 110.0, bottom: 100.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              Config.of(context).appName,
                              style: TextStyle(
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              Config.of(context).appTagLine,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: SocialButton(
                        socialMedia: SocialMedia.Google,
                        buttonText: "Continue with Google",
                        onPressed: () => doSocialLogin(context, authApi, 'google'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: SocialButton(
                        socialMedia: SocialMedia.Facebook,
                        buttonText: "Continue with Facebook",
                        onPressed: () => doSocialLogin(context, authApi, 'facebook'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 20.0),
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.25)),
                            ),
                          ),
                          Text(
                            "OR USE EMAIL",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          new Expanded(
                            child: new Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.25)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              color: Colors.transparent,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('login');
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              color: Colors.transparent,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('register');
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }

  static final _formKey = GlobalKey<FormState>();

  Widget _buildCountryDialog(BuildContext context) {
    final CountryApi countryApi = CountryApi(Config.of(context).apiBaseUrl);
    countryController.text = "";
    phoneController.text = "";

    return AlertDialog(
      title: Text('Complete Registration'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  "Country",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
              FutureBuilder<List<Country>>(
                future: countryApi.fetchCountries(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RoundIconDropDown(
                        icon: Icons.location_city,
                        items: Map.fromIterable(snapshot.data,
                            key: (v) => v.id.toString(), value: (v) => v.name),
                        hintText: "Select your country",
                        margin: EdgeInsets.only(top: 10.0),
                        onChanged: (String value) {},
                        onSaved: (String value) {
                          countryController.text = value;
                        },
                        validator: (value) {
                          if (value == null) return 'Country is required';
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner
                  return Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: CircularProgressIndicator());
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                child: Text(
                  "Phone",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
              RoundIconTextBox(
                icon: Icons.phone,
                hintText: 'Enter your phone number',
                margin: EdgeInsets.only(top: 10.0),
                inputType: TextInputType.number,
                validator: (value) {
                  if (value.trim().isEmpty) return 'Phone number is required';
                },
                onSaved: (value) {
                  phoneController.text = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              Navigator.of(context).pop();
            }
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Submit'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void doSocialLogin(BuildContext context, AuthApi authApi, String media) async {
    final profile = media == 'facebook' ? await authApi.doFacebookAuth() : await authApi.doGoogleAuth();
    if (profile != null) {
      final existingUser = await authApi.loginSocial({
        'email': profile['email'],
        'password': "$media-${profile['id']}"
      });

      if (existingUser != null) {
        await authApi.saveToken(existingUser.token);
        Navigator.popAndPushNamed(context, 'home');
      } else {
        await showDialog(
          context: context,
          builder: (BuildContext context) => _buildCountryDialog(context),
        );

        if (phoneController.text.trim() != "" && countryController.text != "") {
          var userProfile = await authApi.registerUser(User(
            profile['first_name'],
            profile['last_name'],
            profile['email'],
            countryController.text,
            phoneController.text,
            "$media-${profile['id']}",
            true));

          if (userProfile != null) {
            await authApi.saveToken(userProfile.token);
            Navigator.popAndPushNamed(context, 'home');
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('An error occurred. Please try again')));
          }
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Registration cancelled. Please try again')));
        }
      }
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again')));
    }
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
