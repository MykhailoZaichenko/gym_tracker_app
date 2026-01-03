import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/utils/utils.dart';

class WorkoutSummaryDialog extends StatelessWidget {
  final WorkoutModel currentWorkout;
  final WorkoutModel? previousWorkout;
  final Duration duration;
  final VoidCallback onClose;

  const WorkoutSummaryDialog({
    super.key,
    required this.currentWorkout,
    this.previousWorkout,
    required this.duration,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Форматування часу: HH:MM:SS
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String durationStr =
        "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 600), // Обмеження висоти
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Text(
              loc.greatJob,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${loc.durationLabel}: $durationStr",
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Список порівняння вправ
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currentWorkout.exercises.length,
                itemBuilder: (context, index) {
                  final currentEx = currentWorkout.exercises[index];
                  // Шукаємо таку саму вправу в минулому тренуванні
                  final prevEx = previousWorkout?.exercises.firstWhere(
                    (e) => _isSameExercise(e, currentEx),
                    orElse: () => WorkoutExercise(name: '', sets: []),
                  );

                  return _buildExerciseComparisonCard(
                    context,
                    currentEx,
                    prevEx,
                    loc,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(loc.close), // або "Finish"
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameExercise(WorkoutExercise a, WorkoutExercise b) {
    if (a.exerciseId != null && b.exerciseId != null) {
      return a.exerciseId == b.exerciseId;
    }
    return a.name == b.name;
  }

  Widget _buildExerciseComparisonCard(
    BuildContext context,
    WorkoutExercise current,
    WorkoutExercise? previous,
    AppLocalizations loc,
  ) {
    // Якщо немає історії для цієї вправи, просто показуємо список без порівняння
    final bool hasHistory = previous != null && previous.name.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            current.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            if (!hasHistory)
              Text(loc.noPreviousData, style: TextStyle(color: Colors.grey))
            else
              _buildComparisonTable(context, current.sets, previous.sets, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable(
    BuildContext context,
    List<SetData> currentSets,
    List<SetData> prevSets,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        // Заголовки
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 24), // Місце для номера сету
              Expanded(
                child: Text(
                  loc.repsLabel,
                  style: _headerStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  loc.weightLabel,
                  style: _headerStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        // Рядки
        ...List.generate(currentSets.length, (i) {
          final currSet = currentSets[i];
          final prevSet = (i < prevSets.length) ? prevSets[i] : null;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                // Номер сету
                SizedBox(
                  width: 24,
                  child: Text(
                    "${i + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Reps Comparison
                Expanded(
                  child: _buildMetricComparison(
                    current: currSet.reps,
                    previous: prevSet?.reps,
                    isWeight: false,
                  ),
                ),
                const SizedBox(width: 8),
                // Weight Comparison
                Expanded(
                  child: _buildMetricComparison(
                    current: currSet.weight,
                    previous: prevSet?.weight,
                    isWeight: true,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  TextStyle _headerStyle(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
  );

  Widget _buildMetricComparison({
    num? current,
    num? previous,
    required bool isWeight,
  }) {
    if (current == null) return const SizedBox();

    Color bgColor = Colors.grey.shade200; // Нейтральний (жовтий/сірий)
    Color textColor = Colors.black87;

    if (previous != null) {
      if (current > previous) {
        bgColor = Colors.green.shade100; // Прогрес
        textColor = Colors.green.shade800;
      } else if (current < previous) {
        bgColor = Colors.red.shade100; // Регрес
        textColor = Colors.red.shade800;
      } else {
        bgColor = Colors.orange.shade100; // Так само (жовтий)
        textColor = Colors.orange.shade900;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isWeight ? formatDouble(current.toDouble()) : "$current",
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          if (previous != null) ...[
            const SizedBox(width: 4),
            Text(
              isWeight
                  ? "(${formatDouble(previous.toDouble())})"
                  : "($previous)",
              style: TextStyle(
                fontSize: 10,
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
