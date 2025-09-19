import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutDayScreen extends StatefulWidget {
  final DateTime date;
  final List<WorkoutExercise> exercises;
  final void Function(List<WorkoutExercise>) onSave;

  const WorkoutDayScreen({
    Key? key,
    required this.date,
    required this.exercises,
    required this.onSave,
  }) : super(key: key);

  @override
  _WorkoutDayScreenState createState() => _WorkoutDayScreenState();
}

class _WorkoutDayScreenState extends State<WorkoutDayScreen> {
  late List<WorkoutExercise> _exercises;

  @override
  void initState() {
    super.initState();
    // Спочатку відпрацьовує конструктор, потім завантажуємо можливі збережені дані
    _exercises = List.from(widget.exercises);
    _loadSavedExercises();
  }

  // Ключ у SharedPreferences для поточної дати
  String get _prefsKey =>
      'workout_${widget.date.toIso8601String().split('T').first}';

  Future<void> _loadSavedExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKey);
    if (jsonStr != null) {
      final List<dynamic> rawList = jsonDecode(jsonStr);
      setState(() {
        _exercises = rawList
            .map((e) => WorkoutExercise.fromMap(e as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> _saveExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_exercises.map((e) => e.toMap()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  void _addExercise() {
    setState(() {
      _exercises.add(WorkoutExercise(name: "Нова вправа", sets: [SetData()]));
    });
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      _exercises[exerciseIndex].sets.add(SetData());
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  TextField(
                    controller: TextEditingController(text: exercise.name),
                    decoration: const InputDecoration(labelText: "Вправа"),
                    onChanged: (val) => exercise.name = val,
                  ),
                  const SizedBox(height: 8),

                  // Підходи
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int j = 0; j < exercise.sets.length; j++)
                          Container(
                            width: 90,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Text(
                                  "Підхід ${j + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                        width: 30,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: "Вага",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (val) {
                                            exercise.sets[j].weight =
                                                double.tryParse(val);
                                          },
                                        ),
                                      ),
                                      const Text(
                                        "/",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      // Повтори
                                      SizedBox(
                                        width: 30,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: "Повт.",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (val) {
                                            exercise.sets[j].reps =
                                                int.tryParse(val);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Додати ще підхід
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addSet(i),
                        ),
                      ],
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ---- Модель ----

class WorkoutExercise {
  String name;
  List<SetData> sets;

  WorkoutExercise({required this.name, required this.sets});

  factory WorkoutExercise.fromMap(Map<String, dynamic> m) {
    return WorkoutExercise(
      name: m['name'] as String? ?? '',
      sets: (m['sets'] as List<dynamic>? ?? [])
          .map((e) => SetData.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'sets': sets.map((s) => s.toMap()).toList(),
  };
}

class SetData {
  double? weight;
  int? reps;

  SetData({this.weight, this.reps});

  factory SetData.fromMap(Map<String, dynamic> m) {
    return SetData(
      weight: (m['weight'] as num?)?.toDouble(),
      reps: m['reps'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {'weight': weight, 'reps': reps};
}
