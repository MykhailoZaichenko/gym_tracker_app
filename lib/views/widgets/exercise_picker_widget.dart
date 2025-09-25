// lib/widgets/exercise_picker.dart
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/exercise_catalog.dart';

Future<ExerciseInfo?> showExercisePicker(
  BuildContext context, {
  String? initialQuery,
}) {
  return showModalBottomSheet<ExerciseInfo>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (ctx) => _ExercisePickerSheet(initialQuery: initialQuery),
  );
}

class _ExercisePickerSheet extends StatefulWidget {
  final String? initialQuery;
  const _ExercisePickerSheet({this.initialQuery, Key? key}) : super(key: key);

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? kExerciseCatalog
        : kExerciseCatalog
              .where((e) => e.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Пошук вправи',
                      ),
                      onChanged: (v) => setState(() => _query = v),
                      controller: TextEditingController(text: _query),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SizedBox(
              height: 360,
              child: ListView.separated(
                itemCount: filtered.length + 1,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, idx) {
                  if (idx == 0) {
                    return ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Ввести власну назву'),
                      onTap: () => Navigator.of(context).pop(null),
                    );
                  }
                  final it = filtered[idx - 1];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(it.icon),
                    ),
                    title: Text(it.name),
                    onTap: () => Navigator.of(context).pop(it),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
