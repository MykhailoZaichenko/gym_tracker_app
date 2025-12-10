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
    this.isLastSet = false,
    this.onRepsSubmitted,
  });

  final int index;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final VoidCallback onRemoveSetTile;
  final FocusNode? weightFocusNode;
  final FocusNode? repsFocusNode;
  final bool isLastSet;
  final VoidCallback? onRepsSubmitted;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 5),
              Text(
                loc.setNumber(index + 1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 35),
              Expanded(
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    if (value == 'delete') {
                      onRemoveSetTile();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(loc.deleteSet(index + 1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Вага
                SizedBox(
                  width: 50,
                  child: TextField(
                    focusNode: weightFocusNode,
                    textAlign: TextAlign.center,
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    scrollPadding: const EdgeInsets.only(bottom: 200),
                    decoration: InputDecoration(
                      hintText: loc.weightUnitHint,
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) {
                      repsFocusNode!.requestFocus();
                    },
                  ),
                ),
                const Text("/ ", style: TextStyle(color: Colors.grey)),
                // Повтори
                SizedBox(
                  width: 50,
                  child: TextField(
                    focusNode: repsFocusNode,
                    textAlign: TextAlign.center,
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    scrollPadding: const EdgeInsets.only(bottom: 200),
                    textInputAction: isLastSet
                        ? TextInputAction.done
                        : TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: loc.repsUnitHint,
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) {
                      // Викликаємо колбек для переходу на наступний сет
                      if (onRepsSubmitted != null) {
                        onRepsSubmitted!();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
