import 'package:flutter/material.dart';

class ExerciseSetTile extends StatelessWidget {
  const ExerciseSetTile({
    super.key,
    required this.index,
    required this.weightController,
    required this.repsController,
    required this.onRemoveSetTile,
  });

  final int index;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final VoidCallback onRemoveSetTile;

  @override
  Widget build(BuildContext context) {
    final weightFocus = FocusNode();
    final repsFocus = FocusNode();

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
                "Підхід ${index + 1}",
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
                      child: Text('Видалити підхід ${index + 1}'),
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
                    focusNode: weightFocus,
                    textAlign: TextAlign.center,
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Кг',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(repsFocus);
                    },
                  ),
                ),
                const Text("/ ", style: TextStyle(color: Colors.grey)),
                // Повтори
                SizedBox(
                  width: 50,
                  child: TextField(
                    focusNode: repsFocus,
                    textAlign: TextAlign.center,
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'Повт',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) {
                      repsFocus.unfocus();
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
