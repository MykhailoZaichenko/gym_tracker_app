import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';

class ThemeService {
  static final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

  static Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isDarkMode = prefs.getBool(KCOnstats.themeModeKey);
    isDarkModeNotifier.value = isDarkMode ?? false;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KCOnstats.themeModeKey, isDark);
    isDarkModeNotifier.value = isDark;
  }
}
