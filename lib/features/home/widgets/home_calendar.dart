import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_tracker_app/widget/common/month_picker_dialog.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:intl/intl.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class HomeCalendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final Map<String, List<WorkoutExercise>> allWorkouts;
  final void Function(DateTime?) onMonthPicked;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  const HomeCalendar({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.allWorkouts,
    required this.onMonthPicked,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  String _keyOf(DateTime date) => date.toIso8601String().split('T').first;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!.localeName;
    final now = DateTime.now();

    final lastAllowedDay = DateTime(now.year, now.month + 1, 0);

    final startingDayOfWeek = locale.startsWith('uk')
        ? StartingDayOfWeek.monday
        : StartingDayOfWeek.sunday;

    return TableCalendar(
      locale: locale,
      startingDayOfWeek: startingDayOfWeek,
      onPageChanged: onPageChanged,
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {
          final monthName = DateFormat.MMMM(locale).format(day);
          final year = day.year;
          final capitalized = toBeginningOfSentenceCase(monthName);

          return InkWell(
            onTap: () async {
              final now = DateTime.now();
              final picked = await showMonthPicker(
                context: context,
                initialDate: day,
                firstDate: DateTime(2024, 1, 1),
                lastDate: DateTime(now.year, now.month + 1, 0),
              );
              onMonthPicked(picked);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$capitalized $year',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          );
        },
      ),
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: lastAllowedDay,
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
