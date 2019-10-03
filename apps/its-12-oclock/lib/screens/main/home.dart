import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:its_12_oclock/services/sign_in.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
              "Hey ${fbUser.displayName.split(" ")[0]}",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
