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
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Position position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15),
            Text(
              "Hey ${fbUser.displayName.split(" ")[0]}, I recommend you",
              style: TextStyle(fontSize: 20),
            ),
            _placesWidget(),
          ],
        ),
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
    String url = 'geo:${place.location.lat},${place.location.lng}?q=${place.name}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _placesWidget() {
    return FutureBuilder<List<Place>>(
        future: _findPlaces(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                Place place = snapshot.data[index];
                return Dismissible(
                    key: Key(index.toString()),
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
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Liked ${place.name}")));
                      } else {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Disliked ${place.name}")));
                      }
                    },
                    child: Column(children: <Widget>[
                      Card(
                        child: ListTile(
                            leading: CircleAvatar(
                              child: Text(_placeAbbr(place.name)),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            onTap: () {
                              History.save(fbUser, place);
                            },
                            title: Text(place.name),
                            subtitle: Text(
                                "Distance: ${place.distance}m, Rating: ${place.rating}"),
                            trailing: IconButton(
                              icon: Icon(Icons.map),
                              onPressed: () {
                                try {
                                  _launchMaps(place);
                                } on Exception catch(e) {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("Can't launch Maps.")));
                                }
                              },
                              tooltip: "Open on Maps",
                            )),
                      )
                    ]));
              },
            );
          } else if (snapshot.hasError) {
            log(snapshot.error);
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }

  Future<List<Place>> _findPlaces() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      IdTokenResult tokenResult = await user.getIdToken(refresh: true);

      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return PlaceFinder.find(
          Location(lat: position.latitude, lng: position.longitude),
          tokenResult.token);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // TODO: Handle error
        print(e);
        throw e;
      } else {
        // TODO: Handle error
        print(e);
        throw e;
      }
    }
  }
}
