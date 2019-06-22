import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:fonebook/ui_elements/buttons/simple_round_icon_button.dart';
import 'package:fonebook/ui_elements/forms/round_icon_textbox.dart';
import 'package:fonebook/ui_elements/forms/round_icon_dropdown.dart';

import 'package:fonebook/config.dart';

import 'package:fonebook/api/country.dart';
import 'package:fonebook/api/auth.dart';

import 'package:fonebook/models/country.dart';
import 'package:fonebook/models/user.dart';

class RegisterPage extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final TextEditingController firstNameController = TextEditingController();
  static final TextEditingController lastNameController = TextEditingController();
  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController phoneController = TextEditingController();
  static final TextEditingController countryController = TextEditingController();
  static final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color backgroundColor = Colors.white12;

    final Config config = Config.of(context);
    final CountryApi countryApi = CountryApi(config.apiBaseUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
              child: new Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                        child: Text(
                          "First Name",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ),
                      RoundIconTextBox(
                        icon: Icons.person_outline,
                        hintText: 'Enter your first name',
                        onSaved: (value) {
                          firstNameController.text = value;
                        },
                        validator: (value) {
                          if (value.trim().isEmpty)
                            return 'First name is required';
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 10.0),
                        child: Text(
                          "Last Name",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ),
                      RoundIconTextBox(
                          icon: Icons.person_outline,
                          hintText: 'Enter your last name',
                          onSaved: (value) {
                            lastNameController.text = value;
                          },
                          validator: (value) {
                            if (value.trim().isEmpty)
                              return 'Last name is required';
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 10.0),
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
                                  key: (v) => v.id.toString(),
                                  value: (v) => v.name),
                              hintText: "Select your country",
                              onSaved: (value) {
                                countryController.text = value;
                              },
                              onChanged: (String value) {
                                //_formKey.currentState.validate();
                              },
                              validator: (value) {
                                if (value == null) return 'Country is required';
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner
                          return Padding(
                              padding: EdgeInsets.only(left: 40.0),
                              child: CircularProgressIndicator());
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 10.0),
                        child: Text(
                          "Phone",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ),
                      RoundIconTextBox(
                          icon: Icons.phone,
                          hintText: 'Enter your phone number',
                          inputType: TextInputType.number,
                          onSaved: (value) {
                            phoneController.text = value;
                          },
                          validator: (value) {
                            if (value.trim().isEmpty)
                              return 'Phone number is required';
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 10.0),
                        child: Text(
                          "Email",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ),
                      RoundIconTextBox(
                          icon: Icons.person_outline,
                          hintText: 'Enter your email',
                          inputType: TextInputType.emailAddress,
                          onSaved: (value) {
                            emailController.text = value;
                          },
                          validator: (value) {
                            if (value.trim().isEmpty)
                              return 'Email address is required';
                            else {
                              String pattern =
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
                              if (!RegExp(pattern).hasMatch(value))
                                return 'Email address is not valid';
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 10.0),
                        child: Text(
                          "Password",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ),
                      RoundIconTextBox(
                          icon: Icons.lock_open,
                          hintText: 'Enter your password',
                          obscureText: true,
                          onSaved: (value) {
                            passwordController.text = value;
                          },
                          validator: (value) {
                            if (value.trim().isEmpty)
                              return 'Password is required';
                          }),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        child: SimpleRoundIconButton(
                          backgroundColor: primaryColor,
                          buttonText: Text("REGISTER",
                              style: TextStyle(color: Colors.white)),
                          icon: Icon(Icons.arrow_forward),
                          iconAlignment: Alignment.centerRight,
                          onPressed: () => doRegistration(context, config),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  void doRegistration(BuildContext context, Config config) async {
    final AuthApi authApi = AuthApi(config.apiBaseUrl);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Please wait...");
      pr.show();
      try {
        var userProfile = await authApi.registerUser(User(
            firstNameController.text,
            lastNameController.text,
            emailController.text,
            countryController.text,
            phoneController.text,
            passwordController.text,
            false));
        if (userProfile != null) {
          await authApi.saveToken(userProfile.token);
          config.loggedInUser = userProfile;

          pr.hide();
          Navigator.popAndPushNamed(context, 'home', arguments: {
            'isNewLogin': true
          });
        } else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Registration error. Please try again')));
        }
      } catch (e) {
        pr.hide();
        var error = e.message is Map && e.message.containsKey("message")
            ? e.message["message"]
            : "Registration error. Please try again";
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }
}
