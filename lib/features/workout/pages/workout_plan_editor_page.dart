import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/widget/common/pop_save_wideget.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_picker_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPlanEditorPage extends StatefulWidget {
  const WorkoutPlanEditorPage({super.key});

  @override
  State<WorkoutPlanEditorPage> createState() => _WorkoutPlanEditorPageState();
}

class _WorkoutPlanEditorPageState extends State<WorkoutPlanEditorPage> {
  String? _initialEncoded;
  final Map<String, List<String>> _plan = {
    'Понеділок': [],
    'Вівторок': [],
    'Середа': [],
    'Четвер': [],
    'Пʼятниця': [],
    'Субота': [],
    'Неділя': [],
  };

  @override
  void initState() {
    super.initState();
    _loadPlan();
    _initialEncoded = jsonEncode(_plan);
  }

  Future<void> _loadPlan() async {
    final prefs = await SharedPreferences.getInstance();
    for (final day in _plan.keys) {
      final list = prefs.getStringList('plan_$day');
      if (list != null) {
        setState(() {
          _plan[day] = list;
        });
      }
    }
  }

  Future<void> _savePlan() async {
    final prefs = await SharedPreferences.getInstance();
    for (final day in _plan.keys) {
      await prefs.setStringList('plan_$day', _plan[day]!);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('План збережено')));
    _initialEncoded = jsonEncode(_plan);
  }

  Future<void> _addExercise(String day) async {
    final selected = await showExercisePicker(context);

    if (selected == null) return;

    final name = selected == ExerciseInfo.enterCustom
        ? await _askCustomExerciseName(day)
        : selected.name;

    if (name != null && name.isNotEmpty) {
      setState(() {
        _plan[day]!.add(name);
      });
    }
  }

  Future<String?> _askCustomExerciseName(String day) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Введіть назву вправи на $day'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Назва вправи'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }

  void _removeExercise(String day, int index) {
    setState(() {
      _plan[day]!.removeAt(index);
    });
  }

  bool _hasUnsavedChanges() {
    final current = jsonEncode(_plan);
    return _initialEncoded != current;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // block automatic pop, handle manually
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // run your save‑prompt logic
          final allow = await WillPopSavePrompt(
            hasUnsavedChanges: () async => _hasUnsavedChanges(),
            onSave: _savePlan,
          ).handlePop(context);

          if (allow && context.mounted) {
            Navigator.pop(context, result);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Редагування плану'),
          actions: [
            IconButton(
              onPressed: _savePlan,
              icon: const Icon(Icons.save),
              tooltip: 'Зберегти план',
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: _plan.keys.map((day) {
            final exercises = _plan[day]!;
            return ExpansionTile(
              title: Text(day),
              children: [
                ...exercises.asMap().entries.map((entry) {
                  final i = entry.key;
                  final ex = entry.value;
                  return ListTile(
                    title: Text(ex),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeExercise(day, i),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _addExercise(day),
                    icon: const Icon(Icons.add),
                    label: const Text('Додати вправу'),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
