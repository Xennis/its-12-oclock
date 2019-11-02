import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_12_oclock/types/event.dart';
import 'package:its_12_oclock/types/place.dart';

class FirebasePlacesEntry {
  const FirebasePlacesEntry(this.place, this.score);

  static const String fieldPlace = 'place';
  final Place place;
  static const fieldScore = 'score';
  final num score;

  factory FirebasePlacesEntry.fromFirestore(Map<String, dynamic> j) =>
      FirebasePlacesEntry(
        Place.fromFirestore(j[fieldPlace]),
        j[fieldScore],
      );

  Map<String, dynamic> toFirestore() => {
        fieldPlace: place.toFirestore(),
      };
}

class FirebasePlaces {
  static final String _name = 'places';

  static Future<bool> save(FirebaseUser user, Place place, Event event) async {
    Map<String, dynamic> data = FirebasePlacesEntry(place, null).toFirestore();
    data[FirebasePlacesEntry.fieldScore] = FieldValue.increment(event.score);
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

  static Stream<List<FirebasePlacesEntry>> streamFavourites(FirebaseUser user) {
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection(_name)
        .where(FirebasePlacesEntry.fieldScore, isGreaterThanOrEqualTo: 1)
        .orderBy(FirebasePlacesEntry.fieldScore, descending: true)
        .limit(15)
        .snapshots()
        .map((qs) => qs.documents
            .map((ds) => FirebasePlacesEntry.fromFirestore(ds.data))
            .toList());
  }
}
