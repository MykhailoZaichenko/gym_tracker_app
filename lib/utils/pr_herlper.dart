import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';

class PRHelper {
  /// Перевіряє, чи є конкретний підхід рекордом на момент [targetDate]
  static bool isSetRecord({
    required String exerciseId,
    required double currentWeight,
    required double currentReps,
    required DateTime targetDate,
    required Map<String, List<WorkoutExercise>> allWorkouts,
  }) {
    if (currentWeight <= 0 || currentReps <= 0) return false;

    double historicalMaxWeight = 0.0;
    double historicalMaxReps = 0;
    bool hasHistory = false;

    // Створюємо "чисту" дату без часу для правильного порівняння
    final targetDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    allWorkouts.forEach((dateStr, exercises) {
      DateTime date;
      try {
        date = DateTime.parse(dateStr);
      } catch (_) {
        return;
      }

      // Шукаємо тільки в тих тренуваннях, що були ДО targetDay
      final workoutDay = DateTime(date.year, date.month, date.day);
      if (workoutDay.isBefore(targetDay)) {
        for (final ex in exercises) {
          if (ex.exerciseId == exerciseId) {
            for (final set in ex.sets) {
              final w = set.weight ?? 0.0;
              final r = set.reps ?? 0;
              if (w > 0 && r > 0) {
                hasHistory = true; // Знайшли хоча б одне виконання в минулому
                if (w > historicalMaxWeight ||
                    (w == historicalMaxWeight && r > historicalMaxReps)) {
                  historicalMaxWeight = w;
                  historicalMaxReps = r;
                }
              }
            }
          }
        }
      }
    });

    // Якщо до цього дня вправу не робили — це baseline, кубок не даємо
    if (!hasHistory) return false;

    // Перевіряємо, чи побито історичний максимум
    if (currentWeight > historicalMaxWeight) return true;
    if (currentWeight == historicalMaxWeight &&
        currentReps > historicalMaxReps) {
      return true;
    }

    return false;
  }

  /// Перевіряє, чи є хоча б один рекордний підхід у всій вправі
  static bool hasAnyRecordInExercise({
    required WorkoutExercise exercise,
    required DateTime targetDate,
    required Map<String, List<WorkoutExercise>> allWorkouts,
  }) {
    if (exercise.exerciseId == null) return false;

    for (final set in exercise.sets) {
      if (isSetRecord(
        exerciseId: exercise.exerciseId!,
        currentWeight: set.weight ?? 0.0,
        currentReps: set.reps ?? 0,
        targetDate: targetDate,
        allWorkouts: allWorkouts,
      )) {
        return true;
      }
    }
    return false;
  }
}
