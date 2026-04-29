import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_type_selector.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/features/workout/workout_exports.dart';
import 'package:gym_tracker_app/utils/utils.dart';
import 'package:gym_tracker_app/utils/workout_utils.dart';
import 'package:gym_tracker_app/widget/common/custome_snackbar.dart';
import 'package:gym_tracker_app/widget/common/exercise_icon.dart';
import 'package:gym_tracker_app/widget/common/pop_save_wideget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPage extends StatefulWidget {
  final DateTime date;
  final String? workoutId;
  final List<WorkoutExercise>? exercises;
  final bool shouldAutoPick;
  final String workoutType;

  const WorkoutPage({
    super.key,
    required this.date,
    this.workoutId,
    this.exercises,
    this.shouldAutoPick = false,
    required this.workoutType,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late List<WorkoutExercise> _exercises = [];
  final FirestoreService _firestore = FirestoreService();

  late String _currentType;
  WorkoutModel? _lastMatchingWorkout;

  bool _isLoading = true;
  String? _initialEncoded;
  int _activeExerciseIndex = 0;

  final List<TextEditingController> _nameCtrls = [];
  final List<List<TextEditingController>> _weightCtrls = [];
  final List<List<TextEditingController>> _repsCtrls = [];
  final List<List<TextEditingController>> _timeCtrls = [];
  final List<List<TextEditingController>> _distanceCtrls = [];

  final List<List<FocusNode>> _weightFocusNodes = [];
  final List<List<FocusNode>> _repsFocusNodes = [];
  final List<List<FocusNode>> _timeFocusNodes = [];
  final List<List<FocusNode>> _distanceFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _currentType = widget.workoutType.toLowerCase().trim();

    if (!WorkoutTypeSelector.validTypes.contains(_currentType)) {
      _currentType = 'custom';
    }

    if (widget.exercises != null && widget.exercises!.isNotEmpty) {
      _exercises = List.from(widget.exercises!);
      _initControllers();
      _isLoading = false;
      _initialEncoded = _encodeCurrentState();
      _loadActiveIndex();
    } else {
      _loadPreviousSession();
    }
  }

  Future<void> _loadPreviousSession() async {
    try {
      final lastWorkout = await _firestore.getLastWorkoutByType(_currentType);

      if (mounted) {
        setState(() {
          _lastMatchingWorkout = lastWorkout;
          _exercises = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("History load error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
    _initialEncoded = _encodeCurrentState();
  }

  void _copyFromLastSession(AppLocalizations loc) {
    if (_lastMatchingWorkout == null) return;
    final catalog = getExerciseCatalog(loc);

    setState(() {
      _exercises = _lastMatchingWorkout!.exercises.map((e) {
        String localizedName = e.name;
        if (e.exerciseId != null && e.exerciseId!.isNotEmpty) {
          final found = catalog.firstWhere(
            (info) => info.id == e.exerciseId,
            orElse: () => ExerciseInfo(id: '', name: e.name, icon: Icons.error),
          );
          if (found.id.isNotEmpty) {
            localizedName = found.name;
          }
        }

        return e.copyWith(
          name: localizedName,
          sets: e.sets.map((s) => s.copyWith(isCompleted: false)).toList(),
        );
      }).toList();
      _lastMatchingWorkout = null;
      _activeExerciseIndex = 0;
    });

    _initControllers();

    if (_exercises.isNotEmpty) {
      _focusOnExercise(0);
    }
  }

  void _setActiveExercise(int index) {
    setState(() => _activeExerciseIndex = index);
    _saveActiveIndex(index);
    _focusOnExercise(index);
  }

  void _focusOnExercise(int index) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (index < _weightFocusNodes.length &&
          _weightFocusNodes[index].isNotEmpty) {
        _weightFocusNodes[index][0].requestFocus();
      } else if (index < _timeFocusNodes.length &&
          _timeFocusNodes[index].isNotEmpty) {
        _timeFocusNodes[index][0].requestFocus();
      }
    });
  }

  Future<void> _loadActiveIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('active_index_$_currentType') ?? 0;

    if (mounted && savedIndex < _exercises.length) {
      setState(() {
        _activeExerciseIndex = savedIndex;
      });
      _focusOnExercise(savedIndex);
    }
  }

  Future<void> _saveActiveIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('active_index_$_currentType', index);
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
      _addControllersForNewExercise(name);
      _activeExerciseIndex = _exercises.length - 1;
    });

    _focusOnExercise(_activeExerciseIndex);
  }

  void _addControllersForNewExercise(String name) {
    _nameCtrls.add(TextEditingController(text: name));

    final wCtrl = TextEditingController();
    final rCtrl = TextEditingController();
    final tCtrl = TextEditingController();
    final dCtrl = TextEditingController();

    final wNode = FocusNode();
    final rNode = FocusNode();
    final tNode = FocusNode();
    final dNode = FocusNode();

    _addFocusListener(wNode, wCtrl);
    _addFocusListener(rNode, rCtrl);
    _addFocusListener(tNode, tCtrl);
    _addFocusListener(dNode, dCtrl);

    _weightCtrls.add([wCtrl]);
    _repsCtrls.add([rCtrl]);
    _timeCtrls.add([tCtrl]);
    _distanceCtrls.add([dCtrl]);

    _weightFocusNodes.add([wNode]);
    _repsFocusNodes.add([rNode]);
    _timeFocusNodes.add([tNode]);
    _distanceFocusNodes.add([dNode]);
  }

  void _addSet(int exIndex) {
    setState(() {
      final lastSet = _exercises[exIndex].sets.isNotEmpty
          ? _exercises[exIndex].sets.last
          : null;
      _exercises[exIndex].sets.add(
        SetData(
          weight: lastSet?.weight,
          reps: lastSet?.reps,
          timeInMinutes: lastSet?.timeInMinutes,
          distance: lastSet?.distance,
        ),
      );

      final weightCtrl = TextEditingController(
        text: formatDouble(lastSet?.weight),
      );
      final repsCtrl = TextEditingController(text: formatDouble(lastSet?.reps));
      final timeCtrl = TextEditingController(
        text: formatDouble(lastSet?.timeInMinutes),
      );
      final distanceCtrl = TextEditingController(
        text: formatDouble(lastSet?.distance),
      );

      final wNode = FocusNode();
      final rNode = FocusNode();
      final tNode = FocusNode();
      final dNode = FocusNode();

      _addFocusListener(wNode, weightCtrl);
      _addFocusListener(rNode, repsCtrl);
      _addFocusListener(tNode, timeCtrl);
      _addFocusListener(dNode, distanceCtrl);

      _weightCtrls[exIndex].add(weightCtrl);
      _repsCtrls[exIndex].add(repsCtrl);
      _timeCtrls[exIndex].add(timeCtrl);
      _distanceCtrls[exIndex].add(distanceCtrl);

      _weightFocusNodes[exIndex].add(wNode);
      _repsFocusNodes[exIndex].add(rNode);
      _timeFocusNodes[exIndex].add(tNode);
      _distanceFocusNodes[exIndex].add(dNode);
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      final newSetIndex = _weightFocusNodes[exIndex].length - 1;

      if (_weightFocusNodes[exIndex][newSetIndex].canRequestFocus) {
        _weightFocusNodes[exIndex][newSetIndex].requestFocus();
      } else if (_timeFocusNodes[exIndex][newSetIndex].canRequestFocus) {
        _timeFocusNodes[exIndex][newSetIndex].requestFocus();
      }
    });
  }

  void _removeSet(int exIndex, int setIndex) {
    setState(() {
      _exercises[exIndex].sets.removeAt(setIndex);
      _weightCtrls[exIndex].removeAt(setIndex).dispose();
      _repsCtrls[exIndex].removeAt(setIndex).dispose();
      _timeCtrls[exIndex].removeAt(setIndex).dispose();
      _distanceCtrls[exIndex].removeAt(setIndex).dispose();

      _weightFocusNodes[exIndex].removeAt(setIndex).dispose();
      _repsFocusNodes[exIndex].removeAt(setIndex).dispose();
      _timeFocusNodes[exIndex].removeAt(setIndex).dispose();
      _distanceFocusNodes[exIndex].removeAt(setIndex).dispose();
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
      for (var c in _timeCtrls[index]) {
        c.dispose();
      }
      for (var c in _distanceCtrls[index]) {
        c.dispose();
      }

      for (var f in _weightFocusNodes[index]) {
        f.dispose();
      }
      for (var f in _repsFocusNodes[index]) {
        f.dispose();
      }
      for (var f in _timeFocusNodes[index]) {
        f.dispose();
      }
      for (var f in _distanceFocusNodes[index]) {
        f.dispose();
      }

      _weightCtrls.removeAt(index);
      _repsCtrls.removeAt(index);
      _timeCtrls.removeAt(index);
      _distanceCtrls.removeAt(index);

      _weightFocusNodes.removeAt(index);
      _repsFocusNodes.removeAt(index);
      _timeFocusNodes.removeAt(index);
      _distanceFocusNodes.removeAt(index);

      if (_activeExerciseIndex >= _exercises.length) {
        _activeExerciseIndex = _exercises.isNotEmpty
            ? _exercises.length - 1
            : 0;
      }
    });
  }

  void _initControllers() {
    for (var c in _nameCtrls) {
      c.dispose();
    }
    for (var l in _weightCtrls) {
      for (var c in l) {
        c.dispose();
      }
    }
    for (var l in _repsCtrls) {
      for (var c in l) {
        c.dispose();
      }
    }
    for (var l in _timeCtrls) {
      for (var c in l) {
        c.dispose();
      }
    }
    for (var l in _distanceCtrls) {
      for (var c in l) {
        c.dispose();
      }
    }

    _nameCtrls.clear();
    _weightCtrls.clear();
    _repsCtrls.clear();
    _timeCtrls.clear();
    _distanceCtrls.clear();

    _weightFocusNodes.clear();
    _repsFocusNodes.clear();
    _timeFocusNodes.clear();
    _distanceFocusNodes.clear();

    for (var ex in _exercises) {
      _nameCtrls.add(TextEditingController(text: ex.name));
      final wList = <TextEditingController>[];
      final rList = <TextEditingController>[];
      final tList = <TextEditingController>[];
      final dList = <TextEditingController>[];

      final wfList = <FocusNode>[];
      final rfList = <FocusNode>[];
      final tfList = <FocusNode>[];
      final dfList = <FocusNode>[];

      for (var set in ex.sets) {
        final wCtrl = TextEditingController(text: formatDouble(set.weight));
        final rCtrl = TextEditingController(text: formatDouble(set.reps));
        final tCtrl = TextEditingController(
          text: formatDouble(set.timeInMinutes),
        );
        final dCtrl = TextEditingController(text: formatDouble(set.distance));

        final wNode = FocusNode();
        final rNode = FocusNode();
        final tNode = FocusNode();
        final dNode = FocusNode();

        _addFocusListener(wNode, wCtrl);
        _addFocusListener(rNode, rCtrl);
        _addFocusListener(tNode, tCtrl);
        _addFocusListener(dNode, dCtrl);

        wList.add(wCtrl);
        rList.add(rCtrl);
        tList.add(tCtrl);
        dList.add(dCtrl);

        wfList.add(wNode);
        rfList.add(rNode);
        tfList.add(tNode);
        dfList.add(dNode);
      }
      _weightCtrls.add(wList);
      _repsCtrls.add(rList);
      _timeCtrls.add(tList);
      _distanceCtrls.add(dList);

      _weightFocusNodes.add(wfList);
      _repsFocusNodes.add(rfList);
      _timeFocusNodes.add(tfList);
      _distanceFocusNodes.add(dfList);
    }
  }

  void _addFocusListener(FocusNode node, TextEditingController controller) {
    node.addListener(() {
      if (node.hasFocus) {
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

  String _encodeCurrentState() {
    final List<Map<String, dynamic>> state = [];
    for (int i = 0; i < _exercises.length; i++) {
      final ex = _exercises[i];
      final sets = <Map<String, dynamic>>[];
      for (int j = 0; j < ex.sets.length; j++) {
        String wText = '';
        String rText = '';
        String tText = '';
        String dText = '';

        if (i < _weightCtrls.length && j < _weightCtrls[i].length) {
          wText = _weightCtrls[i][j].text;
          rText = _repsCtrls[i][j].text;
          tText = _timeCtrls[i][j].text;
          dText = _distanceCtrls[i][j].text;
        }
        sets.add({
          'weight': double.tryParse(wText.replaceAll(',', '.')),
          'reps': double.tryParse(rText.replaceAll(',', '.')),
          'timeInMinutes': double.tryParse(tText.replaceAll(',', '.')),
          'distance': double.tryParse(dText.replaceAll(',', '.')),
          'isCompleted': ex.sets[j].isCompleted,
        });
      }
      state.add({
        'name': (i < _nameCtrls.length) ? _nameCtrls[i].text : ex.name,
        'exerciseId': ex.exerciseId,
        'sets': sets,
      });
    }
    return jsonEncode(state);
  }

  bool _hasUnsavedChanges() {
    return _initialEncoded != _encodeCurrentState();
  }

  Future<void> _saveExercises() async {
    for (var i = 0; i < _exercises.length; i++) {
      _exercises[i].name = _nameCtrls[i].text;
      for (var j = 0; j < _exercises[i].sets.length; j++) {
        _exercises[i].sets[j].weight = double.tryParse(
          _weightCtrls[i][j].text.replaceAll(',', '.'),
        );
        _exercises[i].sets[j].reps = double.tryParse(
          _repsCtrls[i][j].text.replaceAll(',', '.'),
        );
        _exercises[i].sets[j].timeInMinutes = double.tryParse(
          _timeCtrls[i][j].text.replaceAll(',', '.'),
        );
        _exercises[i].sets[j].distance = double.tryParse(
          _distanceCtrls[i][j].text.replaceAll(',', '.'),
        );
      }
    }
    final String idToSave = widget.date.toIso8601String().split('T').first;
    final workout = WorkoutModel(
      id: idToSave,
      date: widget.date,
      exercises: _exercises,
      type: _currentType,
    );
    try {
      await _firestore.saveWorkout(workout);
      if (mounted) {
        setState(() {
          _initialEncoded = _encodeCurrentState();
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          context,
          message: "Error saving workout: $e",
          isError: true,
        );
      }
    }
  }

  @override
  void dispose() {
    for (var c in _nameCtrls) {
      c.dispose();
    }
    for (var l in _weightCtrls) {
      for (var c in l) {
        c.dispose();
      }
    }
    for (var l in _repsCtrls) {
      for (var c in l) {
        c.dispose();
      }
    }
    for (var l in _timeCtrls) {
      for (var c in l) {
        c.dispose();
      }
    }
    for (var l in _distanceCtrls) {
      for (var c in l) {
        c.dispose();
      }
    }

    for (var l in _weightFocusNodes) {
      for (var f in l) {
        f.dispose();
      }
    }
    for (var l in _repsFocusNodes) {
      for (var f in l) {
        f.dispose();
      }
    }
    for (var l in _timeFocusNodes) {
      for (var f in l) {
        f.dispose();
      }
    }
    for (var l in _distanceFocusNodes) {
      for (var f in l) {
        f.dispose();
      }
    }
    super.dispose();
  }

  Widget _buildCompactCard(int index, AppLocalizations loc) {
    final exercise = _exercises[index];
    final titleText = exercise.name.isEmpty
        ? loc.exerciseDefaultName
        : exercise.name;
    final catalog = getExerciseCatalog(loc);
    ExerciseInfo? info;
    try {
      if (exercise.exerciseId != null) {
        info = catalog.firstWhere((e) => e.id == exercise.exerciseId);
      } else {
        info = catalog.firstWhere((e) => e.name == exercise.name);
      }
    } catch (_) {}

    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _setActiveExercise(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                child: info != null
                    ? ExerciseIcon(
                        exercise: info,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : Icon(
                        Icons.fitness_center,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  titleText,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Text(
                loc.setsCount(exercise.sets.length),
                style: textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedCard(int index, AppLocalizations loc) {
    final exercise = _exercises[index];
    final catalog = getExerciseCatalog(loc);

    ExerciseType exType = ExerciseType.strength;
    try {
      if (exercise.exerciseId != null) {
        exType = catalog.firstWhere((e) => e.id == exercise.exerciseId).type;
      } else {
        exType = catalog.firstWhere((e) => e.name == exercise.name).type;
      }
    } catch (_) {}

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExerciseHeader(
              exercise: exercise,
              nameController: _nameCtrls[index],
              onPickExercise: (ctx, {initialQuery}) async {
                final selected = await showExercisePicker(
                  ctx,
                  initialQuery: initialQuery,
                );
                if (selected != null) {
                  setState(() {
                    _exercises[index].name = selected.name;
                    _exercises[index].exerciseId = selected.id == '__custom__'
                        ? null
                        : selected.id;
                    _nameCtrls[index].text = selected.name;
                  });
                }
                return null;
              },
              onRemoveExercise: () => _removeExercise(index),
              buildIconForName: (nameOrId) {
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
                      name: nameOrId,
                      icon: Icons.fitness_center,
                    ),
                  );
                }
                final color = nameOrId.isEmpty
                    ? Colors.grey.shade300
                    : Theme.of(context).colorScheme.primary;
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: ExerciseIcon(exercise: found, size: 24, color: color),
                );
              },
            ),
            const Divider(),
            ExerciseSetsList(
              exercise: exercise,
              exerciseType: exType,
              weightControllers: _weightCtrls[index],
              repsControllers: _repsCtrls[index],
              timeControllers: _timeCtrls[index],
              distanceControllers: _distanceCtrls[index],
              weightFocusNodes: _weightFocusNodes[index],
              repsFocusNodes: _repsFocusNodes[index],
              timeFocusNodes: _timeFocusNodes[index],
              distanceFocusNodes: _distanceFocusNodes[index],
              onAddSet: () => _addSet(index),
              onRemoveSet: (setIndex) => _removeSet(index, setIndex),
              formatDouble: formatDouble,
            ),
            if (index < _exercises.length - 1)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () => _setActiveExercise(index + 1),
                    icon: const Icon(Icons.arrow_downward, size: 16),
                    label: Text(loc.nextExercise),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final allow = await WillPopSavePrompt(
          hasUnsavedChanges: () async => _hasUnsavedChanges(),
          onSave: _saveExercises,
        ).handlePop(context);
        if (allow && context.mounted) Navigator.pop(context, result);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              WorkoutTypeSelector(
                currentType: _currentType,
                onChanged: (newValue) {
                  setState(() {
                    _currentType = newValue;
                    if (_exercises.isEmpty) _loadPreviousSession();
                  });
                },
              ),
              Text(
                DateFormat.MMMMEEEEd(loc.localeName).format(widget.date),
                style: textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                await _saveExercises();
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
          children: [
            if (_exercises.isEmpty && _lastMatchingWorkout != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () => _copyFromLastSession(loc),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.content_copy,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            loc.copyPreviousWorkout(
                              WorkoutUtils.getLocalizedType(_currentType, loc),
                            ),
                            style: textTheme.labelLarge?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ...List.generate(_exercises.length, (i) {
              final isActive = i == _activeExerciseIndex;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    SizeTransition(sizeFactor: animation, child: child),
                child: isActive
                    ? SizedBox(
                        key: ValueKey('expanded_$i'),
                        child: _buildExpandedCard(i, loc),
                      )
                    : SizedBox(
                        key: ValueKey('compact_$i'),
                        child: _buildCompactCard(i, loc),
                      ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addExercise,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
