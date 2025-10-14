import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/views/pages/graf_page.dart';
import 'package:gym_tracker_app/views/pages/workout_day_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalendarPage extends StatefulWidget {
  const HomeCalendarPage({super.key});
  @override
  _HomeCalendarPageState createState() => _HomeCalendarPageState();
}

class _HomeCalendarPageState extends State<HomeCalendarPage> {
  late Map<String, List<WorkoutExercise>> _allWorkouts;
  bool _isLoading = true;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadAllWorkouts();
  }

  Future<void> _loadAllWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('all_workouts');
    if (raw != null) {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      _allWorkouts = decoded.map((date, listJson) {
        final exercises = (listJson as List<dynamic>)
            .map((m) => WorkoutExercise.fromMap(m as Map<String, dynamic>))
            .toList();
        return MapEntry(date, exercises);
      });
    } else {
      _allWorkouts = {};
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveAllWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _allWorkouts.map(
        (date, list) => MapEntry(date, list.map((e) => e.toMap()).toList()),
      ),
    );
    await prefs.setString('all_workouts', encoded);
  }

  String _keyOf(DateTime date) => date.toIso8601String().split('T').first;

  List<WorkoutExercise> get _selectedExercises {
    if (_selectedDay == null) return [];
    return _allWorkouts[_keyOf(_selectedDay!)] ?? [];
  }

  void _openWorkoutDay(DateTime date) {
    final initialExercises = List<WorkoutExercise>.from(
      _allWorkouts[_keyOf(date)] ?? [],
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutDayPage(
          date: date,
          exercises: initialExercises,
          onSave: (newExercises) async {
            // оновлюємо дані та зберігаємо
            _allWorkouts[_keyOf(date)] = newExercises.cast<WorkoutExercise>();
            await _saveAllWorkouts();
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Календар тренувань'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Прогрес',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => GrafPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 📆 Таблиця місяця з маркерами днів із тренуваннями
          TableCalendar(
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            eventLoader: (day) =>
                _allWorkouts[_keyOf(day)] ?? <WorkoutExercise>[],
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColorDark,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: isDark ? Colors.blueGrey : Colors.blue[300],
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
          ),

          const SizedBox(height: 12),

          // 📝 Список вправ обраного дня
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Вправи за ${_keyOf(_selectedDay!)}:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedExercises.isEmpty)
                    const Text(
                      'Немає вправ за цей день',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _selectedExercises.length,
                        itemBuilder: (ctx, i) {
                          final ex = _selectedExercises[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              // Якщо у вас декілька рядків — вмикаємо isThreeLine
                              isThreeLine: ex.sets.length > 1,
                              title: Text(ex.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Показуємо кількість підходів
                                  Text('${ex.sets.length} підходів'),
                                  const SizedBox(height: 4),
                                  // Для кожного підходу — вага та повторення
                                  for (var j = 0; j < ex.sets.length; j++)
                                    Text(
                                      // Форматуємо вагу з однією цифрою після коми, якщо є
                                      'Підхід ${j + 1}: '
                                      '${ex.sets[j].weight?.toStringAsFixed(1) ?? '-'} кг  '
                                      'x ${ex.sets[j].reps ?? '-'} повт.',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedDay == null
          ? null
          : FloatingActionButton(
              tooltip: 'Редагувати вправи',
              child: const Icon(Icons.edit),
              onPressed: () => _openWorkoutDay(_selectedDay!),
            ),
    );
  }
}

// ---- Моделі імпортуються з workout_day_page.dart ----
