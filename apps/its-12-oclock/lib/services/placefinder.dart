import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:its_12_oclock/models/location.dart';
import 'package:its_12_oclock/models/place.dart';

class PlaceFinderException implements Exception {
  PlaceFinderException([this.message]);

    /// A human-readable error message, possibly null.
  final String message;

  @override
  String toString() => 'PlaceFinderException($message)';
}

class PlaceFinder {
  static final String _url =
      'https://europe-west1-its-12-oclock.cloudfunctions.net/PlaceFinderMock';

  static Future<List<Place>> find(Location location, String token) async {
    final http.Response response = await http.post(_url,
        headers: {'Authorization': "Bearer $token"},
        body: json.encode(location.toJson()));
    if (response.statusCode == 200) {
      return _PlaceFinderReponse.fromJson(json.decode(response.body)).results;
    } else {
      throw PlaceFinderException('Failed to find places: Got ${response.statusCode}');
    }
  }
}

class _PlaceFinderReponse {
  final List<Place> results;

  _PlaceFinderReponse({this.results});

  factory _PlaceFinderReponse.fromJson(Map<String, dynamic> json) {
    final List<Place> results =
        (json['results'] as List).map((i) => Place.fromJson(i)).toList();
    return _PlaceFinderReponse(results: results);
  }
}
