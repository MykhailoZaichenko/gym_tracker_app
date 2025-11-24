import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/pop_save_wideget.dart';
import 'package:gym_tracker_app/features/workout/widgets/workout_picker_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPlanEditorPage extends StatefulWidget {
  const WorkoutPlanEditorPage({super.key});

  @override
  State<WorkoutPlanEditorPage> createState() => _WorkoutPlanEditorPageState();
}

class _WorkoutPlanEditorPageState extends State<WorkoutPlanEditorPage> {
  String? _initialEncoded;
  final List<String> _weekDaysKeys = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final Map<String, List<String>> _plan = {};

  @override
  void initState() {
    super.initState();
    for (var day in _weekDaysKeys) {
      _plan[day] = [];
    }

    _loadPlan();
  }

  String _getLocalizedDayName(String key, String locale) {
    final index = _weekDaysKeys.indexOf(key) + 1;
    final date = DateTime(2024, 1, 1).add(Duration(days: index - 1));

    final fullDayName = DateFormat.EEEE(locale).format(date);
    return toBeginningOfSentenceCase(fullDayName) ?? fullDayName;
  }

  Future<void> _loadPlan() async {
    final prefs = await SharedPreferences.getInstance();
    for (final dayKey in _weekDaysKeys) {
      final list = prefs.getStringList('plan_$dayKey');
      if (list != null) {
        _plan[dayKey] = list;
      }
    }
    if (mounted) {
      setState(() {
        _initialEncoded = jsonEncode(_plan);
      });
    }
  }

  Future<void> _savePlan() async {
    final loc = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    for (final day in _plan.keys) {
      await prefs.setStringList('plan_$day', _plan[day]!);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.planSavedSuccess)));
    setState(() {
      _initialEncoded = jsonEncode(_plan);
    });
  }

  Future<void> _addExercise(String dayKey) async {
    final loc = AppLocalizations.of(context)!;
    final selected = await showExercisePicker(context);

    if (selected == null) return;

    final nameOrId = selected == ExerciseInfo.getEnterCustom(loc)
        ? await _askCustomExerciseName(dayKey)
        : selected.id;

    if (nameOrId != null && nameOrId.isNotEmpty) {
      setState(() {
        _plan[dayKey]!.add(nameOrId);
      });
    }
  }

  Future<String?> _askCustomExerciseName(String dayKey) async {
    final loc = AppLocalizations.of(context)!;
    final locale = loc.localeName;
    final localizedDay = _getLocalizedDayName(dayKey, locale);

    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          '${loc.enterCustomExerciseName} ${loc.onDay(localizedDay)}',
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: loc.exerciseNameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(loc.addExercise),
          ),
        ],
      ),
    );
  }

  void _removeExercise(String dayKey, int index) {
    setState(() {
      _plan[dayKey]!.removeAt(index);
    });
  }

  bool _hasUnsavedChanges() {
    if (_initialEncoded == null) return false;
    final current = jsonEncode(_plan);
    return _initialEncoded != current;
  }

  String _getLocalizedNameByIdOrName(String key, List<ExerciseInfo> catalog) {
    final found = catalog.firstWhere(
      (e) => e.id == key,
      orElse: () =>
          ExerciseInfo(id: key, name: key, icon: Icons.fitness_center),
    );
    return found.name;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final locale = loc.localeName;
    final catalog = getExerciseCatalog(loc);

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
          title: Text(loc.editPlanTitle),
          actions: [
            IconButton(
              onPressed: _savePlan,
              icon: const Icon(Icons.save),
              tooltip: loc.savePlanTooltip,
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _weekDaysKeys.length,
          itemBuilder: (context, index) {
            final dayKey = _weekDaysKeys[index];
            final exercisesIDs = _plan[dayKey]!;
            final localizedDayName = _getLocalizedDayName(dayKey, locale);

            return ExpansionTile(
              title: Text(localizedDayName),
              children: [
                ...exercisesIDs.asMap().entries.map((entry) {
                  final i = entry.key;
                  final exIdOrName = entry.value;
                  final displayedName = _getLocalizedNameByIdOrName(
                    exIdOrName,
                    catalog,
                  );

                  return ListTile(
                    title: Text(displayedName),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeExercise(dayKey, i),
                      tooltip: loc.delete,
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _addExercise(dayKey),
                    icon: const Icon(Icons.add),
                    label: Text(loc.addExercise),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
