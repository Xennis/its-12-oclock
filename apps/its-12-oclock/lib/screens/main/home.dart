import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:its_12_oclock/screens/main/widget.dart';
import 'package:its_12_oclock/services/maps/places.dart';
import 'package:its_12_oclock/services/sign_in.dart';
import 'package:its_12_oclock/widgets/navigation_drawer.dart';

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
                  return PlaceRecommendationDismissible(
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

  Future<List<PlacesSearchResult>> _findPlaces() async {
    if (!await Geolocator().isLocationServiceEnabled()) {
      throw Exception("Location is disabled");
    }
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return PlacesService.searchNearby(
        Location(position.latitude, position.longitude));
  }
}
