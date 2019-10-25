import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:its_12_oclock/screens/login/login.dart';
import 'package:its_12_oclock/services/history.dart';
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
            SizedBox(height: 15),
            Text(
              "History",
              style: TextStyle(fontSize: 24),
            ),
            Expanded(child: _historyWidget()),
          ],
        ),
      ),
    );
  }

  IconData _event(Event event) {
    switch(event) {
      case Event.clicked:
        return Icons.check_circle;
      case Event.disliked:
        return Icons.thumb_down;
      case Event.launch_maps:
        return Icons.map;
      case Event.liked:
      return Icons.thumb_up;
    }
  }

  Widget _historyWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(fbUser.uid)
          .collection(History.collection)
          .orderBy(History.fieldTimestamp, descending: true)
          .snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (_, index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            final String name = document[History.fieldName];
            final Timestamp timestamp = document[History.fieldTimestamp];
            final int eventIndex = document[History.fieldEvent];
            final Event event = Event.values[eventIndex];
            return ListTile(
              title: Text(name),
              subtitle: Row(
                children: <Widget>[
                  Text(DateFormat.yMMMd().format(timestamp.toDate())),
                  Text("  "),
                  Icon(_event(event), size: 14.5, color: Colors.grey),
                ]
              ),
            );
          },
        );
      },
    );
  }
}
