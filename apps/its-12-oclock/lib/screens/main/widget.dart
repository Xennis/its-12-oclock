import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:its_12_oclock/models/event.dart';
import 'package:its_12_oclock/services/history.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceRecommendationDismissible extends StatelessWidget {
  PlaceRecommendationDismissible({Key key, @required this.place, @required this.user});

  final PlacesSearchResult place;
  final FirebaseUser user;

  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(place.placeId),
        background: Container(
          alignment: AlignmentDirectional.centerStart,
          color: Theme.of(context).primaryColor,
          child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              child: Icon(Icons.thumb_up, color: Colors.white)),
        ),
        secondaryBackground: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0),
              child: Icon(Icons.thumb_down, color: Colors.white)),
        ),
        onDismissed: (DismissDirection direction) {
          //setState(() {
          //  snapshot.data.removeAt(index);
          //});
          if (direction == DismissDirection.startToEnd) {
            History.save(user, place, Event.liked);
          } else {
            History.save(user, place, Event.disliked);
          }
        },
        child: Column(children: <Widget>[
          _PlaceRecommendationCard(place: place, user: user),
        ]));
  }
}

class _PlaceRecommendationCard extends StatelessWidget {
  _PlaceRecommendationCard({Key key, @required this.place, @required this.user});

  final PlacesSearchResult place;
  final FirebaseUser user;

  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            leading: CircleAvatar(
              child: Text(_placeAbbr(place.name)),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onTap: () {
              History.save(user, place, Event.clicked);
            },
            title: Text(place.name),
            // TODO: Calculate distance: Distance: ${place.distance}m
            subtitle: Text("Rating: ${place.rating.toStringAsPrecision(2)}"),
            trailing: _trailingLaunchMaps(context, place: place, user: user)));
  }

  String _placeAbbr(String name) {
    List<String> split = name.split(" ");
    if (split.length == 0) {
      return "";
    } else if (split.length == 1) {
      return split[0][0];
    }
    return split[0][0] + split[1][0];
  }

  Widget _trailingLaunchMaps(BuildContext context,
      {PlacesSearchResult place, FirebaseUser user}) {
    return IconButton(
      icon: Icon(Icons.map),
      onPressed: () {
        History.save(user, place, Event.launchMaps);
        try {
          _launchMaps(place);
        } on Exception catch (_) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Can't launch Maps.")));
        }
      },
      tooltip: "Open on Maps",
    );
  }

  void _launchMaps(PlacesSearchResult place) async {
    String url =
        'geo:${place.geometry.location.lat},${place.geometry.location.lng}?q=${place.name}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
