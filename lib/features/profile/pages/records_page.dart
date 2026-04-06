import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/utils/utils.dart';
import 'package:intl/intl.dart';

class ExerciseRecord {
  final String exerciseId;
  final double maxWeight;
  final double reps;
  final DateTime date;
  final double estimated1RM;

  ExerciseRecord({
    required this.exerciseId,
    required this.maxWeight,
    required this.reps,
    required this.date,
    required this.estimated1RM,
  });
}

class RecordsPage extends StatefulWidget {
  final Map<String, List<WorkoutExercise>> allWorkouts;

  const RecordsPage({super.key, required this.allWorkouts});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<ExerciseRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _calculateRecords();
  }

  void _calculateRecords() {
    final Map<String, ExerciseRecord> bestRecords = {};

    widget.allWorkouts.forEach((dateStr, exercises) {
      DateTime date;
      try {
        date = DateTime.parse(dateStr);
      } catch (_) {
        return;
      }

      for (final ex in exercises) {
        final exId = ex.exerciseId;
        if (exId == null) continue;

        for (final set in ex.sets) {
          final weight = set.weight ?? 0.0;
          final reps = set.reps ?? 0;

          if (weight > 0 && reps > 0) {
            final estimatedMax = weight * (1.0 + 0.0333 * reps);

            if (!bestRecords.containsKey(exId) ||
                weight > bestRecords[exId]!.maxWeight ||
                (weight == bestRecords[exId]!.maxWeight &&
                    reps > bestRecords[exId]!.reps)) {
              bestRecords[exId] = ExerciseRecord(
                exerciseId: exId,
                maxWeight: weight,
                reps: reps,
                date: date,
                estimated1RM: estimatedMax,
              );
            }
          }
        }
      }
    });

    final sortedRecords = bestRecords.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _records = sortedRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final catalog = getExerciseCatalog(loc);

    return Scaffold(
      appBar: AppBar(title: Text(loc.recordsThisMonth.replaceAll('🏆 ', ''))),
      body: _records.isEmpty
          ? Center(
              child: Text(
                loc.noRecords,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                final exerciseInfo = catalog.firstWhere(
                  (info) => info.id == record.exerciseId,
                  orElse: () => ExerciseInfo(
                    id: record.exerciseId,
                    name: loc.exerciseDefaultName,
                    icon: Icons.fitness_center,
                  ),
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Верхній поверх: Іконка, Назва, Вага
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              exerciseInfo.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${record.maxWeight.toStringAsFixed(1)} ${loc.weightUnit}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Нижній поверх: Дата та Інформація 1RM
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat.yMMMd(
                              loc.localeName,
                            ).format(record.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${formatDouble(record.reps)} ${loc.repsUnit} • ${loc.oneRepMaxShort}: ${record.estimated1RM.toStringAsFixed(1)}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Tooltip(
                                  message: loc.oneRepMaxTooltip,
                                  triggerMode: TooltipTriggerMode.tap,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
