import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_set_tile.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class ExerciseSetsList extends StatelessWidget {
  final WorkoutExercise exercise;
  final List<TextEditingController> weightControllers;
  final List<TextEditingController> repsControllers;
  final List<FocusNode> weightFocusNodes;
  final List<FocusNode> repsFocusNodes;
  final VoidCallback onAddSet;
  final void Function(int setIndex) onRemoveSet;
  final String Function(double? v) formatDouble;

  const ExerciseSetsList({
    super.key,
    required this.exercise,
    required this.weightControllers,
    required this.repsControllers,
    required this.weightFocusNodes,
    required this.repsFocusNodes,
    required this.onAddSet,
    required this.onRemoveSet,
    required this.formatDouble,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Тепер це звичайний вертикальний список
        for (int j = 0; j < exercise.sets.length; j++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ExerciseSetTile(
              index: j,
              weightController: weightControllers[j],
              repsController: repsControllers[j],
              weightFocusNode: weightFocusNodes[j],
              repsFocusNode: repsFocusNodes[j],
              onRemoveSetTile: () => onRemoveSet(j),
            ),
          ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text(loc.addSetBtn),
            onPressed: () => onAddSet(),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
