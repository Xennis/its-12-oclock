import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_12_oclock/models/event.dart';
import 'package:its_12_oclock/models/place.dart';

class History {
  static final String collectionHistory = "history";
  static final String collectionPlaces = "places";
  static final String fieldName = "name";
  static final String fieldLocation = "location";
  static final String fieldTimestamp = "timestamp";
  static final String fieldEvent = "event";
  static final String fieldScore = "score";

  static Future<DocumentReference> save(
      FirebaseUser user, Place place, Event event) async {
    // Explict assign to variables with types to ensure these types.
    String placeName = place.name;
    String placeId = place.placeId;
    Timestamp timestmap = Timestamp.fromDate(DateTime.now());
    GeoPoint location = GeoPoint(place.location.lat, place.location.lng);

    DocumentReference userDoc =
        Firestore.instance.collection("users").document(user.uid);

    userDoc.collection(collectionPlaces).document(placeId).setData({
      fieldName: placeName,
      fieldLocation: location,
      fieldScore: FieldValue.increment(event.score),
      "event_${event.name}": FieldValue.increment(1)
    }, merge: true);

    return userDoc.collection(collectionHistory).add({
      fieldName: placeName,
      "place": placeId,
      fieldTimestamp: timestmap,
      fieldLocation: location,
      fieldEvent: event.name,
    });
  }
}
