// ignore_for_file: unused_field, duplicate_ignore

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/features/analytics/pages/streak_details_page.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_page.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_summary_dialog.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_type_selection_sheet.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/utils/workout_utils.dart';
import 'package:gym_tracker_app/widget/common/exercise_icon.dart';
import 'package:gym_tracker_app/widget/common/fading_edge.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/status_icon_widget.dart';
import 'package:gym_tracker_app/widget/common/weekly_goal_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // СТАН СЕСІЇ
  bool _isSessionActive = false;
  Timer? _timer;
  String _elapsedTime = "00:00:00";
  String? _activeWorkoutType;
  DateTime? _sessionStartTime;

  // ДАНІ ДЛЯ ЗВІТУ
  WorkoutModel? _comparisonWorkout;
  WorkoutModel? _lastReport;

  // ignore: unused_field
  int _streakWeeks = 0;
  int _weeklyGoal = 3;
  UserModel? _currentUser;
  bool _hasCheckedGoal = false;

  @override
  void initState() {
    super.initState();
    _restoreSessionState();
    _checkTodayWorkout();
    _loadUserDataAndStreak();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- ЛОГІКА ПІДРАХУНКУ ТИЖНЕВОГО СТРІКУ ---

  Future<void> _loadUserDataAndStreak() async {
    final user = await _firestore.getUser();
    final workoutsMap = await _firestore.getAllWorkouts();

    if (user != null) {
      if (mounted) {
        setState(() {
          _currentUser = user;
          _weeklyGoal = user.weeklyGoal > 0 ? user.weeklyGoal : 3;
          _streakWeeks = _calculateWeeklyStreak(workoutsMap, _weeklyGoal);
        });

        if (user.weeklyGoal == 0 && !_hasCheckedGoal) {
          _hasCheckedGoal = true;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _showGoalDialog(user),
          );
        }
      }
    }
  }

  Future<void> _showGoalDialog(UserModel user) async {
    final newGoal = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const WeeklyGoalDialog(initialGoal: 3),
    );

    if (newGoal != null) {
      // 1. Зберігаємо в базу (важливо!)
      await _firestore.updateWeeklyGoal(newGoal);

      // 2. Оновлюємо локальний стан
      final updatedUser = user.copyWith(weeklyGoal: newGoal);
      setState(() {
        _weeklyGoal = newGoal;
        _currentUser = updatedUser;
        // Перераховуємо стрік з новою ціллю
      });

      // Оновлюємо стрік (потрібно заново взяти воркаути або використати збережені)
      final workouts = await _firestore.getAllWorkouts();
      setState(() {
        _streakWeeks = _calculateWeeklyStreak(workouts, newGoal);
      });
    }
  }

  int _calculateWeeklyStreak(Map<String, dynamic> workoutsMap, int goal) {
    if (workoutsMap.isEmpty) return 0;

    // 1. Конвертуємо всі дати тренувань у список
    final dates = <DateTime>[];
    workoutsMap.forEach((key, _) {
      try {
        dates.add(DateTime.parse(key));
      } catch (_) {}
    });

    if (dates.isEmpty) return 0;

    // 2. Групуємо по тижнях (Номер тижня від початку епохи або року)
    // Використаємо простий ключ: "YYYY-WW"
    final Map<String, int> workoutsPerWeek = {};

    for (var date in dates) {
      // Знаходимо понеділок цього тижня, щоб уніфікувати
      final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
      final key =
          "${startOfWeek.year}-${startOfWeek.month}-${startOfWeek.day}"; // Спрощено, тиждень ідентифікуємо по даті понеділка
      workoutsPerWeek[key] = (workoutsPerWeek[key] ?? 0) + 1;
    }

    // 3. Ітеруємо назад від поточного тижня
    final now = DateTime.now();
    final currentMonday = now.subtract(Duration(days: now.weekday - 1));

    int streak = 0;
    // Починаємо перевірку з *минулого* тижня.
    // Поточний тиждень додає до стріку тільки якщо ВЖЕ виконаний.

    // Перевіряємо поточний тиждень
    final currentKey =
        "${currentMonday.year}-${currentMonday.month}-${currentMonday.day}";
    if ((workoutsPerWeek[currentKey] ?? 0) >= goal) {
      streak++;
    }

    // Перевіряємо минулі тижні
    DateTime checkMonday = currentMonday.subtract(const Duration(days: 7));
    while (true) {
      final key = "${checkMonday.year}-${checkMonday.month}-${checkMonday.day}";
      final count = workoutsPerWeek[key] ?? 0;

      if (count >= goal) {
        streak++;
        checkMonday = checkMonday.subtract(const Duration(days: 7));
      } else {
        break; // Стрік перервався
      }
    }

    return streak;
  }

  // --- ЛОГІКА ВІДНОВЛЕННЯ СЕСІЇ ---
  Future<void> _restoreSessionState() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeIso = prefs.getString('workout_start_time');
    final type = prefs.getString('workout_type');

    if (startTimeIso != null && type != null) {
      final startTime = DateTime.parse(startTimeIso);
      _sessionStartTime = startTime;
      _activeWorkoutType = type;
      _isSessionActive = true;

      // Відновлюємо історію для порівняння (під час активного тренування)
      try {
        final history = await _firestore.getLastWorkoutByType(type);
        if (mounted) setState(() => _comparisonWorkout = history);
      } catch (_) {}

      _startUiTimer();
    }
  }

  // --- ЛОГІКА ТАЙМЕРА ---
  void _startSessionLogic(String type) async {
    final now = DateTime.now();
    _sessionStartTime = now;
    _activeWorkoutType = type;
    _isSessionActive = true;
    _lastReport = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('workout_start_time', now.toIso8601String());
    await prefs.setString('workout_type', type);

    // Очищаємо дані про попередні звіти, бо почали нове
    await prefs.remove('last_finished_workout_id');
    await prefs.remove('last_comparison_date');

    _startUiTimer();
  }

  void _startUiTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _sessionStartTime != null) {
        setState(() {
          final d = DateTime.now().difference(_sessionStartTime!);
          String twoDigits(int n) => n.toString().padLeft(2, '0');
          _elapsedTime =
              "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
        });
      }
    });
  }

  void _stopSessionLogic() async {
    _timer?.cancel();
    _isSessionActive = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('workout_start_time');
    await prefs.remove('workout_type');
  }

  // --- ЗАВАНТАЖЕННЯ ДАНИХ ---
  Future<void> _checkTodayWorkout() async {
    setState(() => _isLoading = true);

    // 1. Завантажуємо поточне тренування
    final workout = await _firestore.getWorkout(_today);

    // 2. Отримуємо збережені ID зі сховища
    final prefs = await SharedPreferences.getInstance();
    final lastFinishedId = prefs.getString('last_finished_workout_id');
    final lastComparisonDateIso = prefs.getString('last_comparison_date');

    if (mounted) {
      setState(() {
        _todaysWorkout = workout;
        _isLoading = false;

        // 3. Відновлюємо звіт
        if (workout != null && workout.id == lastFinishedId) {
          _lastReport = workout;

          // 4. ВІДНОВЛЮЄМО ПОРІВНЯННЯ ПО ДАТІ
          // Якщо у нас немає comparisonWorkout, але є збережена дата - завантажуємо його
          if (_comparisonWorkout == null && lastComparisonDateIso != null) {
            _restoreComparisonByDate(DateTime.parse(lastComparisonDateIso));
          }
        }
      });
    }
  }

  // Новий метод для завантаження конкретного старого тренування
  Future<void> _restoreComparisonByDate(DateTime date) async {
    try {
      final oldWorkout = await _firestore.getWorkout(date);
      if (mounted && oldWorkout != null) {
        setState(() {
          _comparisonWorkout = oldWorkout;
        });
      }
    } catch (_) {}
  }

  void _onStartPressed(AppLocalizations loc) {
    WorkoutTypeSelectionSheet.show(context, (selectedType) async {
      _startSessionLogic(selectedType);
      try {
        final history = await _firestore.getLastWorkoutByType(selectedType);
        if (mounted) _comparisonWorkout = history;
      } catch (_) {}
      _openWorkoutPage(selectedType);
    });
  }

  void _openWorkoutPage(String type) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutPage(
          date: _today,
          exercises: _todaysWorkout?.exercises ?? [],
          workoutType: type,
        ),
      ),
    );
    _checkTodayWorkout();
  }

  void _finishSession(AppLocalizations loc) async {
    final duration = DateTime.now().difference(
      _sessionStartTime ?? DateTime.now(),
    );

    _stopSessionLogic();

    if (_todaysWorkout != null) {
      final updatedWorkout = _todaysWorkout!.copyWith(
        durationSeconds: duration.inSeconds,
      );
      await _firestore.saveWorkout(updatedWorkout);

      // Зберігаємо ID звіту ТА Дату порівняння
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_finished_workout_id', updatedWorkout.id);

      if (_comparisonWorkout != null) {
        await prefs.setString(
          'last_comparison_date',
          _comparisonWorkout!.date.toIso8601String(),
        );
      }

      if (!mounted) return;

      setState(() {
        _lastReport = updatedWorkout;
      });

      _showSummaryDialog(updatedWorkout, duration);
    }

    _checkTodayWorkout();
  }

  void _showSummaryDialog(WorkoutModel workout, Duration duration) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WorkoutSummaryDialog(
        currentWorkout: workout,
        previousWorkout: _comparisonWorkout,
        duration: duration,
        onClose: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  ExerciseInfo _getExerciseInfo(
    WorkoutExercise exercise,
    AppLocalizations loc,
  ) {
    final catalog = getExerciseCatalog(loc);
    if (exercise.exerciseId != null && exercise.exerciseId!.isNotEmpty) {
      final found = catalog.firstWhere(
        (e) => e.id == exercise.exerciseId,
        orElse: () => ExerciseInfo(id: '', name: '', icon: Icons.error),
      );
      if (found.name.isNotEmpty) return found;
    }
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

    final bool hasData =
        _todaysWorkout != null && _todaysWorkout!.exercises.isNotEmpty;

    final displayType = _todaysWorkout?.type ?? _activeWorkoutType;
    final localizedType = displayType != null
        ? WorkoutUtils.getLocalizedType(displayType, loc)
        : loc.workoutToday;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loc.navJournal),
            const SizedBox(width: 8),
            // 🔥 ВІДЖЕТ СТРІКУ В APPBAR
            if (_currentUser != null)
              GestureDetector(
                onTap: () async {
                  // Відкриваємо детальну сторінку
                  // Треба завантажити повну мапу тренувань для деталізації
                  final allWorkouts = await _firestore.getAllWorkouts();
                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StreakDetailsPage(
                        streakWeeks: _streakWeeks,
                        weeklyGoal: _weeklyGoal,
                        allWorkouts: allWorkouts,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Color(0xFFE91E63),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$_streakWeeks",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    dateStr.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                if (_isSessionActive)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      _elapsedTime,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // ЗАГОЛОВОК (фіксований)
                if (hasData)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      children: [
                        StatusIconWidget(
                          color: _isSessionActive
                              ? theme.colorScheme.primary
                              : Colors.green,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizedType.toUpperCase(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              loc.exercisesCount(
                                _todaysWorkout!.exercises.length,
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // СПИСОК ВПРАВ (скролиться)
                Expanded(
                  child: !hasData && !_isSessionActive
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const StatusIconWidget(color: null, size: 80),
                            const SizedBox(height: 20),
                            Text(
                              loc.noWorkoutToday,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : hasData
                      ? FadingEdge(
                          startFadeSize: 0.0,
                          endFadeSize: 0.1,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            itemCount: _todaysWorkout!.exercises.length,
                            itemBuilder: (context, index) {
                              final ex = _todaysWorkout!.exercises[index];
                              final exerciseInfo = _getExerciseInfo(ex, loc);
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: theme.primaryColor
                                        .withValues(alpha: 0.1),
                                    // child: Icon(
                                    //   exerciseInfo.icon,
                                    //   color: theme.primaryColor,
                                    // ),
                                    child: ExerciseIcon(
                                      exercise: exerciseInfo,
                                      size: 24,
                                      color: theme.primaryColor,
                                      // color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  title: Text(
                                    ex.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(loc.setsCount(ex.sets.length)),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // КНОПКИ (завжди знизу)
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Кнопка "Останній звіт"
                        if (_lastReport != null && !_isSessionActive)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TextButton.icon(
                              onPressed: () {
                                final dSeconds = _lastReport!.durationSeconds;
                                _showSummaryDialog(
                                  _lastReport!,
                                  Duration(seconds: dSeconds),
                                );
                              },
                              icon: const Icon(Icons.analytics_outlined),
                              label: Text(loc.viewLastReport),
                            ),
                          ),

                        if (_isSessionActive) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: PrimaryFilledButton(
                              text: loc.continueWorkout,
                              onPressed: () => _openWorkoutPage(
                                _activeWorkoutType ?? 'custom',
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () => _finishSession(loc),
                              icon: const Icon(Icons.flag),
                              label: Text(loc.finishWorkout),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ] else if (_lastReport == null) ...[
                          // Показуємо кнопки старту тільки якщо немає активного звіту
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: PrimaryFilledButton(
                              text: hasData
                                  ? loc.continueWorkout
                                  : loc.startWorkout,
                              onPressed: () {
                                if (hasData) {
                                  _openWorkoutPage(
                                    _todaysWorkout?.type ?? 'custom',
                                  );
                                } else {
                                  _onStartPressed(loc);
                                }
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
