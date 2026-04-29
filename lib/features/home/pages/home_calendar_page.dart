import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Додано імпорт
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_page.dart';
import 'package:gym_tracker_app/widget/common/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalendarPage extends StatefulWidget {
  const HomeCalendarPage({super.key});
  @override
  State<HomeCalendarPage> createState() => _HomeCalendarPageState();
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

  // --- Функція для виклику довідки ---
  Future<void> openHelpScreen(String pageName, {String? anchor}) async {
    final String baseUrl = 'https://gym-tracker-help.vercel.app';
    final String urlString = anchor != null
        ? '$baseUrl/$pageName#$anchor'
        : '$baseUrl/$pageName';
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не вдалося відкрити довідку: $urlString')),
        );
      }
    }
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
        builder: (_) => WorkoutPage(
          date: date,
          exercises: initialExercises,
          onSave: (newExercises) async {
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Календар тренувань'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: 'Довідка по календарю',
              onPressed: () => openHelpScreen(
                'interaktivnij_kalendar.htm',
                anchor: 'date_selection',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            TableCalendar(
              locale: "uk_UA",
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  final monthName = ukrainianMonths[day.month - 1];
                  final capitalized =
                      monthName[0].toUpperCase() + monthName.substring(1);
                  return GestureDetector(
                    onTap: () async {
                      final picked = await showMonthPicker(
                        context: context,
                        initialDate: day,
                      );
                      if (picked != null) {
                        setState(() {
                          _focusedDay = picked;
                          _selectedDay = picked;
                        });
                      }
                    },
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
                todayDecoration: const BoxDecoration(
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
                                isThreeLine: ex.sets.length > 1,
                                title: ex.name == ''
                                    ? Text('Вправа${i}')
                                    : Text(ex.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${ex.sets.length} підходів'),
                                    const SizedBox(height: 4),
                                    for (var j = 0; j < ex.sets.length; j++)
                                      Text(
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'help_edit_record',
                    mini: true,
                    onPressed: () => openHelpScreen(
                      'termini_interfejsu.htm',
                      anchor: 'term_edit_record',
                    ),
                    tooltip: 'Що таке редагування запису?',
                    child: const Icon(Icons.question_mark),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'edit_workout',
                    tooltip: 'Редагувати вправи',
                    child: const Icon(Icons.edit),
                    onPressed: () => _openWorkoutDay(_selectedDay!),
                  ),
                ],
              ),
      ),
    );
  }
}
