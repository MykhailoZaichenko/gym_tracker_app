import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:gym_tracker_app/core/constants/exersise_meta.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/profile/profile_exports.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart'; // Потрібен для моделі WorkoutExercise

class ProfileGrafPage extends StatefulWidget {
  const ProfileGrafPage({super.key});

  @override
  State<ProfileGrafPage> createState() => _ProfileGrafPageState();
}

class _ProfileGrafPageState extends State<ProfileGrafPage> {
  User? _user;
  bool _isLoading = true;
  final FirestoreService _firestore = FirestoreService();

  // Всі тренування поточного користувача
  Map<String, List<WorkoutExercise>> _allWorkouts = {};

  // stats and UI
  DateTime _visibleMonth = DateTime.now();

  int _totalSets = 0;
  double _totalWeight = 0.0;
  double _calories = 0.0;
  // ignore: unused_field
  bool _slideToLeft = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Завантажуємо дані профілю ТА тренування з Firestore
  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // 1. Отримуємо профіль
    final user = await _firestore.getUser();

    // 2. Отримуємо тренування
    final workouts = await _firestore.getAllWorkouts();

    if (!mounted) return;

    setState(() {
      _user = user;
      _allWorkouts = workouts; // Зберігаємо завантажені тренування
      _isLoading = false;
    });

    // 3. Рахуємо статистику на основі завантажених даних
    _recalculateStats();
  }

  // Метод перерахунку (викликається при зміні місяця або після завантаження)
  void _recalculateStats() {
    final firstDayOfMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    );

    int totalSets = 0;
    double totalWeight = 0.0;
    double totalCalories = 0.0;

    const double secondsPerRep = 4.0;
    final double? userWeight = _user?.weightKg;
    final canComputeCalories = userWeight != null;

    // Проходимо по мапі тренувань, яку ми завантажили з Firestore
    _allWorkouts.forEach((dateStr, exercises) {
      DateTime date;
      try {
        date = DateTime.parse(dateStr);
      } catch (_) {
        return;
      }

      // Фільтр за датою (чи входить у вибраний місяць)
      if (date.isBefore(firstDayOfMonth) || date.isAfter(lastDayOfMonth)) {
        return;
      }

      for (final ex in exercises) {
        // Отримуємо MET для вправи (якщо є ID, інакше дефолт)
        final exId = ex.exerciseId;
        final met = (exId != null && kExerciseMet.containsKey(exId))
            ? kExerciseMet[exId]!
            : 4.0;

        for (final s in ex.sets) {
          final reps = s.reps ?? 0;
          final weight = s.weight ?? 0.0;
          if (reps <= 0) continue;

          totalSets += 1;
          totalWeight += weight * reps;

          if (canComputeCalories) {
            final secondsThisSet = reps * secondsPerRep;
            final minutesThisSet = secondsThisSet / 60.0;
            final kcalPerMin = met * userWeight / 60.0;
            totalCalories += kcalPerMin * minutesThisSet;
          }
        }
      }
    });

    setState(() {
      _totalSets = totalSets;
      _totalWeight = totalWeight;
      _calories = totalCalories;
    });
  }

  void _prevMonth() {
    setState(() {
      _slideToLeft = false;
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
    _recalculateStats(); // Перераховуємо для нового місяця
  }

  void _nextMonth() {
    setState(() {
      _slideToLeft = true;
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
    _recalculateStats(); // Перераховуємо для нового місяця
  }

  Future<void> _onEditProfile(BuildContext ctx) async {
    if (_user == null) return;
    final updated = await Navigator.push<User?>(
      ctx,
      MaterialPageRoute(builder: (_) => EditProfilePage(user: _user!)),
    );
    if (updated != null && mounted) {
      setState(() {
        _user = updated;
      });
      _recalculateStats(); // Перераховуємо (раптом вага змінилася)
    }
  }

  void _onProfileUpdated(User updated) {
    if (!mounted) return;
    setState(() => _user = updated);
    _recalculateStats();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!.localeName;
    final monthName = DateFormat.MMMM(locale).format(_visibleMonth);
    final capitalizedMonth = toBeginningOfSentenceCase(monthName);

    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ProfileHeader(user: _user, onEditPressed: _onEditProfile),
                      const SizedBox(height: 12),
                      // ProfileStatsCard залишається таким самим,
                      // ми просто передаємо йому нові, правильні дані
                      ProfileStatsCard(
                        visibleMonth: _visibleMonth,
                        ukMonthLabel: capitalizedMonth,
                        totalSets: _totalSets,
                        totalWeight: _totalWeight,
                        totalCalories: _calories,
                        onPrevMonth: _prevMonth,
                        onNextMonth: _nextMonth,
                        onPickMonth: (newMonth) {
                          setState(() {
                            _visibleMonth = newMonth;
                          });
                          _recalculateStats();
                        },
                      ),
                      const SizedBox(height: 12),
                      ProfileSettingsList(
                        user: _user,
                        onProfileUpdated: _onProfileUpdated,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
