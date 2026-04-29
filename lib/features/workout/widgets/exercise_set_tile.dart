import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> openHelpScreen(
    BuildContext context,
    String pageName, {
    String? anchor,
  }) async {
    final String baseUrl = 'https://gym-tracker-help.vercel.app';
    final String urlString = anchor != null
        ? '$baseUrl/$pageName#$anchor'
        : '$baseUrl/$pageName';
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не вдалося відкрити довідку: $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final weightFocus = FocusNode();
    final repsFocus = FocusNode();

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 5),
              Row(
                children: [
                  Text(
                    "Підхід ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => openHelpScreen(
                      context,
                      'termini_interfejsu.htm',
                      anchor: 'term_set',
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.help_outline,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
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
                SizedBox(
                  width: 45,
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
                SizedBox(
                  width: 45,
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
                GestureDetector(
                  onTap: () => openHelpScreen(
                    context,
                    'termini_interfejsu.htm',
                    anchor: 'term_rep',
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    size: 16,
                    color: Colors.blue,
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
