import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String? id;
  String userId;
  int steps;
  double waterLiters;
  int calories;
  DateTime createdAt;

  ActivityModel({
    this.id,
    required this.userId,
    required this.steps,
    required this.waterLiters,
    required this.calories,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'steps': steps,
        'waterLiters': waterLiters,
        'calories': calories,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory ActivityModel.fromMap(Map<String, dynamic> map, String id) =>
      ActivityModel(
        id: id,
        userId: map['userId'] ?? '',
        steps: map['steps'] ?? 0,
        waterLiters: (map['waterLiters'] ?? 0).toDouble(),
        calories: map['calories'] ?? 0,
        createdAt: (map['createdAt'] as Timestamp).toDate(),
      );
}
