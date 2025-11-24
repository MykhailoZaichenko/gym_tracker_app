import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class ExerciseInfo {
  final String id;
  final String name;
  final IconData icon;

  const ExerciseInfo({
    required this.id,
    required this.name,
    required this.icon,
  });

  static ExerciseInfo getEnterCustom(AppLocalizations loc) {
    return ExerciseInfo(
      id: '__custom__',
      name: loc.enterCustomName,
      icon: Icons.edit,
    );
  }
}

List<ExerciseInfo> getExerciseCatalog(AppLocalizations loc) {
  return [
    ExerciseInfo(id: 'squat', name: loc.exSquat, icon: Icons.fitness_center),
    ExerciseInfo(id: 'lunge', name: loc.exLunge, icon: Icons.directions_walk),
    ExerciseInfo(
      id: 'leg_press',
      name: loc.exLegPress,
      icon: Icons.square_foot,
    ),
    ExerciseInfo(id: 'wall_sit', name: loc.exWallSit, icon: Icons.wallpaper),
    ExerciseInfo(
      id: 'leg_extension',
      name: loc.exLegExtension,
      icon: Icons.linear_scale,
    ),
    ExerciseInfo(id: 'leg_curl', name: loc.exLegCurl, icon: Icons.rotate_left),
    ExerciseInfo(id: 'deadlift', name: loc.exDeadlift, icon: Icons.trending_up),
    ExerciseInfo(
      id: 'good_morning',
      name: loc.exGoodMorning,
      icon: Icons.self_improvement,
    ),
    ExerciseInfo(
      id: 'standing_calf_raise',
      name: loc.exStandingCalfRaise,
      icon: Icons.trending_flat,
    ),
    ExerciseInfo(
      id: 'seated_calf_raise',
      name: loc.exSeatedCalfRaise,
      icon: Icons.event_seat,
    ),
    ExerciseInfo(id: 'push_up', name: loc.exPushUp, icon: Icons.push_pin),
    ExerciseInfo(id: 'pull_up', name: loc.exPullUp, icon: Icons.arrow_upward),
    ExerciseInfo(id: 'dip', name: loc.exDip, icon: Icons.vertical_align_center),
    ExerciseInfo(
      id: 'bench_press',
      name: loc.exBenchPress,
      icon: Icons.fitness_center,
    ),
    ExerciseInfo(
      id: 'machine_fly',
      name: loc.exMachineFly,
      icon: Icons.sensors,
    ),
    ExerciseInfo(
      id: 'lateral_raise',
      name: loc.exLateralRaise,
      icon: Icons.open_with,
    ),
    ExerciseInfo(
      id: 'bent_over_row',
      name: loc.exBentOverRow,
      icon: Icons.swap_horiz,
    ),
    ExerciseInfo(
      id: 'lat_pull_down',
      name: loc.exLatPullDown,
      icon: Icons.arrow_downward,
    ),
    ExerciseInfo(
      id: 'shoulder_shrug',
      name: loc.exShoulderShrug,
      icon: Icons.arrow_upward_outlined,
    ),
    ExerciseInfo(
      id: 'overhead_press',
      name: loc.exOverheadPress,
      icon: Icons.trending_up,
    ),
    ExerciseInfo(
      id: 'front_raise',
      name: loc.exFrontRaise,
      icon: Icons.arrow_forward,
    ),
    ExerciseInfo(
      id: 'rear_delt_raise',
      name: loc.exRearDeltRaise,
      icon: Icons.sync_alt,
    ),
    ExerciseInfo(
      id: 'upright_row',
      name: loc.exUprightRow,
      icon: Icons.vertical_split,
    ),
    ExerciseInfo(
      id: 'face_pull',
      name: loc.exFacePull,
      icon: Icons.account_circle,
    ),
    ExerciseInfo(
      id: 'biceps_curl',
      name: loc.exBicepsCurl,
      icon: Icons.fitness_center,
    ),
    ExerciseInfo(
      id: 'triceps_extension',
      name: loc.exTricepsExtension,
      icon: Icons.back_hand,
    ),
    ExerciseInfo(id: 'crunch', name: loc.exCrunch, icon: Icons.rotate_right),
    ExerciseInfo(
      id: 'sit_up',
      name: loc.exSitUp,
      icon: Icons.keyboard_double_arrow_up,
    ),
    ExerciseInfo(id: 'plank', name: loc.exPlank, icon: Icons.crop_square),
    ExerciseInfo(
      id: 'leg_raise',
      name: loc.exLegRaise,
      icon: Icons.vertical_align_top,
    ),
    ExerciseInfo(
      id: 'hyperextension',
      name: loc.exHyperextension,
      icon: Icons.accessibility_new,
    ),
    ExerciseInfo(
      id: 'hammer_curl',
      name: loc.exHammerCurl,
      icon: Icons.construction,
    ),
    ExerciseInfo(
      id: 'zottman_curl',
      name: loc.exZottmanCurl,
      icon: Icons.autorenew,
    ),
    ExerciseInfo(
      id: 'machine_row',
      name: loc.exMachineRow,
      icon: Icons.settings_ethernet,
    ),
    ExerciseInfo(
      id: 'leg_raise_hang',
      name: loc.exLegRaiseHang,
      icon: Icons.how_to_reg,
    ),
  ];
}

final List<ExerciseInfo> kExerciseCatalog = [];
