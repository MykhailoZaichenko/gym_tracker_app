import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_page.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_type_selection_sheet.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/fading_edge.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/status_icon_widget.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final FirestoreService _firestore = FirestoreService();
  bool _isLoading = true;
  WorkoutModel? _todaysWorkout;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkTodayWorkout();
  }

  Future<void> _checkTodayWorkout() async {
    setState(() => _isLoading = true);
    try {
      final workout = await _firestore.getWorkout(_today);
      if (mounted) {
        setState(() {
          _todaysWorkout = workout;
        });
      }
    } catch (e) {
      debugPrint("Journal load error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 1. Логіка натискання кнопки
  void _onMainButtonPressed() {
    final loc = AppLocalizations.of(context)!;

    // Якщо тренування вже є -> Продовжуємо
    if (_todaysWorkout != null) {
      _continueCurrentWorkout();
    } else {
      // Якщо немає -> Відкриваємо вибір типу (Dropdown/Sheet)
      _showWorkoutTypeSelector(loc);
    }
  }

  void _showWorkoutTypeSelector(AppLocalizations loc) {
    WorkoutTypeSelectionSheet.show(context, (selectedType) {
      _launchNewWorkout(selectedType);
    });
  }

  void _launchNewWorkout(String type) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            WorkoutPage(date: _today, workoutType: type, shouldAutoPick: true),
      ),
    );
    _checkTodayWorkout(); // Оновлюємо список після повернення
  }

  void _continueCurrentWorkout() async {
    if (_todaysWorkout == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutPage(
          date: _today,
          exercises: _todaysWorkout!.exercises,
          workoutType: _todaysWorkout!.type ?? 'custom',
          shouldAutoPick: false,
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
    // Спроба знайти по ID
    if (exercise.exerciseId != null && exercise.exerciseId!.isNotEmpty) {
      try {
        return catalog.firstWhere((e) => e.id == exercise.exerciseId);
      } catch (_) {}
    }
    // Спроба знайти по назві
    try {
      return catalog.firstWhere(
        (e) => e.id == exercise.name || e.name == exercise.name,
      );
    } catch (_) {
      return ExerciseInfo(
        id: '',
        name: exercise.name,
        icon: Icons.fitness_center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dateStr = DateFormat.MMMMEEEEd(loc.localeName).format(_today);
    final theme = Theme.of(context);

    // Перевірка на наявність вправ
    final hasWorkout = _todaysWorkout != null;
    final exerciseCount = hasWorkout ? _todaysWorkout!.exercises.length : 0;

    return Scaffold(
      appBar: AppBar(title: Text(loc.navJournal), centerTitle: false),
      // НІЯКОГО FAB ТУТ
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

                // ВАРІАНТ 1: НЕМАЄ ТРЕНУВАННЯ
                if (!hasWorkout) ...[
                  const Spacer(),
                  const StatusIconWidget(color: null, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    loc.noWorkoutToday,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ]
                // ВАРІАНТ 2: Є ТРЕНУВАННЯ (Список)
                else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        StatusIconWidget(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.greenAccent[400]
                              : Colors.green,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // Показуємо тип (наприклад "Push Workout")
                              _todaysWorkout!.type != null
                                  ? WorkoutTypeSelectionSheet.getLocalizedTemplateName(
                                      _todaysWorkout!.type!,
                                      loc,
                                    )
                                  : loc.workoutToday,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              loc.exercisesCount(exerciseCount),
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

                  // 🔥 СПИСОК ВПРАВ
                  Expanded(
                    child: exerciseCount == 0
                        ? Center(child: Text("No exercises yet"))
                        : FadingEdge(
                            startFadeSize: 0.05,
                            endFadeSize: 0.1,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 0,
                                bottom: 80,
                              ),
                              itemCount: exerciseCount,
                              itemBuilder: (context, index) {
                                final ex = _todaysWorkout!.exercises[index];
                                final exerciseInfo = _getExerciseInfo(ex, loc);
                                final titleText = exerciseInfo.name.isEmpty
                                    ? ex.name
                                    : exerciseInfo.name;

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                titleText,
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                loc.setsCount(ex.sets.length),
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                              // Виводимо пару сетів для наочності
                                              if (ex.sets.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 4.0,
                                                      ),
                                                  child: Text(
                                                    "${ex.sets.first.weight ?? 0}kg x ${ex.sets.first.reps ?? 0}",
                                                    style: theme
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
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

                // КНОПКА ВНИЗУ (Одна для всього)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryFilledButton(
                      text: hasWorkout
                          ? loc
                                .continueWorkout // "Продовжити"
                          : loc.startWorkout, // "Почати"
                      onPressed: _onMainButtonPressed,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
