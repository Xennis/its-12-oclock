import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/services/sign_in.dart';

import 'login/login.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Settings"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
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