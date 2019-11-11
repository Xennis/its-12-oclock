import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:its_12_oclock/services/google_maps/maps_places.dart';
import 'package:its_12_oclock/services/sign_in.dart';
import 'package:its_12_oclock/types/location.dart';
import 'package:its_12_oclock/types/place.dart';
import 'package:its_12_oclock/widgets/navigation_drawer.dart';
import 'package:its_12_oclock/widgets/place_dismissible.dart';

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
          future: _findPlaces(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return PlaceRecommendationDismissible(
                      place: snapshot.data[index], user: Auth.fbUser);
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
