import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/fading_edge.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final FirestoreService _firestore = FirestoreService();
  bool _isLoading = true;
  List<WorkoutExercise>? _todaysWorkout;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkTodayWorkout();
  }

  // Перевіряємо, чи є тренування на сьогодні, при кожному вході на вкладку
  Future<void> _checkTodayWorkout() async {
    setState(() => _isLoading = true);
    final workout = await _firestore.getWorkout(_today);
    if (mounted) {
      setState(() {
        _todaysWorkout = workout.isNotEmpty ? workout : null;
        _isLoading = false;
      });
    }
  }

  void _startOrContinueWorkout() async {
    final isNew = _todaysWorkout == null;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutPage(
          date: _today,
          exercises: _todaysWorkout ?? [],
          shouldAutoPick: isNew,
        ),
      ),
    );
    _checkTodayWorkout();
  }

  ExerciseInfo _getExerciseInfo(
    WorkoutExercise exercise,
    AppLocalizations loc,
  ) {
    final catalog = getExerciseCatalog(loc);
    // 1. Шукаємо за ID
    if (exercise.exerciseId != null && exercise.exerciseId!.isNotEmpty) {
      final found = catalog.firstWhere(
        (e) => e.id == exercise.exerciseId,
        orElse: () => ExerciseInfo(id: '', name: '', icon: Icons.error),
      );
      if (found.name.isNotEmpty) return found;
    }
    // 2. Шукаємо за назвою (для кастомних або старих)
    final foundByName = catalog.firstWhere(
      (e) => e.id == exercise.name,
      orElse: () =>
          ExerciseInfo(id: '', name: exercise.name, icon: Icons.fitness_center),
    );
    return foundByName;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dateStr = DateFormat.MMMMEEEEd(loc.localeName).format(_today);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.navJournal), centerTitle: false),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                // Дата
                Center(
                  child: Text(
                    dateStr.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ВЕЛИКА ІКОНКА СТАТУСУ (тільки якщо тренування НЕМАЄ)
                if (_todaysWorkout == null) ...[
                  const Spacer(),
                  _buildStatusIcon(context, null, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    loc.noWorkoutToday,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ] else ...[
                  // Якщо тренування Є - показуємо заголовок і список
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        _buildStatusIcon(context, Colors.green, size: 40),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.workoutToday,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              loc.exercisesCount(_todaysWorkout!.length),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- ВЕРТИКАЛЬНИЙ СПИСОК карток вправ ---
                  Expanded(
                    child: FadingEdge(
                      startFadeSize: 0.05,
                      endFadeSize: 0.1,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 0,
                          bottom: 80,
                        ),
                        itemCount: _todaysWorkout!.length,
                        itemBuilder: (context, index) {
                          final ex = _todaysWorkout![index];
                          final exerciseInfo = _getExerciseInfo(ex, loc);
                          final titleText = exerciseInfo.name.isEmpty
                              ? '${loc.exerciseDefaultName} ${index + 1}'
                              : exerciseInfo.name;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: theme.dividerColor.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            elevation: 2, // Невелика тінь, як на скетчі
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ІКОНКА ВПРАВИ ЗЛІВА
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: theme.primaryColor
                                        .withValues(alpha: 0.1),
                                    child: Icon(
                                      exerciseInfo.icon,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // ТЕКСТОВА ЧАСТИНА СПРАВА
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Назва вправи
                                        Text(
                                          titleText,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        // Кількість сетів
                                        Text(
                                          loc.setsCount(ex.sets.length),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                        // Деталі сетів (перші 3)
                                        ...ex.sets.take(3).map((s) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 2.0,
                                            ),
                                            child: Text(
                                              '${loc.setLabelCompact} ${ex.sets.indexOf(s) + 1}: ${s.weight ?? '-'} ${loc.weightUnit} x ${s.reps ?? '-'}',
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          );
                                        }),
                                        if (ex.sets.length > 3)
                                          Text(
                                            '...',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Кнопка внизу
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryFilledButton(
                      text: _todaysWorkout != null
                          ? loc.continueWorkout
                          : loc.startWorkout,
                      onPressed: _startOrContinueWorkout,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatusIcon(
    BuildContext context,
    Color? color, {
    required double size,
  }) {
    return Container(
      padding: EdgeInsets.all(size / 4),
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        color != null ? Icons.check_circle_outline : Icons.fitness_center,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
