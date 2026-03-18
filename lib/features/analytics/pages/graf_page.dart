import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/core/constants/date_constants.dart';
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

// Допоміжний клас для зберігання розгорнутої статистики за період
class _PeriodStats {
  final double volume;
  final double maxWeight;
  final double sessions;
  final DateTime? maxWeightDate;
  final DateTime? periodDate;

  _PeriodStats({
    required this.volume,
    required this.maxWeight,
    required this.sessions,
    this.maxWeightDate,
    this.periodDate,
  });
}

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
        if (dailyMax > (result[dayKey] ?? 0)) {
          result[dayKey] = dailyMax;
        }
      }
    });

    return result;
  }

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

  // Беремо весь минулий активний період без "зрізання" по днях
  _PeriodStats _getPreviousPeriodStats(
    String targetId,
    List<ExerciseInfo> catalog,
  ) {
    DateTime currentStart;
    if (_range == RangeMode.month) {
      currentStart = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    } else {
      currentStart = DateTime(_visibleMonth.year, 1, 1);
    }

    DateTime? lastActiveDate;

    // Шукаємо останній місяць у минулому, коли юзер робив цю вправу
    _allWorkouts.forEach((dateStr, exercises) {
      final date = DateTime.parse(dateStr);
      if (date.isBefore(currentStart)) {
        final hasExercise = exercises.any(
          (ex) => _getCanonicalId(ex, catalog) == targetId,
        );
        if (hasExercise) {
          if (lastActiveDate == null || date.isAfter(lastActiveDate!)) {
            lastActiveDate = date;
          }
        }
      }
    });

    // Якщо ніколи не робив - повертаємо нулі (це справжній "Старт")
    if (lastActiveDate == null) {
      return _PeriodStats(volume: 0, maxWeight: 0, sessions: 0);
    }

    DateTime prevStart, prevEnd;
    if (_range == RangeMode.month) {
      prevStart = DateTime(lastActiveDate!.year, lastActiveDate!.month, 1);
      prevEnd = DateTime(
        lastActiveDate!.year,
        lastActiveDate!.month + 1,
        0,
        23,
        59,
        59,
      );
    } else {
      prevStart = DateTime(lastActiveDate!.year, 1, 1);
      prevEnd = DateTime(lastActiveDate!.year, 12, 31, 23, 59, 59);
    }

    double prevVolume = 0;
    double prevMax = 0;
    DateTime? prevMaxDate;
    Set<String> prevSessionDays = {};

    // Рахуємо всі досягнення за той минулий місяць повністю
    _allWorkouts.forEach((dateStr, exercises) {
      final date = DateTime.parse(dateStr);

      if ((date.isAfter(prevStart) || date.isAtSameMomentAs(prevStart)) &&
          (date.isBefore(prevEnd) || date.isAtSameMomentAs(prevEnd))) {
        final matching = exercises.where(
          (ex) => _getCanonicalId(ex, catalog) == targetId,
        );
        if (matching.isNotEmpty) {
          prevSessionDays.add(dateStr.split('T').first);

          for (final ex in matching) {
            for (final s in ex.sets) {
              final w = s.weight ?? 0;
              final r = s.reps ?? 0;
              prevVolume += w * r;

              if (w > prevMax) {
                prevMax = w;
                prevMaxDate = date;
              }
            }
          }
        }
      }
    });

    return _PeriodStats(
      volume: prevVolume,
      maxWeight: prevMax,
      sessions: prevSessionDays.length.toDouble(),
      maxWeightDate: prevMaxDate,
      periodDate: prevStart,
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
    final textTheme = Theme.of(context).textTheme;
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
          style: textTheme.titleMedium,
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
                title: Text(
                  '${loc.setLabelCompact} ${i + 1}',
                  style: textTheme.bodyMedium,
                ),
                subtitle: Text(
                  '${loc.weightLabel}: ${s.weight ?? '-'}  •  ${loc.repsUnit}: ${s.reps ?? '-'}',
                  style: textTheme.bodySmall,
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
    final textTheme = Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context)!.localeName;
    switch (_range) {
      case RangeMode.month:
        return Text('${value.round()}', style: textTheme.bodySmall);
      case RangeMode.year:
        final month = value.round();
        if (month < 1 || month > 12) return const SizedBox();
        final date = DateTime(DateTime.now().year, month);
        final monthShort = DateFormat.MMM(locale).format(date);
        return Text(
          toBeginningOfSentenceCase(monthShort) ?? '',
          style: textTheme.bodySmall,
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

  String _formatPeriodName(DateTime? date, RangeMode range, String locale) {
    final loc = AppLocalizations.of(context)!;
    if (date == null) return loc.previousPeriod;
    if (range == RangeMode.month) {
      final m = DateFormat.MMMM(locale).format(date);
      return "${toBeginningOfSentenceCase(m)} ${date.year}";
    } else {
      return "${date.year}";
    }
  }

  String _formatDate(DateTime? date, String locale) {
    if (date == null) return "";
    return DateFormat.MMMd(locale).format(date); // e.g. "5 бер."
  }

  // 🔥 ОНОВЛЕНИЙ БЕЙДЖ З ЛОГІКОЮ "ПАУЗИ"
  Widget _buildPercentBadge(
    ProgressionData? data,
    AppLocalizations loc, {
    bool isWeight = false,
    required String currentLabel,
    required String prevLabel,
    String? currentSubtext,
    String? prevSubtext,
  }) {
    final textTheme = Theme.of(context).textTheme;
    if (data == null) return const SizedBox();

    final bool isBothZero = data.startValue == 0 && data.currentValue == 0;
    final bool isNewStart = data.startValue == 0 && data.currentValue > 0;
    final bool isPause =
        data.startValue > 0 &&
        data.currentValue == 0; // 🔥 Новий стан: відпочинок
    final bool isZeroChange =
        data.startValue == data.currentValue && data.startValue > 0;
    final bool isPositive = data.currentValue > data.startValue;

    Color color;
    IconData icon;
    String textToShow;

    if (isBothZero) {
      color = Colors.grey.withValues(alpha: 0.5);
      icon = Icons.remove;
      textToShow = '—';
    } else if (isNewStart) {
      color = Colors.blue;
      icon = Icons.flag_circle;
      textToShow = loc.localeName == 'uk' ? 'Старт' : 'Start';
    } else if (isPause) {
      // 🔥 ЛОГІКА ПАУЗИ
      color = Colors.grey;
      icon = Icons.pause_circle_outline;
      textToShow = loc.localeName == 'uk' ? 'Пауза' : 'Pause';
    } else if (isZeroChange) {
      color = Colors.grey;
      icon = Icons.remove;
      textToShow = '0.0%';
    } else {
      color = isPositive ? Colors.green : Colors.red;
      icon = isPositive
          ? Icons.arrow_upward_rounded
          : Icons.arrow_downward_rounded;
      final sign = isPositive ? '+' : '';
      textToShow = '$sign${data.percentage.toStringAsFixed(1)}%';
    }

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(loc.comparisonTitle, style: textTheme.titleMedium),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogRow(
                  prevLabel,
                  formatNumberCompact(data.startValue),
                  isWeight ? loc.weightUnit : '',
                  dateSubtext: prevSubtext,
                ),
                const SizedBox(height: 8),
                _buildDialogRow(
                  currentLabel,
                  formatNumberCompact(data.currentValue),
                  isWeight ? loc.weightUnit : '',
                  dateSubtext: currentSubtext,
                ),
                const Divider(),
                _buildDialogRow(
                  loc.difference,
                  textToShow,
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
            const SizedBox(width: 4),
            Text(
              textToShow,
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

  // Оновлений рядок діалогу, щоб вміщати підпис знизу
  Widget _buildDialogRow(
    String label,
    String value,
    String unit, {
    Color? color,
    bool isBold = false,
    String? dateSubtext,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodySmall),
                if (dateSubtext != null && dateSubtext.isNotEmpty)
                  Text(
                    dateSubtext,
                    style: textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
              ],
            ),
          ),
          Text(
            '$value $unit'.trim(),
            style: (isBold ? textTheme.labelLarge : textTheme.bodyMedium)
                ?.copyWith(
                  color: color ?? Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
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
    final textTheme = Theme.of(context).textTheme;

    _prepareExerciseList(loc);

    final catalog = getExerciseCatalog(loc);
    String targetId = _selectedExerciseDisplay ?? '';
    try {
      targetId = catalog
          .firstWhere((c) => c.name == _selectedExerciseDisplay)
          .id;
    } catch (_) {}

    // --- ДАНІ ПОТОЧНОГО ПЕРІОДУ ---
    final volumeDataRaw = _selectedExerciseDisplay != null
        ? _accumulateVolumePerDay(_selectedExerciseDisplay!, loc)
        : <DateTime, double>{};
    final volumeEntries = _filterEntries(volumeDataRaw);
    final volumeSpots = _buildSpots(volumeEntries);
    final currentVolume = _totalForEntries(volumeEntries);

    final maxWeightDataRaw = _selectedExerciseDisplay != null
        ? _accumulateMaxWeightPerDay(_selectedExerciseDisplay!, loc)
        : <DateTime, double>{};
    final maxWeightEntries = _filterEntries(maxWeightDataRaw);

    double currentMaxWeight = 0.0;
    DateTime? currentMaxWeightDate;
    if (maxWeightEntries.isNotEmpty) {
      final maxEntry = maxWeightEntries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      currentMaxWeight = maxEntry.value;
      currentMaxWeightDate = maxEntry.key;
    }

    final currentSessions = volumeEntries.length.toDouble();

    // --- ДАНІ МИНУЛОГО ПЕРІОДУ ---
    final prevStats = _selectedExerciseDisplay != null
        ? _getPreviousPeriodStats(targetId, catalog)
        : _PeriodStats(volume: 0, maxWeight: 0, sessions: 0);

    // --- ПРОГРЕСІЯ ---
    final volumeProgression = ProgressionData(
      startValue: prevStats.volume,
      currentValue: currentVolume,
    );
    final maxWeightProgression = ProgressionData(
      startValue: prevStats.maxWeight,
      currentValue: currentMaxWeight,
    );
    final sessionProgression = ProgressionData(
      startValue: prevStats.sessions,
      currentValue: currentSessions,
    );

    // --- ДЕТАЛІ ДЛЯ ДІАЛОГІВ ---
    final currentLabel = _formatPeriodName(_visibleMonth, _range, locale);
    final prevLabel = _formatPeriodName(prevStats.periodDate, _range, locale);
    final currentMaxDateStr = _formatDate(currentMaxWeightDate, locale);
    final prevMaxDateStr = _formatDate(prevStats.maxWeightDate, locale);

    // Решта логіки для графіку
    final dynamicInterval = _bottomInterval(volumeSpots.length);
    double maxY = 1;
    for (final s in volumeSpots) {
      if (s.y > maxY) maxY = s.y;
    }
    final double yInterval = (maxY <= 0) ? 1.0 : (maxY / 4).toDouble();

    final Color chartColor = (volumeProgression.isPositive
        ? Colors.green
        : Colors.red);

    String dateLabel = _formatPeriodName(_visibleMonth, _range, locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.chartsTitle, style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(loc.exerciseLabel, style: textTheme.bodyLarge),
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
                          Text(dateLabel, style: textTheme.titleMedium),
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
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : volumeSpots.isEmpty
                  ? Center(
                      child: Text(
                        loc.noDataRange,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
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
                              lineColor: chartColor,
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
                                  color: chartColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  loc.liftedWeight,
                                  style: textTheme.bodyMedium,
                                ),
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

            // TOTALS ROW
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
                  Expanded(
                    child: Column(
                      children: [
                        buildSummaryItem(
                          context: context,
                          label: loc.totalLifted,
                          value: formatNumberCompact(currentVolume),
                          color: chartColor,
                        ),
                        const SizedBox(height: 4),
                        _buildPercentBadge(
                          volumeProgression,
                          loc,
                          currentLabel: currentLabel,
                          prevLabel: prevLabel,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        buildSummaryItem(
                          context: context,
                          label: loc.maxWeight,
                          value:
                              '${formatNumberCompact(currentMaxWeight)} ${loc.weightUnit}',
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(height: 4),
                        _buildPercentBadge(
                          maxWeightProgression,
                          loc,
                          isWeight: true,
                          currentLabel: currentLabel,
                          prevLabel: prevLabel,
                          currentSubtext: currentMaxDateStr,
                          prevSubtext: prevMaxDateStr,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        buildSummaryItem(
                          context: context,
                          label: loc.gymSessions,
                          value: currentSessions.toInt().toString(),
                        ),
                        const SizedBox(height: 4),
                        _buildPercentBadge(
                          sessionProgression,
                          loc,
                          currentLabel: currentLabel,
                          prevLabel: prevLabel,
                        ),
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
