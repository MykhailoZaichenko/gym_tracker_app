import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/core/constants/date_constants.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:gym_tracker_app/features/analytics/models/progression_data_model.dart';
import 'package:gym_tracker_app/features/analytics/models/workout_exercise_graf_model.dart';
import 'package:gym_tracker_app/utils/utils.dart';
import 'package:gym_tracker_app/features/analytics/widgets/line_chart_card.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/build_summary_item_widget.dart';
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
        setState(() {
          _range = RangeMode.values[_tabController.index];
          _visibleMonth = DateTime.now();
        });
      }
    });
    _loadAllWorkouts();
  }

  Future<void> _loadAllWorkouts() async {
    final rawWorkouts = await _firestore.getAllWorkouts();

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

    for (final list in _allWorkouts.values) {
      for (final ex in list) {
        final id = _getCanonicalId(ex, catalog);
        if (id != 'unknown') {
          uniqueCanonicalIds.add(id);
        }
      }
    }

    final names = uniqueCanonicalIds
        .map((id) => _getLocalizedNameById(id, catalog))
        .toSet()
        .toList();

    names.sort();
    _displayExerciseNames = names;

    if (_displayExerciseNames.isNotEmpty) {
      if (_selectedExerciseDisplay == null ||
          !_displayExerciseNames.contains(_selectedExerciseDisplay)) {
        _selectedExerciseDisplay = _displayExerciseNames.first;
      }
    } else {
      _selectedExerciseDisplay = null;
    }
  }

  // ---- ОБРОБКА ДАНИХ ----

  // 1. Агрегація для Volume (сума ваги за день)
  Map<DateTime, double> _accumulateVolumePerDay(
    String selectedDisplayName,
    AppLocalizations loc,
  ) {
    final Map<DateTime, double> result = {};
    final catalog = getExerciseCatalog(loc);

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

  // 2. Агрегація для Max Weight (макс вага за день) - НОВЕ
  Map<DateTime, double> _accumulateMaxWeightPerDay(
    String selectedDisplayName,
    AppLocalizations loc,
  ) {
    final Map<DateTime, double> result = {};
    final catalog = getExerciseCatalog(loc);

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

      double dailyMax = 0;
      for (final ex in matching) {
        for (final s in ex.sets) {
          if (s.weight != null && s.weight! > dailyMax) {
            dailyMax = s.weight!;
          }
        }
      }

      if (dailyMax > 0) {
        final dayKey = DateTime(date.year, date.month, date.day);
        // Якщо в один день було кілька тренувань, беремо абсолютний максимум
        if (dailyMax > (result[dayKey] ?? 0)) {
          result[dayKey] = dailyMax;
        }
      }
    });

    return result;
  }

  // 3. Фільтрація по даті (повертає відсортований список)
  List<MapEntry<DateTime, double>> _filterEntries(
    Map<DateTime, double> rawData,
  ) {
    if (rawData.isEmpty) return [];

    DateTime start, end;
    if (_range == RangeMode.month) {
      start = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
      end = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + 1,
        1,
      ).subtract(const Duration(days: 1));
    } else {
      start = DateTime(_visibleMonth.year, 1, 1);
      end = DateTime(_visibleMonth.year, 12, 31);
    }

    final entries = rawData.entries.where(
      (e) => !e.key.isBefore(start) && !e.key.isAfter(end),
    );

    return entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  }

  // 4. Розрахунок прогресії
  ProgressionData? _calculateProgression(
    List<MapEntry<DateTime, double>> entries,
  ) {
    if (entries.length < 2) {
      return null;
    }
    final first = entries.first.value;
    final last = entries.last.value;
    return ProgressionData(startValue: first, currentValue: last);
  }

  ProgressionData? _calculateSessionProgression(
    List<MapEntry<DateTime, double>> currentEntries,
  ) {
    if (currentEntries.isEmpty) return null;

    // Рахуємо кількість унікальних днів у поточному періоді
    final currentCount = currentEntries.length.toDouble();

    // Визначаємо попередній період
    DateTime prevStart, prevEnd;
    if (_range == RangeMode.month) {
      // Якщо зараз Лютий 2025 -> Попередній: Січень 2025
      prevStart = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
      prevEnd = DateTime(_visibleMonth.year, _visibleMonth.month, 0);
    } else {
      // Якщо зараз 2025 -> Попередній: 2024
      prevStart = DateTime(_visibleMonth.year - 1, 1, 1);
      prevEnd = DateTime(_visibleMonth.year - 1, 12, 31);
    }

    // Рахуємо сесії для попереднього періоду
    // (Потрібно знову пройтись по _allWorkouts, але з фільтром по попередній даті)
    final loc = AppLocalizations.of(context)!;
    final catalog = getExerciseCatalog(loc);
    String targetId = _selectedExerciseDisplay ?? '';
    try {
      targetId = catalog
          .firstWhere((c) => c.name == _selectedExerciseDisplay)
          .id;
    } catch (_) {}

    int prevCount = 0;
    _allWorkouts.forEach((dateStr, exercises) {
      final date = DateTime.parse(dateStr);
      if (date.isAfter(prevStart.subtract(const Duration(seconds: 1))) &&
          date.isBefore(prevEnd.add(const Duration(seconds: 1)))) {
        // Перевіряємо чи була ця вправа в цей день
        final hasExercise = exercises.any((ex) {
          final exId = _getCanonicalId(ex, catalog);
          return exId == targetId;
        });

        if (hasExercise) prevCount++;
      }
    });

    return ProgressionData(
      startValue: prevCount.toDouble(),
      currentValue: currentCount,
    );
  }

  // ---- UI LOGIC ----

  bool get _canGoBack {
    final minDate = DateConstants.appStartDate;
    if (_range == RangeMode.month) {
      return _visibleMonth.year > minDate.year ||
          (_visibleMonth.year == minDate.year &&
              _visibleMonth.month > minDate.month);
    } else {
      return _visibleMonth.year > minDate.year;
    }
  }

  bool get _canGoForward {
    final currentMonthStart = DateConstants.currentMonthStart;
    if (_range == RangeMode.month) {
      return _visibleMonth.isBefore(currentMonthStart);
    } else {
      return _visibleMonth.year < currentMonthStart.year;
    }
  }

  void _prevPeriod() {
    if (!_canGoBack) return;
    setState(() {
      if (_range == RangeMode.month) {
        _visibleMonth = DateTime(
          _visibleMonth.year,
          _visibleMonth.month - 1,
          1,
        );
      } else {
        _visibleMonth = DateTime(
          _visibleMonth.year - 1,
          _visibleMonth.month,
          1,
        );
      }
    });
  }

  void _nextPeriod() {
    if (!_canGoForward) return;
    setState(() {
      if (_range == RangeMode.month) {
        _visibleMonth = DateTime(
          _visibleMonth.year,
          _visibleMonth.month + 1,
          1,
        );
      } else {
        _visibleMonth = DateTime(
          _visibleMonth.year + 1,
          _visibleMonth.month,
          1,
        );
      }
    });
  }

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
          // Для року беремо середнє або максимум за місяць?
          // Зазвичай для року підсумовують об'єм, але для ваги беруть макс.
          // Тут використовуємо спрощений підхід (сума для сумісності з логікою графіка)
          // Але для maxWeight краще брати max.
          // Оскільки цей метод загальний, залишимо сумування, але це може спотворити MaxWeight графік на рік.
          // *Покращення*: для MaxWeight треба окрему логіку будування точок.
          // Але поки залишимо як є, щоб не ускладнювати надмірно.
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
        final maxDays = DateTime(
          _visibleMonth.year,
          _visibleMonth.month + 1,
          0,
        ).day;
        if (dayNum < 1 || dayNum > maxDays) return null;
        return DateTime(_visibleMonth.year, _visibleMonth.month, dayNum);
      case RangeMode.year:
        final month = x.round();
        if (month < 1 || month > 12) return null;
        return DateTime(_visibleMonth.year, month, 1);
    }
  }

  void _onPointTapped(DateTime day) {
    final loc = AppLocalizations.of(context)!;
    if (_range == RangeMode.year) return;

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

  double _bottomInterval(int pointsCount) {
    switch (_range) {
      case RangeMode.year:
        return 1.0;
      case RangeMode.month:
        if (pointsCount <= 5) return 5.0;
        if (pointsCount <= 15) return 3.0;
        return 2.0;
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

  // НОВЕ: Віджет для відображення відсотка
  Widget _buildPercentBadge(
    ProgressionData? data,
    AppLocalizations loc, {
    bool isWeight = false,
  }) {
    if (data == null) return const SizedBox();

    final color = data.isPositive ? Colors.green : Colors.red;
    final icon = data.isPositive
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;
    final sign = data.isPositive ? '+' : '';

    return InkWell(
      onTap: () {
        // Показуємо діалог з деталями
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(loc.comparisonTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogRow(
                  loc.startValue,
                  formatNumberCompact(data.startValue),
                  isWeight ? loc.weightUnit : '',
                ),
                const SizedBox(height: 8),
                _buildDialogRow(
                  loc.currentValue,
                  formatNumberCompact(data.currentValue),
                  isWeight ? loc.weightUnit : '',
                ),
                const Divider(),
                _buildDialogRow(
                  loc.difference,
                  '${data.percentage.toStringAsFixed(1)}%',
                  '',
                  color: color,
                  isBold: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(loc.close),
              ),
            ],
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 2),
            Text(
              '$sign${data.percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogRow(
    String label,
    String value,
    String unit, {
    Color? color,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          '$value $unit',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();
    final loc = AppLocalizations.of(context)!;
    final locale = loc.localeName;

    _prepareExerciseList(loc);

    // 1. Отримуємо дані для Volume
    final volumeDataRaw = _selectedExerciseDisplay != null
        ? _accumulateVolumePerDay(_selectedExerciseDisplay!, loc)
        : <DateTime, double>{};
    final volumeEntries = _filterEntries(volumeDataRaw);
    final volumeSpots = _buildSpots(volumeEntries);
    final volumeProgression = _calculateProgression(volumeEntries);
    final sessionProgression = _calculateSessionProgression(volumeEntries);

    // 2. Отримуємо дані для Max Weight
    final maxWeightDataRaw = _selectedExerciseDisplay != null
        ? _accumulateMaxWeightPerDay(_selectedExerciseDisplay!, loc)
        : <DateTime, double>{};
    final maxWeightEntries = _filterEntries(maxWeightDataRaw);
    // Для макс ваги нам потрібен останній запис у вибраному періоді для відображення "Max Weight"
    final maxWeightValue = maxWeightEntries.isNotEmpty
        ? maxWeightEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b)
        : 0.0;
    final maxWeightProgression = _calculateProgression(maxWeightEntries);

    final dynamicInterval = _bottomInterval(volumeSpots.length);

    double maxY = 1;
    for (final s in volumeSpots) {
      if (s.y > maxY) maxY = s.y;
    }
    final double yInterval = (maxY <= 0) ? 1.0 : (maxY / 4).toDouble();

    // Колір графіка (залежить від прогресу Volume)
    final Color chartColor = volumeProgression != null
        ? (volumeProgression.isPositive ? Colors.green : Colors.red)
        : Colors.blue;

    String dateLabel;
    if (_range == RangeMode.month) {
      final monthName = DateFormat.MMMM(locale).format(_visibleMonth);
      dateLabel =
          '${toBeginningOfSentenceCase(monthName)} ${_visibleMonth.year}';
    } else {
      dateLabel = _visibleMonth.year.toString();
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.chartsTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Exercise Dropdown
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

            // Tabs (Month/Year)
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

            // === 📅 NAVIGATOR ===
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _canGoBack ? _prevPeriod : null,
                    color: _canGoBack
                        ? null
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _range == RangeMode.month
                        ? () async {
                            final picked = await showMonthPicker(
                              context: context,
                              initialDate: _visibleMonth,
                              firstDate: DateConstants.appStartDate,
                              lastDate: DateConstants.appMaxDate,
                            );
                            if (picked != null) {
                              setState(() {
                                _visibleMonth = picked;
                              });
                            }
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            dateLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (_range == RangeMode.month) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _canGoForward ? _nextPeriod : null,
                    color: _canGoForward
                        ? null
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // CHART CARD
            Expanded(
              child: _selectedExerciseDisplay == null
                  ? Center(
                      child: Text(
                        loc.addExercisesHint,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    )
                  : volumeSpots.isEmpty
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
                              spots: volumeSpots,
                              maxY: maxY,
                              yInterval: yInterval,
                              range: _range,
                              bottomInterval: () => dynamicInterval,
                              buildBottomTitle: _buildBottomTitle,
                              formatY: formatNumberCompact,
                              lineColor: chartColor, // Передаємо колір
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
                                  color: chartColor, //
                                ),
                                const SizedBox(width: 6),
                                Text(loc.liftedWeight),
                                IconButton(
                                  onPressed: () {
                                    tooltipKey.currentState
                                        ?.ensureTooltipVisible();
                                  },
                                  tooltip: null,
                                  icon: Tooltip(
                                    key: tooltipKey,
                                    message: loc.liftedWeightHelp,
                                    preferBelow: false,
                                    verticalOffset: 20,
                                    showDuration: const Duration(seconds: 4),
                                    triggerMode: TooltipTriggerMode.manual,
                                    child: Icon(
                                      Icons.help_outline_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),

            // TOTALS ROW (Modified for badges)
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
                  // Total Lifted + Badge
                  Expanded(
                    child: Column(
                      children: [
                        buildSummaryItem(
                          context: context,
                          label: loc.totalLifted,
                          value: formatNumberCompact(
                            _totalForEntries(volumeEntries),
                          ),
                          color: chartColor,
                        ),
                        const SizedBox(height: 4),
                        // Badge for Volume
                        _buildPercentBadge(volumeProgression, loc),
                      ],
                    ),
                  ),

                  // Max Weight + Badge
                  Expanded(
                    child: Column(
                      children: [
                        buildSummaryItem(
                          context: context,
                          label: loc.maxWeight,
                          value:
                              '${formatNumberCompact(maxWeightValue)} ${loc.weightUnit}',
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(height: 4),
                        // Badge for Max Weight
                        _buildPercentBadge(
                          maxWeightProgression,
                          loc,
                          isWeight: true,
                        ),
                      ],
                    ),
                  ),

                  // Points Count
                  Expanded(
                    child: Column(
                      children: [
                        buildSummaryItem(
                          context: context,
                          label: loc.gymSessions, // "Сесії в залі"
                          value: volumeEntries.length.toString(),
                        ),
                        const SizedBox(height: 4),
                        // 🔥 Badge для сесій
                        _buildPercentBadge(sessionProgression, loc),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
