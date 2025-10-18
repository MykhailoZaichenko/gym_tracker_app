import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/constants.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({
    super.key,
    required this.visibleMonth,
    required this.ukMonthLabel,
    required this.totalSets,
    required this.totalWeight,
    required this.totalCalories,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onPickMonth, // викликається при виборі місяця/року у діалозі
  });

  final DateTime visibleMonth;
  final String ukMonthLabel;
  final int totalSets;
  final double totalWeight;
  final double totalCalories;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final void Function(DateTime newMonth) onPickMonth;

  String _formatNumber(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1);
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    final result = await showDialog<DateTime>(
      context: context,
      builder: (ctx) {
        return _MonthPickerDialog(initialDate: visibleMonth);
      },
    );

    if (result != null) {
      onPickMonth(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel =
        '${visibleMonth.year} - ${visibleMonth.month.toString().padLeft(2, '0')}';
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () => _showMonthPicker(context),
                child: Semantics(
                  button: true,
                  label: 'Вибрати місяць',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ваш прогрес за $ukMonthLabel ${visibleMonth.year}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),

            // month navigation: removed swipe icons, left/right arrows remain
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ліворуч місце для балансу (тут можна додати щось пізніше)
                  const SizedBox(width: 24),

                  // центральна частина: стрілки + tappable month label
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: onPrevMonth,
                  ),
                  Row(
                    children: [
                      Text(
                        monthLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: onNextMonth,
                  ),

                  // праворуч замість swipe-іконки просто порожній контейнер або future control
                  const SizedBox(width: 24),
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

/// Діалог вибору місяця + року.
/// Показує 12 кнопок для місяців і контрол для року (мінус/плюс + ввід).
class _MonthPickerDialog extends StatefulWidget {
  const _MonthPickerDialog({required this.initialDate});

  final DateTime initialDate;

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late int _year;
  late int _selectedMonth; // 1..12
  final _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _year = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
    _yearController.text = _year.toString();
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  void _apply() {
    final parsedYear = int.tryParse(_yearController.text.trim());
    if (parsedYear != null) _year = parsedYear;
    final picked = DateTime(_year, _selectedMonth, 1);
    Navigator.of(context).pop(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text('Виберіть місяць і рік'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // year control
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() {
                  _year -= 1;
                  _yearController.text = _year.toString();
                }),
              ),
              SizedBox(
                width: 84,
                child: TextField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  onSubmitted: (_) {
                    final parsed = int.tryParse(_yearController.text.trim());
                    if (parsed != null) {
                      setState(() => _year = parsed);
                    } else {
                      _yearController.text = _year.toString();
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() {
                  _year += 1;
                  _yearController.text = _year.toString();
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // months grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(12, (i) {
              final month = i + 1;
              final selected = month == _selectedMonth;
              return ChoiceChip(
                label: Text(ukrainianMonths[i]),
                selected: selected,
                onSelected: (_) => setState(() => _selectedMonth = month),
                selectedColor: theme.colorScheme.primary.withValues(
                  alpha: 0.14,
                ),
                labelStyle: TextStyle(
                  color: selected ? theme.colorScheme.primary : null,
                ),
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // відміна
          child: const Text('Скасувати'),
        ),
        TextButton(onPressed: _apply, child: const Text('ОК')),
      ],
    );
  }
}
