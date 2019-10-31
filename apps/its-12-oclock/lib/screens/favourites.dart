import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/services/history.dart';
import 'package:its_12_oclock/services/sign_in.dart';

class FavouritesScreen extends StatefulWidget {
  static const String routeName = '/favourites';
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("Favourites"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Column(children: <Widget>[
          _placesList(Auth.fbUser),
        ]));
  }

  Widget _placesList(FirebaseUser user) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(user.uid)
          .collection(History.collectionPlaces)
          .where(History.fieldScore, isGreaterThanOrEqualTo: 1)
          .orderBy(History.fieldScore, descending: true)
          .limit(15)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
              child: ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (_, index) {
              final DocumentSnapshot document = snapshot.data.documents[index];
              return Column(
                  children: <Widget>[Card(child: _placeItem(document))]);
            },
          ));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _placeItem(DocumentSnapshot document) {
    final String name = document[History.fieldName];
    final num score = document[History.fieldScore];
    return ListTile(
        title: Text(name),
        subtitle: Row(children: <Widget>[
          Text("Score: $score"),
        ]));
  }
}
