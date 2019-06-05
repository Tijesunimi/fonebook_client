import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final SocialMedia socialMedia;
  final String buttonText;
  final Function onPressed;

  SocialButton({this.socialMedia, this.buttonText, this.onPressed});

  Color buttonColor;
  Icon buttonIcon;

  @override
  Widget build(BuildContext context) {
    setButtonProperties();

    // TODO: implement build
    return FlatButton(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      color: buttonColor,
      onPressed: onPressed,
      child: new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new FlatButton(
                onPressed: this.onPressed,
                padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: buttonIcon,
                    ),
                    Expanded(
                      child: Text(
                        buttonText,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setButtonProperties() {
    switch (this.socialMedia) {
      case SocialMedia.Facebook:
        buttonColor = Color(0Xff3B5998);
        buttonIcon = Icon(
          const IconData(0xea90,
            fontFamily: 'icomoon'),
          color: Colors.white,
          size: 15.0,
        );
        break;
      case SocialMedia.Google:
        buttonColor = Color(0Xffdb3236);
        buttonIcon = Icon(
          const IconData(0xea88,
            fontFamily: 'icomoon'),
          color: Colors.white,
          size: 15.0,
        );
        break;
      default:
        buttonColor = Color(0Xffdb3236);
        buttonIcon = Icon(
          Icons.email,
          color: Colors.white,
          size: 15.0,
        );
    }
  }


}

enum SocialMedia {
  Google, Facebook
}