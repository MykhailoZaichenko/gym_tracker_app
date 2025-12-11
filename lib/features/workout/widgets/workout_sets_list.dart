import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_set_tile.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';

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
                  weightController: weightControllers[j],
                  repsController: repsControllers[j],
                  weightFocusNode: weightFocusNodes[j],
                  repsFocusNode: repsFocusNodes[j],
                  // isLastSet: j == exercise.sets.length - 1,
                  onRemoveSetTile: () => onRemoveSet(j),
                  // onRepsSubmitted: () {
                  //   if (j + 1 < weightFocusNodes.length) {
                  //     weightFocusNodes[j + 1].requestFocus();
                  //   } else {
                  //     FocusScope.of(context).unfocus();
                  //   }
                  // },
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onAddSet(),
          ),
        ),
      ],
    );
  }
}
