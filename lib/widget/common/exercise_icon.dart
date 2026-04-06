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
    final currentIconColor = Theme.of(context).iconTheme.color;
    if (exercise.hasCustomIcon) {
      return Image.asset(
        exercise.assetPath!,
        width: size,
        height: size,
        color: currentIconColor,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image, size: size, color: Colors.red);
        },
      );
    }

    return Icon(exercise.icon, size: size, color: color);
  }
}
