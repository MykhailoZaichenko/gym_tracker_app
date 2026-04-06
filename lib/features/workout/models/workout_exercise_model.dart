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
  double? reps;
  double? timeInMinutes;
  double? distance;
  bool isCompleted;

  SetData({
    this.weight,
    this.reps,
    this.timeInMinutes,
    this.distance,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'reps': reps,
      'timeInMinutes': timeInMinutes,
      'distance': distance,
      'isCompleted': isCompleted,
    };
  }

  factory SetData.fromMap(Map<String, dynamic> map) {
    return SetData(
      weight: (map['weight'] as num?)?.toDouble(),
      reps: (map['reps'] as num?)?.toDouble(),
      timeInMinutes: (map['timeInMinutes'] as num?)?.toDouble(),
      distance: (map['distance'] as num?)?.toDouble(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  SetData copyWith({
    double? weight,
    double? reps,
    double? timeInMinutes,
    double? distance,
    bool? isCompleted,
  }) {
    return SetData(
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      timeInMinutes: timeInMinutes ?? this.timeInMinutes,
      distance: distance ?? this.distance,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
