import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/utils.dart';
import 'package:gym_tracker_app/widget/common/month_picker_dialog.dart';

class ProfileStatsCard extends StatefulWidget {
  const ProfileStatsCard({
    super.key,
    required this.visibleMonth,
    required this.ukMonthLabel,
    required this.totalSets,
    required this.totalWeight,
    required this.totalCalories,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onPickMonth,
  });

  final DateTime visibleMonth;
  final String ukMonthLabel;
  final int totalSets;
  final double totalWeight;
  final double totalCalories;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final void Function(DateTime newMonth) onPickMonth;

  @override
  State<ProfileStatsCard> createState() => _ProfileStatsCardState();
}

class _ProfileStatsCardState extends State<ProfileStatsCard> {
  bool isForward = true;

  void _handlePrev() {
    setState(() => isForward = false);
    widget.onPrevMonth();
  }

  void _handleNext() {
    setState(() => isForward = true);
    widget.onNextMonth();
  }

  void _handlePick(DateTime newMonth) {
    setState(() => isForward = newMonth.isAfter(widget.visibleMonth));
    widget.onPickMonth(newMonth);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthLabel =
        '${widget.visibleMonth.year} - ${widget.visibleMonth.month.toString().padLeft(2, '0')}';

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < -100) {
          _handleNext();
        } else if (velocity > 100) {
          _handlePrev();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.primary.withAlpha(25),
            width: 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              final offset = isForward
                  ? const Offset(0.2, 0)
                  : const Offset(-0.2, 0);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: offset,
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Column(
              key: ValueKey(
                '${widget.visibleMonth.year}-${widget.visibleMonth.month}',
              ),
              children: [
                // 🔽 Заголовок з вибором місяця
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        final result = await showMonthPicker(
                          context: context,
                          initialDate: widget.visibleMonth,
                        );
                        if (result != null) {
                          _handlePick(result);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Semantics(
                          button: true,
                          label: 'Вибрати місяць',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ваш прогрес за ${widget.ukMonthLabel} ${widget.visibleMonth.year}',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔁 Навігація по місяцях
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _handlePrev,
                      ),
                      Row(
                        children: [
                          Text(monthLabel, style: theme.textTheme.titleMedium),
                          const SizedBox(width: 6),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _handleNext,
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),

                // 📊 Статистика
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
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.totalSets.toString(),
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Підходів',
                                style: theme.textTheme.bodySmall,
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
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatNumberCompact(widget.totalWeight),
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Вага (kg·reps)',
                                style: theme.textTheme.bodySmall,
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
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${formatNumberCompact(widget.totalCalories)} ккал',
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text('Калорії', style: theme.textTheme.bodySmall),
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
        ),
      ),
    );
  }
}
