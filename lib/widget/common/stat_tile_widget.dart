import 'package:flutter/material.dart';

/// Віджет для відображення єдиної статистичної плитки (наприклад, Калорії, Вага, Підходи).
class StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;

  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Використовуємо Expanded, щоб плитка зайняла 1/3 доступного простору в Row
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            // Центруємо вміст
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                // Використовуємо наданий колір або PrimaryColor з теми
                color: iconColor ?? theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              // Головне значення (наприклад, '102.4 ккал')
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  // fontWeight: FontWeight
                  //     .bold, // Додамо жирний шрифт для кращої видимості
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Підпис (наприклад, 'Калорії')
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
