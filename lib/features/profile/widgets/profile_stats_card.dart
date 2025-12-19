import 'package:flutter/material.dart';
import 'package:gym_tracker_app/utils/utils.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/month_picker_dialog.dart';
import 'package:gym_tracker_app/widget/common/stat_tile_widget.dart';
import 'package:intl/intl.dart';

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
  late PageController _pageController;

  // Базова дата для розрахунку індексу (січень 2024)
  final DateTime _baseDate = DateTime(2024, 1, 1);
  late int _maxPageCount;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _maxPageCount =
        (now.year - _baseDate.year) * 12 + (now.month - _baseDate.month) + 1;
    final initialIndex = _calculateIndex(widget.visibleMonth);
    _pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: 0.925,
    );
  }

  @override
  void didUpdateWidget(ProfileStatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final now = DateTime.now();
    _maxPageCount =
        (now.year - _baseDate.year) * 12 + (now.month - _baseDate.month) + 1;
    if (oldWidget.visibleMonth != widget.visibleMonth) {
      final newIndex = _calculateIndex(widget.visibleMonth);
      if (_pageController.hasClients &&
          _pageController.page?.round() != newIndex) {
        _pageController.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _calculateIndex(DateTime date) {
    final index =
        (date.year - _baseDate.year) * 12 + (date.month - _baseDate.month);
    return index < 0 ? 0 : index;
  }

  DateTime _calculateDate(int index) {
    return DateTime(_baseDate.year, _baseDate.month + index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return SizedBox(
      height: 270,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _maxPageCount,
        onPageChanged: (index) {
          final newDate = _calculateDate(index);
          widget.onPickMonth(newDate);
        },
        itemBuilder: (context, index) {
          final date = _calculateDate(index);
          final isCurrent =
              date.year == widget.visibleMonth.year &&
              date.month == widget.visibleMonth.month;

          String monthLabel;
          if (isCurrent) {
            monthLabel = widget.ukMonthLabel;
          } else {
            monthLabel = DateFormat('MMMM', loc.localeName).format(date);
            monthLabel = toBeginningOfSentenceCase(monthLabel) ?? monthLabel;
          }

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.1)).clamp(0.95, 1.0);
              }
              return Center(
                child: SizedBox(
                  height: Curves.easeOut.transform(value) * 270,
                  width: Curves.easeOut.transform(value) * 400,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 8,
              ), // Відступи між картками
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isCurrent
                      ? theme.colorScheme.primary.withAlpha(50)
                      : theme.dividerColor.withAlpha(20),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔽 Заголовок з вибором місяця
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: InkWell(
                        onTap: isCurrent
                            ? () async {
                                final now = DateTime.now();
                                final result = await showMonthPicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: _baseDate,
                                  lastDate: DateTime(
                                    now.year,
                                    now.month + 1,
                                    0,
                                  ),
                                );
                                if (result != null) {
                                  // Переходимо на вибраний місяць
                                  final newIndex = _calculateIndex(result);
                                  _pageController.jumpToPage(newIndex);
                                }
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${loc.yourProgressFor} $monthLabel ${date.year}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isCurrent ? null : Colors.grey,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // const Divider(height: 20, thickness: 0.5),
                    const SizedBox(height: 10),

                    // 📊 Статистика
                    Expanded(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatTile(
                            icon: Icons.fitness_center,
                            // Якщо це не активна картка, показуємо прочерк, бо даних ще немає
                            value: isCurrent
                                ? widget.totalSets.toString()
                                : '-',
                            label: isCurrent
                                ? loc.setsCount(widget.totalSets)
                                : loc.setsCount(0).replaceAll('0', ''),
                          ),
                          const SizedBox(width: 8),
                          StatTile(
                            icon: Icons.square_foot,
                            value: isCurrent
                                ? formatNumberCompact(widget.totalWeight)
                                : '-',
                            label: '${loc.weightLabel} (${loc.weightUnit})',
                          ),
                          const SizedBox(width: 8),
                          StatTile(
                            icon: Icons.local_fire_department,
                            value: isCurrent
                                ? loc
                                      .caloriesCount(
                                        formatNumberCompact(
                                          widget.totalCalories,
                                        ),
                                      )
                                      .replaceAll(
                                        RegExp(r'[^0-9]'),
                                        '',
                                      ) // Тільки число
                                : '-',
                            label: loc.calories,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
