import 'package:flutter/material.dart';

/// Уніфікований віджет для відображення діалогового вікна з підтвердженням.
/// Повертає майбутній [bool], що вказує, чи було натиснуто "Так" (true).
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Так',
  String cancelText = 'Ні',
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        // Кнопка скасування (Ні)
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelText),
        ),
        // Кнопка підтвердження (Так)
        TextButton(
          // Можемо надати їй виділення, якщо це кнопка "Так"
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
