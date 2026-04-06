import 'package:cloud_firestore/cloud_firestore.dart';

class BodyWeightModel {
  final String id;
  final DateTime date;
  final double weight;
  final String unit; // 'kg' або 'lbs'

  BodyWeightModel({
    required this.id,
    required this.date,
    required this.weight,
    this.unit = 'kg',
  });

  Map<String, dynamic> toMap() {
    return {'date': Timestamp.fromDate(date), 'weight': weight, 'unit': unit};
  }

  factory BodyWeightModel.fromMap(String id, Map<String, dynamic> map) {
    return BodyWeightModel(
      id: id,
      date: (map['date'] as Timestamp).toDate(),
      weight: (map['weight'] as num).toDouble(),
      unit: map['unit'] ?? 'kg',
    );
  }
}
