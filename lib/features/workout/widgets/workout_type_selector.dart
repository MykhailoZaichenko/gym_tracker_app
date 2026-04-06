import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/utils/workout_utils.dart';

class WorkoutTypeSelector extends StatelessWidget {
  final String currentType;
  final ValueChanged<String> onChanged;
  final Color? color;

  const WorkoutTypeSelector({
    super.key,
    required this.currentType,
    required this.onChanged,
    this.color,
  });

  static const List<String> validTypes = [
    'push',
    'pull',
    'legs',
    'upper',
    'lower',
    'full_body',
    'cardio',
    'custom',
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final normalizedType = currentType.toLowerCase().trim();
    final String safeValue = validTypes.contains(normalizedType)
        ? normalizedType
        : 'custom';

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: safeValue,
        isDense: true,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 20,
          color: color ?? Theme.of(context).colorScheme.onSurface,
        ),
        style: textTheme.titleLarge?.copyWith(
          color: color ?? Theme.of(context).colorScheme.onSurface,
        ),
        dropdownColor: Theme.of(context).cardColor,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: validTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: Alignment.centerLeft,
            child: Text(WorkoutUtils.getLocalizedType(value, loc)),
          );
        }).toList(),
      ),
    );
  }
}
