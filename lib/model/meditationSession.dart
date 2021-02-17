import 'package:cloud_firestore/cloud_firestore.dart';

class MeditationSession {
  String id;
  Timestamp createdAt;

  String length;

  MeditationSession();

  MeditationSession.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    createdAt = data['createdAt'];
    length = data['length'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'length': length,
    };
  }
}
