import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/services/history.dart';
import 'package:its_12_oclock/services/sign_in.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = '/history';
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("History"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: _historyList(),
    );
  }

  Widget _historyList() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(fbUser.uid)
          .collection(History.collection)
          .orderBy(History.fieldTimestamp, descending: true)
          .limit(50)
          .snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return Center(
          child: CircularProgressIndicator()
        );
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (_, index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            return _historyItem(document);
          },
        );
      },
    );
  }

  Widget _historyItem(DocumentSnapshot document) {
    final String name = document[History.fieldName];
    final Timestamp timestamp = document[History.fieldTimestamp];
    final int eventIndex = document[History.fieldEvent];
    final Event event = Event.values[eventIndex];
    return ListTile(
      title: Text(name),
      subtitle: Row(children: <Widget>[
        Text(DateFormat.yMMMd().format(timestamp.toDate())),
        Text("  "),
        Icon(_eventIconData(event), size: 14.5, color: Colors.grey),
      ]),
    );
  }

  IconData _eventIconData(Event event) {
    switch (event) {
      case Event.clicked:
        return Icons.check_circle;
      case Event.disliked:
        return Icons.thumb_down;
      case Event.launch_maps:
        return Icons.map;
      case Event.liked:
      default:
        return Icons.thumb_up;
    }
  }
}
