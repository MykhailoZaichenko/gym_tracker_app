import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/health/pages/health_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:gym_tracker_app/core/constants/exersise_meta.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/profile/profile_exports.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
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
    final updated = await Navigator.push<UserModel?>(
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

  void _onProfileUpdated(UserModel updated) {
    if (!mounted) return;
    setState(() => _user = updated);
    _recalculateStats();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!.localeName;
    final monthName = DateFormat.MMMM(locale).format(_visibleMonth);
    final capitalizedMonth = toBeginningOfSentenceCase(monthName);
    final listPadding = MediaQuery.of(context).size.width * 0.05;

    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: listPadding + 3,
                        ),
                        child: ProfileHeader(
                          user: _user,
                          onEditPressed: _onEditProfile,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.monitor_weight_outlined,
                              color: Colors.blueAccent,
                            ),
                          ),
                          title: const Text(
                            "Контроль ваги",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text("Графік ваги та нагадування"),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            // Перехід на сторінку здоров'я
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HealthPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: listPadding + 3,
                        ),
                        child: ProfileSettingsList(
                          user: _user,
                          onProfileUpdated: _onProfileUpdated,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
