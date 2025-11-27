import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:gym_tracker_app/features/workout/pages/workout_plan_editor_page.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class PlanProposalDialog extends StatelessWidget {
  const PlanProposalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = ThemeService.isDarkModeNotifier.value;

    // Використовуємо Stack і BackdropFilter для ефекту розмиття на весь екран
    return Stack(
      children: [
        // 1. Розмиття фону
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3), // Легке затемнення
            ),
          ),
        ),
        // 2. Саме діалогове вікно по центру
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Картинка або іконка
                // Якщо є картинка: Image.asset('assets/images/plan_illustration.png', height: 120),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    size: 60,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),

                // Заголовок
                Text(
                  loc.proposalTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Опис
                Text(
                  loc.proposalSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Кнопка "Перейти до плану"
                PrimaryFilledButton(
                  text: loc.goToPlan,
                  onPressed: () {
                    // Закриваємо діалог
                    Navigator.of(context).pop();
                    // Переходимо до редактора
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const WorkoutPlanEditorPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Кнопка "Можливо пізніше"
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    loc.maybeLater,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Функція для виклику діалогу
Future<void> showPlanProposal(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false, // Змушуємо юзера натиснути одну з кнопок
    barrierColor:
        Colors.transparent, // Прозорий, бо ми самі робимо BackdropFilter
    builder: (context) => const PlanProposalDialog(),
  );
}
