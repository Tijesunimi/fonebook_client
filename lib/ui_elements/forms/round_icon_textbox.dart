import 'package:flutter/material.dart';

class RoundIconTextBox extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;

  RoundIconTextBox({this.icon, this.hintText, this.controller});

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
            child: TextField(
              controller: this.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.hintText,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }
}