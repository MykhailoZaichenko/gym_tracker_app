// lib/data/classes/workout.dart

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

class WorkoutExercise {
  String name;
  List<SetData> sets;

  WorkoutExercise({required this.name, required this.sets});

  factory WorkoutExercise.fromMap(Map<String, dynamic> m) {
    final setsList = (m['sets'] as List<dynamic>? ?? [])
        .map((e) => SetData.fromMap(e as Map<String, dynamic>))
        .toList();

    return WorkoutExercise(name: m['name'] as String? ?? '', sets: setsList);
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'sets': sets.map((s) => s.toMap()).toList(),
  };
}
