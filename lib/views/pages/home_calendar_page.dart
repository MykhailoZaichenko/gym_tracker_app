import 'package:flutter/material.dart';
import 'package:gym_tracker_app/views/pages/workout_day_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeCalendarPage extends StatefulWidget {
  @override
  _HomeCalendarPageState createState() => _HomeCalendarPageState();
}

class _HomeCalendarPageState extends State<HomeCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<WorkoutExercise>> _workouts = {};
  final Map<int, List<WorkoutExercise>> _weeklyTemplates = {};

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  void _openWorkoutPage(DateTime day) {
    final key = _dateOnly(day);

    final exercises = List<WorkoutExercise>.from(
      _workouts[key] ?? _weeklyTemplates[day.weekday] ?? <WorkoutExercise>[],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutDayScreen(
          date: key,
          exercises: exercises,
          onSave: (List<WorkoutExercise> newExercises) {
            setState(() {
              _workouts[key] = newExercises;
            });
          },
        ),
      ),
    );
  }

  void _addTemplateForWeekday(int weekday) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutDayScreen(
          date: DateTime.now(),
          exercises: List<WorkoutExercise>.from(
            _weeklyTemplates[weekday] ?? <WorkoutExercise>[],
          ),
          onSave: (List<WorkoutExercise> newExercises) {
            setState(() {
              _weeklyTemplates[weekday] = newExercises;
            });
          },
        ),
      ),
    );
  }

  /// 🔥 Генеруємо дані для графіка: окремо вага і повторення
  Map<String, List<FlSpot>> _generateProgressData() {
    final weightSpots = <FlSpot>[];
    final repsSpots = <FlSpot>[];

    final currentMonth = _focusedDay.month;
    final currentYear = _focusedDay.year;
    final daysInMonth = DateUtils.getDaysInMonth(currentYear, currentMonth);

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentYear, currentMonth, day);
      final key = _dateOnly(date);

      final exercises = _workouts[key] ?? [];
      double totalWeight = 0;
      double totalReps = 0;

      for (var ex in exercises) {
        for (var set in ex.sets) {
          totalWeight += (set.weight ?? 0);
          totalReps += (set.reps ?? 0);
        }
      }

      if (totalWeight > 0 || totalReps > 0) {
        weightSpots.add(FlSpot(day.toDouble(), totalWeight));
        repsSpots.add(FlSpot(day.toDouble(), totalReps));
      }
    }

    return {"weight": weightSpots, "reps": repsSpots};
  }

  @override
  Widget build(BuildContext context) {
    final spots = _generateProgressData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Мій календар тренувань"),
        actions: [
          PopupMenuButton<int>(
            onSelected: _addTemplateForWeekday,
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text("Шаблон для Понеділка")),
              PopupMenuItem(value: 2, child: Text("Шаблон для Вівторка")),
              PopupMenuItem(value: 3, child: Text("Шаблон для Середи")),
              PopupMenuItem(value: 4, child: Text("Шаблон для Четверга")),
              PopupMenuItem(value: 5, child: Text("Шаблон для П’ятниці")),
              PopupMenuItem(value: 6, child: Text("Шаблон для Суботи")),
              PopupMenuItem(value: 7, child: Text("Шаблон для Неділі")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _openWorkoutPage(selectedDay);
            },
          ),
          if (_selectedDay != null) ...[
            const SizedBox(height: 12),
            Text(
              "Вправ на ${_dateOnly(_selectedDay!).toLocal().toString().split(' ')[0]}: "
              "${(_workouts[_dateOnly(_selectedDay!)] ?? _weeklyTemplates[_selectedDay!.weekday])?.length ?? 0}",
            ),
          ],
          const SizedBox(height: 20),

          // 📊 Графік прогресу
          if (spots["weight"]!.isNotEmpty || spots["reps"]!.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  height: 220,
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      gridData: FlGridData(show: true),
                      lineBarsData: [
                        // 🔵 Лінія ваги
                        LineChartBarData(
                          spots: spots["weight"]!,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                        ),
                        // 🔴 Лінія повторів
                        LineChartBarData(
                          spots: spots["reps"]!,
                          isCurved: true,
                          color: Colors.red,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 🏷 Легенда
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(width: 15, height: 3, color: Colors.blue),
                        const SizedBox(width: 6),
                        const Text("Вага"),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Container(width: 15, height: 3, color: Colors.red),
                        const SizedBox(width: 6),
                        const Text("Повторення"),
                      ],
                    ),
                  ],
                ),
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Немає даних для графіка цього місяця",
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
