import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';

class WillPopSavePrompt extends StatelessWidget {
  final Future<bool> Function() hasUnsavedChanges;
  final Future<void> Function() onSave;

  const WillPopSavePrompt({
    super.key,
    required this.hasUnsavedChanges,
    required this.onSave,
  });

  Future<bool> handlePop(BuildContext context) async {
    if (!await hasUnsavedChanges()) return true;

    final result = await showDialog<ExitChoice>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Зберегти зміни?'),
        content: const Text('Є незбережені зміни. Зберегти перед виходом?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.cancel),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.discard),
            child: const Text('Не зберігати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.save),
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );

    if (result == ExitChoice.cancel || result == null) return false;
    if (result == ExitChoice.discard) return true;

    await onSave();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent automatic pop unless you allow it manually
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // your custom logic when back is pressed but route not yet popped
          handlePop(context);
        } else {
          // optional: you can inspect `result` if needed
          debugPrint('Route popped with result: $result');
        }
      },
      child: const SizedBox.shrink(), // Placeholder, не рендерить нічого
    );
  }
}
