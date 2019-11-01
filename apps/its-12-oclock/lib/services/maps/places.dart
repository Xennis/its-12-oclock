import 'package:google_maps_webservice/places.dart';
import 'package:its_12_oclock/services/settings.dart';

class PlacesServiceException implements Exception {
  PlacesServiceException([this.message]);

  /// A human-readable error message, possibly null.
  final String message;

  @override
  String toString() => 'PlacesServiceException($message)';
}

class PlacesService {
  // Only enter a restricted key here.
  static const String API_KEY = 'AIzaSyDlxH95kF9uPX78g27wHt2nJLC6SxSHvEc';

  static GoogleMapsPlaces mapsPlaces = new GoogleMapsPlaces(apiKey: API_KEY);

  static Future<List<PlacesSearchResult>> searchNearby(
      Location location) async {
    if (await SharedPrefs.getBool(SharedPrefs.KEY_SETTINGS_MOCK)) {
      return _searchNearbyMock();
    }

    final PlacesSearchResponse response =
        await mapsPlaces.searchNearbyWithRankBy(location, 'distance',
            opennow: true, type: 'restaurant');
    if (response.isOkay) {
      return response.results;
    }
    throw PlacesServiceException(response.errorMessage);
  }

  static Future<List<PlacesSearchResult>> _searchNearbyMock() {
    return Future<List<PlacesSearchResult>>.value([
      PlacesSearchResult(
          null,
          Geometry(Location(53.5699641, 9.9437931), null, null, null),
          "Tim Burrito's",
          null,
          null,
          "KhIJ181I6GmPsUcRadihR8bA6Qt",
          null,
          null,
          null,
          4.9,
          null,
          null,
          null,
          null,
          null,
          null),
      PlacesSearchResult(
          null,
          Geometry(Location(53.5699651, 9.9437929), null, null, null),
          "Frau Max",
          null,
          null,
          "AcZA311I6GmPsUcRadihR8bA6Bu",
          null,
          null,
          null,
          4.3,
          null,
          null,
          null,
          null,
          null,
          null),
    ]);
  }
}
