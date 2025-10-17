import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Загальний базовий шрифт (міняй family тут, якщо потрібно)
  static TextStyle _base(BuildContext context) =>
      GoogleFonts.inter(textStyle: Theme.of(context).textTheme.bodyMedium);

  // Основний текст (для content)
  static TextStyle body(BuildContext context) => _base(context).copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.35,
  );

  // Підзаголовок / малий заголовок
  static TextStyle subtitle(BuildContext context) => _base(context).copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
  );

  // Заголовок сторінки / великий заголовок
  static TextStyle titleLarge(BuildContext context) => _base(context).copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );

  // Заголовок середній (наприклад назва секції)
  static TextStyle titleMedium(BuildContext context) => _base(context).copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  // Значення статистики (великий акцент)
  static TextStyle statValue(BuildContext context) => _base(context).copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.primary,
  );

  // Менші підписи / підказки
  static TextStyle caption(BuildContext context) => _base(context).copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).textTheme.bodySmall?.color,
  );

  // Помилка / акцент (наприклад текст помилки)
  static TextStyle error(BuildContext context) => _base(context).copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.error,
  );
}
