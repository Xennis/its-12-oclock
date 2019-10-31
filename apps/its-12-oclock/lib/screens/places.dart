import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/models/event.dart';
import 'package:its_12_oclock/services/history.dart';
import 'package:its_12_oclock/services/sign_in.dart';

class PlacesScreen extends StatefulWidget {
  static const String routeName = '/places';
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("My places"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: _placesList(Auth.fbUser),
    );
  }

  Widget _placesList(FirebaseUser user) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(user.uid)
          .collection(History.collectionPlaces)
          .orderBy(History.fieldScore, descending: true)
          .limit(50)
          .snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (_, index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            return _placeItem(document);
          },
        );
      },
    );
  }

  Widget _placeItem(DocumentSnapshot document) {
    final String name = document[History.fieldName];
    final num score = document[History.fieldScore];

    return ListTile(
        title: Text(name),
        subtitle: Row(
            children: <Widget>[
                  Text("Score: $score  –  "),
                ] +
                _eventCount(document, Event.clicked) +
                _eventCount(document, Event.launchMaps) +
                _eventCount(document, Event.liked) +
                _eventCount(document, Event.disliked)));
  }

  List<Widget> _eventCount(DocumentSnapshot document, Event event) {
    int count = document["event_" + event.name];
    if (count == null) {
      count = 0;
    }
    return <Widget>[
      Text("${count.toString().padLeft(3, "0")} "),
      Icon(event.iconData,
          size: 14.5, color: Colors.grey, semanticLabel: event.name),
      Text("    ")
    ];
  }
}
