import 'package:its_12_oclock/models/location.dart';

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

  static double _intToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    }
    return value;
  }
}