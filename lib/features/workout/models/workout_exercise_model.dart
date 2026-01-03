class WorkoutExercise {
  String name;
  String? exerciseId;
  List<SetData> sets;

  WorkoutExercise({required this.name, this.exerciseId, required this.sets});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exerciseId': exerciseId,
      'sets': sets.map((s) => s.toMap()).toList(),
    };
  }

  factory WorkoutExercise.fromMap(Map<String, dynamic> map) {
    return WorkoutExercise(
      name: map['name'] ?? '',
      exerciseId: map['exerciseId'],
      sets:
          (map['sets'] as List<dynamic>?)
              ?.map((s) => SetData.fromMap(s))
              .toList() ??
          [],
    );
  }

  // ДОДАНО: метод copyWith для вправи
  WorkoutExercise copyWith({
    String? name,
    String? exerciseId,
    List<SetData>? sets,
  }) {
    return WorkoutExercise(
      name: name ?? this.name,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
    );
  }
}

class SetData {
  double? weight;
  int? reps;
  bool isCompleted; // Для чекбоксів (галочок)

  SetData({this.weight, this.reps, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {'weight': weight, 'reps': reps, 'isCompleted': isCompleted};
  }

  factory SetData.fromMap(Map<String, dynamic> map) {
    return SetData(
      weight: (map['weight'] as num?)?.toDouble(),
      reps: map['reps'] as int?,
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // ДОДАНО: метод copyWith для сету (саме він викликає помилку)
  SetData copyWith({double? weight, int? reps, bool? isCompleted}) {
    return SetData(
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
