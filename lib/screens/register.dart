import 'package:flutter/material.dart';
import 'package:fonebook_client/ui_elements/buttons/simple_round_icon_button.dart';
import 'package:fonebook_client/ui_elements/forms/round_icon_textbox.dart';
import 'package:fonebook_client/ui_elements/forms/round_icon_dropdown.dart';

import 'package:fonebook_client/api/country.dart';
import 'package:fonebook_client/models/country.dart';
import 'package:fonebook_client/config.dart';

class RegisterPage extends StatelessWidget {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color backgroundColor = Colors.white12;

    final CountryApi countryApi = CountryApi(Config.of(context).apiBaseUrl);

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
                controller: firstNameController,
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
                controller: lastNameController,
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
                controller: phoneController,
              ),
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
                      items: Map.fromIterable(snapshot.data, key: (v) => v.id.toString(), value: (v) => v.name),
                      hintText: "Select your country",
                      onChanged: (String value) {
                        debugPrint(value);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner
                  return Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: CircularProgressIndicator()
                  );
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