import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';

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
    if (selectedDay == null) {
      return const Center(child: Text('Оберіть день'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Вправи за ${keyOf(selectedDay!)}:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (selectedExercises.isEmpty)
            const Text(
              'Немає вправ за цей день',
              style: TextStyle(color: Colors.grey),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: selectedExercises.length,
                itemBuilder: (ctx, i) {
                  final ex = selectedExercises[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      isThreeLine: ex.sets.length > 1,
                      title: ex.name == '' ? Text('Вправа $i') : Text(ex.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${ex.sets.length} підходів'),
                          const SizedBox(height: 4),
                          for (var j = 0; j < ex.sets.length; j++)
                            Text(
                              'Підхід ${j + 1}: '
                              '${ex.sets[j].weight?.toStringAsFixed(1) ?? '-'} кг '
                              'x ${ex.sets[j].reps ?? '-'} повт.',
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
