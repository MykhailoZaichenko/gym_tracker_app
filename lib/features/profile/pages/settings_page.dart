import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/core/locale/locale_serviece.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
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

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final loc = AppLocalizations.of(context)!;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                loc.appLanguage,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Text('🇺🇦', style: TextStyle(fontSize: 24)),
                title: const Text('Українська'),
                trailing:
                    LocaleService.localeNotifier.value.languageCode == 'uk'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  LocaleService.changeLocale('uk');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: const Text('English'),
                trailing:
                    LocaleService.localeNotifier.value.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  LocaleService.changeLocale('en');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _confirmClearData() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.clearDataConfirmTitle),
        content: Text(loc.clearDataConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(loc.no),
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
              if (!mounted) return;
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(loc.dataClearedSuccess)));
            },
            child: Text(loc.yes),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ThemeService.isDarkModeNotifier.value;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SwitchListTile(
              secondary: Icon(
                Icons.brightness_6,
                color: isDark ? Colors.white : theme.primaryColor,
              ),
              title: isDark ? Text(loc.darkMode) : Text(loc.lightMode),
              value: isDark,
              onChanged: _toggleDarkMode,
            ),
            const Divider(),

            ValueListenableBuilder<Locale>(
              valueListenable: LocaleService.localeNotifier,
              builder: (context, locale, child) {
                return ListTile(
                  leading: Icon(
                    Icons.language,
                    color: isDark ? Colors.white : theme.primaryColor,
                  ),
                  title: Text(loc.appLanguage),
                  // Показуємо поточну вибрану мову
                  subtitle: Text(
                    locale.languageCode == 'uk' ? 'Українська' : 'English',
                  ),
                  onTap: _showLanguageSelector,
                );
              },
            ),
            const Divider(),

            SwitchListTile(
              secondary: Icon(
                Icons.notifications,
                color: isDark ? Colors.white : theme.primaryColor,
              ),
              title: Text(loc.notifications),
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
                loc.clearData,
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
              title: Text(loc.aboutApp),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: loc.appName,
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.fitness_center),
                  children: [Text(loc.appDescription)],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
