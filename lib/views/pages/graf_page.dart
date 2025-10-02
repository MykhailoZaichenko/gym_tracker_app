// lib/views/pages/graf_page.dart
//
// Сторінка графіків прогресу (без тижня):
// - Dropdown для вибору вправи
// - Tabs: Місяць / Рік
// - Перелистування місяців у режимі Місяць
// - X: дні місяця / місяці; Y: сумарна піднята вага за день (sum(weight * reps))
// - Тап по точці відкриває діалог зі списком сетів (вага і повтори)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_tracker_app/views/widgets/line_chart_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RangeMode { month, year }

class GrafPage extends StatefulWidget {
  const GrafPage({Key? key}) : super(key: key);

  @override
  _GrafPageState createState() => _GrafPageState();
}

class _GrafPageState extends State<GrafPage> with TickerProviderStateMixin {
  Map<String, List<WorkoutExerciseGraf>> _allWorkouts = {};
  bool _isLoading = true;

  List<String> _exerciseNames = [];
  String? _selectedExerciseName;

  RangeMode _range = RangeMode.month;
  late TabController _tabController;

  // only used for month view navigation
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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('all_workouts');
    if (raw != null) {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      _allWorkouts = decoded.map((key, value) {
        final list = (value as List<dynamic>)
            .map(
              (item) =>
                  WorkoutExerciseGraf.fromMap(item as Map<String, dynamic>),
            )
            .toList();
        return MapEntry(key, list);
      });
    } else {
      _allWorkouts = {};
    }

    _collectExerciseNames();
    setState(() => _isLoading = false);
  }

  void _collectExerciseNames() {
    final names = <String>{};
    for (final list in _allWorkouts.values) {
      for (final e in list) {
        final n = e.name.trim();
        if (n.isNotEmpty) names.add(n);
      }
    }
    _exerciseNames = names.toList()..sort();
    if (_exerciseNames.isNotEmpty && _selectedExerciseName == null) {
      _selectedExerciseName = _exerciseNames.first;
    }
  }

  /// Для заданої вправи повертає мапу: DateTime (date at midnight) -> сумарна поднята вага за день
  Map<DateTime, double> _accumulatePerDay(String exerciseName) {
    final Map<DateTime, double> result = {};
    _allWorkouts.forEach((dateStr, exercises) {
      final date = DateTime.parse(dateStr);
      final ex = exercises.firstWhere(
        (e) => e.name == exerciseName,
        orElse: () => WorkoutExerciseGraf(name: '', sets: []),
      );
      if (ex.name.isEmpty) return;
      double sum = 0;
      for (final s in ex.sets) {
        final w = s.weight ?? 0;
        final r = s.reps ?? 0;
        sum += w * r;
      }
      final dayKey = DateTime(date.year, date.month, date.day);
      result[dayKey] = (result[dayKey] ?? 0) + sum;
    });
    return result;
  }

  List<MapEntry<DateTime, double>> _filteredEntriesForRange() {
    if (_selectedExerciseName == null) return [];
    final acc = _accumulatePerDay(_selectedExerciseName!);
    final now = DateTime.now();
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
        final yearStart = DateTime(now.year, 1, 1);
        final yearEnd = DateTime(now.year, 12, 31);
        entries = entries.where(
          (e) => !e.key.isBefore(yearStart) && !e.key.isAfter(yearEnd),
        );
        break;
    }

    final sorted = entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return sorted;
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
        for (final m in months) spots.add(FlSpot(m.key.toDouble(), m.value));
        break;
    }
    return spots;
  }

  String _formatY(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    if (v == v.floorToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(0);
  }

  // отримати дату з координати X (для тапу по точці)
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
    final key =
        '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    final exList = _allWorkouts[key] ?? [];
    final ex = exList.firstWhere(
      (e) => e.name == _selectedExerciseName,
      orElse: () => WorkoutExerciseGraf(name: '', sets: []),
    );
    if (ex.name.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${ex.name} — $key'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: ex.sets.length,
            separatorBuilder: (_, __) => const Divider(height: 8),
            itemBuilder: (_, i) {
              final s = ex.sets[i];
              return ListTile(
                title: Text('Підхід ${i + 1}'),
                subtitle: Text(
                  'Вага: ${s.weight ?? '-'} кг  •  Повт.: ${s.reps ?? '-'}',
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрити'),
          ),
        ],
      ),
    );
  }

  void _prevMonth() {
    setState(
      () => _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month - 1,
        1,
      ),
    );
  }

  void _nextMonth() {
    setState(
      () => _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + 1,
        1,
      ),
    );
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
    switch (_range) {
      case RangeMode.month:
        return Text('${value.round()}', style: const TextStyle(fontSize: 11));
      case RangeMode.year:
        const months = [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        final m = value.round();
        return Text(
          (m >= 1 && m <= 12) ? months[m] : m.toString(),
          style: const TextStyle(fontSize: 11),
        );
    }
  }

  double _totalForEntries(List<MapEntry<DateTime, double>> entries) {
    double s = 0;
    for (final e in entries) s += e.value;
    return s;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final entries = _filteredEntriesForRange();
    final spots = _buildSpots(entries);

    double maxY = 1;
    for (final s in spots) if (s.y > maxY) maxY = s.y;
    final double yInterval = (maxY <= 0) ? 1.0 : (maxY / 4).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Прогрес — графіки'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Вправа:'),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedExerciseName,
                    hint: const Text('Оберіть вправу'),
                    items: _exerciseNames
                        .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedExerciseName = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              tabs: const [
                Tab(text: 'Місяць'),
                Tab(text: 'Рік'),
              ],
            ),
            const SizedBox(height: 8),
            if (_range == RangeMode.month)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _prevMonth,
                  ),
                  Text(
                    '${_visibleMonth.year} - ${_visibleMonth.month.toString().padLeft(2, '0')}',
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Expanded(
              child: _selectedExerciseName == null
                  ? Center(
                      child: Text(
                        'Додайте вправи у календарі, щоб бачити графік',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    )
                  : spots.isEmpty
                  ? Center(
                      child: Text(
                        'Немає даних для вибраної вправи у цьому діапазоні',
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
                              formatY: _formatY,
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
                                const Text('Піднята вага'),
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
                    'Всього піднято: ${_formatY(_totalForEntries(entries))}',
                  ),
                  Text('Точек: ${entries.length}'),
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

/// Модельні класи (як у вас раніше)
class WorkoutExerciseGraf {
  String name;
  List<SetData> sets;

  WorkoutExerciseGraf({required this.name, required this.sets});

  factory WorkoutExerciseGraf.fromMap(Map<String, dynamic> m) {
    return WorkoutExerciseGraf(
      name: m['name'] as String? ?? '',
      sets: (m['sets'] as List<dynamic>? ?? [])
          .map((e) => SetData.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
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
