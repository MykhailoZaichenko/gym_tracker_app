import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class WorkoutTypeSelectionSheet extends StatelessWidget {
  final Function(String) onTypeSelected;
  const WorkoutTypeSelectionSheet({super.key, required this.onTypeSelected});

  static void show(BuildContext context, Function(String) onTypeSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true, // Важливо для кнопок навігації
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          WorkoutTypeSelectionSheet(onTypeSelected: onTypeSelected),
    );
  }

  static const List<String> types = [
    'push',
    'pull',
    'legs',
    'upper',
    'lower',
    'full_body',
    'cardio',
    'custom',
  ];

  static String getLocalizedTemplateName(String key, AppLocalizations loc) {
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
        return key.toUpperCase();
    }
  }

  Icon _getIconForType(String key) {
    switch (key) {
      case 'push':
        return const Icon(Icons.arrow_upward);
      case 'pull':
        return const Icon(Icons.arrow_downward);
      case 'legs':
        return const Icon(Icons.directions_walk);
      case 'cardio':
        return const Icon(Icons.favorite);
      case 'custom':
        return const Icon(Icons.edit_note);
      default:
        return const Icon(Icons.fitness_center);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.selectWorkoutType,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Використовуємо GridView для компактності
            GridView.builder(
              shrinkWrap: true, // Стискає грід по висоті контенту
              physics:
                  const NeverScrollableScrollPhysics(), // Вимикаємо скрол гріда (скролить шторка)
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 стовпчики
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio:
                    3, // Співвідношення сторін плитки (ширина/висота)
              ),
              itemCount: types.length,
              itemBuilder: (context, index) {
                final type = types[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onTypeSelected(type);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).dividerColor.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        _getIconForType(type),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            getLocalizedTemplateName(type, loc),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
