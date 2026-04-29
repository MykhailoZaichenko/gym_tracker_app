import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Додано імпорт
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
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // --- Функція для виклику глосарію ---
  Future<void> openHelpScreen(String pageName, {String? anchor}) async {
    final String baseUrl = 'https://gym-tracker-help.vercel.app';
    final String urlString = anchor != null
        ? '$baseUrl/$pageName#$anchor'
        : '$baseUrl/$pageName';
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не вдалося відкрити довідку: $urlString')),
        );
      }
    }
  }

  // Гнучка функція для визначення якоря за частиною назви вправи (враховує укр та англ варіанти)
  String? getAnchorForExercise(String name) {
    final n = name.toLowerCase();

    // Груди / Бруси
    if (n.contains('віджимання на брусах') || n.contains('dip')) {
      return 'term_dip';
    }
    if (n.contains('відтискання') || n.contains('push')) return 'term_pushup';
    if (n.contains('жим лежачи') || n.contains('bench press')) {
      return 'term_bench_press';
    }
    if (n.contains('машинні розведення') || n.contains('machine fly')) {
      return 'term_machine_fly';
    }

    // Ноги
    if (n.contains('випади') || n.contains('lunge')) return 'term_lunge';
    if (n.contains('вправа біля стіни') || n.contains('wall sit')) {
      return 'term_wall_sit';
    }
    if (n.contains('жим ногами') || n.contains('leg press')) {
      return 'term_leg_press';
    }
    if (n.contains('згинання ніг') || n.contains('leg curl')) {
      return 'term_leg_curl';
    }
    if (n.contains('носки сидячи') ||
        n.contains('calf') && n.contains('seated')) {
      return 'term_calf_raise_seated';
    }
    if (n.contains('носки стоячи') ||
        n.contains('calf') && n.contains('standing')) {
      return 'term_calf_raise_standing';
    }
    if (n.contains('присідання') || n.contains('squat')) return 'term_squat';
    if (n.contains('розгинання ніг') || n.contains('leg extension')) {
      return 'term_leg_extension';
    }

    // Спина
    if (n.contains('гіперекстензія') || n.contains('hyperextension')) {
      return 'term_hyperextension';
    }
    if (n.contains('гуд-морнінг') ||
        n.contains('good-morning') ||
        n.contains('good morning')) {
      return 'term_good_morning';
    }
    if (n.contains('підтягування') ||
        n.contains('pull-up') ||
        n.contains('pull up')) {
      return 'term_pull_up';
    }
    if (n.contains('ряд машинний') ||
        n.contains('row (машина)') ||
        n.contains('machine row')) {
      return 'term_machine_row';
    }
    if (n.contains('тяга верхнього') || n.contains('lat pull')) {
      return 'term_lat_pull_down';
    }
    if (n.contains('тяга в нахилі') ||
        n.contains('bent over') ||
        n.contains('bent-over')) {
      return 'term_bent_over_row';
    }
    if (n.contains('тяга') &&
            !n.contains('верхнього') &&
            !n.contains('нахилі') &&
            !n.contains('обличчя') &&
            !n.contains('підборіддя') ||
        n.contains('deadlift')) {
      return 'term_deadlift';
    }

    // Плечі
    if (n.contains('жим над головою') || n.contains('overhead press')) {
      return 'term_overhead_press';
    }
    if (n.contains('задні розведення') || n.contains('rear delt')) {
      return 'term_rear_delt_raise';
    }
    if (n.contains('передні підйоми') || n.contains('front raise')) {
      return 'term_front_raise';
    }
    if (n.contains('розведення рук') || n.contains('lateral raise')) {
      return 'term_lateral_raise';
    }
    if (n.contains('тяга до обличчя') || n.contains('face pull')) {
      return 'term_face_pull';
    }
    if (n.contains('тяга до підборіддя') || n.contains('upright row')) {
      return 'term_upright_row';
    }
    if (n.contains('шраги') || n.contains('shrug')) {
      return 'term_shoulder_shrug';
    }

    // Руки
    if (n.contains('зоттмана') || n.contains('zottman')) {
      return 'term_zottman_curl';
    }
    if (n.contains('молотковий') || n.contains('hammer curl')) {
      return 'term_hammer_curl';
    }
    if (n.contains('на біцепс') || n.contains('bicep')) {
      return 'term_biceps_curl';
    }
    if (n.contains('французький') || n.contains('triceps extension')) {
      return 'term_triceps_extension';
    }

    // Прес
    if (n.contains('підйом тулуба') ||
        n.contains('sit-up') ||
        n.contains('sit up')) {
      return 'term_sit_up';
    }
    if (n.contains('ніг у висі') || n.contains('hanging leg')) {
      return 'term_leg_raise_hang';
    }
    if ((n.contains('підйоми ніг') || n.contains('leg raise')) &&
        !n.contains('висі') &&
        !n.contains('hanging')) {
      return 'term_leg_raise';
    }
    if (n.contains('планка') || n.contains('plank')) return 'term_plank';
    if (n.contains('повороти тулуба') || n.contains('russian twist')) {
      return 'term_russian_twist';
    }
    if (n.contains('скручування') || n.contains('crunch')) return 'term_crunch';

    return null;
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
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Пошук вправи',
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
                  itemCount: filtered.length + 1,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, idx) {
                    if (idx == 0) {
                      return ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Ввести власну назву'),
                        // УВАГА: Тут посилання веде на терміни інтерфейсу!
                        // Якщо твій файл називається інакше (не termini_interfejsu.htm), зміни його нижче.
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.help_outline,
                            color: Colors.grey,
                          ),
                          onPressed: () => openHelpScreen(
                            'termini_interfejsu.htm',
                            anchor: 'term_custom_name',
                          ),
                        ),
                        onTap: () =>
                            Navigator.of(context).pop(ExerciseInfo.enterCustom),
                      );
                    }
                    final it = filtered[idx - 1];
                    final anchor = getAnchorForExercise(it.name);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(it.icon),
                      ),
                      title: Text(it.name),
                      // Кнопка довідки для вправи тепер веде у файл katalog_vprav.htm
                      trailing: anchor != null
                          ? IconButton(
                              icon: const Icon(
                                Icons.help_outline,
                                color: Colors.blue,
                              ),
                              onPressed: () => openHelpScreen(
                                'katalog_vprav.htm',
                                anchor: anchor,
                              ),
                            )
                          : null,
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
