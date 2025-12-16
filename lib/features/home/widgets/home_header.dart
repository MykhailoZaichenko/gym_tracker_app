import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onOpenPlanEditor;

  const HomeHeader({super.key, required this.onOpenPlanEditor});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(loc.calendarTitle),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white70),
              backgroundColor: ThemeService.isDarkModeNotifier.value
                  ? Colors.deepPurple.withValues(alpha: 0.15)
                  : Theme.of(context).primaryColorDark,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            ),
            onPressed: onOpenPlanEditor,
            icon: const Icon(Icons.calendar_month, size: 18),
            label: Text(loc.myPlan, style: const TextStyle(fontSize: 13)),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
