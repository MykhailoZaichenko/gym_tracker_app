import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart'; // Для збереження
import 'package:gym_tracker_app/widget/common/custome_snackbar.dart';
import 'package:gym_tracker_app/widget/common/weekly_goal_dialog.dart';
import 'package:intl/intl.dart';

class StreakDetailsPage extends StatefulWidget {
  final int streakWeeks;
  final int weeklyGoal; // Початкова ціль
  final Map<String, List<WorkoutExercise>> allWorkouts;

  const StreakDetailsPage({
    super.key,
    required this.streakWeeks,
    required this.weeklyGoal,
    required this.allWorkouts,
  });

  @override
  State<StreakDetailsPage> createState() => _StreakDetailsPageState();
}

class _StreakDetailsPageState extends State<StreakDetailsPage> {
  late int _currentGoal;
  final FirestoreService _firestore = FirestoreService();

  @override
  void initState() {
    super.initState();
    _currentGoal = widget.weeklyGoal;
  }

  bool _hasWorkout(DateTime date) {
    final key = date.toIso8601String().split('T').first;
    return widget.allWorkouts.containsKey(key) &&
        widget.allWorkouts[key]!.isNotEmpty;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _changeGoal() async {
    final loc = AppLocalizations.of(context)!;
    // Відкриваємо той самий діалог, що і на JournalPage
    final newGoal = await showDialog<int>(
      context: context,
      builder: (_) => WeeklyGoalDialog(initialGoal: _currentGoal),
    );

    if (newGoal != null && newGoal != _currentGoal) {
      // 1. Зберігаємо в базу
      await _firestore.updateWeeklyGoal(newGoal);

      // 2. Оновлюємо UI миттєво
      if (mounted) {
        setState(() {
          _currentGoal = newGoal;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.show(context, message: loc.goalLabel(newGoal))
              as SnackBar,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final contentColor = isDark ? Colors.white : Colors.black;

    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    int workoutsThisWeek = 0;
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      if (_hasWorkout(day)) workoutsThisWeek++;
    }

    // Використовуємо _currentGoal замість widget.weeklyGoal
    final int needed = _currentGoal - workoutsThisWeek;
    final int stillNeeded = needed > 0 ? needed : 0;
    final int daysRemainingInWeek = 7 - currentWeekday;

    // Логіка провалу з урахуванням НОВОЇ цілі
    final bool isWeekFailed = daysRemainingInWeek < stillNeeded;
    final isGoalMet = workoutsThisWeek >= _currentGoal;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(loc.weekLabel),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: contentColor),
        titleTextStyle: TextStyle(
          color: contentColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          // 🔥 ТРИ КРАПОЧКИ
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _changeGoal();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: contentColor, size: 20),
                      const SizedBox(width: 8),
                      // Можна додати localized string "Змінити ціль"
                      Text(
                        loc.weeklyGoalTitle,
                        style: TextStyle(color: contentColor),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_fire_department,
            size: 100,
            color: Color(0xFFE91E63),
          ),
          const SizedBox(height: 16),
          Text(
            loc.streakWeeks(widget.streakWeeks),
            style: TextStyle(
              color: contentColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final date = startOfWeek.add(Duration(days: index));

                final shortName = DateFormat.E(loc.localeName).format(date);
                final dayName = shortName.length >= 2
                    ? shortName.substring(0, 2).toUpperCase()
                    : shortName.toUpperCase();

                final isFuture = date.isAfter(now) && !isSameDay(date, now);
                final hasWorkout = _hasWorkout(date);

                Widget icon;
                Color bgColor;

                if (hasWorkout) {
                  icon = const Icon(Icons.check, color: Colors.white, size: 20);
                  bgColor = const Color(0xFF4CAF50);
                } else if (isFuture) {
                  icon = const SizedBox();
                  bgColor = Colors.grey.withValues(alpha: 0.2);
                } else {
                  if (isWeekFailed) {
                    icon = const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    );
                    bgColor = Colors.redAccent.withValues(alpha: 0.8);
                  } else {
                    icon = const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 20,
                    );
                    bgColor = Colors.orangeAccent.withValues(alpha: 0.8);
                  }
                }

                return Column(
                  children: [
                    Text(
                      dayName,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: icon),
                    ),
                  ],
                );
              }),
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              isGoalMet
                  ? loc.streakKeep
                  : (isWeekFailed
                        ? loc.streakLostMsg
                        : loc.streakBurn(stillNeeded)),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: contentColor.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
