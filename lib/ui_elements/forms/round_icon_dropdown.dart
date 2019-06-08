import 'package:flutter/material.dart';

class RoundIconDropDown extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final Map<String, String> items;
  final Function onChanged;
  final EdgeInsets margin;
  final Function validator;
  final Function onSaved;

  RoundIconDropDown(
      {this.icon,
      this.hintText,
      this.items,
      this.onChanged,
      this.validator,
      this.onSaved,
      this.margin:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)});

  @override
  State<StatefulWidget> createState() => RoundIconDropDownState(
      this.icon,
      this.hintText,
      this.items,
      this.onChanged,
      this.onSaved,
      this.validator,
      this.margin);
}

class RoundIconDropDownState extends State<RoundIconDropDown> {
  final IconData icon;
  final String hintText;
  final Map<String, String> items;
  final Function onChanged;
  final Function onSaved;
  Function validator;
  final EdgeInsets margin;

  String selectedItem;
  String errorText;

  RoundIconDropDownState(this.icon, this.hintText, this.items, this.onChanged,
      this.onSaved, this.validator, this.margin);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: this.margin,
      child: DropdownButtonFormField<String>(
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
          hintStyle: TextStyle(color: Colors.grey)
        ),
        items: items.keys.map((String key) {
          return new DropdownMenuItem<String>(
            value: key,
            child: new Text(items[key]),
          );
        }).toList(),
        value: selectedItem,
        validator: this.validator,
        onChanged: (value) {
          setState(() {
            selectedItem = value;
          });
          this.onChanged(value);
        },
        onSaved: this.onSaved,
      ),
    );
  }
}
