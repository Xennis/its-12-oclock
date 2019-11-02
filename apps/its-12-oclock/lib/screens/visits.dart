import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/services/firebase/firebase_history.dart';
import 'package:its_12_oclock/services/sign_in.dart';

class VisitsScreen extends StatefulWidget {
  static const String routeName = '/visists';
  @override
  _VisitsScreenState createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Visits'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: _historyList(Auth.fbUser),
    );
  }

  Widget _historyList(FirebaseUser user) {
    return StreamBuilder<List<FirebaseHistoryEntry>>(
      stream: FirebaseHistory.streamClickedRecent(user),
      builder: (_, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, index) {
            return _historyItem(snapshot.data[index]);
          },
        );
      },
    );
  }

  Widget _historyItem(FirebaseHistoryEntry entry) {
    return ListTile(
      title: Text(entry.place.name),
      subtitle: Text(DateFormat.yMMMd().format(entry.timestamp.toDate())),
    );
  }
}
