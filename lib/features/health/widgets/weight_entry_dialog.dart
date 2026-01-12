import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/date_constants.dart'; // 🔥 IMPORT
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class WeightEntryDialog extends StatefulWidget {
  final double? initialWeight;
  final DateTime initialDate;
  final bool isEditing;

  const WeightEntryDialog({
    super.key,
    this.initialWeight,
    required this.initialDate,
    this.isEditing = false,
  });

  @override
  State<WeightEntryDialog> createState() => _WeightEntryDialogState();
}

class _WeightEntryDialogState extends State<WeightEntryDialog> {
  late DateTime _selectedDate;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: widget.initialWeight != null ? widget.initialWeight.toString() : '',
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      // 🔥 Використовуємо константу як у всьому додатку (або -1 місяць якщо треба динамічно)
      firstDate: DateConstants.appStartDate,
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: Theme.of(context).colorScheme),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final dateStr = DateFormat.yMMMMd(loc.localeName).format(_selectedDate);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEditing ? loc.editWeight : loc.addWeight,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      dateStr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                IntrinsicWidth(
                  child: TextField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.0',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  loc.weightUnit,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    loc.cancel.toUpperCase(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final val = double.tryParse(
                      _controller.text.replaceAll(',', '.'),
                    );
                    if (val != null) {
                      Navigator.pop(context, {
                        'date': _selectedDate,
                        'weight': val,
                        'unit': 'kg',
                      });
                    }
                  },
                  child: Text(
                    loc.save.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
