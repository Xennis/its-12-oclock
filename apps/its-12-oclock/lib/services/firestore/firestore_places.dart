import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_12_oclock/types/event.dart';
import 'package:its_12_oclock/types/place.dart';

class FirestorePlacesEntry {
  const FirestorePlacesEntry(this.place, this.score);

  static const String fieldPlace = 'place';
  final Place place;
  static const fieldScore = 'score';
  final num score;

  factory FirestorePlacesEntry.fromFirestore(Map<String, dynamic> j) =>
      FirestorePlacesEntry(
        Place.fromFirestore(j[fieldPlace]),
        j[fieldScore],
      );

  Map<String, dynamic> toFirestore() => {
        fieldPlace: place.toFirestore(),
      };
}

class FirestorePlaces {
  static final String _name = 'places';

  static Future<bool> save(FirebaseUser user, Place place, Event event) async {
    Map<String, dynamic> data = FirestorePlacesEntry(place, null).toFirestore();
    // TODO: Use FirebasePlacesEntry.fieldScore here lead to 'event' write.
    data['score'] = FieldValue.increment(event.score);
    data['event_${event.name}'] = FieldValue.increment(1);
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection(_name)
        .document(place.id)
        .setData(data, merge: true)
        .then((docRef) {
      return true;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }

  static Stream<List<FirestorePlacesEntry>> streamFavourites(FirebaseUser user) {
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection(_name)
        .where(FirestorePlacesEntry.fieldScore, isGreaterThanOrEqualTo: 1)
        .orderBy(FirestorePlacesEntry.fieldScore, descending: true)
        .limit(15)
        .snapshots()
        .map((qs) => qs.documents
            .map((ds) => FirestorePlacesEntry.fromFirestore(ds.data))
            .toList());
  }
}
