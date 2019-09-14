import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;

class PlaceFinder {
  static Future<List<Place>> find(Location location) async {
    final response = await http.post(
        'https://europe-west1-hacker-playground-101.cloudfunctions.net/PlaceFinder',
        headers: {'Content-Type': 'application/json'},
        body: json.encode(location.toJson()));
    if (response.statusCode == 200) {
      return _PlaceFinderReponse.fromJson(json.decode(response.body)).results;
    } else {
      // TODO: Handle error
      throw Exception('Failed to find places');
    }
  }
}

class Place {
  final int distance;
  final Location location;
  final String name;
  final String placeId;
  final double rating;

  Place({this.distance, this.location, this.name, this.placeId, this.rating});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      distance: json['distance'],
      location: Location.fromJson(json['location']),
      name: json['name'],
      placeId: json['place_id'],
      rating: _intToDouble(json['rating']),
    );
  }

  static dynamic _intToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    }
    return value;
  }
}

class Location {
  final double lat;
  final double lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json['lat'], lng: json['lng']);
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}

class _PlaceFinderReponse {
  final List<Place> results;

  _PlaceFinderReponse({this.results});

  factory _PlaceFinderReponse.fromJson(Map<String, dynamic> json) {
    var results =
        (json['results'] as List).map((i) => Place.fromJson(i)).toList();
    return _PlaceFinderReponse(results: results);
  }
}
