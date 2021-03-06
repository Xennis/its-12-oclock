import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/services/firestore/firestore_history.dart';
import 'package:its_12_oclock/services/firebase/firebase_auth.dart';
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
      body: _historyList(AppAuth.fbUser),
    );
  }

  Widget _historyList(FirebaseUser user) {
    return StreamBuilder<List<FirestoreHistoryEntry>>(
      stream: FirestoreHistory.streamClickedRecent(user),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final FirestoreHistoryEntry entry = snapshot.data[index];
            return PlaceCard(
                place: entry.place,
                subtitle: _VisitsSubtitle(date: entry.date));
          },
        );
      },
    );
  }
}

class _VisitsSubtitle extends StatelessWidget {
  const _VisitsSubtitle({Key key, @required this.date})
      : assert(date != null),
        super(key: key);

  final DateTime date;

  Widget build(BuildContext context) {
    return Text(MaterialLocalizations.of(context).formatMediumDate(date));
  }
}
