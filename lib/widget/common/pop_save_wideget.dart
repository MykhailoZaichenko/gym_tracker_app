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
    if (!await hasUnsavedChanges()) return true;
    final loc = AppLocalizations.of(context)!;

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
            child: Text(loc.discard),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ExitChoice.save),
            child: Text(loc.save),
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
