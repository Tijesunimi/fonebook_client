import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:fonebook/config.dart';

import 'package:fonebook/api/auth.dart';

import 'package:fonebook/ui_elements/buttons/simple_round_icon_button.dart';
import 'package:fonebook/ui_elements/forms/round_icon_textbox.dart';

class LoginPage extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color backgroundColor = Colors.white12;

    final Config config = Config.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: new Container(
            //height: MediaQuery.of(context).size.height,
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
                      "Email",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  RoundIconTextBox(
                    icon: Icons.person_outline,
                    hintText: 'Enter your email',
                    onSaved: (value) {
                      emailController.text = value;
                    },
                    validator: (value) {
                      if (value.trim().isEmpty) return 'Email address is required';
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
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
                      if (value.trim().isEmpty) return 'Password is required';
                    }
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: SimpleRoundIconButton(
                      backgroundColor: primaryColor,
                      buttonText:
                          Text("LOGIN", style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.arrow_forward),
                      iconAlignment: Alignment.centerRight,
                      onPressed: () {
                        doLogin(context, config);
                      },
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

  void doLogin(BuildContext context, Config config) async {
    final AuthApi authApi = AuthApi(config.apiBaseUrl);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage("Please wait...");
      pr.show();

      var userProfile = await authApi.loginUser({
        'email': emailController.text,
        'password': passwordController.text
      });
      if (userProfile != null) {
        await authApi.saveToken(userProfile.token);
        config.loggedInUser = userProfile;

        pr.hide();
        Navigator.popAndPushNamed(context, 'home', arguments: {
          'isNewLogin': true
        });
      } else {
        pr.hide();
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')));
      }
    }
  }
}