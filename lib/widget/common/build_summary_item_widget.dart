import 'package:flutter/material.dart';

Widget buildSummaryItem({
  required BuildContext context,
  required String label,
  required String value,
  Color? color,
}) {
  return Column(
    children: [
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 14),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
