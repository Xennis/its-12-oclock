import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/services/settings.dart';
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
            _settingItem(
              title: "Account",
              subtitle: "Logged in as ${fbUser.email}",
              action: RaisedButton(
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
            ),
            Divider(color: Colors.black),
            _settingItem(
                title: "PlaceFinder",
                subtitle: "Use mock data",
                action: Switch(
                  value: usePlaceFinderMock,
                  onChanged: (bool value) {
                    usePlaceFinderMock = value;
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _settingItem({String title, String subtitle, Widget action}) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 16.0)),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          action,
        ],
      ),
    );
  }
}
