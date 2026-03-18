import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class ExerciseSetTile extends StatelessWidget {
  const ExerciseSetTile({
    super.key,
    required this.index,
    required this.weightController,
    required this.repsController,
    required this.onRemoveSetTile,
    required this.weightFocusNode,
    required this.repsFocusNode,
  });

  final int index;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final VoidCallback onRemoveSetTile;
  final FocusNode? weightFocusNode;
  final FocusNode? repsFocusNode;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Номер підходу
          SizedBox(
            width: 45,
            child: Text(
              loc.setNumber(index + 1),
              style: textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 8),

          // Поле для ваги
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: TextField(
                focusNode: weightFocusNode,
                textAlign: TextAlign.center,
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: loc.weightUnitHint,
                  hintStyle: textTheme.bodySmall,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) {
                  repsFocusNode!.requestFocus();
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Поле для повторень
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: TextField(
                focusNode: repsFocusNode,
                textAlign: TextAlign.center,
                controller: repsController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: loc.repsUnitHint,
                  hintStyle: textTheme.bodySmall,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Кнопка видалення
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            onPressed: onRemoveSetTile,
            tooltip: loc.deleteSet(index + 1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
