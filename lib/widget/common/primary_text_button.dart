//Todo use it accros app
import 'package:flutter/material.dart';

/// Уніфікований віджет для кнопок типу TextButton.
/// Використовується для другорядних дій, таких як 'Register' або 'Forgot password'.
class PrimaryTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Стилізація: можемо задати мінімальний розмір або певний колір,
    // але для TextButton часто достатньо стандартного вигляду.
    // За замовчуванням, він використовуватиме колір PrimaryColor з теми.
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        // Можна додати індивідуальний стиль тексту, якщо потрібно:
        // style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
