import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:its_12_oclock/services/firebase/firebase_history.dart';
import 'package:its_12_oclock/services/firebase/firebase_places.dart';
import 'package:its_12_oclock/services/google_maps/maps_places.dart';
import 'package:its_12_oclock/services/sign_in.dart';
import 'package:its_12_oclock/types/event.dart';
import 'package:its_12_oclock/types/location.dart';
import 'package:its_12_oclock/types/place.dart';
import 'package:its_12_oclock/widgets/navigation_drawer.dart';
import 'package:its_12_oclock/widgets/place_card.dart';
import 'package:its_12_oclock/widgets/place_dismissible.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Place>> recommendations;

  @override
  void initState() {
    super.initState();
    recommendations = _findPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('It\'s 12 o\'clock'),
      ),
      drawer: NavigationDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15),
          Text(
            'You could go to ...',
            style: TextStyle(fontSize: 20),
          ),
          _placesWidget(),
        ],
      ),
    );
  }

  Widget _placesWidget() {
    try {
      return FutureBuilder<List<Place>>(
          future: recommendations,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final Place place = snapshot.data[index];
                  final FirebaseUser user = Auth.fbUser;
                  return PlaceRecommendationDismissible(
                    key: Key(place.id),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        snapshot.data.removeAt(index);
                      });
                      if (direction == DismissDirection.startToEnd) {
                        FirebasePlaces.save(user, place, Event.liked);
                        FirebaseHistory.save(
                            user, place, Event.liked, DateTime.now());
                      } else {
                        FirebasePlaces.save(user, place, Event.disliked);
                        FirebaseHistory.save(
                            user, place, Event.disliked, DateTime.now());
                      }
                    },
                    child: PlaceCard(
                      onTap: () {
                        FirebasePlaces.save(user, place, Event.clicked);
                        FirebaseHistory.save(
                            user, place, Event.clicked, DateTime.now());
                      },
                      place: place,
                      trailing: _PlaceRecommendationTrailing(
                        onPressed: () {
                          FirebasePlaces.save(user, place, Event.launchMaps);
                          FirebaseHistory.save(
                              user, place, Event.launchMaps, DateTime.now());
                          try {
                            _launchMaps(place);
                          } on Exception catch (_) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Can\'t launch Maps.')));
                          }
                        },
                      ),
                      subtitle: Text(
                          'Rating: ${place.rating?.toStringAsPrecision(2)}'),
                    ),
                  );
                },
              ));
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              return Text('${snapshot.error.toString()}');
            }
            return Center(child: CircularProgressIndicator());
          });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print(e);
        return Text(e.message);
      } else {
        print(e);
        return Text(e.message);
      }
    } on MapsPlacesException catch (e) {
      return Text(e.message);
    }
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

  Future<List<Place>> _findPlaces() async {
    if (!await Geolocator().isLocationServiceEnabled()) {
      throw Exception('Location is disabled');
    }
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
    if (position == null) {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    }

    return MapsPlaces.searchNearby(Location.fromGeolocator(position));
  }
}

class _PlaceRecommendationTrailing extends StatelessWidget {
  const _PlaceRecommendationTrailing({Key key, this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.map),
      onPressed: onPressed,
      tooltip: 'Open on Maps',
    );
  }
}
