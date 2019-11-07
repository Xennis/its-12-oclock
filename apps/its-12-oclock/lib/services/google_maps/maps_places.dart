import 'package:google_maps_webservice/places.dart' as maps;
import 'package:its_12_oclock/services/shared_prefs.dart';
import 'package:its_12_oclock/types/location.dart';
import 'package:its_12_oclock/types/place.dart';

class MapsPlacesException implements Exception {
  MapsPlacesException([this.message]);

  /// A human-readable error message, possibly null.
  final String message;

  @override
  String toString() => 'MapsPlacesException($message)';
}

class MapsPlaces {
  // Only enter a restricted key here.
  static const String _API_KEY = 'AIzaSyDlxH95kF9uPX78g27wHt2nJLC6SxSHvEc';

  static maps.GoogleMapsPlaces _mapsPlaces =
      maps.GoogleMapsPlaces(apiKey: _API_KEY);

  static Future<List<Place>> searchNearby(Location location) async {
    if (await SharedPrefs.getBool(SharedPrefs.KEY_SETTINGS_MOCK)) {
      return _searchNearbyMock();
    }

    final maps.PlacesSearchResponse response =
        await _mapsPlaces.searchNearbyWithRankBy(location.toMaps(), 'distance',
            opennow: true, type: 'restaurant');
    if (response.isOkay) {
      return response.results.map((i) => Place.fromMaps(i)).toList();
    }
    throw MapsPlacesException(response.errorMessage);
  }

  static Future<List<Place>> _searchNearbyMock() {
    return Future<List<Place>>.value([
      Place('Tim Burrito\'s', 'KhIJ181I6GmPsUcRadihR8bA6Qt',
          Location(53.5699641, 9.9437931), 4.9, null),
      Place('Frau Max', 'AcZA311I6GmPsUcRadihR8bA6Bu',
          Location(53.5699651, 9.9437929), 4.3, null),
    ]);
  }

  static String photoUrl({PlacePhoto placePhoto, int maxWidth, int maxHeight}) {
    return _mapsPlaces.buildPhotoUrl(
        photoReference: placePhoto?.reference,
        maxWidth: maxWidth,
        maxHeight: maxHeight);
  }
}
