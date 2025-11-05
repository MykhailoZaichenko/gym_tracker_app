import 'package:gym_tracker_app/core/constants/constants.dart';

class WeeklyWorkoutPlan {
  final Map<Weekday, List<String>> exercises;

  WeeklyWorkoutPlan({required this.exercises});

  factory WeeklyWorkoutPlan.empty() =>
      WeeklyWorkoutPlan(exercises: {for (final day in Weekday.values) day: []});
}
