import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';

class MonthPickerDialog extends StatefulWidget {
  const MonthPickerDialog({
    required this.initialDate,
    super.key,
    String? title,
    required String cancelLabel,
    required String okLabel,
  });

  final DateTime initialDate;

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
    builder: (_) => MonthPickerDialog(
      initialDate: initialDate,
      title: title,
      cancelLabel: cancelLabel,
      okLabel: okLabel,
    ),
  );
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late int _year;
  late int _selectedMonth;
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
      title: const Text('Виберіть місяць і рік'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                selectedColor: theme.colorScheme.primary.withAlpha(36),
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        TextButton(onPressed: _apply, child: const Text('ОК')),
      ],
    );
  }
}
