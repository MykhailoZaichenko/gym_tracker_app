import 'package:flutter/material.dart';

class StatusIconWidget extends StatelessWidget {
  final Color? color;
  final double size;

  const StatusIconWidget({super.key, this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color baseColor;

    if (color != null) {
      baseColor = color!;
    } else {
      baseColor = isDark
          ? theme.colorScheme.primary
          : theme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.all(size / 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: isDark ? 0.25 : 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        color != null ? Icons.check_circle_outline : Icons.fitness_center,
        size: size,
        color: baseColor,
      ),
    );
  }
}
