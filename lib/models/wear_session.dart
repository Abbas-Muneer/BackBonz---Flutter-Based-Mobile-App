import 'package:cloud_firestore/cloud_firestore.dart';

class WearSession {
  const WearSession({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    required this.dateKey,
    this.createdAt,
  });

  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final int durationSeconds;
  final String dateKey;
  final DateTime? createdAt;

  Duration get duration => Duration(seconds: durationSeconds);

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'durationSeconds': durationSeconds,
      'dateKey': dateKey,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory WearSession.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return WearSession(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      durationSeconds: data['durationSeconds'] as int? ?? 0,
      dateKey: data['dateKey'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
