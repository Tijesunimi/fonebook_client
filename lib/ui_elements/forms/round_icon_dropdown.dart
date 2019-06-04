import 'package:flutter/material.dart';

class RoundIconDropDown extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final Map<String, String> items;
  final Function onChanged;

  RoundIconDropDown({this.icon, this.hintText, this.items, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 15.0),
            child: Icon(
              this.icon,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(this.hintText),
                isExpanded: true,
                items: items.keys.map((String key) {
                  return new DropdownMenuItem<String>(
                    value: key,
                    child: new Text(items[key]),
                  );
                }).toList(),
                onChanged: this.onChanged,
              ),
            ),
          )
        ],
      ),
    );
  }
}