import 'package:flutter/material.dart';
import 'package:fonebook_client/ui_elements/buttons/simple_round_icon_button.dart';
import 'package:fonebook_client/ui_elements/forms/round_icon_textbox.dart';
import 'package:fonebook_client/ui_elements/forms/round_icon_dropdown.dart';

class RegisterPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color backgroundColor = Colors.white12;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: new Container(
          //height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
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
                controller: emailController,
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
                controller: emailController,
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
                controller: emailController,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 10.0),
                child: Text(
                  "Country",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
              RoundIconDropDown(
                icon: Icons.location_city,
                items: {
                  '1': 'Nigeria',
                  '2': 'Ghana',
                  '3': 'Australia'
                },
                hintText: "Select your country",
                onChanged: (String value) {
                  debugPrint(value);
                },
              ),
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
                controller: emailController,
              ),
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
                controller: passwordController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: SimpleRoundIconButton(
                  backgroundColor: primaryColor,
                  buttonText:
                  Text("REGISTER", style: TextStyle(color: Colors.white)),
                  icon: Icon(Icons.arrow_forward),
                  iconAlignment: Alignment.centerRight,
                  onPressed: () {
                    debugPrint('Pressed');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}