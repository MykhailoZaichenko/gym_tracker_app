import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';

class ExerciseSetTile extends StatelessWidget {
  const ExerciseSetTile({
    super.key,
    required this.index,
    required this.exerciseType,
    this.weightController,
    this.repsController,
    this.timeController,
    this.distanceController,
    required this.onRemoveSetTile,
    this.weightFocusNode,
    this.repsFocusNode,
    this.timeFocusNode,
    this.distanceFocusNode,
  });

  final int index;
  final ExerciseType exerciseType;
  final TextEditingController? weightController;
  final TextEditingController? repsController;
  final TextEditingController? timeController;
  final TextEditingController? distanceController;

  final VoidCallback onRemoveSetTile;
  final FocusNode? weightFocusNode;
  final FocusNode? repsFocusNode;
  final FocusNode? timeFocusNode;
  final FocusNode? distanceFocusNode;

  Widget _buildTextField(
    BuildContext context,
    TextEditingController? controller,
    FocusNode? focusNode,
    String hint,
    FocusNode? nextFocus,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: TextField(
          focusNode: focusNode,
          textAlign: TextAlign.center,
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: nextFocus != null
              ? TextInputAction.next
              : TextInputAction.done,
          style: textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodySmall,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          onSubmitted: (_) {
            nextFocus?.requestFocus();
          },
        ),
      ),
    );
  }

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
          SizedBox(
            width: 45,
            child: Text(loc.setNumber(index + 1), style: textTheme.labelLarge),
          ),
          const SizedBox(width: 8),

          if (exerciseType == ExerciseType.cardio) ...[
            _buildTextField(
              context,
              timeController,
              timeFocusNode,
              loc.cardioMin,
              distanceFocusNode,
            ),
            const SizedBox(width: 8),
            _buildTextField(
              context,
              distanceController,
              distanceFocusNode,
              loc.cardioKm,
              null,
            ),
          ] else ...[
            _buildTextField(
              context,
              weightController,
              weightFocusNode,
              exerciseType == ExerciseType.bodyweight
                  ? loc.bodyweightAddWeight
                  : loc.weightUnitHint,
              repsFocusNode,
            ),
            const SizedBox(width: 12),
            _buildTextField(
              context,
              repsController,
              repsFocusNode,
              loc.repsUnitHint,
              null,
            ),
          ],

          const SizedBox(width: 8),
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
