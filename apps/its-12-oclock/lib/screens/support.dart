import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SupportScreen extends StatefulWidget {
  static const String routeName = '/support';
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Support"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Column(
        children: <Widget>[
          Text("Press F1!"),
        ]
      ),
    );
  }
}