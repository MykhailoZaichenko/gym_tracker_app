class WorkoutExerciseGraf {
  String name;
  String? exerciseId;
  List<SetData> sets;

  WorkoutExerciseGraf({
    required this.name,
    this.exerciseId,
    required this.sets,
  });

  factory WorkoutExerciseGraf.fromMap(Map<String, dynamic> m) {
    return WorkoutExerciseGraf(
      name: m['name'] as String? ?? '',
      exerciseId: m['exerciseId'] as String?,
      sets: (m['sets'] as List<dynamic>? ?? [])
          .map((e) => SetData.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'exerciseId': exerciseId,
    'sets': sets.map((s) => s.toMap()).toList(),
  };
}

class SetData {
  double? weight;
  double? reps;

  SetData({this.weight, this.reps});

  factory SetData.fromMap(Map<String, dynamic> m) {
    return SetData(
      weight: (m['weight'] as num?)?.toDouble(),
      reps: (m['reps'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {'weight': weight, 'reps': reps};
}
