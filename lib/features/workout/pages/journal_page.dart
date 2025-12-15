import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final FirestoreService _firestore = FirestoreService();
  bool _isLoading = true;
  List<WorkoutExercise>? _todaysWorkout;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkTodayWorkout();
  }

  // Перевіряємо, чи є тренування на сьогодні, при кожному вході на вкладку
  Future<void> _checkTodayWorkout() async {
    setState(() => _isLoading = true);
    final workout = await _firestore.getWorkout(_today);
    if (mounted) {
      setState(() {
        _todaysWorkout = workout.isNotEmpty ? workout : null;
        _isLoading = false;
      });
    }
  }

  void _startOrContinueWorkout() async {
    final isNew = _todaysWorkout == null;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutPage(
          date: _today,
          // Якщо тренування нове, передаємо пустий список, але з прапорцем autoPick
          exercises: _todaysWorkout ?? [],
          shouldAutoPick: isNew, // <--- Відкриє пікер, якщо це нове тренування
        ),
      ),
    );
    _checkTodayWorkout();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dateStr = DateFormat.MMMMEEEEd(loc.localeName).format(_today);

    return Scaffold(
      appBar: AppBar(title: Text(loc.navJournal), centerTitle: false),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Гарна дата
                  Text(
                    dateStr.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Велика іконка статусу
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: _todaysWorkout != null
                          ? Colors.green.withValues(alpha: 0.1)
                          : Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _todaysWorkout != null
                          ? Icons.check_circle_outline
                          : Icons.fitness_center,
                      size: 80,
                      color: _todaysWorkout != null
                          ? Colors.green
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Текст статусу
                  Text(
                    _todaysWorkout != null
                        ? loc.workoutToday
                        : loc.noWorkoutToday,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_todaysWorkout != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        loc.exercisesCount(_todaysWorkout!.length),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                  const Spacer(),

                  // Головна кнопка дії
                  SizedBox(
                    height: 60,
                    child: PrimaryFilledButton(
                      text: _todaysWorkout != null
                          ? loc.continueWorkout
                          : loc.startWorkout,
                      onPressed: _startOrContinueWorkout,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
