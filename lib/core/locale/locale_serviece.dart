import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  // Ключ для збереження в налаштуваннях
  static const String _localeKey = 'app_locale';

  // Notifier, який тримає поточну локаль. За замовчуванням - українська.
  static final ValueNotifier<Locale> localeNotifier = ValueNotifier(
    const Locale('uk'),
  );

  // Завантаження збереженої мови при запуску
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_localeKey);
    if (savedCode != null) {
      localeNotifier.value = Locale(savedCode);
    }
  }

  // Зміна мови та збереження вибору
  static Future<void> changeLocale(String languageCode) async {
    if (localeNotifier.value.languageCode == languageCode) return;

    localeNotifier.value = Locale(languageCode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
  }
}
