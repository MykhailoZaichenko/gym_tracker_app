import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

/// Уніфікований віджет для відображення діалогового вікна з підтвердженням.
/// Повертає майбутній [bool], що вказує, чи було натиснуто "Так" (true).
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
}) {
  final loc = AppLocalizations.of(context)!;
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        // Кнопка скасування (Ні)
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelText ?? loc.no),
        ),
        // Кнопка підтвердження (Так)
        TextButton(
          // Можемо надати їй виділення, якщо це кнопка "Так"
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmText ?? loc.yes),
        ),
      ],
    ),
  );
}
