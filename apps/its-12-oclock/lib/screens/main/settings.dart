import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:its_12_oclock/screens/login/login.dart';
import 'package:its_12_oclock/services/sign_in.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  Position position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15),
            Text(
              "Account",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }), ModalRoute.withName('/login'));
              },
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
