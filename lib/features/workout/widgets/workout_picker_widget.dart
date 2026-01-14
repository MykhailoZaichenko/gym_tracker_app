// lib/widgets/exercise_picker.dart
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/exercise_icon.dart';

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
  const _ExercisePickerSheet({this.initialQuery});

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _controller = TextEditingController(text: _query);
    _focusNode = FocusNode();
    _controller.addListener(() {
      final v = _controller.text;
      if (v != _query) {
        setState(() => _query = v);
      }
    });
    // Request focus after first frame to ensure keyboard opens reliably
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final catalog = getExerciseCatalog(loc);
    final filtered = _query.isEmpty
        ? catalog
        : catalog
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
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: loc.searchExercise,
                      ),
                      textInputAction: TextInputAction.search,
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
            Flexible(
              // Flexible дає ListView займати доступний простір, скрол працює природно
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filtered.length + 1,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, idx) {
                    if (idx == 0) {
                      return ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(loc.enterCustomName),
                        onTap: () => Navigator.of(
                          context,
                        ).pop(ExerciseInfo.getEnterCustom(loc)),
                      );
                    }
                    final it = filtered[idx - 1];
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(
                          4,
                        ), // Трохи відступу, щоб іконка не торкалася країв
                        decoration: BoxDecoration(
                          color: Colors
                              .grey[200], // Світлий фон, щоб чорні іконки було видно на темній темі
                          shape: BoxShape.circle,
                        ),
                        child: ExerciseIcon(
                          exercise: it,
                          size: 24,
                          color: Colors
                              .black, // Примусово чорний колір для стандартних іконок, якщо треба
                        ),
                      ),
                      title: Text(it.name),
                      onTap: () => Navigator.of(context).pop(it),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
