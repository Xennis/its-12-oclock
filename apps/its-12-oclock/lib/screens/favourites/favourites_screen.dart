import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/services/firebase/firebase_places.dart';
import 'favourites_item.dart';
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
            title: Text('Favourites'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: _placesList(context, Auth.fbUser));
  }

  Widget _placesList(BuildContext context, FirebaseUser user) {
    return StreamBuilder<List<FirebasePlacesEntry>>(
      stream: FirebasePlaces.streamFavourites(user),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              final FirebasePlacesEntry entry = snapshot.data[index];
              return Column(children: <Widget>[
                FavouritePlaceCard(place: entry.place, score: entry.score)
              ]);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
