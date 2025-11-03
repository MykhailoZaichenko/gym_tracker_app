import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';

class MonthPickerDialog extends StatefulWidget {
  const MonthPickerDialog({
    required this.initialDate,
    super.key,
    this.title,
    this.cancelLabel = 'Скасувати',
    this.okLabel = 'ОК',
  });

  final DateTime initialDate;
  final String? title;
  final String cancelLabel;
  final String okLabel;

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime initialDate,
  String? title,
  String cancelLabel = 'Скасувати',
  String okLabel = 'ОК',
}) {
  return showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    builder: (_) => MonthPickerDialog(
      initialDate: initialDate,
      title: title,
      cancelLabel: cancelLabel,
      okLabel: okLabel,
    ),
  );
}

class _MonthPickerDialogState extends State<MonthPickerDialog>
    with SingleTickerProviderStateMixin {
  late int _year;
  late int _selectedMonth;
  late final TextEditingController _yearController;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _year = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
    _yearController = TextEditingController(text: _year.toString());
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _yearController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _apply() {
    final parsedYear = int.tryParse(_yearController.text.trim());
    if (parsedYear != null) _year = parsedYear;
    final picked = DateTime(_year, _selectedMonth, 1);
    Navigator.of(context).pop(picked);
  }

  void _changeYear(int delta) {
    setState(() {
      _year += delta;
      _yearController.text = _year.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.title ?? 'Виберіть місяць і рік',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Year selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () => _changeYear(-1),
                  tooltip: 'Попередній рік',
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary.withAlpha(80)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary, width: 2),
                      ),
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () => _changeYear(1),
                  tooltip: 'Наступний рік',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Month chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(12, (i) {
                final month = i + 1;
                final selected = month == _selectedMonth;

                return IntrinsicWidth(
                  child: ChoiceChip(
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    pressElevation: 0,
                    side: BorderSide(
                      color: selected
                          ? theme.colorScheme.primary.withValues(alpha: 0.5)
                          : theme.dividerColor.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    label: Text(
                      ukrainianMonths[i],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight
                            .w500, // fixed weight to avoid width change
                        color: selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    selected: selected,
                    selectedColor: theme.colorScheme.primary.withValues(
                      alpha: 0.15,
                    ),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _selectedMonth = month),
                  ),
                );
              }),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              widget.cancelLabel,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          FilledButton.tonal(
            onPressed: _apply,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(widget.okLabel),
          ),
        ],
      ),
    );
  }
}
