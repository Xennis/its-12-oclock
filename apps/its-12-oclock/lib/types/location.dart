import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart' as maps;

class Location {
  const Location(this.lat, this.lng);

  final double lat;
  final double lng;

  factory Location.fromMaps(maps.Location l) => Location(l.lat, l.lng);

  maps.Location toMaps() => maps.Location(lat, lng);

  factory Location.fromGeolocator(Position l) =>
      Location(l.latitude, l.longitude);

  factory Location.fromFirestore(GeoPoint l) =>
      Location(l.latitude, l.longitude);

  GeoPoint toFirestore() => GeoPoint(lat, lng);
}
