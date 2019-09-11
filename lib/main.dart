import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'It\'s 12 o\'clock',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(title: 'It\'s 12 o\'clock'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _saveCurrentRestaurant,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text("Save restaurant"),
            ),
          ],
        ),
      ),
    );
  }

  _saveCurrentRestaurant() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      log(position.latitude.toString());
      log(position.longitude.toString());
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // TODO: Handle error
        print(e);
      } else {
        // TODO: Handle error
        print(e);
      }
    }
  }
}
