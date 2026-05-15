import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/exercise_icon.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';

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

  late List<ExerciseInfo> _fullCatalog = [];

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Завантажуємо каталог один раз, коли доступний контекст для локалізації
    if (_fullCatalog.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      _fullCatalog = getExerciseCatalog(loc);
    }
  }

  // Функція для відкриття YouTube
  Future<void> _launchYouTubeSearch(String exerciseName) async {
    final query = 'як правильно робити $exerciseName техніка виконання';
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
      'https://www.youtube.com/results?search_query=$encodedQuery',
    );

    if (await canLaunchUrl(url)) {
      final bool nativeAppLaunched = await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );

      if (!nativeAppLaunched) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else {
      debugPrint('Не вдалося відкрити посилання: $url');
    }
  }

  // Функція для показу вікна з деталями та анатомічною схемою
  void _showExerciseDetails(ExerciseInfo exercise, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(exercise.name, style: textTheme.titleLarge),
        // Обгортаємо в ScrollView, щоб уникнути переповнення екрана
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // АНАТОМІЧНА СХЕМА (Stack)
              if (exercise.muscleImagePath != null) ...[
                Center(
                  child: SizedBox(
                    height: 180, // Висота манекена
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Базовий сірий манекен (спереду або ззаду)
                        SvgPicture.asset(
                          exercise.isFrontBody
                              ? 'assets/muscles/body_front.svg'
                              : 'assets/muscles/body_back.svg',
                          fit: BoxFit.contain,
                        ),
                        // Червоний м'яз, що накладається зверху
                        SvgPicture.asset(
                          exercise.muscleImagePath!,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ІНФОРМАЦІЯ
              if (exercise.category != null)
                Text(
                  'Категорія: ${exercise.category}',
                  style: textTheme.bodyLarge,
                ),

              if (exercise.equipment.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Спорядження: ${exercise.equipment.join(", ")}',
                  style: textTheme.bodyMedium,
                ),
              ],

              if (exercise.targetMuscles.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Цільові м\'язи: ${exercise.targetMuscles.join(", ")}',
                  style: textTheme.bodyMedium,
                ),
              ],

              // ПОРАДИ З ВИКОНАННЯ
              if (exercise.tips.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text('Поради щодо техніки:', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                // Виводимо кожну пораду як рядок з галочкою
                ...exercise.tips
                    .map(
                      (tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(tip, style: textTheme.bodySmall),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              _launchYouTubeSearch(exercise.name);
            },
            icon: const Icon(Icons.play_circle_fill, color: Colors.red),
            label: const Text(
              'YouTube гайд',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Закрити'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Розумний пошук, який ігнорує регістр і спецсимволи
  String _normalizeString(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[^a-zа-яієїґ0-9]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    // Фільтруємо наш чистий Dart-каталог
    final filteredCatalog = _query.isEmpty
        ? _fullCatalog
        : _fullCatalog.where((e) {
            final nameNorm = _normalizeString(e.name);
            final queryNorm = _normalizeString(_query);
            return nameNorm.contains(queryNorm);
          }).toList();

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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredCatalog.length + 1,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, idx) {
                    if (idx == 0) {
                      return ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(
                          loc.enterCustomName,
                          style: textTheme.bodyLarge,
                        ),
                        onTap: () => Navigator.of(
                          context,
                        ).pop(ExerciseInfo.getEnterCustom(loc)),
                      );
                    }

                    // Беремо вправу безпосередньо з відфільтрованого каталогу
                    final it = filteredCatalog[idx - 1];

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: ExerciseIcon(
                          exercise: it, // Передаємо саму вправу
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(it.name, style: textTheme.bodyLarge),
                      subtitle: it.category != null
                          ? Text(it.category!, style: textTheme.bodySmall)
                          : null,
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                        onPressed: () => _showExerciseDetails(it, context),
                      ),
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
