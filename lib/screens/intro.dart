import 'package:flutter/material.dart';
import 'package:fonebook/ui_elements/buttons/social_button.dart';
import 'package:fonebook/config.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color backgroundColor = Colors.white12;

    // TODO: implement build
    return Scaffold(
      body: new Container(
        //height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 110.0, bottom: 100.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      Config.of(context).appName,
                      style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      Config.of(context).appTagLine,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: SocialButton(
                socialMedia: SocialMedia.Google,
                buttonText: "Continue with Google",
                onPressed: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: SocialButton(
                socialMedia: SocialMedia.Facebook,
                buttonText: "Continue with Facebook",
                onPressed: () {},
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.all(8.0),
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.25)),
                    ),
                  ),
                  Text(
                    "OR USE EMAIL",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.all(8.0),
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.25)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.transparent,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "LOGIN",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('login');
                      },
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.transparent,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "REGISTER",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('register');
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
