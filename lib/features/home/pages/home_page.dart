import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_page.dart';
import 'package:gym_tracker_app/features/home/home_exports.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<Map<String, List<WorkoutExercise>>> _workoutsStream;
  late Map<String, List<WorkoutExercise>> _allWorkouts;
  bool _isLoading = true;
  final FirestoreService _firestore = FirestoreService();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  WorkoutModel? _selectedWorkoutModel;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadAllWorkouts();
    _workoutsStream = _firestore.getAllWorkoutsStream();
    _fetchWorkoutDetails(_selectedDay!);
  }

  Future<void> _loadAllWorkouts() async {
    _allWorkouts = await _firestore.getAllWorkouts();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchWorkoutDetails(DateTime date) async {
    // Спочатку скидаємо, щоб UI не показував старий тип
    if (mounted) {
      setState(() => _selectedWorkoutModel = null);
    }

    // Робимо запит до бази
    final workout = await _firestore.getWorkout(date);

    if (mounted) {
      setState(() {
        _selectedWorkoutModel = workout;
      });
    }
  }

  String _keyOf(DateTime date) => date.toIso8601String().split('T').first;

  void _openWorkoutDay(DateTime date) async {
    final workoutModel = await _firestore.getWorkout(date);
    final type = workoutModel?.type ?? 'custom';
    final initialExercises = List<WorkoutExercise>.from(
      _allWorkouts[_keyOf(date)] ?? [],
    );

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutPage(
          date: date,
          exercises: initialExercises,
          workoutType: type,
        ),
      ),
    );

    _loadAllWorkouts();
    _fetchWorkoutDetails(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final loc = AppLocalizations.of(context)!;
    final now = DateTime.now();

    final isCurrentMonth =
        _focusedDay.year == now.year && _focusedDay.month == now.month;

    return StreamBuilder<Map<String, List<WorkoutExercise>>>(
      stream: _workoutsStream,
      builder: (context, snapshot) {
        // Якщо завантаження (перший раз)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Отримуємо дані (або пусту мапу, якщо помилка/пусто)
        final allWorkouts = snapshot.data ?? {};

        // Отримуємо вправи для вибраного дня
        final selectedExercises =
            allWorkouts[_keyOf(_selectedDay ?? now)] ?? [];

        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                HomeCalendar(
                  selectedDay: _selectedDay,
                  focusedDay: _focusedDay,
                  allWorkouts: allWorkouts,
                  onMonthPicked: (picked) {
                    if (picked != null) {
                      setState(() {
                        _focusedDay = picked;
                        _selectedDay = picked;
                      });
                      _fetchWorkoutDetails(picked);
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                    _fetchWorkoutDetails(selected);
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: HomeExerciseList(
                    selectedDay: _selectedDay,
                    selectedExercises: selectedExercises,
                    keyOf: _keyOf,
                    workoutType: _selectedWorkoutModel?.type,
                  ),
                ),
              ],
            ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Кнопка "Повернутись до сьогодні"
                // З'являється, якщо ми не в поточному місяці
                if (!isCurrentMonth) ...[
                  FloatingActionButton.extended(
                    heroTag: 'btn_today',
                    onPressed: () {
                      setState(() {
                        final today = DateTime.now();
                        _focusedDay = today;
                        _selectedDay = today;
                      });
                    },
                    icon: const Icon(
                      Icons.calendar_today,
                    ), // Або arrow_forward_ios
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.backToToday,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.double_arrow_rounded, size: 18),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 16), // Відступ між кнопками
                ],

                // Стандартна кнопка редагування (якщо день вибрано)
                if (_selectedDay != null)
                  FloatingActionButton(
                    heroTag: 'btn_edit',
                    tooltip: loc.editExercisesTooltip,
                    onPressed: () => _openWorkoutDay(_selectedDay!),
                    child: const Icon(Icons.edit),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
