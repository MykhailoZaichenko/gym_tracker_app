import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:gym_tracker_app/core/utils.dart';
import 'package:gym_tracker_app/features/analytics/widgets/line_chart_card.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';

class GrafPage extends StatefulWidget {
  const GrafPage({super.key});

  @override
  State<GrafPage> createState() => _GrafPageState();
}

class _GrafPageState extends State<GrafPage> with TickerProviderStateMixin {
  Map<String, List<WorkoutExerciseGraf>> _allWorkouts = {};
  bool _isLoading = true;
  final FirestoreService _firestore = FirestoreService();

  // Список унікальних назв (вже локалізованих) для відображення
  List<String> _displayExerciseNames = [];
  String? _selectedExerciseDisplay;

  RangeMode _range = RangeMode.month;
  late TabController _tabController;

  DateTime _visibleMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _range = RangeMode.values[_tabController.index]);
      }
    });
    _loadAllWorkouts();
  }

  Future<void> _loadAllWorkouts() async {
    final rawWorkouts = await _firestore.getAllWorkouts();

    // Перетворюємо у формат для графіків
    _allWorkouts = rawWorkouts.map((key, value) {
      final list = value
          .map(
            (e) => WorkoutExerciseGraf(
              name: e.name,
              exerciseId: e.exerciseId,
              sets: e.sets
                  .map((s) => SetData(weight: s.weight, reps: s.reps))
                  .toList(),
            ),
          )
          .toList();
      return MapEntry(key, list);
    });

    setState(() => _isLoading = false);
  }

  String _getCanonicalId(WorkoutExerciseGraf ex, List<ExerciseInfo> catalog) {
    final rawName = ex.name.trim();
    if (ex.exerciseId != null && ex.exerciseId!.isNotEmpty) {
      return ex.exerciseId!;
    }
    if (rawName.isEmpty) return 'unknown';
    try {
      final found = catalog.firstWhere(
        (c) => c.id == rawName || c.name.toLowerCase() == rawName.toLowerCase(),
      );
      return found.id;
    } catch (_) {}
    return rawName;
  }

  /// Отримує локалізовану назву для відображення в UI за канонічним ID
  String _getLocalizedNameById(String canonicalId, List<ExerciseInfo> catalog) {
    try {
      final found = catalog.firstWhere((c) => c.id == canonicalId);
      return found.name;
    } catch (_) {
      return canonicalId;
    }
  }

  void _prepareExerciseList(AppLocalizations loc) {
    final catalog = getExerciseCatalog(loc);
    final uniqueCanonicalIds = <String>{};

    // Збираємо всі унікальні ID зі всіх тренувань
    for (final list in _allWorkouts.values) {
      for (final ex in list) {
        final id = _getCanonicalId(ex, catalog);

        // --- ФІКС ТУТ: Фільтруємо 'unknown' (вправи без назви) ---
        if (id != 'unknown') {
          uniqueCanonicalIds.add(id);
        }
      }
    }

    // Перетворюємо ID на красиві локалізовані назви для списку
    final names = uniqueCanonicalIds
        .map((id) => _getLocalizedNameById(id, catalog))
        .toSet()
        .toList();

    names.sort();
    _displayExerciseNames = names;

    // Логіка збереження вибору при оновленні списку
    if (_displayExerciseNames.isNotEmpty) {
      if (_selectedExerciseDisplay == null ||
          !_displayExerciseNames.contains(_selectedExerciseDisplay)) {
        _selectedExerciseDisplay = _displayExerciseNames.first;
      }
    } else {
      _selectedExerciseDisplay = null;
    }
  }

  // ---- АГРЕГАЦІЯ ----

  Map<DateTime, double> _accumulatePerDay(
    String selectedDisplayName,
    AppLocalizations loc,
  ) {
    final Map<DateTime, double> result = {};
    final catalog = getExerciseCatalog(loc);

    // Знаходимо ID для обраної назви
    String targetCanonicalId = selectedDisplayName;
    try {
      final found = catalog.firstWhere((c) => c.name == selectedDisplayName);
      targetCanonicalId = found.id;
    } catch (_) {}

    _allWorkouts.forEach((dateStr, exercises) {
      final date = DateTime.parse(dateStr);

      final matching = exercises.where((ex) {
        final exId = _getCanonicalId(ex, catalog);
        return exId == targetCanonicalId;
      });

      double sum = 0;
      for (final ex in matching) {
        for (final s in ex.sets) {
          final w = s.weight ?? 0;
          final r = s.reps ?? 0;
          sum += w * r;
        }
      }

      if (sum > 0) {
        final dayKey = DateTime(date.year, date.month, date.day);
        result[dayKey] = (result[dayKey] ?? 0) + sum;
      }
    });

    return result;
  }

  List<MapEntry<DateTime, double>> _filteredEntriesForRange(
    AppLocalizations loc,
  ) {
    if (_selectedExerciseDisplay == null) return [];

    final acc = _accumulatePerDay(_selectedExerciseDisplay!, loc);

    Iterable<MapEntry<DateTime, double>> entries = acc.entries;
    switch (_range) {
      case RangeMode.month:
        final first = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
        final last = DateTime(
          _visibleMonth.year,
          _visibleMonth.month + 1,
          1,
        ).subtract(const Duration(days: 1));
        entries = entries.where(
          (e) => !e.key.isBefore(first) && !e.key.isAfter(last),
        );
        break;
      case RangeMode.year:
        final yearStart = DateTime(DateTime.now().year, 1, 1);
        final yearEnd = DateTime(DateTime.now().year, 12, 31);
        entries = entries.where(
          (e) => !e.key.isBefore(yearStart) && !e.key.isAfter(yearEnd),
        );
        break;
    }

    final sorted = entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return sorted;
  }

  // ... UI методи без змін ...

  List<FlSpot> _buildSpots(List<MapEntry<DateTime, double>> entries) {
    final spots = <FlSpot>[];
    if (entries.isEmpty) return spots;

    switch (_range) {
      case RangeMode.month:
        for (final e in entries) {
          spots.add(FlSpot(e.key.day.toDouble(), e.value));
        }
        break;
      case RangeMode.year:
        final monthMap = <int, double>{};
        for (final e in entries) {
          monthMap[e.key.month] = (monthMap[e.key.month] ?? 0) + e.value;
        }
        final months = monthMap.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
        for (final m in months) {
          spots.add(FlSpot(m.key.toDouble(), m.value));
        }
        break;
    }
    return spots;
  }

  DateTime? _xToDate(double x) {
    switch (_range) {
      case RangeMode.month:
        final dayNum = x.round();
        return DateTime(_visibleMonth.year, _visibleMonth.month, dayNum);
      case RangeMode.year:
        final month = x.round();
        return DateTime(DateTime.now().year, month, 1);
    }
  }

  void _onPointTapped(DateTime day) {
    final loc = AppLocalizations.of(context)!;
    final key =
        '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    final exList = _allWorkouts[key] ?? [];

    final catalog = getExerciseCatalog(loc);
    String targetId = _selectedExerciseDisplay ?? '';
    try {
      targetId = catalog
          .firstWhere((c) => c.name == _selectedExerciseDisplay)
          .id;
    } catch (_) {}

    final ex = exList.firstWhere(
      (e) => _getCanonicalId(e, catalog) == targetId,
      orElse: () => WorkoutExerciseGraf(name: '', sets: []),
    );

    if (ex.name.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          '$_selectedExerciseDisplay — $key',
          style: ThemeService.isDarkModeNotifier.value
              ? const TextStyle(color: Colors.white)
              : const TextStyle(color: Colors.black),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: ex.sets.length,
            separatorBuilder: (_, __) => const Divider(height: 8),
            itemBuilder: (_, i) {
              final s = ex.sets[i];
              return ListTile(
                title: Text('${loc.setLabelCompact} ${i + 1}'),
                subtitle: Text(
                  '${loc.weightLabel}: ${s.weight ?? '-'}  •  ${loc.repsUnit}: ${s.reps ?? '-'}',
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.close),
          ),
        ],
      ),
    );
  }

  void _prevMonth() {
    setState(() {
      if (_range == RangeMode.month) {
        if (_visibleMonth.year > 2024) {
          _visibleMonth = DateTime(
            _visibleMonth.year,
            _visibleMonth.month - 1,
            1,
          );
        }
      } else {
        // Рік назад
        if (_visibleMonth.year > 2024) {
          _visibleMonth = DateTime(
            _visibleMonth.year - 1,
            _visibleMonth.month,
            1,
          );
        }
      }
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    setState(() {
      if (_range == RangeMode.month) {
        // Перевірка: чи наступний місяць не в майбутньому
        final nextMonth = DateTime(
          _visibleMonth.year,
          _visibleMonth.month + 1,
          1,
        );
        if (nextMonth.year < now.year ||
            (nextMonth.year == now.year && nextMonth.month <= now.month)) {
          _visibleMonth = nextMonth;
        }
      } else {
        // Рік вперед
        if (_visibleMonth.year < now.year) {
          _visibleMonth = DateTime(
            _visibleMonth.year + 1,
            _visibleMonth.month,
            1,
          );
        }
      }
    });
  }

  double _bottomInterval() {
    switch (_range) {
      case RangeMode.month:
        return 5;
      case RangeMode.year:
        return 1;
    }
  }

  Widget _buildBottomTitle(double value) {
    final locale = AppLocalizations.of(context)!.localeName;
    switch (_range) {
      case RangeMode.month:
        return Text('${value.round()}', style: const TextStyle(fontSize: 11));
      case RangeMode.year:
        final month = value.round();
        if (month < 1 || month > 12) return const SizedBox();
        final date = DateTime(DateTime.now().year, month);
        final monthShort = DateFormat.MMM(locale).format(date);
        return Text(
          toBeginningOfSentenceCase(monthShort) ?? '',
          style: const TextStyle(fontSize: 11),
        );
    }
  }

  double _totalForEntries(List<MapEntry<DateTime, double>> entries) {
    double s = 0;
    for (final e in entries) {
      s += e.value;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final loc = AppLocalizations.of(context)!;
    final locale = loc.localeName;

    // Оновлюємо список вправ при кожному build
    _prepareExerciseList(loc);

    final entries = _filteredEntriesForRange(loc);
    final spots = _buildSpots(entries);

    double maxY = 1;
    for (final s in spots) {
      if (s.y > maxY) maxY = s.y;
    }
    final double yInterval = (maxY <= 0) ? 1.0 : (maxY / 4).toDouble();

    final monthName = DateFormat.MMMM(locale).format(_visibleMonth);
    final capitalizedMonth = toBeginningOfSentenceCase(monthName);
    final now = DateTime.now();

    bool canGoBack = _visibleMonth.year > 2024;
    bool canGoForward = false;

    if (_range == RangeMode.month) {
      canGoForward =
          _visibleMonth.year < now.year ||
          (_visibleMonth.year == now.year && _visibleMonth.month < now.month);
    } else {
      // Для року
      canGoForward = _visibleMonth.year < now.year;
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.chartsTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(loc.exerciseLabel),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedExerciseDisplay,
                    hint: Text(loc.chooseExercise),
                    items: _displayExerciseNames
                        .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _selectedExerciseDisplay = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              tabs: [
                Tab(text: loc.tabMonth),
                Tab(text: loc.tabYear),
              ],
            ),
            const SizedBox(height: 8),
            if (_range == RangeMode.month)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: canGoBack ? _prevMonth : null,
                    ),

                    // Клікабельний місяць
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        // Викликаємо діалог вибору місяця
                        final now = DateTime.now();
                        final picked = await showMonthPicker(
                          context: context,
                          initialDate: _visibleMonth,
                          // Можемо обмежити дати, як і в інших місцях
                          firstDate: DateTime(2024, 1),
                          lastDate: DateTime(now.year, now.month),
                        );

                        if (picked != null) {
                          setState(() {
                            _visibleMonth = picked;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '$capitalizedMonth ${_visibleMonth.year}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: canGoForward ? _nextMonth : null,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: _selectedExerciseDisplay == null
                  ? Center(
                      child: Text(
                        loc.addExercisesHint,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    )
                  : spots.isEmpty
                  ? Center(
                      child: Text(
                        loc.noDataRange,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    )
                  : Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            ProgressLineChart(
                              spots: spots,
                              maxY: maxY,
                              yInterval: yInterval,
                              range: _range,
                              bottomInterval: _bottomInterval,
                              buildBottomTitle: _buildBottomTitle,
                              formatY: formatNumberCompact,
                              onPointTap: (x) {
                                final date = _xToDate(x);
                                if (date != null) _onPointTapped(date);
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 4,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 6),
                                Text(loc.liftedWeight),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
                top: 4.0,
                left: 4.0,
                right: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${loc.totalLifted} ${formatNumberCompact(_totalForEntries(entries))}',
                  ),
                  Text('${loc.pointsCount} ${entries.length}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class WorkoutExerciseGraf {
  String name;
  String? exerciseId;
  List<SetData> sets;

  WorkoutExerciseGraf({
    required this.name,
    this.exerciseId,
    required this.sets,
  });

  factory WorkoutExerciseGraf.fromMap(Map<String, dynamic> m) {
    return WorkoutExerciseGraf(
      name: m['name'] as String? ?? '',
      exerciseId: m['exerciseId'] as String?,
      sets: (m['sets'] as List<dynamic>? ?? [])
          .map((e) => SetData.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'exerciseId': exerciseId,
    'sets': sets.map((s) => s.toMap()).toList(),
  };
}

class SetData {
  double? weight;
  int? reps;

  SetData({this.weight, this.reps});

  factory SetData.fromMap(Map<String, dynamic> m) {
    return SetData(
      weight: (m['weight'] as num?)?.toDouble(),
      reps: m['reps'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {'weight': weight, 'reps': reps};
}
