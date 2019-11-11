import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/services/firebase/firebase_history.dart';
import 'package:its_12_oclock/services/sign_in.dart';
import 'package:its_12_oclock/widgets/place_card.dart';

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
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final FirebaseHistoryEntry entry = snapshot.data[index];
            return PlaceCard(
                place: entry.place,
                subtitle: _VisitsSubtitle(timestamp: entry.timestamp));
          },
        );
      },
    );
  }
}

class _VisitsSubtitle extends StatelessWidget {
  const _VisitsSubtitle({Key key, @required this.timestamp})
      : assert(timestamp != null),
        super(key: key);

  final Timestamp timestamp;

  Widget build(BuildContext context) {
    return Text(DateFormat.yMMMd().format(timestamp.toDate()));
  }
}
