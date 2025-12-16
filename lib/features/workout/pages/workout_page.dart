import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';

import 'package:gym_tracker_app/features/workout/workout_exports.dart';
import 'package:gym_tracker_app/utils/utils.dart';
import 'package:gym_tracker_app/widget/common/pop_save_wideget.dart';
import 'package:intl/intl.dart';

class WorkoutPage extends StatefulWidget {
  final DateTime date;
  final String? workoutId;
  final List<WorkoutExercise>? exercises;
  final bool shouldAutoPick;

  const WorkoutPage({
    super.key,
    required this.date,
    this.workoutId,
    this.exercises,
    this.shouldAutoPick = false,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late List<WorkoutExercise> _exercises = [];
  final FirestoreService _firestore = FirestoreService();

  bool _isLoading = true;
  String? _initialEncoded;

  final List<TextEditingController> _nameCtrls = [];
  final List<List<TextEditingController>> _weightCtrls = [];
  final List<List<TextEditingController>> _repsCtrls = [];
  final List<List<FocusNode>> _weightFocusNodes = [];
  final List<List<FocusNode>> _repsFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _addFocusListener(FocusNode node, TextEditingController controller) {
    node.addListener(() {
      if (node.hasFocus) {
        // Чекаємо кадр, щоб переконатися, що клавіатура та фокус відпрацювали
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && controller.text.isNotEmpty) {
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          }
        });
      }
    });
  }

  Future<void> _loadExercises() async {
    // 1. Спочатку пробуємо завантажити з Firebase (якщо є збережене тренування)
    // Тут увага: getWorkout тепер має повертати список, або ми шукаємо по ID
    // Але якщо ти використовуєш getWorkout(date), воно поверне збережені.
    // Якщо у нас вже є workoutId, краще було б вантажити по ньому, але залишимо як є.
    List<WorkoutExercise> savedExercises = [];

    // Якщо передали ID, спробуємо знайти конкретне тренування (опціонально)
    // Якщо ні - використовуємо стару логіку getWorkout(date)
    savedExercises = await _firestore.getWorkout(widget.date);

    if (savedExercises.isNotEmpty) {
      _exercises = savedExercises;
    } else if (widget.exercises != null && widget.exercises!.isNotEmpty) {
      // 2. Якщо в базі пусто, але передали аргументи (редагування з HomePage)
      _exercises = List.from(widget.exercises!);
    } else {
      // 3. Якщо все пусто - перевіряємо план
      if (!widget.shouldAutoPick) {
        final plan = await _firestore.getWeeklyPlan();
        final weekdayKey = DateFormat.E('en').format(widget.date);
        final planned = plan[weekdayKey] ?? [];

        if (planned.isNotEmpty) {
          _exercises = planned
              .map(
                (idOrName) => WorkoutExercise(
                  name: idOrName,
                  exerciseId: idOrName,
                  sets: [SetData()],
                ),
              )
              .toList();
        } else {
          _exercises = [];
        }
      } else {
        _exercises = [];
      }
    }

    if (mounted) {
      _initControllers();
      setState(() {
        _isLoading = false;
      });
      if (widget.shouldAutoPick && _exercises.isEmpty) {
        // Невелика затримка, щоб UI встиг побудуватися
        Future.delayed(const Duration(milliseconds: 100), () {
          _addExercise();
        });
      }
    }
    _initialEncoded = jsonEncode(_exercises.map((e) => e.toMap()).toList());
  }

  void _initControllers() {
    _nameCtrls.clear();
    _weightCtrls.clear();
    _weightFocusNodes.clear();
    _repsCtrls.clear();

    for (var ex in _exercises) {
      _nameCtrls.add(TextEditingController(text: ex.name));
      final wList = <TextEditingController>[];
      final rList = <TextEditingController>[];
      final wfList = <FocusNode>[];
      final rfList = <FocusNode>[];

      for (var set in ex.sets) {
        final wCtrl = TextEditingController(text: formatDouble(set.weight));
        final rCtrl = TextEditingController(text: set.reps?.toString() ?? '');
        final wNode = FocusNode();
        final rNode = FocusNode();

        // Додаємо слухачів для виділення
        _addFocusListener(wNode, wCtrl);
        _addFocusListener(rNode, rCtrl);

        wList.add(wCtrl);
        rList.add(rCtrl);
        wfList.add(wNode);
        rfList.add(rNode);
      }

      _weightCtrls.add(wList);
      _repsCtrls.add(rList);
      _weightFocusNodes.add(wfList);
      _repsFocusNodes.add(rfList);
    }
  }

  String _getLocalizedName(WorkoutExercise exercise, AppLocalizations loc) {
    final catalog = getExerciseCatalog(loc);

    if (exercise.exerciseId != null && exercise.exerciseId!.isNotEmpty) {
      final foundById = catalog.firstWhere(
        (e) => e.id == exercise.exerciseId,
        orElse: () => ExerciseInfo(id: '', name: '', icon: Icons.error),
      );
      if (foundById.name.isNotEmpty) return foundById.name;
    }

    final foundByName = catalog.firstWhere(
      (e) => e.id == exercise.name,
      orElse: () => ExerciseInfo(id: '', name: '', icon: Icons.error),
    );
    if (foundByName.name.isNotEmpty) return foundByName.name;

    return exercise.name;
  }

  Future<void> _saveExercises() async {
    // 1. Валідація та збір даних
    for (var i = 0; i < _exercises.length; i++) {
      _exercises[i].name = _nameCtrls[i].text;
      for (var j = 0; j < _exercises[i].sets.length; j++) {
        final weightText = _weightCtrls[i][j].text.replaceAll(',', '.');
        final repsText = _repsCtrls[i][j].text;
        _exercises[i].sets[j].weight = double.tryParse(weightText);
        _exercises[i].sets[j].reps = int.tryParse(repsText);
      }
    }

    // 2. Генерація ID
    final String idToSave = widget.date.toIso8601String().split('T').first;

    final workout = WorkoutModel(
      id: idToSave,
      date: widget.date,
      exercises: _exercises,
    );

    try {
      // 3. Збереження
      // await
      _firestore.saveWorkout(workout);

      if (mounted) {
        // Оновлюємо початковий стан для відстеження змін
        setState(() {
          _initialEncoded = jsonEncode(
            _exercises.map((e) => e.toMap()).toList(),
          );
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Тренування збережено!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Помилка збереження: $e')));
      }
    }
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

  Future<void> _addExercise() async {
    final selected = await showExercisePicker(context);
    if (selected == null) return;

    String name = selected.name;
    String? id = selected.id;

    if (selected.id == '__custom__') {
      name = '';
      id = null;
    }

    setState(() {
      _exercises.add(
        WorkoutExercise(name: name, exerciseId: id, sets: [SetData()]),
      );

      _nameCtrls.add(TextEditingController(text: name));

      final wCtrl = TextEditingController();
      final rCtrl = TextEditingController();
      final wNode = FocusNode();
      final rNode = FocusNode();

      _addFocusListener(wNode, wCtrl);
      _addFocusListener(rNode, rCtrl);

      _weightCtrls.add([wCtrl]);
      _repsCtrls.add([rCtrl]);
      _weightFocusNodes.add([wNode]);
      _repsFocusNodes.add([rNode]);

      Future.delayed(const Duration(milliseconds: 100), () {
        wNode.requestFocus();
      });
    });
  }

  void _addSet(int exIndex) {
    setState(() {
      final lastSet = _exercises[exIndex].sets.isNotEmpty
          ? _exercises[exIndex].sets.last
          : null;

      _exercises[exIndex].sets.add(
        SetData(weight: lastSet?.weight, reps: lastSet?.reps),
      );

      final weightCtrl = TextEditingController(
        text: formatDouble(lastSet?.weight),
      );
      final repsCtrl = TextEditingController(
        text: lastSet?.reps?.toString() ?? '',
      );

      final wNode = FocusNode();
      final rNode = FocusNode();
      _addFocusListener(wNode, weightCtrl);
      _addFocusListener(rNode, repsCtrl);

      weightCtrl.selection = TextSelection(
        baseOffset: 0,
        extentOffset: weightCtrl.text.length,
      );

      _weightCtrls[exIndex].add(weightCtrl);
      _repsCtrls[exIndex].add(repsCtrl);
      _weightFocusNodes[exIndex].add(wNode);
      _repsFocusNodes[exIndex].add(rNode);

      Future.delayed(const Duration(milliseconds: 50), () {
        wNode.requestFocus();
      });
    });
  }

  void _removeSet(int exIndex, int setIndex) {
    setState(() {
      _exercises[exIndex].sets.removeAt(setIndex);
      _weightCtrls[exIndex].removeAt(setIndex);
      _repsCtrls[exIndex].removeAt(setIndex);
      _weightFocusNodes[exIndex].removeAt(setIndex).dispose();
      _repsFocusNodes[exIndex].removeAt(setIndex).dispose();
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
      _nameCtrls.removeAt(index).dispose();
      for (var c in _weightCtrls[index]) {
        c.dispose();
      }
      for (var c in _repsCtrls[index]) {
        c.dispose();
      }
      for (var f in _weightFocusNodes[index]) {
        f.dispose();
      }
      for (var f in _repsFocusNodes[index]) {
        f.dispose();
      }
      _weightCtrls.removeAt(index);
      _repsCtrls.removeAt(index);
      _weightFocusNodes.removeAt(index);
      _repsFocusNodes.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var c in _nameCtrls) {
      c.dispose();
    }
    for (var list in _weightCtrls)
      // ignore: curly_braces_in_flow_control_structures
      for (var c in list) {
        c.dispose();
      }
    for (var list in _repsCtrls)
      // ignore: curly_braces_in_flow_control_structures
      for (var c in list) {
        c.dispose();
      }
    for (var list in _weightFocusNodes)
      // ignore: curly_braces_in_flow_control_structures
      for (var f in list) {
        f.dispose();
      }
    for (var list in _repsFocusNodes)
      // ignore: curly_braces_in_flow_control_structures
      for (var f in list) {
        f.dispose();
      }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final loc = AppLocalizations.of(context)!;

    // Оновлення назв при локалізації
    for (int i = 0; i < _exercises.length; i++) {
      final exercise = _exercises[i];
      final localizedName = _getLocalizedName(exercise, loc);

      if (exercise.exerciseId != null &&
          exercise.exerciseId!.isNotEmpty &&
          _nameCtrls[i].text != localizedName) {
        final selection = _nameCtrls[i].selection;
        _nameCtrls[i].text = localizedName;
        if (selection.start >= 0 && selection.end <= localizedName.length) {
          _nameCtrls[i].selection = selection;
        }
      } else if (exercise.exerciseId == null &&
          _nameCtrls[i].text == exercise.name) {
        final catalog = getExerciseCatalog(loc);
        final isStandard = catalog.any((e) => e.id == exercise.name);
        if (isStandard) {
          _nameCtrls[i].text = localizedName;
        }
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final allow = await WillPopSavePrompt(
          hasUnsavedChanges: () async => _hasUnsavedChanges(),
          onSave: () async {
            await _saveExercises();
            // Тут widget.onSave не обов'язковий, бо ми вже зберегли в БД
          },
        ).handlePop(context);

        if (allow && context.mounted) {
          Navigator.pop(context, result);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${loc.workoutTitle} ${widget.date.toLocal().toIso8601String().split('T').first}",
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: loc.save,
              onPressed: () async {
                await _saveExercises();
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
          itemCount: _exercises.length,
          itemBuilder: (context, i) {
            final exercise = _exercises[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                        final loc = AppLocalizations.of(context)!;
                        final catalog = getExerciseCatalog(loc);

                        var found = catalog.firstWhere(
                          (e) => e.id == nameOrId,
                          orElse: () =>
                              ExerciseInfo(id: '', name: '', icon: Icons.code),
                        );
                        if (found.id.isEmpty) {
                          found = catalog.firstWhere(
                            (e) => e.name == nameOrId,
                            orElse: () => ExerciseInfo(
                              id: 'none',
                              name: nameOrId, // fallback name
                              icon: Icons.fitness_center,
                            ),
                          );
                        }

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
                    const Divider(),
                    ExerciseSetsList(
                      exercise: exercise,
                      weightControllers: _weightCtrls[i],
                      repsControllers: _repsCtrls[i],
                      onAddSet: () => _addSet(i),
                      weightFocusNodes: _weightFocusNodes[i],
                      repsFocusNodes: _repsFocusNodes[i],
                      onRemoveSet: (setIndex) => _removeSet(i, setIndex),
                      formatDouble: formatDouble,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addExercise,
          tooltip: loc.addExerciseTooltip,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
