import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/models/workout_exercise_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/data/exercise_catalog.dart';
import 'package:gym_tracker_app/views/widgets/exercise_picker_widget.dart';

class WorkoutDayPage extends StatefulWidget {
  final DateTime date;
  final List<WorkoutExercise> exercises;
  final void Function(List<WorkoutExercise>) onSave;

  const WorkoutDayPage({
    super.key,
    required this.date,
    required this.exercises,
    required this.onSave,
  });

  @override
  _WorkoutDayPageState createState() => _WorkoutDayPageState();
}

class _WorkoutDayPageState extends State<WorkoutDayPage> {
  late List<WorkoutExercise> _exercises = [];

  bool _isLoading = true;

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

  /// Якщо value ціле — повертає без .0, інакше — як є
  String _formatDouble(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  // Завантажуємо збережені вправи або беремо widget.exercises
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
  }

  // Ініціалізуємо TextEditingController-и на основі _exercises
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

  // Зберігаємо дані з контролерів у модель і в SharedPreferences
  Future<void> _saveExercises() async {
    // Спочатку скидаємо модель з контролерів
    for (var i = 0; i < _exercises.length; i++) {
      _exercises[i].name = _nameCtrls[i].text;
      for (var j = 0; j < _exercises[i].sets.length; j++) {
        _exercises[i].sets[j].weight = double.tryParse(_weightCtrls[i][j].text);
        _exercises[i].sets[j].reps = int.tryParse(_repsCtrls[i][j].text);
      }
    }

    // Стороннє збереження
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_exercises.map((e) => e.toMap()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  void _addExercise() {
    setState(() {
      _exercises.add(
        WorkoutExercise(name: '', exerciseId: null, sets: [SetData()]),
      );
      // додаємо контролери для нової вправи
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
      // видаляємо модель
      _exercises.removeAt(index);

      // чистимо контролер назви
      _nameCtrls.removeAt(index).dispose();

      // чистимо контролери ваги й повторів
      _weightCtrls.removeAt(index).forEach((c) => c.dispose());
      _repsCtrls.removeAt(index).forEach((c) => c.dispose());
    });
  }

  @override
  void dispose() {
    // Чистимо контролери
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

  Widget _buildExerciseIconWidget(String name) {
    final found = kExerciseCatalog.firstWhere(
      (e) => e.name == name,
      orElse: () => kExerciseCatalog.isNotEmpty
          ? kExerciseCatalog.first
          : ExerciseInfo(id: 'none', name: '', icon: Icons.fitness_center),
    );
    final color = name.isEmpty
        ? Colors.grey.shade300
        : Theme.of(context).primaryColor;
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withValues(alpha: 0.12),
      child: Icon(found.icon, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Тренування ${widget.date.toLocal().toIso8601String().split('T').first}",
        ),
        actions: [
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
                  // Назва вправи
                  Row(
                    children: [
                      _buildExerciseIconWidget(_nameCtrls[i].text),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showExercisePicker(
                              context,
                              initialQuery: _nameCtrls[i].text,
                            );

                            if (picked == null) {
                              // користувач скасував — нічого не робимо
                              return;
                            }

                            if (picked.id == '__custom__') {
                              // користувач вибрав явно "Ввести власну назву" — відкриваємо діалог
                              final custom = await showDialog<String>(
                                context: context,
                                builder: (ctx) {
                                  final ctrl = TextEditingController(
                                    text: _nameCtrls[i].text,
                                  );
                                  return AlertDialog(
                                    title: const Text('Введіть назву вправи'),
                                    content: TextField(
                                      controller: ctrl,
                                      autofocus: true,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                        child: const Text('Відміна'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(
                                          ctx,
                                        ).pop(ctrl.text.trim()),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (custom != null && custom.isNotEmpty) {
                                setState(() {
                                  _nameCtrls[i].text = custom;
                                  exercise.name = custom;
                                  exercise.exerciseId = null;
                                });
                              }

                              return;
                            }

                            // Інакше — обрана вправа з каталогу
                            setState(() {
                              _nameCtrls[i].text = picked.name;
                              exercise.name = picked.name;
                              exercise.exerciseId = picked.id;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _nameCtrls[i].text.isEmpty
                                        ? 'Оберіть вправу'
                                        : _nameCtrls[i].text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _nameCtrls[i].text.isEmpty
                                          ? Colors.grey
                                          : null,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _removeExercise(i);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Видалити вправу'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Підходи
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (int j = 0; j < exercise.sets.length; j++)
                          Container(
                            width: 90,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 5),
                                    Text(
                                      "Підхід ${j + 1}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          size: 20,
                                        ),
                                        onSelected: (value) {
                                          if (value == 'delete') {
                                            _removeSet(i, j);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text(
                                              'Видалити підхід ${j + 1}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Вага
                                      SizedBox(
                                        width: 35,
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          controller: _weightCtrls[i][j],
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Кг',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "/",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      // Повтори
                                      SizedBox(
                                        width: 35,
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          controller: _repsCtrls[i][j],
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Повт.',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Додати ще підхід
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addSet(i),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        tooltip: 'Додати вправу',
        child: const Icon(Icons.add),
      ),
    );
  }
}
