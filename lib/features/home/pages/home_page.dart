import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/analytics/pages/graf_page.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_page.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_plan_editor_page.dart';
import 'package:gym_tracker_app/features/home/home_exports.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/features/home/widgets/plan_proposal_dialog_widget.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';

class HomeCalendarPage extends StatefulWidget {
  const HomeCalendarPage({super.key});

  @override
  State<HomeCalendarPage> createState() => _HomeCalendarPageState();
}

class _HomeCalendarPageState extends State<HomeCalendarPage> {
  late Map<String, List<WorkoutExercise>> _allWorkouts;
  bool _isLoading = true;
  final FirestoreService _firestore = FirestoreService();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadAllWorkouts();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPlanProposal();
    });
  }

  Future<void> _checkAndShowPlanProposal() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_plan_proposal') ?? false;

    if (!hasSeen && mounted) {
      await showPlanProposal(context);
      await prefs.setBool('has_seen_plan_proposal', true);
    }
  }

  Future<void> _loadAllWorkouts() async {
    // Завантажуємо всі тренування з Firestore
    _allWorkouts = await _firestore.getAllWorkouts();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  String _keyOf(DateTime date) => date.toIso8601String().split('T').first;

  List<WorkoutExercise> get _selectedExercises {
    if (_selectedDay == null) return [];
    return _allWorkouts[_keyOf(_selectedDay!)] ?? [];
  }

  void _openWorkoutDay(DateTime date) async {
    final initialExercises = List<WorkoutExercise>.from(
      _allWorkouts[_keyOf(date)] ?? [],
    );

    // Переходимо на WorkoutPage
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutPage(
          date: date,
          exercises: initialExercises,
          onSave: (newExercises) {
            // Callback не обов'язковий для збереження (бо WorkoutPage зберігає в DB),
            // але корисний для миттєвого оновлення UI Home Page
          },
        ),
      ),
    );

    // Після повернення — перезавантажуємо дані, щоб відобразити зміни
    _loadAllWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final loc = AppLocalizations.of(context)!;

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
                tooltip: loc.editExercisesTooltip,
                child: const Icon(Icons.edit),
                onPressed: () => _openWorkoutDay(_selectedDay!),
              ),
      ),
    );
  }
}
