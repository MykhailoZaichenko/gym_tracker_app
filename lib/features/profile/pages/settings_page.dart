import 'package:firebase_auth/firebase_auth.dart'; // Додано для обробки помилок
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/constants/constants.dart';
import 'package:gym_tracker_app/core/locale/locale_serviece.dart';
import 'package:gym_tracker_app/features/welcome/pages/welcome_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/notification_service.dart';
import 'package:gym_tracker_app/widget/common/custome_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:gym_tracker_app/services/auth_service.dart'; // Додано
import 'package:gym_tracker_app/services/firestore_service.dart'; // Додано

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  bool _notificationsEnabled = true;
  bool _isLoading = false; // Додано для відображення прогресу видалення
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _notificationService.init();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    final savedDark = _prefs.getBool(KCOnstats.themeModeKey) ?? false;
    ThemeService.isDarkModeNotifier.value = savedDark;
    _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
    if (mounted) setState(() {});
  }

  Future<void> _toggleDarkMode(bool value) async {
    ThemeService.isDarkModeNotifier.value = value;
    await _prefs.setBool(KCOnstats.themeModeKey, value);
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    await _prefs.setBool('notifications_enabled', value);

    if (!mounted) return;
    if (value) {
      // Якщо увімкнули - надсилаємо тестове повідомлення
      final loc = AppLocalizations.of(context)!;
      await _notificationService.showInstantNotification(
        title: loc.notificationsEnabledTitle, // "Сповіщення увімкнено! 🔔"
        body: loc
            .notificationsEnabledBody, // "Тепер ви будете отримувати нагадування."
      );
    } else {
      // Якщо вимкнули - можна скасувати всі заплановані
      await _notificationService.cancelAll();
    }
  }

  Future<void> _onDeleteAccountPressed() async {
    // 1. Отримуємо локалізацію
    final loc = AppLocalizations.of(context)!;
    final authService = AuthService();
    final firestoreService = FirestoreService();

    // 2. Показуємо діалог
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.deleteAccountTitle),
        content: Text(loc.deleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(loc.delete),
          ),
        ],
      ),
    );

    // Якщо натиснули "Відміна" або закрили вікно — нічого не робимо
    if (confirm != true) return;

    // Починаємо завантаження
    setState(() => _isLoading = true);

    try {
      // 3. Видаляємо дані з бази та самого юзера
      await firestoreService.deleteUserData();
      await authService.deleteAccount();

      if (!mounted) return;

      // 4. ПРАВИЛЬНА НАВІГАЦІЯ:
      // Переходимо на WelcomePage і видаляємо всю історію навігації
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Обробка помилки, якщо треба перелогінитись
        if (e.code == 'requires-recent-login') {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(loc.securityUpdate),
              content: Text(loc.reLoginRequiredMsg),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(loc.ok),
                ),
              ],
            ),
          );
        } else {
          CustomSnackBar.show(
            context,
            message: "Error deleting account: ${e.message}",
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackBar.show(
          context,
          message: "Error deleting account: $e",
          isError: true,
        );
      }
    }
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
              await _prefs.clear();
              if (!mounted) return;
              setState(() {
                ThemeService.isDarkModeNotifier.value = false;
                _notificationsEnabled = true;
              });
              Navigator.of(context).pop();
              CustomSnackBar.show(context, message: loc.dataClearedSuccess);
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

    // Якщо йде процес видалення, показуємо лоадер на весь екран
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

            // Очищення локальних даних
            ListTile(
              leading: Icon(
                Icons
                    .cleaning_services_outlined, // Змінив іконку, щоб не плутати з видаленням акаунту
                color: theme.colorScheme.onSurface,
              ),
              title: Text(loc.clearData),
              onTap: _confirmClearData,
            ),
            const Divider(),

            // === КНОПКА ВИДАЛЕННЯ АКАУНТУ ===
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text(
                loc.deleteAccount, // "Видалити акаунт"
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: _onDeleteAccountPressed,
            ),

            // =================================
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
