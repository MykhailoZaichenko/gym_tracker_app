import 'package:flutter/material.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({
    Key? key,
    required this.visibleMonth,
    required this.ukMonthLabel,
    required this.totalSets,
    required this.totalWeight,
    required this.totalCalories,
    required this.onPrevMonth,
    required this.onNextMonth,
  }) : super(key: key);

  final DateTime visibleMonth;
  final String ukMonthLabel;
  final int totalSets;
  final double totalWeight;
  final double totalCalories;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  String _formatNumber(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel =
        '${visibleMonth.year} - ${visibleMonth.month.toString().padLeft(2, '0')}';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Ваш прогрес за $ukMonthLabel ${visibleMonth.year}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            // month navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.swipe_left,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                    size: 24,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: onPrevMonth,
                      ),
                      Text(
                        monthLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: onNextMonth,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.swipe_right,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                    size: 24,
                  ),
                ],
              ),
            ),

            // stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            totalSets.toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Підходів',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.square_foot,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatNumber(totalWeight),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Вага (kg·reps)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_formatNumber(totalCalories)} ккал',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Калорії',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
