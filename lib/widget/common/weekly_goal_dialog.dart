import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class WeeklyGoalDialog extends StatefulWidget {
  final int initialGoal;
  const WeeklyGoalDialog({super.key, required this.initialGoal});

  @override
  State<WeeklyGoalDialog> createState() => _WeeklyGoalDialogState();
}

class _WeeklyGoalDialogState extends State<WeeklyGoalDialog> {
  late int _goal;

  @override
  void initState() {
    super.initState();
    _goal = widget.initialGoal;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(loc.weeklyGoalTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(loc.weeklyGoalQuestion),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _goal > 1 ? () => setState(() => _goal--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '$_goal',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _goal < 7 ? () => setState(() => _goal++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Text(loc.timesPerWeek, style: const TextStyle(color: Colors.grey)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _goal),
          child: Text(loc.save),
        ),
      ],
    );
  }
}
