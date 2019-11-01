import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:its_12_oclock/models/event.dart';
import 'package:its_12_oclock/services/history.dart';
import 'package:its_12_oclock/services/maps/places.dart';
import 'package:its_12_oclock/services/sign_in.dart';
import 'package:its_12_oclock/widgets/navigation_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position position;

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
            "You could go to ...",
            style: TextStyle(fontSize: 20),
          ),
          _placesWidget(),
        ],
      ),
    );
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

  void _launchMaps(PlacesSearchResult place) async {
    String url =
        'geo:${place.geometry.location.lat},${place.geometry.location.lng}?q=${place.name}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Widget _placesWidget() {
    try {
      return FutureBuilder<List<PlacesSearchResult>>(
          future: _findPlaces(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return _placeDismissible(context,
                      place: snapshot.data[index], user: Auth.fbUser);
                },
              ));
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              return Text("${snapshot.error.toString()}");
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
    } on PlacesServiceException catch (e) {
      return Text(e.message);
    }
  }

  Widget _placeDismissible(BuildContext context,
      {PlacesSearchResult place, FirebaseUser user}) {
    return Dismissible(
        key: Key(place.placeId),
        background: Container(
          alignment: AlignmentDirectional.centerStart,
          color: Colors.green,
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
          Card(
            child: _placeItem(place: place, user: user),
          )
        ]));
  }

  Widget _placeItem({PlacesSearchResult place, FirebaseUser user}) {
    return ListTile(
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
        trailing: _trailingLaunchMaps(context, place: place, user: user));
  }

  Widget _trailingLaunchMaps(BuildContext context, {PlacesSearchResult place, FirebaseUser user}) {
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

  Future<List<PlacesSearchResult>> _findPlaces() async {
    if (!await Geolocator().isLocationServiceEnabled()) {
      throw Exception("Location is disabled");
    }
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    try {
      return PlacesService.searchNearby(
          Location(position.latitude, position.longitude));
    } on PlatformException catch (e) {
      throw e;
    } on PlacesServiceException catch (e) {
      throw e;
    }
  }
}
