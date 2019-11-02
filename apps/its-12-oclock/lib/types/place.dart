import 'package:google_maps_webservice/places.dart' as maps;
import 'package:its_12_oclock/types/location.dart';

class Place {
  const Place(this.name, this.id, this.location, this.rating, this.photo);

  final String name;
  final String id;
  final Location location;
  final num rating;
  final PlacePhoto photo;

  factory Place.fromFirestore(Map<dynamic, dynamic> j) => Place(
      j['name'],
      j['id'],
      Location.fromFirestore(j['location']),
      j['rating'],
      PlacePhoto.fromFirestore(j['photo']));

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'id': id,
        'location': location.toFirestore(),
        'num': rating,
        'photo': photo.toFirestore(),
      };

  factory Place.fromMaps(maps.PlacesSearchResult p) {
    return Place(p.name, p.placeId, Location.fromMaps(p.geometry.location),
        p.rating, PlacePhoto.fromMaps(p.photos?.first));
  }
}

class PlacePhoto {
  final String reference;
  final List<String> htmlAttributions;

  const PlacePhoto(this.reference, this.htmlAttributions);

  factory PlacePhoto.fromFirestore(Map<dynamic, dynamic> j) {
    final List<dynamic> htmlAttributions = j['htmlAttributions'];
    return PlacePhoto(j['reference'], htmlAttributions.cast<String>().toList());
  }

  Map<String, dynamic> toFirestore() => {
        'reference': reference,
        'htmlAttributions': htmlAttributions,
      };

  factory PlacePhoto.fromMaps(maps.Photo p) {
    if (p == null) {
      return null;
    }
    return PlacePhoto(p.photoReference, p.htmlAttributions);
  }
}
