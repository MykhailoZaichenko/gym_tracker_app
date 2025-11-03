class WeeklyWorkoutPlan {
  final Map<Weekday, List<String>> exercises;

  WeeklyWorkoutPlan({required this.exercises});

  factory WeeklyWorkoutPlan.empty() =>
      WeeklyWorkoutPlan(exercises: {for (final day in Weekday.values) day: []});
}

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

String weekdayLabel(Weekday day) {
  switch (day) {
    case Weekday.monday:
      return 'Понеділок';
    case Weekday.tuesday:
      return 'Вівторок';
    case Weekday.wednesday:
      return 'Середа';
    case Weekday.thursday:
      return 'Четвер';
    case Weekday.friday:
      return 'Пʼятниця';
    case Weekday.saturday:
      return 'Субота';
    case Weekday.sunday:
      return 'Неділя';
  }
}
