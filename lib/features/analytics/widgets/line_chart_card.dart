import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';

class ProgressLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double maxY;
  final double yInterval;
  final RangeMode range;
  final double Function() bottomInterval;
  final Widget Function(double) buildBottomTitle;
  final String Function(double) formatY;
  final void Function(double x)? onPointTap;
  final Color lineColor;

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
    required this.lineColor,
  });

  Map<String, double> get yBounds => computeYBounds(spots);
  Map<String, double> get xBounds => computeXBounds(spots);

  double computeMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0.0;

    final ys = spots.map((s) => s.y).toList()..sort();
    final lowIndex = (ys.length * 0.05).floor().clamp(0, ys.length - 1);
    return ys[lowIndex];
  }

  double computeMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 1.0;

    final ys = spots.map((s) => s.y).toList()..sort();
    final highIndex = (ys.length * 0.95).floor().clamp(0, ys.length - 1);
    return ys[highIndex];
  }

  Map<String, double> computeYBounds(List<FlSpot> spots) {
    if (spots.isEmpty) return {'min': 0.0, 'max': 1.0};

    final rawMin = computeMinY(spots);
    final rawMax = computeMaxY(spots);

    if ((rawMax - rawMin).abs() < 1e-9) {
      final v = rawMax;
      final delta = (v.abs() < 1e-6) ? 1.0 : v.abs() * 0.05;
      return {'min': v - delta, 'max': v + delta};
    }

    final paddingRel = 0.1;
    final minWithPad = rawMin - (rawMax - rawMin) * paddingRel;
    final maxWithPad = rawMax + (rawMax - rawMin) * paddingRel;

    final minY = minWithPad < 0 ? 0 : minWithPad; // prevent negatives
    final maxY = maxWithPad;

    if (minY >= maxY) {
      final mid = (rawMin + rawMax) / 2.0;
      return {'min': (mid - 1.0).toDouble(), 'max': (mid + 1.0).toDouble()};
    }

    return {'min': minY.toDouble(), 'max': maxY.toDouble()};
  }

  // New: compute dynamic X bounds from spots (clamped to typical month range 1..31)
  Map<String, double> computeXBounds(List<FlSpot> spots) {
    if (spots.isEmpty) return {'min': 1.0, 'max': 31.0};

    final xs = spots.map((s) => s.x).toList()..sort();
    final rawMin = xs.first;
    final rawMax = xs.last;

    // If all x equal, give a small neighborhood
    if ((rawMax - rawMin).abs() < 1e-9) {
      final v = rawMax;
      final min = (v - 1.0).clamp(1.0, 31.0);
      final max = (v + 1.0).clamp(1.0, 31.0);
      return {'min': min, 'max': max};
    }

    // Small absolute padding (half a day) and small relative padding (5%)
    final pad = (rawMax - rawMin) * 0.05;
    final padAbs = 0.5;
    final usedPad = pad > padAbs ? pad : padAbs;

    final minWithPad = (rawMin - usedPad).clamp(1.0, rawMin);
    final maxWithPad = (rawMax + usedPad).clamp(rawMax, 31.0);

    if (minWithPad >= maxWithPad) {
      final min = (rawMin - 1.0).clamp(1.0, 31.0);
      final max = (rawMax + 1.0).clamp(1.0, 31.0);
      return {'min': min, 'max': max};
    }

    return {'min': minWithPad, 'max': maxWithPad};
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        height: maxY + 50,
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  reservedSize: 40,
                  maxIncluded: range == RangeMode.month ? true : false,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false, reservedSize: 40),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: bottomInterval(),
                  getTitlesWidget: (val, meta) => Transform.rotate(
                    angle: -0.5,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                      ),
                      child: buildBottomTitle(val),
                    ),
                  ),
                  reservedSize: 32,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: bottomInterval(),
                  getTitlesWidget: (val, meta) => Transform.rotate(
                    angle: -0.5, // Adjust the angle (in radians) as needed
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                      ),
                      child: buildBottomTitle(val),
                    ),
                  ),
                  reservedSize: 32,
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: lineColor,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter:
                      (
                        FlSpot spot,
                        double percent,
                        LineChartBarData bar,
                        int index,
                      ) => FlDotCirclePainter(
                        radius: 4,
                        color: Theme.of(
                          context,
                        ).scaffoldBackgroundColor, // fill = background
                        strokeWidth: 2,
                        strokeColor: lineColor, // outline = bar color
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  // градієнт з прозорістю
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.4),
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),

                  // або однотонний колір:
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    return LineTooltipItem(
                      '${touchedSpot.y}', // the text you want to show
                      TextStyle(
                        color: ThemeService.isDarkModeNotifier.value == true
                            ? Colors.white
                            : Colors
                                  .black, // <-- change tooltip text color here
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }).toList();
                },
              ),
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
            ),
          ),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
