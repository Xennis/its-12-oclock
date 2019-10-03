import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_12_oclock/models/place.dart';

class History {
  static final String collection = "history";
  static final String fieldName = "name";
  static final String fieldTimestamp = "timestamp";

  static Future<DocumentReference> save(FirebaseUser user, Place place) async {
    // Explict assign to variables with types to ensure these types.
    String placeName = place.name;
    String placeId = place.placeId;
    Timestamp timestmap = Timestamp.fromDate(DateTime.now());
    GeoPoint location = GeoPoint(place.location.lat, place.location.lng);

    return Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection(collection)
        .add({
      fieldName: placeName,
      "place": placeId,
      fieldTimestamp: timestmap,
      "location": location,
    });
  }
}