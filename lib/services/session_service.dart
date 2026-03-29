import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/time_formatter.dart';
import '../models/wear_session.dart';

abstract class SessionService {
  Stream<List<WearSession>> watchTodaySessions({
    required String userId,
    required DateTime startOfDay,
    required DateTime endOfDay,
  });

  Future<void> saveSession(WearSession session);

  String dateKeyFor(DateTime date);
}

class SessionFailure implements Exception {
  const SessionFailure(this.message);

  final String message;
}

class FirestoreSessionService implements SessionService {
  FirestoreSessionService(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<WearSession>> watchTodaySessions({
    required String userId,
    required DateTime startOfDay,
    required DateTime endOfDay,
  }) {
    return _collection(userId)
        .where(
          'endTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('endTime', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('endTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(WearSession.fromFirestore)
              .toList(growable: false),
        );
  }

  @override
  Future<void> saveSession(WearSession session) async {
    try {
      await _collection(session.userId).add(session.toFirestore());
    } on FirebaseException catch (_) {
      throw const SessionFailure(
        'We could not save that session right now. Please try again.',
      );
    }
  }

  @override
  String dateKeyFor(DateTime date) => TimeFormatter.formatDateKey(date);

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection('users').doc(userId).collection('sessions');
  }
}
