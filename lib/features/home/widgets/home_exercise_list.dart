import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/widget/common/fading_edge.dart';

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

  String _getLocalizedName(WorkoutExercise exercise, AppLocalizations loc) {
    final catalog = getExerciseCatalog(loc);
    if (exercise.exerciseId != null && exercise.exerciseId!.isNotEmpty) {
      final found = catalog.firstWhere(
        (e) => e.id == exercise.exerciseId,
        orElse: () => ExerciseInfo(id: '', name: '', icon: Icons.error),
      );
      if (found.name.isNotEmpty) return found.name;
    }
    final foundByName = catalog.firstWhere(
      (e) => e.id == exercise.name,
      orElse: () => ExerciseInfo(id: '', name: '', icon: Icons.error),
    );
    if (foundByName.name.isNotEmpty) return foundByName.name;
    return exercise.name;
  }

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
              child: FadingEdge(
                startFadeSize: 0.05,
                endFadeSize: 0.1,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: selectedExercises.length,
                  itemBuilder: (ctx, i) {
                    final ex = selectedExercises[i];
                    final localizedName = _getLocalizedName(ex, loc);
                    final titleText = localizedName.isEmpty
                        ? '${loc.exerciseDefaultName} ${i + 1}'
                        : localizedName;

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
                            Text(loc.setsCount(ex.sets.length)),
                            const SizedBox(height: 4),
                            for (var j = 0; j < ex.sets.length; j++)
                              Text(
                                '${loc.setLabelCompact} ${j + 1}: '
                                '${ex.sets[j].weight?.toStringAsFixed(1) ?? '-'} ${loc.weightUnit} '
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
            ),
        ],
      ),
    );
  }
}
