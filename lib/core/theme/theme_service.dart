import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';

class ThemeService {
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(KCOnstats.themeModeKey) ?? 'system';

    if (savedTheme == 'light') {
      themeModeNotifier.value = ThemeMode.light;
    } else if (savedTheme == 'dark') {
      themeModeNotifier.value = ThemeMode.dark;
    } else {
      themeModeNotifier.value = ThemeMode.system;
    }
  }

  static Future<void> changeTheme(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.light) {
      await prefs.setString(KCOnstats.themeModeKey, 'light');
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(KCOnstats.themeModeKey, 'dark');
    } else {
      await prefs.setString(KCOnstats.themeModeKey, 'system');
    }
  }
}
