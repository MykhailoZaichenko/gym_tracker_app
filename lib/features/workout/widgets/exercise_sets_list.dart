import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/widgets/exercise_set_tile.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';

class ExerciseSetsList extends StatelessWidget {
  const ExerciseSetsList({
    super.key,
    required this.exercise,
    required this.weightControllers,
    required this.repsControllers,
    required this.onAddSet,
    required this.onRemoveSet,
    required this.formatDouble,
  });

  final WorkoutExercise exercise;
  final List<TextEditingController> weightControllers;
  final List<TextEditingController> repsControllers;
  final VoidCallback onAddSet;
  final void Function(int setIndex) onRemoveSet;
  final String Function(double? v) formatDouble;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int j = 0; j < exercise.sets.length; j++)
                ExerciseSetTile(
                  index: j,
                  weightController: weightControllers.length > j
                      ? weightControllers[j]
                      : TextEditingController(
                          text: formatDouble(exercise.sets[j].weight),
                        ),
                  repsController: repsControllers.length > j
                      ? repsControllers[j]
                      : TextEditingController(
                          text: exercise.sets[j].reps?.toString() ?? '',
                        ),
                  onRemoveSetTile: () => onRemoveSet(j),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onAddSet(),
          ),
        ),
      ],
    );
  }
}
