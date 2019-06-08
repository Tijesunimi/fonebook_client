import 'package:flutter/material.dart';

class RoundIconTextBox extends StatefulWidget {
  final IconData icon;
  final String hintText, errorText;
  final EdgeInsets margin;
  final TextInputType inputType;
  final bool obscureText;
  final Function validator;
  final Function onSaved;

  RoundIconTextBox(
      {this.icon,
      this.hintText,
      this.errorText,
      this.validator,
      this.onSaved,
      this.margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      this.inputType: TextInputType.text,
      this.obscureText: false});

  @override
  State<StatefulWidget> createState() => RoundIconTextBoxState(
      this.icon,
      this.hintText,
      this.errorText,
      this.validator,
      this.onSaved,
      this.margin,
      this.inputType,
      this.obscureText);
}

class RoundIconTextBoxState extends State<RoundIconTextBox> {
  final IconData icon;
  final String hintText, errorText;
  final EdgeInsets margin;
  final TextInputType inputType;
  final bool obscureText;
  final Function validator;
  final Function onSaved;

  RoundIconTextBoxState(
      this.icon,
      this.hintText,
      this.errorText,
      this.validator,
      this.onSaved,
      this.margin,
      this.inputType,
      this.obscureText);

  bool _autoValidate;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    _autoValidate = false;
    this.controller = TextEditingController();
    this.controller.addListener(startAutoValidate);
  }

  void startAutoValidate() {
    if (this.controller.text != "") {
      this.controller.removeListener(startAutoValidate);
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: this.margin,
      child: TextFormField(
        keyboardType: this.inputType,
        obscureText: this.obscureText,
        validator: this.validator,
        autovalidate: this._autoValidate,
        onSaved: this.onSaved,
        controller: this.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(this.icon),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
              borderRadius: const BorderRadius.all(
                const Radius.circular(20.0),
              )),
          hintText: this.hintText,
          errorText: this.errorText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
