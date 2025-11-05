import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/analytics/pages/graf_page.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_page.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_plan_editor_page.dart';
import 'package:gym_tracker_app/features/home/home_exports.dart';

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
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        appBar: HomeHeader(
          onOpenAnalytics: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => GrafPage()));
          },
          onOpenPlanEditor: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WorkoutPlanEditorPage()),
            );
          },
        ),
        body: Column(
          children: [
            HomeCalendar(
              selectedDay: _selectedDay,
              focusedDay: _focusedDay,
              allWorkouts: _allWorkouts,
              onMonthPicked: (picked) {
                if (picked != null) {
                  setState(() {
                    _focusedDay = picked;
                    _selectedDay = picked;
                  });
                }
              },
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: HomeExerciseList(
                selectedDay: _selectedDay,
                selectedExercises: _selectedExercises,
                keyOf: _keyOf,
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
      ),
    );
  }
}
