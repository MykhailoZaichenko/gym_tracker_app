import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class MonthPickerDialog extends StatefulWidget {
  const MonthPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.title,
    this.cancelLabel,
    this.okLabel,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? title;
  final String? cancelLabel;
  final String? okLabel;

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime initialDate,

  DateTime? firstDate,
  DateTime? lastDate,
  String? title,
  String? cancelLabel,
  String? okLabel,
}) {
  final loc = AppLocalizations.of(context)!;
  final now = DateTime.now();
  final start = firstDate ?? DateTime(2024, 1);
  final end = lastDate ?? DateTime(now.year, 12);
  return showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    builder: (_) => MonthPickerDialog(
      initialDate: initialDate,
      firstDate: start,
      lastDate: end,
      title: title,
      cancelLabel: cancelLabel = loc.cancel,
      okLabel: okLabel = loc.ok,
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
    if (_year < widget.firstDate.year) _year = widget.firstDate.year;
    if (_year > widget.lastDate.year) _year = widget.lastDate.year;
    _yearController = TextEditingController(text: _year.toString());
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
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
    if (!_isMonthSelectable(_year, _selectedMonth)) return;
    final picked = DateTime(_year, _selectedMonth, 1);
    Navigator.of(context).pop(picked);
  }

  void _changeYear(int delta) {
    final newYear = _year + delta;
    if (newYear >= widget.firstDate.year && newYear <= widget.lastDate.year) {
      setState(() {
        _year = newYear;
        _yearController.text = _year.toString();

        if (!_isMonthSelectable(_year, _selectedMonth)) {
          for (int m = 1; m <= 12; m++) {
            if (_isMonthSelectable(_year, m)) {
              _selectedMonth = m;
              break;
            }
          }
        }
      });
    }
  }

  bool _isMonthSelectable(int year, int month) {
    // final dateToCheck = DateTime(year, month);
    // Порівнюємо з першим числом місяця firstDate та останнім числом місяця lastDate
    // Для спрощення: перевіряємо, чи місяць випадає з діапазону

    // Якщо рік менший за мінімальний або більший за максимальний -> false
    if (year < widget.firstDate.year || year > widget.lastDate.year) {
      return false;
    }

    // Якщо це рік початку, перевіряємо місяць
    if (year == widget.firstDate.year && month < widget.firstDate.month) {
      return false;
    }

    // Якщо це рік кінця, перевіряємо місяць
    if (year == widget.lastDate.year && month > widget.lastDate.month) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final primary = theme.colorScheme.primary;
    final loc = AppLocalizations.of(context)!;

    final canGoBack = _year > widget.firstDate.year;
    final canGoForward = _year < widget.lastDate.year;

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.title ?? loc.pickMonthYear,
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
                  onPressed: canGoBack ? () => _changeYear(-1) : null,
                  tooltip: loc.prevYear,
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      // contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: primary.withAlpha(80)),
                      // ),
                      // focusedBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: primary, width: 2),
                      // ),
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    // onSubmitted: (_) {
                    //   final parsed = int.tryParse(_yearController.text.trim());
                    //   if (parsed != null) {
                    //     setState(() => _year = parsed);
                    //   } else {
                    //     _yearController.text = _year.toString();
                    //   }
                    // },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: canGoForward ? () => _changeYear(1) : null,
                  tooltip: loc.nextYear,
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
                final enabled = _isMonthSelectable(_year, month);
                final monthName = DateFormat.MMMM(
                  loc.localeName,
                ).format(DateTime(2024, month));
                final label = toBeginningOfSentenceCase(monthName);

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
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight
                            .w500, // fixed weight to avoid width change
                        color: enabled
                            ? (selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface)
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                      ),
                    ),
                    selected: selected,
                    onSelected: enabled
                        ? (_) => setState(() => _selectedMonth = month)
                        : null,
                    selectedColor: theme.colorScheme.primary.withValues(
                      alpha: 0.15,
                    ),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    showCheckmark: false,
                    // onSelected: (_) => setState(() => _selectedMonth = month),
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
              widget.cancelLabel ?? loc.cancel,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          FilledButton.tonal(
            onPressed: _isMonthSelectable(_year, _selectedMonth)
                ? _apply
                : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(widget.okLabel ?? loc.ok),
          ),
        ],
      ),
    );
  }
}
