import 'package:cloud_firestore/cloud_firestore.dart';

class Hparameter {
 

  String temperature;
  String temperatureFahrenheit;
  String weight;
  String weightLBS;
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
    temperatureFahrenheit = data['temperatureFahrenheit'];
    weight = data['weight'];
    weightLBS = data['weightLBS'];
    saturation = data['saturation'];
    pulse = data['pulse'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'temperature': temperature,
      'temperatureFahrenheit': temperatureFahrenheit,
      'weight': weight,
      'weightLBS': weightLBS,
      'saturation': saturation,
      'pulse': pulse,
    };
  }
}
