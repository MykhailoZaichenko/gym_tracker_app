import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_tracker_app/widget/common/month_picker_dialog.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';

class HomeCalendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final Map<String, List<WorkoutExercise>> allWorkouts;
  final void Function(DateTime?) onMonthPicked;
  final void Function(DateTime, DateTime) onDaySelected;

  const HomeCalendar({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.allWorkouts,
    required this.onMonthPicked,
    required this.onDaySelected,
  });

  String _keyOf(DateTime date) => date.toIso8601String().split('T').first;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "uk_UA",
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {
          final monthName = ukrainianMonths[day.month - 1];
          final capitalized =
              monthName[0].toUpperCase() + monthName.substring(1);
          return InkWell(
            onTap: () async {
              final picked = await showMonthPicker(
                context: context,
                initialDate: day,
              );
              onMonthPicked(picked);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$capitalized ${day.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          );
        },
      ),
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(day, selectedDay),
      eventLoader: (day) => allWorkouts[_keyOf(day)] ?? <WorkoutExercise>[],
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: ThemeService.isDarkModeNotifier.value
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).primaryColorDark,
          shape: BoxShape.circle,
        ),
        todayDecoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: ThemeService.isDarkModeNotifier.value
              ? Colors.blueGrey
              : Colors.blue[300],
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: onDaySelected,
    );
  }
}
