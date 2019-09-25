import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:its_12_oclock/sign_in.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              "Hey $name",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
