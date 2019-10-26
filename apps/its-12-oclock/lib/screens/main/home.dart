import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:its_12_oclock/models/location.dart';
import 'package:its_12_oclock/models/place.dart';
import 'package:its_12_oclock/services/history.dart';
import 'package:its_12_oclock/services/placefinder.dart';
import 'package:its_12_oclock/services/sign_in.dart';
import 'package:its_12_oclock/widgets/navigation_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';
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

  _launchMaps(Place place) async {
    String url =
        'geo:${place.location.lat},${place.location.lng}?q=${place.name}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Position> _getPosition() async {
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (!isLocationEnabled) {
      // TODO: Inform the user.
      //Scaffold.of(context)
      //    .showSnackBar(SnackBar(content: Text("Location service is off")));
      return Geolocator().getLastKnownPosition();
    }
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Widget _placesWidget() {
    try {
      return FutureBuilder<List<Place>>(future: () async {
        Position position = await _getPosition();
        return _findPlaces(position);
      }(), builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              return _placeDismissible(context, snapshot.data[index]);
            },
          );
        } else if (snapshot.hasError) {
          log(snapshot.error);
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print(e);
        return Text(e.message);
      } else {
        print(e);
        return Text(e.message);
      }
    } on PlaceFinderException catch (e) {
      return Text(e.message);
    }
  }

  Widget _placeDismissible(BuildContext context, Place place) {
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
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Liked ${place.name}")));
            History.save(fbUser, place, Event.liked);
          } else {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Disliked ${place.name}")));
            History.save(fbUser, place, Event.disliked);
          }
        },
        child: Column(children: <Widget>[
          Card(
            child: _placeItem(place),
          )
        ]));
  }

  Widget _placeItem(Place place) {
    return ListTile(
        leading: CircleAvatar(
          child: Text(_placeAbbr(place.name)),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onTap: () {
          History.save(fbUser, place, Event.clicked);
        },
        title: Text(place.name),
        subtitle: Text("Distance: ${place.distance}m, Rating: ${place.rating}"),
        trailing: IconButton(
          icon: Icon(Icons.map),
          onPressed: () {
            History.save(fbUser, place, Event.launch_maps);
            try {
              _launchMaps(place);
            } on Exception catch (_) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Can't launch Maps.")));
            }
          },
          tooltip: "Open on Maps",
        ));
  }

  Future<List<Place>> _findPlaces(Position position) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      IdTokenResult tokenResult = await user.getIdToken(refresh: true);
      return PlaceFinder.find(
          Location(lat: position.latitude, lng: position.longitude),
          tokenResult.token);
    } on PlatformException catch (e) {
      throw e;
    } on PlaceFinderException catch (e) {
      throw e;
    }
  }
}
