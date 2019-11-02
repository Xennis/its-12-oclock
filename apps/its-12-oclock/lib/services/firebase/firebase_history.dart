import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_12_oclock/types/event.dart';
import 'package:its_12_oclock/types/place.dart';

class FirebaseHistoryEntry {
  const FirebaseHistoryEntry(this.place, this.timestamp, this.event);

  static const String fieldPlace = 'place';
  final Place place;
  static final String fieldTimestamp = 'timestamp';
  final Timestamp timestamp;
  static final String fieldEvent = 'event';
  final Event event;

  factory FirebaseHistoryEntry.fromFirestore(Map<String, dynamic> j) =>
      FirebaseHistoryEntry(
        Place.fromFirestore(j[fieldPlace]),
        j[fieldTimestamp],
        Event.fromName(j[fieldEvent]),
      );

  Map<String, dynamic> toFirestore() => {
        fieldPlace: place.toFirestore(),
        fieldTimestamp: timestamp,
        fieldEvent: event.name
      };
}

class FirebaseHistory {
  static final String _name = 'history';

  static Future<bool> save(FirebaseUser user, Place place, Event event, DateTime now) async {
    Timestamp timestamp = Timestamp.fromDate(now);
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection(_name)
        .add(FirebaseHistoryEntry(place, timestamp, event).toFirestore())
        .then((docRef) {
      return true;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }

  static Stream<List<FirebaseHistoryEntry>> streamClickedRecent(
      FirebaseUser user) {
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection(_name)
        .where(FirebaseHistoryEntry.fieldEvent, isEqualTo: Event.clicked.name)
        .orderBy(FirebaseHistoryEntry.fieldTimestamp, descending: true)
        .limit(15)
        .snapshots()
        .map((qs) => qs.documents
            .map((ds) => FirebaseHistoryEntry.fromFirestore(ds.data))
            .toList());
  }
}
