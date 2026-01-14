import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/health/models/body_weight_model.dart';
import 'package:gym_tracker_app/features/health/widgets/weight_entry_dialog.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/services/notification_service.dart';
import 'package:gym_tracker_app/widget/common/fading_edge.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final FirestoreService _firestore = FirestoreService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _handleWeightEntry(List<BodyWeightModel> history) async {
    final today = DateTime.now();
    final existingEntry = history.firstWhere(
      (e) => _isSameDay(e.date, today),
      orElse: () => BodyWeightModel(id: '', date: today, weight: 0),
    );

    final isEditing = existingEntry.weight > 0;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => WeightEntryDialog(
        initialDate: existingEntry.date,
        initialWeight: isEditing ? existingEntry.weight : null,
        isEditing: isEditing,
      ),
    );

    if (result != null) {
      final model = BodyWeightModel(
        id: '',
        date: result['date'],
        weight: result['weight'],
        unit: result['unit'],
      );
      await _firestore.saveBodyWeight(model);
    }
  }

  void _editOldEntry(BodyWeightModel entry) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => WeightEntryDialog(
        initialDate: entry.date,
        initialWeight: entry.weight,
        isEditing: true,
      ),
    );

    if (result != null) {
      final model = BodyWeightModel(
        id: '',
        date: result['date'],
        weight: result['weight'],
        unit: result['unit'],
      );
      await _firestore.saveBodyWeight(model);
    }
  }

  void _configureReminder() async {
    final loc = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final savedDaysStr = prefs.getString('reminder_days') ?? "";
    Set<int> selectedDays = savedDaysStr.isNotEmpty
        ? savedDaysStr.split(',').map(int.parse).toSet()
        : {};
    int timeMinutes = prefs.getInt('reminder_time') ?? (10 * 60 + 30);

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final timeOfDay = TimeOfDay(
              hour: timeMinutes ~/ 60,
              minute: timeMinutes % 60,
            );
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.reminderSettings,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    loc.selectDay,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (index) {
                      final dayNum = index + 1;
                      final isSelected = selectedDays.contains(dayNum);
                      final dayName = DateFormat.E(
                        loc.localeName,
                      ).format(DateTime(2024, 1, dayNum));
                      return FilterChip(
                        label: Text(dayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setSheetState(() {
                            if (selected) {
                              selectedDays.add(dayNum);
                            } else {
                              selectedDays.remove(dayNum);
                            }
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    loc.selectTime,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      timeOfDay.format(sheetContext),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final newTime = await showTimePicker(
                        context: sheetContext,
                        initialTime: timeOfDay,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (newTime != null) {
                        setSheetState(() {
                          timeMinutes = newTime.hour * 60 + newTime.minute;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          sheetContext,
                        ).colorScheme.primary,
                        foregroundColor: Theme.of(
                          sheetContext,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await prefs.setString(
                          'reminder_days',
                          selectedDays.join(','),
                        );
                        await prefs.setInt('reminder_time', timeMinutes);
                        if (selectedDays.isEmpty) {
                          await _notificationService.cancelWeightReminders();
                        } else {
                          await _notificationService.scheduleRemindersForDays(
                            days: selectedDays.toList(),
                            hour: timeMinutes ~/ 60,
                            minute: timeMinutes % 60,
                            title: loc.appName,
                            body: loc.addWeight,
                          );
                        }
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loc.saveSettings)),
                          );
                        }
                      },
                      child: Text(loc.saveSettings),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.healthTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: _configureReminder,
            tooltip: loc.reminderSettings,
          ),
        ],
      ),
      body: StreamBuilder<List<BodyWeightModel>>(
        stream: _firestore.getBodyWeightHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];
          final currentWeight = data.isNotEmpty ? data.last.weight : 0.0;

          // --- ЛОГІКА СТАТИСТИКИ ---
          String diffText = "--";
          double percentChange = 0.0;
          Color statusColor = Colors.grey;
          String dateRangeText = "";

          if (data.length >= 2) {
            final firstDate = data.first.date;
            final lastDate = data.last.date;
            final dateFormat = DateFormat('dd.MM.yyyy');

            dateRangeText =
                "${dateFormat.format(firstDate)} - ${dateFormat.format(lastDate)}";

            final startWeight = data.first.weight;
            final diff = currentWeight - startWeight;

            if (startWeight != 0) {
              percentChange = (diff / startWeight) * 100;
            }

            if (diff > 0) {
              diffText = "+${diff.toStringAsFixed(1)}";
              statusColor = Colors.green; // Ріст
            } else if (diff < 0) {
              diffText = diff.toStringAsFixed(1);
              statusColor = Colors.red; // Спад
            } else {
              diffText = "0.0";
              statusColor = Colors.orange;
            }
          }

          final isTodayEntry =
              data.isNotEmpty && _isSameDay(data.last.date, DateTime.now());

          final historyList = List.of(data).reversed.toList();

          return Column(
            children: [
              //ВЕРХНЯ ЧАСТИНА (НЕ СКРОЛИТЬСЯ)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Стискаємо
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.weightLabel,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _handleWeightEntry(data),
                            child: Text(
                              isTodayEntry
                                  ? loc.editWeight.toUpperCase()
                                  : loc.addWeight.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.currentValue,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    currentWeight.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    loc.weightUnit,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // ПРАВА ЧАСТИНА
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (dateRangeText.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Text(
                                    dateRangeText,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              Row(
                                children: [
                                  if (data.length >= 2)
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            percentChange >= 0
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward,
                                            size: 12,
                                            color: statusColor,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            "${percentChange.abs().toStringAsFixed(1)}%",
                                            style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      diffText,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 200,
                        child: data.isEmpty
                            ? Center(child: Text(loc.noDataRange))
                            : _buildChart(data, theme, statusColor),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔥 ЗАГОЛОВОК ІСТОРІЇ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    loc.history,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 🔥 СПИСОК ІСТОРІЇ (СКРОЛИТЬСЯ ОКРЕМО)
              Expanded(
                child: data.isEmpty
                    ? const SizedBox()
                    : FadingEdge(
                        startFadeSize: 0.05,
                        endFadeSize: 0.1,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                          itemCount: historyList.length,
                          itemBuilder: (context, index) {
                            final entry = historyList[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 0,
                              color: theme.cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                onTap: () => _editOldEntry(entry),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.monitor_weight_outlined,
                                    size: 20,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                title: Text(
                                  "${entry.weight} ${loc.weightUnit}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat.yMMMMd(
                                    loc.localeName,
                                  ).format(entry.date),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                trailing: const Icon(
                                  Icons.edit_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChart(
    List<BodyWeightModel> data,
    ThemeData theme,
    Color lineColor,
  ) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].weight));
    }

    double minY = data.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 1;
    double maxY = data.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 1;

    // Розумний інтервал для осі X
    double xInterval = data.length > 5 ? (data.length / 5).ceilToDouble() : 1.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('d MMM', 'uk').format(data[index].date),
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: theme.scaffoldBackgroundColor,
                  strokeWidth: 2,
                  strokeColor: lineColor,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  lineColor.withValues(alpha: 0.3),
                  lineColor.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
