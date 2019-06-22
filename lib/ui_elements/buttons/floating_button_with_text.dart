import 'package:flutter/material.dart';

class FloatingActionButtonWithText extends StatelessWidget {
  final String text;
  final IconData icon;
  final double width;

  FloatingActionButtonWithText({this.text, this.icon, this.width:100.0});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 50.0,
      width: this.width,
      child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          color: Theme.of(context).primaryColor,
          onPressed: () {},
          child: Row(
            children: <Widget>[
              Icon(this.icon, color: Colors.white),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(this.text, style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
    );
  }
}
