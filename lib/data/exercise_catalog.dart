// lib/data/exercise_catalog.dart
import 'package:flutter/material.dart';

class ExerciseInfo {
  final String id;
  final String name;
  final IconData icon;

  const ExerciseInfo({
    required this.id,
    required this.name,
    required this.icon,
  });
}

// Простий вбудований каталог — можна замінити на assets JSON
const List<ExerciseInfo> kExerciseCatalog = [
  ExerciseInfo(id: 'squat', name: 'Присідання', icon: Icons.fitness_center),
  ExerciseInfo(id: 'bench', name: 'Жим лежачи', icon: Icons.bolt),
  ExerciseInfo(id: 'deadlift', name: 'Тяга', icon: Icons.run_circle_outlined),
  ExerciseInfo(id: 'press', name: 'Жим плечима', icon: Icons.trending_up),
  ExerciseInfo(id: 'pullup', name: 'Підтягування', icon: Icons.arrow_upward),
  ExerciseInfo(id: 'row', name: 'Тяга в нахилі', icon: Icons.swap_vert),
  // додай свої вправи тут
];
