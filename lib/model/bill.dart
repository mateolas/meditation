import 'package:cloud_firestore/cloud_firestore.dart';

class Hparameter {
 

  String temperature;
  String weight;
  String saturation;
  String pulse;

  String id;
  Timestamp createdAt;
  Timestamp updatedAt;
  Timestamp warrantyStart;
  Timestamp warrantyEnd;

  Hparameter();

  Hparameter.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    createdAt = data['createdAt'];
    temperature = data['temperature'];
    weight = data['weight'];
    saturation = data['saturation'];
    pulse = data['pulse'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'temperature': temperature,
      'weight': weight,
      'saturation': saturation,
      'pulse': pulse,
    };
  }
}
