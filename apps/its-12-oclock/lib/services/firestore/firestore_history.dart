import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_12_oclock/types/event.dart';
import 'package:its_12_oclock/types/place.dart';

class FirestoreHistoryEntry {
  const FirestoreHistoryEntry(this.place, this.date, this.event);

  static const String fieldPlace = 'place';
  final Place place;
  static final String fieldTimestamp = 'timestamp';
  final DateTime date;
  static final String fieldEvent = 'event';
  final Event event;

  factory FirestoreHistoryEntry.fromFirestore(Map<String, dynamic> j) =>
      FirestoreHistoryEntry(
        Place.fromFirestore(j[fieldPlace]),
        j[fieldTimestamp].toDate(),
        Event.fromName(j[fieldEvent]),
      );

  Map<String, dynamic> toFirestore() => {
        fieldPlace: place.toFirestore(),
        fieldTimestamp: Timestamp.fromDate(date),
        fieldEvent: event.name
      };
}

class FirestoreHistory {
  static final String _name = 'history';

  static Future<bool> save(FirebaseUser user, Place place, Event event, DateTime now) async {
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection(_name)
        .add(FirestoreHistoryEntry(place, now, event).toFirestore())
        .then((docRef) {
      return true;
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }

  static Stream<List<FirestoreHistoryEntry>> streamClickedRecent(
      FirebaseUser user) {
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection(_name)
        .where(FirestoreHistoryEntry.fieldEvent, isEqualTo: Event.clicked.name)
        .orderBy(FirestoreHistoryEntry.fieldTimestamp, descending: true)
        .limit(15)
        .snapshots()
        .map((qs) => qs.documents
            .map((ds) => FirestoreHistoryEntry.fromFirestore(ds.data))
            .toList());
  }
}
