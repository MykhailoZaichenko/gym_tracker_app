class WorkoutExercise {
  String name;
  String? exerciseId;
  List<SetData> sets;

  WorkoutExercise({required this.name, this.exerciseId, required this.sets});

  factory WorkoutExercise.fromMap(Map<String, dynamic> m) {
    return WorkoutExercise(
      name: m['name'] as String? ?? '',
      exerciseId: m['exerciseId'] as String?,
      sets: (m['sets'] as List<dynamic>? ?? [])
          .map((e) => SetData.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    if (exerciseId != null) 'exerciseId': exerciseId,
    'sets': sets.map((s) => s.toMap()).toList(),
  };
}

class SetData {
  double? weight;
  int? reps;

  SetData({this.weight, this.reps});

  factory SetData.fromMap(Map<String, dynamic> m) {
    return SetData(
      weight: (m['weight'] as num?)?.toDouble(),
      reps: m['reps'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {'weight': weight, 'reps': reps};
}
