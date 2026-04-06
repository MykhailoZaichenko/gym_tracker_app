import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_set_tile.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';

class ExerciseSetsList extends StatelessWidget {
  final WorkoutExercise exercise;
  final ExerciseType exerciseType;

  final List<TextEditingController>? weightControllers;
  final List<TextEditingController>? repsControllers;
  final List<TextEditingController>? timeControllers;
  final List<TextEditingController>? distanceControllers;

  final List<FocusNode>? weightFocusNodes;
  final List<FocusNode>? repsFocusNodes;
  final List<FocusNode>? timeFocusNodes;
  final List<FocusNode>? distanceFocusNodes;

  final VoidCallback onAddSet;
  final void Function(int setIndex) onRemoveSet;
  final String Function(double? v) formatDouble;

  const ExerciseSetsList({
    super.key,
    required this.exercise,
    required this.exerciseType,
    this.weightControllers,
    this.repsControllers,
    this.timeControllers,
    this.distanceControllers,
    this.weightFocusNodes,
    this.repsFocusNodes,
    this.timeFocusNodes,
    this.distanceFocusNodes,
    required this.onAddSet,
    required this.onRemoveSet,
    required this.formatDouble,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        for (int j = 0; j < exercise.sets.length; j++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ExerciseSetTile(
              index: j,
              exerciseType: exerciseType,
              weightController: weightControllers?[j],
              repsController: repsControllers?[j],
              timeController: timeControllers?[j],
              distanceController: distanceControllers?[j],
              weightFocusNode: weightFocusNodes?[j],
              repsFocusNode: repsFocusNodes?[j],
              timeFocusNode: timeFocusNodes?[j],
              distanceFocusNode: distanceFocusNodes?[j],
              onRemoveSetTile: () => onRemoveSet(j),
            ),
          ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text(loc.addSetBtn, style: textTheme.labelLarge),
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
