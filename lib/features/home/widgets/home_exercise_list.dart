import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class HomeExerciseList extends StatelessWidget {
  final DateTime? selectedDay;
  final List<WorkoutExercise> selectedExercises;
  final String Function(DateTime) keyOf;

  const HomeExerciseList({
    super.key,
    required this.selectedDay,
    required this.selectedExercises,
    required this.keyOf,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (selectedDay == null) {
      return Center(child: Text(loc.selectDay));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${loc.exercisesFor} ${keyOf(selectedDay!)}:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (selectedExercises.isEmpty)
            Text(
              loc.noExercisesToday,
              style: const TextStyle(color: Colors.grey),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: selectedExercises.length,
                itemBuilder: (ctx, i) {
                  final ex = selectedExercises[i];
                  // Формуємо рядок для назви вправи (якщо пуста - дефолт)
                  final titleText = ex.name.isEmpty
                      ? '${loc.exerciseDefaultName} $i'
                      : ex.name;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      isThreeLine: ex.sets.length > 1,
                      title: Text(titleText),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Використовуємо plural message для кількості підходів
                          Text(loc.setsCount(ex.sets.length)),
                          const SizedBox(height: 4),
                          for (var j = 0; j < ex.sets.length; j++)
                            Text(
                              '${loc.setLabelCompact} ${j + 1}: '
                              '${ex.sets[j].weight?.toStringAsFixed(1) ?? '-'} ${loc.weightLabel.replaceAll(RegExp(r'.*\(|\)'), '')} ' // extracting kg or just hardcode unit if needed
                              'x ${ex.sets[j].reps ?? '-'} ${loc.repsUnit}',
                              style: const TextStyle(fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
