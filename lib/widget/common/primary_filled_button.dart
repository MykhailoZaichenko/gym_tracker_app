import 'package:flutter/material.dart';

class PrimaryFilledButton extends StatelessWidget {
  // Функція, яка викликається при натисканні
  final VoidCallback onPressed;
  // Текст на кнопці
  final String text;
  // Додаткова логіка: чи активна кнопка (за замовчуванням true)
  final bool isEnabled;

  const PrimaryFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isEnabled = true,
    isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      // Викликаємо onPressed, тільки якщо кнопка активна
      onPressed: isEnabled ? onPressed : null,
      style: FilledButton.styleFrom(
        // Забезпечуємо повну ширину
        minimumSize: const Size(double.infinity, 50.0),
        // Додайте тут будь-які інші стилі, які мають бути універсальними
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
