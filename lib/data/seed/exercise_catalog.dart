import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class ExerciseInfo {
  final String id;
  final String name;
  final IconData icon; // Використовується як заглушка, якщо немає картинки
  final String? assetPath; // Шлях до вашого PNG файлу

  const ExerciseInfo({
    required this.id,
    required this.name,
    required this.icon,
    this.assetPath,
  });

  // Допоміжний метод, щоб перевірити, чи є кастомна іконка
  bool get hasCustomIcon => assetPath != null;

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
    // --- LEGS ---
    ExerciseInfo(
      id: 'squat',
      name: loc.exSquat,
      icon: Icons.fitness_center,
      assetPath: 'assets/icons/squat-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'front_squat',
      name: loc.exFrontSquat,
      icon: Icons.accessibility,
    ),
    ExerciseInfo(
      id: 'goblet_squat',
      name: loc.exGobletSquat,
      icon: Icons.sports_mma,
    ),
    ExerciseInfo(
      id: 'lunge',
      name: loc.exLunge,
      icon: Icons.directions_walk,
      assetPath: 'assets/icons/lunge-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'walking_lunge',
      name: loc.exWalkingLunge,
      icon: Icons.directions_run,
    ),
    ExerciseInfo(
      id: 'bulgarian_split_squat',
      name: loc.exBulgarianSplitSquat,
      icon: Icons.airline_seat_legroom_extra,
    ),
    ExerciseInfo(
      id: 'leg_press',
      name: loc.exLegPress,
      icon: Icons.square_foot,
      assetPath: 'assets/icons/leg_press-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'wall_sit',
      name: loc.exWallSit,
      icon: Icons.wallpaper,
      assetPath: 'assets/icons/wall_sit-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'leg_extension',
      name: loc.exLegExtension,
      icon: Icons.linear_scale,
      assetPath: 'assets/icons/leg_extension-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'leg_curl',
      name: loc.exLegCurl,
      icon: Icons.rotate_left,
      assetPath: 'assets/icons/leg_curl-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'deadlift',
      name: loc.exDeadlift,
      icon: Icons.trending_up,
      assetPath: 'assets/icons/deadlift-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'sumo_deadlift',
      name: loc.exSumoDeadlift,
      icon: Icons.accessibility_new,
    ),
    ExerciseInfo(
      id: 'romanian_deadlift',
      name: loc.exRomanianDeadlift,
      icon: Icons.nordic_walking,
    ),
    ExerciseInfo(
      id: 'good_morning',
      name: loc.exGoodMorning,
      icon: Icons.self_improvement,
      assetPath: 'assets/icons/good_morning-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'hip_thrust',
      name: loc.exHipThrust,
      icon: Icons.airline_seat_flat,
    ),
    ExerciseInfo(
      id: 'glute_bridge',
      name: loc.exGluteBridge,
      icon: Icons.airline_seat_flat_angled,
    ),
    ExerciseInfo(
      id: 'standing_calf_raise',
      name: loc.exStandingCalfRaise,
      icon: Icons.trending_flat,
      assetPath: 'assets/icons/standing_calf_raise-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'seated_calf_raise',
      name: loc.exSeatedCalfRaise,
      icon: Icons.event_seat,
      assetPath: 'assets/icons/seated_calf_raise-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'donkey_calf_raise',
      name: loc.exDonkeyCalfRaise,
      icon: Icons.bedroom_baby,
    ),
    ExerciseInfo(
      id: 'abductor_machine',
      name: loc.exAbductorMachine,
      icon: Icons.compare_arrows,
    ),
    ExerciseInfo(
      id: 'adductor_machine',
      name: loc.exAdductorMachine,
      icon: Icons.compress,
    ),

    // --- CHEST ---
    ExerciseInfo(
      id: 'bench_press',
      name: loc.exBenchPress,
      icon: Icons.fitness_center,
      assetPath: 'assets/icons/bench_press-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'incline_bench_press',
      name: loc.exInclineBenchPress,
      icon: Icons.show_chart,
    ),
    ExerciseInfo(
      id: 'decline_bench_press',
      name: loc.exDeclineBenchPress,
      icon: Icons.trending_down,
    ),
    ExerciseInfo(
      id: 'dumbbell_bench_press',
      name: loc.exDumbbellBenchPress,
      icon: Icons.circle,
    ),
    ExerciseInfo(
      id: 'incline_dumbbell_press',
      name: loc.exInclineDumbbellPress,
      icon: Icons.north_east,
    ),
    ExerciseInfo(
      id: 'push_up',
      name: loc.exPushUp,
      icon: Icons.push_pin,
      // Я не бачив push_up у списку файлів на скріншоті, але він був у сітці.
      // Якщо файл є, розкоментуйте рядок нижче:
      // assetPath: 'assets/icons/push_up-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'diamond_push_up',
      name: loc.exDiamondPushUp,
      icon: Icons.diamond,
    ),
    ExerciseInfo(
      id: 'dip',
      name: loc.exDip,
      icon: Icons.vertical_align_center,
      assetPath: 'assets/icons/dip-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'machine_fly',
      name: loc.exMachineFly,
      icon: Icons.sensors,
      assetPath: 'assets/icons/machine_fly-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'cable_crossover',
      name: loc.exCableCrossover,
      icon: Icons.cable,
    ),
    ExerciseInfo(
      id: 'dumbbell_fly',
      name: loc.exDumbbellFly,
      icon: Icons.flight,
    ),
    ExerciseInfo(
      id: 'pullover',
      name: loc.exPullover,
      icon: Icons.keyboard_capslock,
    ),
    ExerciseInfo(
      id: 'chest_press_machine',
      name: loc.exChestPressMachine,
      icon: Icons.smart_button,
    ),

    // --- BACK ---
    ExerciseInfo(
      id: 'pull_up',
      name: loc.exPullUp,
      icon: Icons.arrow_upward,
      assetPath: 'assets/icons/pull_up-removebg-preview.png',
    ),
    ExerciseInfo(id: 'chin_up', name: loc.exChinUp, icon: Icons.front_hand),
    ExerciseInfo(
      id: 'lat_pull_down',
      name: loc.exLatPullDown,
      icon: Icons.arrow_downward,
      assetPath: 'assets/icons/lat_pull_down-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'close_grip_lat_pull_down',
      name: loc.exCloseGripLatPullDown,
      icon: Icons.vertical_align_bottom,
    ),
    ExerciseInfo(
      id: 'bent_over_row',
      name: loc.exBentOverRow,
      icon: Icons.swap_horiz,
      assetPath: 'assets/icons/bent_over_row-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'reverse_grip_row',
      name: loc.exReverseGripRow,
      icon: Icons.flip_camera_android,
    ),
    ExerciseInfo(
      id: 'single_arm_dumbbell_row',
      name: loc.exSingleArmDumbbellRow,
      icon: Icons.rowing,
    ),
    ExerciseInfo(id: 't_bar_row', name: loc.exTBarRow, icon: Icons.anchor),
    ExerciseInfo(
      id: 'seated_cable_row',
      name: loc.exSeatedCableRow,
      icon: Icons.chair,
    ),
    ExerciseInfo(
      id: 'machine_row',
      name: loc.exMachineRow,
      icon: Icons.settings_ethernet,
      assetPath: 'assets/icons/machine_row-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'straight_arm_pulldown',
      name: loc.exStraightArmPulldown,
      icon: Icons.straight,
    ),
    ExerciseInfo(
      id: 'hyperextension',
      name: loc.exHyperextension,
      icon: Icons.accessibility_new,
      assetPath: 'assets/icons/hyperextension-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'rack_pull',
      name: loc.exRackPull,
      icon: Icons.align_vertical_bottom,
    ),

    // --- SHOULDERS ---
    ExerciseInfo(
      id: 'overhead_press',
      name: loc.exOverheadPress,
      icon: Icons.trending_up,
      assetPath: 'assets/icons/overhead_press-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'seated_dumbbell_press',
      name: loc.exSeatedDumbbellPress,
      icon: Icons.weekend,
    ),
    ExerciseInfo(
      id: 'arnold_press',
      name: loc.exArnoldPress,
      icon: Icons.autorenew,
    ),
    ExerciseInfo(
      id: 'lateral_raise',
      name: loc.exLateralRaise,
      icon: Icons.open_with,
      // Якщо lateral_raise є у папці (його не видно на скріншоті), розкоментуйте:
      // assetPath: 'assets/icons/lateral_raise-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'cable_lateral_raise',
      name: loc.exCableLateralRaise,
      icon: Icons.usb,
    ),
    ExerciseInfo(
      id: 'front_raise',
      name: loc.exFrontRaise,
      icon: Icons.arrow_forward,
      assetPath: 'assets/icons/front_raise-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'rear_delt_raise',
      name: loc.exRearDeltRaise,
      icon: Icons.sync_alt,
      assetPath: 'assets/icons/rear_delt_raise-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'reverse_pec_deck',
      name: loc.exReversePecDeck,
      icon: Icons.flip,
    ),
    ExerciseInfo(
      id: 'face_pull',
      name: loc.exFacePull,
      icon: Icons.account_circle,
      assetPath: 'assets/icons/face_pull-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'upright_row',
      name: loc.exUprightRow,
      icon: Icons.vertical_split,
      assetPath: 'assets/icons/upright_row-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'shoulder_shrug',
      name: loc.exShoulderShrug,
      icon: Icons.arrow_upward_outlined,
      assetPath: 'assets/icons/shoulder_shrug-removebg-preview.png',
    ),

    // --- ARMS ---
    ExerciseInfo(
      id: 'biceps_curl',
      name: loc.exBicepsCurl,
      icon: Icons.fitness_center,
      assetPath: 'assets/icons/biceps_curl-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'dumbbell_curl',
      name: loc.exDumbbellCurl,
      icon: Icons.circle_outlined,
    ),
    ExerciseInfo(
      id: 'hammer_curl',
      name: loc.exHammerCurl,
      icon: Icons.construction,
      assetPath: 'assets/icons/hammer_curl-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'preacher_curl',
      name: loc.exPreacherCurl,
      icon: Icons.menu_book,
    ),
    ExerciseInfo(
      id: 'concentration_curl',
      name: loc.exConcentrationCurl,
      icon: Icons.center_focus_strong,
    ),
    ExerciseInfo(
      id: 'cable_curl',
      name: loc.exCableCurl,
      icon: Icons.settings_input_hdmi,
    ),
    ExerciseInfo(
      id: 'zottman_curl',
      name: loc.exZottmanCurl,
      icon: Icons.refresh,
      assetPath: 'assets/icons/zottman_curl-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'triceps_extension',
      name: loc.exTricepsExtension,
      icon: Icons.back_hand,
      assetPath: 'assets/icons/triceps_extension-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'skull_crusher',
      name: loc.exSkullCrusher,
      icon: Icons.warning,
    ),
    ExerciseInfo(
      id: 'tricep_pushdown',
      name: loc.exTricepPushdown,
      icon: Icons.arrow_downward_sharp,
    ),
    ExerciseInfo(
      id: 'tricep_dip_machine',
      name: loc.exTricepDipMachine,
      icon: Icons.event_seat_outlined,
    ),
    ExerciseInfo(
      id: 'bench_dip',
      name: loc.exBenchDip,
      icon: Icons.airline_seat_legroom_reduced,
    ),

    // --- ABS/CORE ---
    ExerciseInfo(
      id: 'crunch',
      name: loc.exCrunch,
      icon: Icons.rotate_right,
      assetPath: 'assets/icons/crunch-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'cable_crunch',
      name: loc.exCableCrunch,
      icon: Icons.rss_feed,
    ),
    ExerciseInfo(
      id: 'sit_up',
      name: loc.exSitUp,
      icon: Icons.keyboard_double_arrow_up,
      assetPath: 'assets/icons/sit_up-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'leg_raise',
      name: loc.exLegRaise,
      icon: Icons.vertical_align_top,
      assetPath: 'assets/icons/leg_raise-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'leg_raise_hang',
      name: loc.exLegRaiseHang,
      icon: Icons.how_to_reg,
      assetPath: 'assets/icons/leg_raise_hang-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'russian_twist',
      name: loc.exRussianTwist,
      icon: Icons.loop,
      assetPath: 'assets/icons/russian_twist-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'plank',
      name: loc.exPlank,
      icon: Icons.crop_square,
      assetPath: 'assets/icons/plank-removebg-preview.png',
    ),
    ExerciseInfo(
      id: 'side_plank',
      name: loc.exSidePlank,
      icon: Icons.crop_landscape,
    ),
    ExerciseInfo(
      id: 'ab_wheel_rollout',
      name: loc.exAbWheelRollout,
      icon: Icons.directions_bike,
    ),
    ExerciseInfo(
      id: 'bicycle_crunch',
      name: loc.exBicycleCrunch,
      icon: Icons.pedal_bike,
    ),
    ExerciseInfo(id: 'woodchopper', name: loc.exWoodchopper, icon: Icons.cut),

    // --- CARDIO/OTHER ---
    ExerciseInfo(
      id: 'cardio_treadmill',
      name: loc.exCardioTreadmill,
      icon: Icons.directions_run,
    ),
    ExerciseInfo(
      id: 'cardio_elliptical',
      name: loc.exCardioElliptical,
      icon: Icons.directions_walk,
    ),
    ExerciseInfo(
      id: 'cardio_rowing',
      name: loc.exCardioRowing,
      icon: Icons.rowing,
    ),
    ExerciseInfo(
      id: 'farmer_walk',
      name: loc.exFarmerWalk,
      icon: Icons.shopping_bag,
    ),
  ];
}
