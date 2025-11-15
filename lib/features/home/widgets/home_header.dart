import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onOpenAnalytics;
  final VoidCallback onOpenPlanEditor;

  const HomeHeader({
    super.key,
    required this.onOpenAnalytics,
    required this.onOpenPlanEditor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Календар тренувань'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.bar_chart_outlined),
          tooltip: 'Прогрес',
          onPressed: onOpenAnalytics,
        ),
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
            label: const Text('Мій план', style: TextStyle(fontSize: 13)),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
