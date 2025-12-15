import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class WillPopSavePrompt extends StatelessWidget {
  final Future<bool> Function() hasUnsavedChanges;
  final Future<void> Function() onSave;

  const WillPopSavePrompt({
    super.key,
    required this.hasUnsavedChanges,
    required this.onSave,
  });

  Future<bool> handlePop(BuildContext context) async {
    // 1. Перевіряємо, чи є зміни
    final hasChanges = await hasUnsavedChanges();
    if (!hasChanges) return true; // Можна виходити

    if (!context.mounted) return false;
    final loc = AppLocalizations.of(context)!;

    // 2. Показуємо діалог
    final result = await showDialog<ExitChoice>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.saveChangesTitle),
        content: Text(loc.unsavedChangesMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.cancel),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.discard),
            child: Text(loc.discard), // "Не зберігати"
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.save),
            child: Text(loc.save),
          ),
        ],
      ),
    );

    // 3. Обробляємо результат
    if (result == null || result == ExitChoice.cancel) {
      return false; // Залишаємось на сторінці
    }

    if (result == ExitChoice.discard) {
      return true; // Виходимо без збереження
    }

    if (result == ExitChoice.save) {
      await onSave(); // Зберігаємо
      return true; // Виходимо
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Блокуємо автоматичний вихід
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Викликаємо нашу логіку
        final shouldPop = await handlePop(context);

        if (shouldPop && context.mounted) {
          // Якщо дозволено вихід -> закриваємо екран вручну
          Navigator.of(context).pop(result);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
