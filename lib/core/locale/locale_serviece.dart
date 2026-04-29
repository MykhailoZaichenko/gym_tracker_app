import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  // Ключ для збереження в налаштуваннях
  static const String _localeKey = 'app_locale';

  // ЗМІНА 1: Додали знак питання (Locale?), тепер null означає "системна мова".
  // За замовчуванням ставимо null, щоб додаток відразу підлаштовувався під телефон.
  static final ValueNotifier<Locale?> localeNotifier = ValueNotifier(null);

  // Завантаження збереженої мови при запуску
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_localeKey);

    if (savedCode != null) {
      localeNotifier.value = Locale(savedCode);
    } else {
      // Якщо мова ще не вибиралася, залишаємо системну (null)
      localeNotifier.value = null;
    }
  }

  // ЗМІНА 2: Додали знак питання (String? languageCode)
  static Future<void> changeLocale(String? languageCode) async {
    // Перевіряємо, чи не намагаємось ми змінити на ту саму мову
    if (localeNotifier.value?.languageCode == languageCode) return;

    final prefs = await SharedPreferences.getInstance();

    if (languageCode == null) {
      // Якщо вибрано "Як у системі", видаляємо налаштування і передаємо null
      localeNotifier.value = null;
      await prefs.remove(_localeKey);
    } else {
      // Якщо вибрано конкретну мову, зберігаємо її
      localeNotifier.value = Locale(languageCode);
      await prefs.setString(_localeKey, languageCode);
    }
  }
}
