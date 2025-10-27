import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gym_tracker_app/core/theme/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    // ініціалізуємо і локальне поле, і notifier
    final savedDark = _prefs.getBool(KCOnstats.themeModeKey) ?? false;
    ThemeService.isDarkModeNotifier.value = savedDark;
    // setState(() {
    //   _darkMode = savedDark;
    // });

    // підтягуємо уведомлення
    _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
  }

  // Оновлений toggle для темної теми
  Future<void> _toggleDarkMode(bool value) async {
    ThemeService.isDarkModeNotifier.value = value;

    // 3) зберігаємо в SharedPreferences
    await _prefs.setBool(KCOnstats.themeModeKey, value);
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    await _prefs.setBool('notifications_enabled', value);
    // Запустіть ваш механізм налаштування пуш-повідомлень тут
  }

  void _confirmClearData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Очистити всі дані'),
        content: const Text(
          'Це видалить усі збережені тренування та налаштування. Продовжити?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Ні'),
          ),
          TextButton(
            onPressed: () async {
              // Очистити всі ключі
              await _prefs.clear();
              // Після очищення — поновити стан
              setState(() {
                ThemeService.isDarkModeNotifier.value = false;
                _notificationsEnabled = true;
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Дані успішно очищені')),
              );
            },
            child: const Text('Так'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ThemeService.isDarkModeNotifier.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Налаштування'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SwitchListTile(
              secondary: Icon(
                Icons.brightness_6,
                color: isDark ? Colors.white : theme.primaryColor,
              ),
              title: isDark ? Text('Темний режим') : Text('Світлий режим'),
              value: isDark,
              onChanged: _toggleDarkMode,
            ),
            const Divider(),

            SwitchListTile(
              secondary: Icon(
                Icons.notifications,
                color: isDark ? Colors.white : theme.primaryColor,
              ),
              title: const Text('Сповіщення'),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
            const Divider(),

            ListTile(
              leading: Icon(
                Icons.delete_forever,
                color: theme.colorScheme.error,
              ),
              title: Text(
                'Очистити всі дані',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: _confirmClearData,
            ),
            const Divider(),

            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: isDark ? Colors.white : theme.primaryColor,
              ),
              title: const Text('Про додаток'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Gym Tracker',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.fitness_center),
                  children: const [
                    Text('Додаток для відстеження ваших тренувань.'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
