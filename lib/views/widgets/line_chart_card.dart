// 1. Create a new widget file, e.g. lib/views/widgets/progress_line_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// enum RangeMode { month, year }

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

class ProgressLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double maxY;
  final double yInterval;
  final range;
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LineChart(
        LineChartData(
          // minX: 1,
          // maxX: range == RangeMode.month
          //     ? 30
          //     : daysInMonth(
          //         DateTime.now().year,
          //         DateTime.now().month,
          //       ).toDouble(),
          minY: (spots.isEmpty || spots.first.y <= 0)
              ? 0
              : spots.first.y * 0.85,
          maxY: (spots.isEmpty || maxY <= 0) ? 1 : maxY * 1.15,
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
