import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:its_12_oclock/services/firebase/firebase_history.dart';
import 'package:its_12_oclock/services/firebase/firebase_places.dart';
import 'package:its_12_oclock/services/google_maps/maps_places.dart';
import 'package:its_12_oclock/types/event.dart';
import 'package:its_12_oclock/types/place.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceRecommendationDismissible extends StatelessWidget {
  const PlaceRecommendationDismissible(
      {Key key, @required this.place, @required this.user})
      : assert(place != null),
        assert(user != null),
        super(key: key);

  final Place place;
  final FirebaseUser user;

  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(place.id),
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
            FirebasePlaces.save(user, place, Event.liked);
            FirebaseHistory.save(user, place, Event.liked);
          } else {
            FirebasePlaces.save(user, place, Event.disliked);
            FirebaseHistory.save(user, place, Event.disliked);
          }
        },
        child: Column(children: <Widget>[
          _PlaceRecommendationCard(place: place, user: user),
        ]));
  }
}

class _PlaceRecommendationCard extends StatelessWidget {
  const _PlaceRecommendationCard(
      {Key key, @required this.place, @required this.user})
      : assert(place != null),
        assert(user != null),
        super(key: key);

  final Place place;
  final FirebaseUser user;

  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            leading: _PlaceRecommendationLeading(place: place),
            onTap: () {
              FirebasePlaces.save(user, place, Event.clicked);
              FirebaseHistory.save(user, place, Event.clicked);
            },
            title: Text(place.name),
            // TODO: Calculate distance: Distance: ${place.distance}m
            subtitle: Text('Rating: ${place.rating?.toStringAsPrecision(2)}'),
            trailing: _trailingLaunchMaps(context, place: place, user: user)));
  }

  String _placeAbbr(String name) {
    List<String> split = name.split(' ');
    if (split.length == 0) {
      return '';
    } else if (split.length == 1) {
      return split[0][0];
    }
    return split[0][0] + split[1][0];
  }

  Widget _trailingLaunchMaps(BuildContext context,
      {Place place, FirebaseUser user}) {
    return IconButton(
      icon: Icon(Icons.map),
      onPressed: () {
        FirebaseHistory.save(user, place, Event.launchMaps);
        FirebaseHistory.save(user, place, Event.launchMaps);
        try {
          _launchMaps(place);
        } on Exception catch (_) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Can\'t launch Maps.')));
        }
      },
      tooltip: 'Open on Maps',
    );
  }

  void _launchMaps(Place place) async {
    String url =
        'geo:${place.location.lat},${place.location.lng}?q=${place.name}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}

class _PlaceRecommendationLeading extends StatelessWidget {
  const _PlaceRecommendationLeading({Key key, @required this.place})
      : assert(place != null),
        super(key: key);

  final Place place;

  Widget build(BuildContext context) {
    if (place.photo == null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(_placeAbbr(place.name)),
      );
    }

    final String photoUrl =
        MapsPlaces.photoUrl(placePhoto: place.photo, maxHeight: 184);

    return GestureDetector(
      onTap: () {
        // TODO: Display in the UI
        place.photo.htmlAttributions?.forEach((a) => print(a));
      },
      child: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(photoUrl),
      ),
    );
  }

  String _placeAbbr(String name) {
    List<String> split = name.split(' ');
    if (split.length == 0) {
      return '';
    } else if (split.length == 1) {
      return split[0][0];
    }
    return split[0][0] + split[1][0];
  }
}
