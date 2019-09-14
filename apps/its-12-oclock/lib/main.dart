import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:its_12_oclock/placefinder.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'It\'s 12 o\'clock',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(title: 'It\'s 12 o\'clock'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Position position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _findPlaces();
                setState(() {});
              },
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text("Save restaurant"),
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
                      leading: FlutterLogo(size: 56.0),
                      title: Text(place.name),
                      subtitle: Text("Distance: ${place.distance}m, Rating: ${place.rating}"),
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
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return PlaceFinder.find(
          Location(lat: position.latitude, lng: position.longitude));
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
