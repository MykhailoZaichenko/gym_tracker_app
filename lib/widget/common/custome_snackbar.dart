import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Кольори: Червоний для помилки, Primary (або Зелений) для успіху
    final backgroundColor = isError
        ? colorScheme.errorContainer
        : colorScheme.primaryContainer;

    final textColor = isError
        ? colorScheme.onErrorContainer
        : colorScheme.onPrimaryContainer;

    final icon = isError
        ? Icons.error_outline_rounded
        : Icons.check_circle_outline_rounded;

    // Очищаємо чергу повідомлень, щоб нове з'явилося миттєво
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // 🔥 ГОЛОВНЕ: робить плашку "плаваючою"
        behavior: SnackBarBehavior.floating,

        // 🔥 ВІДСТУПИ: піднімають плашку вгору, щоб не перекривати кнопки знизу
        margin: const EdgeInsets.only(
          bottom: 80, // Піднімаємо високо, щоб не закривати FAB
          left: 16,
          right: 16,
        ),

        elevation: 4,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Закруглені кути
        ),
        duration: const Duration(seconds: 2), // Трохи швидше зникає
      ),
    );
  }
}
