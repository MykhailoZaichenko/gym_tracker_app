//todo make x bounds dynamic based on range mode and data
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_tracker_app/data/constants.dart';

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

class ProgressLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double maxY;
  final double yInterval;
  final RangeMode range;
  final double Function() bottomInterval;
  final Widget Function(double) buildBottomTitle;
  final String Function(double) formatY;
  final void Function(double x)? onPointTap;

  const ProgressLineChart({
    super.key,
    required this.spots,
    required this.maxY,
    required this.yInterval,
    required this.range,
    required this.bottomInterval,
    required this.buildBottomTitle,
    required this.formatY,
    this.onPointTap,
  });

  Map<String, double> get yBounds => computeYBounds(spots);

  double computeMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0.0;

    final ys = spots.map((s) => s.y).toList()..sort();
    // відкидаємо зовсім малі виброси: беремо 5-й перцентиль як нижню межу
    final lowIndex = (ys.length * 0.05).floor().clamp(0, ys.length - 1);
    return ys[lowIndex];
  }

  double computeMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 1.0;

    final ys = spots.map((s) => s.y).toList()..sort();
    // верхній перцентиль (95%)
    final highIndex = (ys.length * 0.95).floor().clamp(0, ys.length - 1);
    return ys[highIndex];
  }

  Map<String, double> computeYBounds(List<FlSpot> spots) {
    if (spots.isEmpty) return {'min': 0.0, 'max': 1.0};

    final rawMin = computeMinY(spots);
    final rawMax = computeMaxY(spots);

    // Якщо весь набір однаковий — задаємо невеликий діапазон навколо значення
    if ((rawMax - rawMin).abs() < 1e-9) {
      final v = rawMax;
      final delta = (v.abs() < 1e-6)
          ? 1.0
          : v.abs() * 0.05; // 5% або 1 якщо нуль
      return {'min': v - delta, 'max': v + delta};
    }

    // Відносний паддінг (5%) і абсолютний мін/макс паддінг
    final paddingRel = 0.05;
    final minWithPad = rawMin - (rawMax - rawMin) * paddingRel;
    final maxWithPad = rawMax + (rawMax - rawMin) * paddingRel;

    // Захист від занадто малого / великого
    final minClamp = rawMin - 1000.0; // за потреби зменшити
    final maxClamp = rawMax + 1000.0;

    // Остаточні межі
    final minY = minWithPad.clamp(
      minClamp,
      rawMin,
    ); // не даємо стрибнути нижче занадто сильно
    final maxY = maxWithPad.clamp(
      rawMax,
      maxClamp,
    ); // і не даємо стрибнути вище занадто сильно

    // Додатково переконаємось, що minY < maxY
    if (minY >= maxY) {
      final mid = (rawMin + rawMax) / 2.0;
      return {'min': mid - 1.0, 'max': mid + 1.0};
    }

    return {'min': minY, 'max': maxY};
  }

  int daysInMonth(int year, int month) {
    final nextMonth = (month == 12)
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  Map<String, double> computeXBounds({
    required List<FlSpot> spots,
    required RangeMode range,
    DateTime? referenceDate,
    double minClamp = 1.0,
    double maxClamp = 3650.0,
  }) {
    final ref = referenceDate ?? DateTime.now();

    final monthDays = daysInMonth(ref.year, ref.month).toDouble();

    if (spots.isEmpty) {
      final defaultMax = (range == RangeMode.month) ? monthDays : 30.0;
      return {
        'min': 1.0.clamp(minClamp, maxClamp),
        'max': defaultMax.clamp(minClamp, maxClamp),
      };
    }

    final xs = spots.map((s) => s.x).toList()..sort();
    final lowIdx = (xs.length * 0.01).floor().clamp(0, xs.length - 1);
    final highIdx = (xs.length * 0.99).floor().clamp(0, xs.length - 1);
    final rawMin = xs[lowIdx];
    final rawMax = xs[highIdx];

    if ((rawMax - rawMin).abs() < 1e-9) {
      final v = rawMax;
      final delta = (v.abs() < 1e-6)
          ? 1.0
          : (v.abs() * 0.05).clamp(1.0, double.infinity);
      final minX = (v - delta).clamp(minClamp, maxClamp);
      final maxX = (v + delta).clamp(minClamp, maxClamp);
      return {'min': minX, 'max': maxX};
    }

    double desiredMax;
    if (range == RangeMode.month) {
      desiredMax = math.max(monthDays, rawMax);
    } else {
      desiredMax = rawMax + (rawMax - rawMin) * 0.05;
    }

    double desiredMin = math.min(1.0, rawMin - (rawMax - rawMin) * 0.05);

    final minX = desiredMin.clamp(minClamp, maxClamp);
    final maxX = desiredMax.clamp(minClamp, maxClamp);

    if (minX >= maxX) {
      final mid = (rawMin + rawMax) / 2.0;
      return {
        'min': (mid - 1.0).clamp(minClamp, maxClamp),
        'max': (mid + 1.0).clamp(minClamp, maxClamp),
      };
    }

    return {'min': minX, 'max': maxX};
  }

  @override
  Widget build(BuildContext context) {
    final xBounds = computeXBounds(spots: spots, range: range);
    return Expanded(
      child: LineChart(
        LineChartData(
          minX: xBounds['min']!,
          maxX: xBounds['max']!,

          minY: yBounds['min']!,
          maxY: yBounds['max']!,

          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // interval: yInterval,
                getTitlesWidget: (val, meta) => Transform.rotate(
                  angle: -0.5,
                  child: Text(
                    formatY(val),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                reservedSize: 40,
                minIncluded: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 40),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: bottomInterval(),
                getTitlesWidget: (val, meta) =>
                    Transform.rotate(angle: -0.5, child: buildBottomTitle(val)),
                reservedSize: 32,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: bottomInterval(),
                getTitlesWidget: (val, meta) => Transform.rotate(
                  angle: -0.5, // Adjust the angle (in radians) as needed
                  child: buildBottomTitle(val),
                ),
                reservedSize: 32,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
          lineTouchData: LineTouchData(
            touchCallback: (event, response) {
              if (event is FlTapUpEvent &&
                  response != null &&
                  response.lineBarSpots != null &&
                  response.lineBarSpots!.isNotEmpty) {
                final touched = response.lineBarSpots!.first;
                final x = touched.x;
                if (onPointTap != null) onPointTap!(x);
              }
            },
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }
}
