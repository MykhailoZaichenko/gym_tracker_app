import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';

class ExerciseIcon extends StatelessWidget {
  final ExerciseInfo exercise;
  final double size;
  final Color? color;

  const ExerciseIcon({
    super.key,
    required this.exercise,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Якщо є шлях до асету (наша PNG)
    if (exercise.hasCustomIcon) {
      return Image.asset(
        exercise.assetPath!,
        width: size,
        height: size,
        // color: color, // Розкоментуйте, якщо хочете перефарбувати чорні лінії в інший колір
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Якщо файл не знайдено (наприклад, помилка в назві), покажемо заглушку
          return Icon(Icons.broken_image, size: size, color: Colors.red);
        },
      );
    }

    // 2. Якщо асету немає, показуємо стандартну іконку Flutter
    return Icon(exercise.icon, size: size, color: color);
  }
}
