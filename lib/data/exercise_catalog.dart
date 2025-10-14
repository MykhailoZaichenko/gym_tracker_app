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

  static const ExerciseInfo enterCustom = ExerciseInfo(
    id: '__custom__',
    name: 'Ввести власну назву',
    icon: Icons.edit,
  );
}

// Простий вбудований каталог — можна замінити на assets JSON
final List<ExerciseInfo> kExerciseCatalog = [
  ExerciseInfo(id: 'squat', name: 'Присідання', icon: Icons.fitness_center),

  // ExerciseInfo(
  //   id: 'lunge',
  //   name: 'Випади',
  //   imgIcon: ImageIcon(
  //     AssetImage('assets/images/icon.png'),
  //     color: Colors.blue,
  //   ),
  // ),
  ExerciseInfo(id: 'lunge', name: 'Випади', icon: Icons.directions_walk),
  ExerciseInfo(id: 'leg_press', name: 'Жим ногами', icon: Icons.square_foot),
  ExerciseInfo(
    id: 'wall_sit',
    name: 'Вправа біля стіни',
    icon: Icons.wallpaper,
  ),
  ExerciseInfo(
    id: 'leg_extension',
    name: 'Розгинання ніг',
    icon: Icons.linear_scale,
  ),
  ExerciseInfo(id: 'leg_curl', name: 'Згинання ніг', icon: Icons.rotate_left),
  ExerciseInfo(
    id: 'deadlift',
    name: 'Тяга (deadlift)',
    icon: Icons.trending_up,
  ),
  ExerciseInfo(
    id: 'good_morning',
    name: 'Good-morning',
    icon: Icons.self_improvement,
  ),
  ExerciseInfo(
    id: 'standing_calf_raise',
    name: 'Підйоми на носки стоячи',
    icon: Icons.trending_flat,
  ),
  ExerciseInfo(
    id: 'seated_calf_raise',
    name: 'Підйоми на носки сидячи',
    icon: Icons.event_seat,
  ),
  ExerciseInfo(
    id: 'push_up',
    name: 'Відтискання (push-up)',
    icon: Icons.push_pin,
  ),
  ExerciseInfo(id: 'pull_up', name: 'Підтягування', icon: Icons.arrow_upward),
  ExerciseInfo(
    id: 'dip',
    name: 'Віджимання на брусах (dip)',
    icon: Icons.vertical_align_center,
  ),
  ExerciseInfo(
    id: 'bench_press',
    name: 'Жим лежачи',
    icon: Icons.fitness_center,
  ),
  ExerciseInfo(
    id: 'machine_fly',
    name: 'Машинні розведення',
    icon: Icons.sensors,
  ),
  ExerciseInfo(
    id: 'lateral_raise',
    name: 'Розведення рук у сторони',
    icon: Icons.open_with,
  ),
  ExerciseInfo(
    id: 'bent_over_row',
    name: 'Тяга в нахилі',
    icon: Icons.swap_horiz,
  ),
  ExerciseInfo(
    id: 'lat_pull_down',
    name: 'Тяга верхнього блока',
    icon: Icons.arrow_downward,
  ),
  ExerciseInfo(
    id: 'shoulder_shrug',
    name: 'Шраги (плечі)',
    icon: Icons.arrow_upward_outlined,
  ),
  ExerciseInfo(
    id: 'overhead_press',
    name: 'Жим над головою (military press)',
    icon: Icons.trending_up,
  ),
  ExerciseInfo(
    id: 'front_raise',
    name: 'Передні підйоми рук',
    icon: Icons.arrow_forward,
  ),
  ExerciseInfo(
    id: 'rear_delt_raise',
    name: 'Задні розведення дельт',
    icon: Icons.sync_alt,
  ),
  ExerciseInfo(
    id: 'upright_row',
    name: 'Upright row',
    icon: Icons.vertical_split,
  ),
  ExerciseInfo(id: 'face_pull', name: 'Face pull', icon: Icons.account_circle),
  ExerciseInfo(
    id: 'biceps_curl',
    name: 'Підйоми на біцепс',
    icon: Icons.fitness_center,
  ),
  ExerciseInfo(
    id: 'triceps_extension',
    name: 'Французький жим (трицепс)',
    icon: Icons.back_hand,
  ),
  ExerciseInfo(
    id: 'crunch',
    name: 'Скручування / Crunch',
    icon: Icons.rotate_right,
  ),
  ExerciseInfo(
    id: 'sit_up',
    name: 'Підйом тулуба (sit-up)',
    icon: Icons.keyboard_double_arrow_up,
  ),
  ExerciseInfo(id: 'russian_twist', name: 'Russian twist', icon: Icons.loop),
  ExerciseInfo(id: 'plank', name: 'Планка', icon: Icons.crop_square),
  ExerciseInfo(
    id: 'leg_raise',
    name: 'Підйоми ніг',
    icon: Icons.vertical_align_top,
  ),
  ExerciseInfo(
    id: 'hyperextension',
    name: 'Гіперекстензія',
    icon: Icons.accessibility_new,
  ),
  ExerciseInfo(
    id: 'hammer_curl',
    name: 'Молотковий підйом (hammer curl)',
    icon: Icons.construction,
  ),
  ExerciseInfo(id: 'zottman_curl', name: 'Zottman curl', icon: Icons.autorenew),
  ExerciseInfo(
    id: 'machine_row',
    name: 'Ряд машинний / Row (машина)',
    icon: Icons.settings_ethernet,
  ),
  ExerciseInfo(
    id: 'leg_raise_hang',
    name: 'Підйоми ніг у висі',
    icon: Icons.how_to_reg,
  ),
];
