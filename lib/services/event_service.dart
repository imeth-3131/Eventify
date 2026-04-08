import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<EventModel>> streamEvents() {
    return _db.collection('events').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => EventModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> addEvent({
    required String title,
    required String date,
    required String location,
    required String description,
  }) async {
    await _db.collection('events').add({
      'title': title,
      'date': date,
      'location': location,
      'description': description,
      'registrationCount': 0,
    });
  }

  Future<void> registerForEvent(String eventId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('You must be logged in.');
    }

    final registrationId = '${eventId}_$uid';
    final registrationRef = _db.collection('registrations').doc(registrationId);
    final eventRef = _db.collection('events').doc(eventId);

    await _db.runTransaction((transaction) async {
      final existingRegistration = await transaction.get(registrationRef);
      if (existingRegistration.exists) {
        throw Exception('You are already registered for this event.');
      }

      transaction.set(registrationRef, {
        'eventId': eventId,
        'userId': uid,
        'registeredAt': Timestamp.now(),
      });

      transaction.update(eventRef, {
        'registrationCount': FieldValue.increment(1),
      });
    });
  }

  Future<bool> isUserRegistered(String eventId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc = await _db.collection('registrations').doc('${eventId}_$uid').get();
    return doc.exists;
  }

  Future<List<EventModel>> getMyEvents() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final registrationSnapshot = await _db
        .collection('registrations')
        .where('userId', isEqualTo: uid)
        .get();

    final eventIds = registrationSnapshot.docs
        .map((doc) => doc.data()['eventId'] as String?)
        .whereType<String>()
        .toList();

    return getEventsByIds(eventIds);
  }

  Future<List<EventModel>> getEventsByIds(List<String> eventIds) async {
    if (eventIds.isEmpty) return [];
    final results = <EventModel>[];
    for (var i = 0; i < eventIds.length; i += 10) {
      final chunk = eventIds.sublist(i, i + 10 > eventIds.length ? eventIds.length : i + 10);
      final snapshot = await _db.collection('events').where(FieldPath.documentId, whereIn: chunk).get();
      results.addAll(snapshot.docs.map((doc) => EventModel.fromMap(doc.id, doc.data())));
    }
    return results;
  }

  Future<List<String>> getRegisteredUserIdsForEvent(String eventId) async {
    final snapshot = await _db
        .collection('registrations')
        .where('eventId', isEqualTo: eventId)
        .get();
    return snapshot.docs
        .map((doc) => doc.data()['userId'] as String?)
        .whereType<String>()
        .toList();
  }
}
