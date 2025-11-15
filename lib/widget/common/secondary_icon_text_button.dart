import 'package:flutter/material.dart';

enum ButtonVariant { elevated, outlined, destructive }

/// Уніфікований віджет для кнопок з іконкою та текстом.
/// Використовується для другорядних дій ("Редагувати", "Видалити").
class SecondaryIconTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final ButtonVariant variant;
  final bool isLoading;

  const SecondaryIconTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    this.variant = ButtonVariant.elevated, // За замовчуванням Elevated
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Спільний стиль для кнопок з іконкою
    final commonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Вміст іконки/індикатора
    final iconWidget = isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon, size: 18);

    // Колір для деструктивної кнопки "Видалити"
    final foregroundColor = variant == ButtonVariant.destructive
        ? colorScheme
              .error // Червоний для видалення
        : colorScheme.primary;

    // Вибираємо тип кнопки
    switch (variant) {
      case ButtonVariant.elevated:
        return ElevatedButton.icon(
          style: commonStyle,
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          label: Text(label),
        );

      case ButtonVariant.outlined:
      case ButtonVariant.destructive:
        return OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            foregroundColor: foregroundColor,
            side: BorderSide(color: foregroundColor, width: 1.5),
          ),
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          label: Text(label),
        );
    }
  }
}
