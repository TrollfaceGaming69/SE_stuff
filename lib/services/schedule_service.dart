// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleEvent {
  String id;
  String dateKey;
  String title;
  String note;
  String time;
  Timestamp? createdAt;

  ScheduleEvent({
    this.id = '',
    required this.dateKey,
    required this.title,
    this.note = '',
    required this.time,
    this.createdAt,
  });

  factory ScheduleEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScheduleEvent(
      id: doc.id,
      dateKey: data['dateKey'] ?? '',
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      time: data['time'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateKey': dateKey,
      'title': title,
      'note': note,
      'time': time,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _schedulesCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('schedules');
  }

  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  Stream<List<ScheduleEvent>> schedulesStream() {
    final uid = _currentUid;
    if (uid == null) return Stream.value([]);

    return _schedulesCollection(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ScheduleEvent.fromFirestore(doc)).toList());
  }

  Future<String> addSchedule({
    required String dateKey,
    required String title,
    required String note,
    required String time,
  }) async {
    final uid = _currentUid;
    if (uid == null) throw Exception('User not authenticated');

    final docRef = await _schedulesCollection(uid).add({
      'dateKey': dateKey,
      'title': title,
      'note': note,
      'time': time,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<void> updateSchedule({
    required String scheduleId,
    required String title,
    required String note,
    required String time,
  }) async {
    final uid = _currentUid;
    if (uid == null) return;

    await _schedulesCollection(uid).doc(scheduleId).update({
      'title': title,
      'note': note,
      'time': time,
    });
  }

  Future<void> deleteSchedule(String scheduleId) async {
    final uid = _currentUid;
    if (uid == null) return;

    await _schedulesCollection(uid).doc(scheduleId).delete();
  }
}
