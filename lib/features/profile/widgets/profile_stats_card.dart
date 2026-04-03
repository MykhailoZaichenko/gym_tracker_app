import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/date_constants.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/month_picker_dialog.dart';
import 'package:gym_tracker_app/widget/common/stat_tile_widget.dart';
import 'package:intl/intl.dart';

class ProfileStatsCard extends StatefulWidget {
  const ProfileStatsCard({
    super.key,
    required this.visibleMonth,
    required this.ukMonthLabel,
    required this.avgWorkoutsPerWeek,
    required this.totalMinutes,
    required this.avgMinutes,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onPickMonth,
  });

  final DateTime visibleMonth;
  final String ukMonthLabel;
  final double avgWorkoutsPerWeek;
  final int totalMinutes;
  final int avgMinutes;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final void Function(DateTime newMonth) onPickMonth;

  @override
  State<ProfileStatsCard> createState() => _ProfileStatsCardState();
}

class _ProfileStatsCardState extends State<ProfileStatsCard> {
  late PageController _pageController;
  late final DateTime _baseDate;
  late int _maxPageCount;

  @override
  void initState() {
    super.initState();
    _baseDate = DateConstants.appStartDate;
    final current = DateConstants.currentMonthStart;
    _maxPageCount =
        (current.year - _baseDate.year) * 12 +
        (current.month - _baseDate.month) +
        1;
    final initialIndex = _calculateIndex(widget.visibleMonth);
    _pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: 0.9,
    );
  }

  @override
  void didUpdateWidget(ProfileStatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final current = DateConstants.currentMonthStart;
    _maxPageCount =
        (current.year - _baseDate.year) * 12 +
        (current.month - _baseDate.month) +
        1;
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

  String _formatTotalTime(int minutes, AppLocalizations loc) {
    if (minutes == 0) return '-';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '$hours${loc.hoursShort} $mins${loc.minutesShort}';
    }
    return '$mins ${loc.minutesShort}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final loc = AppLocalizations.of(context)!;

    return SizedBox(
      height: 230,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _maxPageCount,
        clipBehavior: Clip.none,
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
                  height: Curves.easeOut.transform(value) * 230,
                  width: Curves.easeOut.transform(value) * 400,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? theme.colorScheme.surfaceContainer
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                    spreadRadius: isCurrent ? 0 : -2,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: InkWell(
                        onTap: isCurrent
                            ? () async {
                                final result = await showMonthPicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: _baseDate,
                                  lastDate: DateConstants.appMaxDate,
                                );
                                if (result != null) {
                                  final newIndex = _calculateIndex(result);
                                  _pageController.jumpToPage(newIndex);
                                }
                              }
                            : null,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${loc.yourProgressFor} $monthLabel ${date.year}',
                                style: textTheme.titleMedium?.copyWith(
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
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatTile(
                            icon: Icons.calendar_month_outlined,
                            value: isCurrent
                                ? widget.avgWorkoutsPerWeek.toStringAsFixed(1)
                                : '-',
                            label: loc.timesPerWeek, // "разів/тиждень"
                          ),
                          const SizedBox(width: 8),
                          StatTile(
                            icon: Icons.timer_outlined,
                            value: isCurrent
                                ? '${widget.avgMinutes} ${loc.minutesShort}'
                                : '-',
                            label: loc.avarageTimeLabel, // "Середній час"
                          ),
                          const SizedBox(width: 8),
                          StatTile(
                            icon: Icons.access_time,
                            value: isCurrent
                                ? _formatTotalTime(widget.totalMinutes, loc)
                                : '-',
                            label: loc.inGymLabel,
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
