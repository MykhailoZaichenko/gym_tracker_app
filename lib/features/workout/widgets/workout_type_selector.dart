import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

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

  // Єдиний список типів для всього додатку
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

  String _getLocalizedName(String key, AppLocalizations loc) {
    switch (key) {
      case 'push':
        return loc.splitPush;
      case 'pull':
        return loc.splitPull;
      case 'legs':
        return loc.splitLegs;
      case 'upper':
        return loc.splitUpper;
      case 'lower':
        return loc.splitLower;
      case 'full_body':
        return loc.splitFullBody;
      case 'cardio':
        return loc.splitCardio;
      case 'custom':
        return loc.splitCustom;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // ГОЛОВНИЙ ФІКС: Нормалізація
    // Перетворюємо вхідне значення в нижній регістр.
    // Якщо такого типу немає в списку validTypes -> ставимо 'custom'.
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
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).colorScheme.onSurface,
        ),
        // Колір випадаючого меню (щоб було видно на темному фоні)
        dropdownColor: Theme.of(context).cardColor,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: validTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(_getLocalizedName(value, loc)),
          );
        }).toList(),
      ),
    );
  }
}
