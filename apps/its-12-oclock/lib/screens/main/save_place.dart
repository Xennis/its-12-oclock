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

class SavePlaceWidget extends StatefulWidget {
  @override
  _SavePlaceWidgetState createState() => _SavePlaceWidgetState();
}

class _SavePlaceWidgetState extends State<SavePlaceWidget> {
  Position position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15),
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.refresh),
              onPressed: () {
                _findPlaces();
                setState(() {});
              },
              color: Theme.of(context).primaryColor,
            ),
            _placesWidget(),
          ],
        ),
      ),
    );
  }

  Widget _placesWidget() {
    return FutureBuilder<List<Place>>(
        future: _findPlaces(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Place place = snapshot.data[index];
                // await Geolocator().distanceBetween(position.latitude, position.longitude, place.location.lat, place.location.lng);
                return Column(children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: FlutterLogo(
                          size: 56.0, colors: Theme.of(context).primaryColor),
                      onTap: () {
                        History.save(fbUser, place, Event.clicked);
                      },
                      title: Text(place.name),
                      subtitle: Text(
                          "Distance: ${place.distance}m, Rating: ${place.rating}"),
                      trailing: Icon(Icons.more_vert),
                    ),
                  )
                ]);
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
