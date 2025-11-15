import 'package:flutter/material.dart';

class AppPageTitle extends StatelessWidget {
  final String title;

  const AppPageTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Використовуємо titleLarge як універсальний стиль для заголовків сторінок
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        // Можливо, ви хочете зробити його жирнішим або іншого кольору
        fontWeight: FontWeight.bold,
        // Додайте будь-які інші уніфіковані стилі
      ),
      textAlign: TextAlign.center,
    );
  }
}
