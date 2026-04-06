import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';

class WorkoutModel {
  final String id; // Унікальний ID тренування (наприклад, "2023-12-10_10-30")
  final DateTime date; // Дата і час початку
  final DateTime? endTime; // Час завершення (для підрахунку тривалості)
  final int durationSeconds; // Тривалість у секундах (якщо треба точніше)
  final List<WorkoutExercise> exercises; // Список вправ у цьому тренуванні
  final String? type;

  WorkoutModel({
    required this.id,
    required this.date,
    this.endTime,
    this.durationSeconds = 0,
    required this.exercises,
    this.type,
  });

  // 1. Перетворення з об'єкта в JSON (для відправки в Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date), // Firebase любить Timestamp
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'durationSeconds': durationSeconds,
      // Масиви вправ теж треба перетворити в Map
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'type': type,
    };
  }

  // 2. Перетворення з JSON в об'єкт (для отримання з Firebase)
  factory WorkoutModel.fromMap(Map<String, dynamic> map, String docId) {
    return WorkoutModel(
      id: docId, // ID беремо з назви документа
      date: (map['date'] as Timestamp).toDate(),
      endTime: map['endTime'] != null
          ? (map['endTime'] as Timestamp).toDate()
          : null,
      durationSeconds: map['durationSeconds'] ?? 0,
      exercises:
          (map['exercises'] as List<dynamic>?)
              ?.map((e) => WorkoutExercise.fromMap(e))
              .toList() ??
          [],
      type: map['type'],
    );
  }

  // Метод copyWith для зручного оновлення стану
  WorkoutModel copyWith({
    String? id,
    DateTime? date,
    DateTime? endTime,
    int? durationSeconds,
    List<WorkoutExercise>? exercises,
    String? type,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      date: date ?? this.date,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      exercises: exercises ?? this.exercises,
      type: type ?? this.type,
    );
  }
}
