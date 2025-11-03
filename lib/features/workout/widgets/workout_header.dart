import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';

typedef ExercisePickerFn =
    Future<ExerciseInfo?> Function(
      BuildContext context, {
      String? initialQuery,
    });

class ExerciseHeader extends StatelessWidget {
  const ExerciseHeader({
    super.key,
    required this.exercise,
    required this.nameController,
    required this.onPickExercise,
    required this.onRemoveExercise,
    required this.buildIconForName,
  });

  final WorkoutExercise exercise;
  final TextEditingController nameController;
  final ExercisePickerFn onPickExercise;
  final VoidCallback onRemoveExercise;
  final Widget Function(String nameOrId) buildIconForName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: nameController,
          builder: (context, value, _) {
            final key =
                (exercise.exerciseId != null && exercise.exerciseId!.isNotEmpty)
                ? exercise.exerciseId!
                : value.text;
            return buildIconForName(key);
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () async {
              final picked = await onPickExercise(
                context,
                initialQuery: nameController.text,
              );
              if (picked == null) return;

              if (picked.id == '__custom__') {
                final custom = await showDialog<String>(
                  context: context,
                  builder: (ctx) {
                    final ctrl = TextEditingController(
                      text: nameController.text,
                    );
                    return AlertDialog(
                      title: const Text('Введіть назву вправи'),
                      content: TextField(controller: ctrl, autofocus: true),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Відміна'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(ctx).pop(ctrl.text.trim()),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                if (custom != null && custom.isNotEmpty) {
                  nameController.text = custom;
                  exercise.name = custom;
                  exercise.exerciseId = null;
                }
                return;
              }

              // Стандартний вибір
              nameController.text = picked.name;
              exercise.name = picked.name;
              exercise.exerciseId = picked.id;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: nameController,
                builder: (context, value, _) {
                  final text = value.text;
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          text.isEmpty ? 'Оберіть вправу' : text,
                          style: TextStyle(
                            fontSize: 16,
                            color: text.isEmpty ? Colors.grey : null,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (value) {
            if (value == 'delete') onRemoveExercise();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Text('Видалити вправу'),
            ),
          ],
        ),
      ],
    );
  }
}
