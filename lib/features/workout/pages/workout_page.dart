import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Додано імпорт
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/features/workout/workout_exports.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';

class WorkoutPage extends StatefulWidget {
  final DateTime date;
  final List<WorkoutExercise> exercises;
  final void Function(List<WorkoutExercise>) onSave;

  const WorkoutPage({
    super.key,
    required this.date,
    required this.exercises,
    required this.onSave,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late List<WorkoutExercise> _exercises = [];

  bool _isLoading = true;
  String? _initialEncoded;

  final List<TextEditingController> _nameCtrls = [];
  final List<List<TextEditingController>> _weightCtrls = [];
  final List<List<TextEditingController>> _repsCtrls = [];

  String get _prefsKey =>
      'workout_${widget.date.toIso8601String().split('T').first}';

  @override
  void initState() {
    super.initState();
    _loadExercises();
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

  String _formatDouble(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  Future<void> _loadExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_prefsKey);

    if (rawJson != null) {
      final List<dynamic> decoded = jsonDecode(rawJson);
      _exercises = decoded
          .map((m) => WorkoutExercise.fromMap(m as Map<String, dynamic>))
          .toList();
    } else {
      _exercises = List.from(widget.exercises);
    }

    _initControllers();
    setState(() {
      _isLoading = false;
    });
    _initialEncoded = jsonEncode(_exercises.map((e) => e.toMap()).toList());
  }

  void _initControllers() {
    _nameCtrls.clear();
    _weightCtrls.clear();
    _repsCtrls.clear();

    for (var ex in _exercises) {
      _nameCtrls.add(TextEditingController(text: ex.name));

      final wList = <TextEditingController>[];
      final rList = <TextEditingController>[];
      for (var set in ex.sets) {
        wList.add(TextEditingController(text: _formatDouble(set.weight)));
        rList.add(TextEditingController(text: set.reps?.toString() ?? ''));
      }
      _weightCtrls.add(wList);
      _repsCtrls.add(rList);
    }
  }

  Future<void> _saveExercises() async {
    for (var i = 0; i < _exercises.length; i++) {
      _exercises[i].name = _nameCtrls[i].text;
      for (var j = 0; j < _exercises[i].sets.length; j++) {
        _exercises[i].sets[j].weight = double.tryParse(_weightCtrls[i][j].text);
        _exercises[i].sets[j].reps = int.tryParse(_repsCtrls[i][j].text);
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_exercises.map((e) => e.toMap()).toList());
    await prefs.setString(_prefsKey, encoded);

    _initialEncoded = encoded;
  }

  String _encodeCurrentFromControllers() {
    final current = <Map<String, dynamic>>[];
    for (var i = 0; i < _exercises.length; i++) {
      final ex = _exercises[i];
      final name = _nameCtrls.length > i ? _nameCtrls[i].text : ex.name;
      final sets = <Map<String, dynamic>>[];
      for (var j = 0; j < ex.sets.length; j++) {
        final weightText =
            (_weightCtrls.length > i && _weightCtrls[i].length > j)
            ? _weightCtrls[i][j].text
            : '';
        final repsText = (_repsCtrls.length > i && _repsCtrls[i].length > j)
            ? _repsCtrls[i][j].text
            : '';
        final weight = double.tryParse(weightText);
        final reps = int.tryParse(repsText);
        sets.add({'weight': weight, 'reps': reps});
      }
      current.add({'name': name, 'exerciseId': ex.exerciseId, 'sets': sets});
    }
    return jsonEncode(current);
  }

  bool _hasUnsavedChanges() {
    final current = _encodeCurrentFromControllers();
    return _initialEncoded != current;
  }

  Future<bool> _onWillPop() async {
    if (_initialEncoded == null) return true;
    if (!_hasUnsavedChanges()) return true;

    final result = await showDialog<ExitChoice>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Зберегти зміни?'),
        content: const Text(
          'Є незбережені зміни. Бажаєте зберегти перед виходом?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.cancel),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.discard),
            child: const Text('Не зберігати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.save),
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );

    if (result == null) return false;
    if (result == ExitChoice.cancel) return false;
    if (result == ExitChoice.discard) return true;

    await _saveExercises();
    if (!mounted) return false;
    widget.onSave(_exercises);
    return true;
  }

  void _addExercise() {
    setState(() {
      _exercises.add(
        WorkoutExercise(name: '', exerciseId: null, sets: [SetData()]),
      );
      _nameCtrls.add(TextEditingController());
      _weightCtrls.add([TextEditingController()]);
      _repsCtrls.add([TextEditingController()]);
    });
  }

  void _removeSet(int exIndex, int setIndex) {
    setState(() {
      _exercises[exIndex].sets.removeAt(setIndex);
      _weightCtrls[exIndex].removeAt(setIndex);
      _repsCtrls[exIndex].removeAt(setIndex);
    });
  }

  void _addSet(int exIndex) {
    setState(() {
      _exercises[exIndex].sets.add(SetData());
      _weightCtrls[exIndex].add(TextEditingController());
      _repsCtrls[exIndex].add(TextEditingController());
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
      _nameCtrls.removeAt(index).dispose();
      _weightCtrls.removeAt(index).forEach((c) => c.dispose());
      _repsCtrls.removeAt(index).forEach((c) => c.dispose());
    });
  }

  @override
  void dispose() {
    for (var c in _nameCtrls) {
      c.dispose();
    }
    for (var list in _weightCtrls) {
      for (var c in list) {
        c.dispose();
      }
    }
    for (var list in _repsCtrls) {
      for (var c in list) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Тренування ${widget.date.toLocal().toIso8601String().split('T').first}",
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Що таке вправа?',
              onPressed: () => openHelpScreen(
                'termini_interfejsu.htm',
                anchor: 'term_exercise',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: 'Довідка по введенню даних',
              onPressed: () => openHelpScreen(
                'dodavannya_pidhodu.htm',
                anchor: 'input_parameters',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                await _saveExercises();
                widget.onSave(_exercises);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _exercises.length,
          itemBuilder: (context, i) {
            final exercise = _exercises[i];

            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExerciseHeader(
                      exercise: exercise,
                      nameController: _nameCtrls[i],
                      onPickExercise: (ctx, {initialQuery}) =>
                          showExercisePicker(ctx, initialQuery: initialQuery),
                      onRemoveExercise: () => _removeExercise(i),
                      buildIconForName: (nameOrId) {
                        final found = kExerciseCatalog.firstWhere(
                          (e) => e.id == nameOrId || e.name == nameOrId,
                          orElse: () => kExerciseCatalog.isNotEmpty
                              ? kExerciseCatalog.first
                              : ExerciseInfo(
                                  id: 'none',
                                  name: '',
                                  icon: Icons.fitness_center,
                                ),
                        );
                        final color = (nameOrId.isEmpty)
                            ? Colors.grey.shade300
                            : Theme.of(context).colorScheme.primary;
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: color.withValues(alpha: 0.12),
                          child: Icon(found.icon, color: color),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    ExerciseSetsList(
                      exercise: exercise,
                      weightControllers: _weightCtrls[i],
                      repsControllers: _repsCtrls[i],
                      onAddSet: () => _addSet(i),
                      onRemoveSet: (setIndex) => _removeSet(i, setIndex),
                      formatDouble: (v) {
                        if (v == null) return '';
                        return v == v.roundToDouble()
                            ? v.toInt().toString()
                            : v.toString();
                      },
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'help_add_set',
              mini: true,
              onPressed: () => openHelpScreen(
                'termini_interfejsu.htm',
                anchor: 'term_add_set',
              ),
              tooltip: 'Що таке додавання підходу?',
              child: const Icon(Icons.question_mark),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'add_exercise',
              onPressed: _addExercise,
              tooltip: 'Додати вправу',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
