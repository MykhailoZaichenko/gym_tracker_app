import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/locale/locale_serviece.dart';
import 'package:gym_tracker_app/features/welcome/pages/welcome_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/notification_service.dart';
import 'package:gym_tracker_app/widget/common/custome_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:gym_tracker_app/services/auth_service.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  bool _notificationsEnabled = true;
  bool _isLoading = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
    if (mounted) setState(() {});
  }

  Future<void> _toggleNotifications(bool value) async {
    final loc = AppLocalizations.of(context)!;

    if (value) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(loc.enableNotificationsTitle),
          content: Text(loc.enableNotificationsBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(loc.noThanks),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(loc.yesSetUp),
            ),
          ],
        ),
      );

      if (confirm != true) {
        setState(() => _notificationsEnabled = false);
        return;
      }

      await _notificationService.init();
      setState(() => _notificationsEnabled = true);
      await _prefs.setBool('notifications_enabled', true);

      await _notificationService.showInstantNotification(
        title: loc.notificationsEnabledTitle,
        body: loc.notificationsEnabledBody,
      );
    } else {
      setState(() => _notificationsEnabled = false);
      await _prefs.setBool('notifications_enabled', false);
      await _notificationService.cancelAll();
    }
  }

  Future<void> _onDeleteAccountPressed() async {
    final loc = AppLocalizations.of(context)!;
    final authService = AuthService();
    final firestoreService = FirestoreService();

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

    if (confirm != true) return;
    setState(() => _isLoading = true);

    try {
      await firestoreService.deleteUserData();
      await authService.deleteAccount();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
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
    final textTheme = Theme.of(context).textTheme;
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
              Text(loc.appLanguage, style: textTheme.titleLarge),
              const SizedBox(height: 16),
              // НОВА КНОПКА: Як у системі
              ListTile(
                leading: const Icon(Icons.settings_suggest, size: 24),
                title: Text(loc.systemLanguage),
                trailing: null,
                onTap: () {
                  LocaleService.changeLocale(
                    null,
                  ); // Передаємо null для системи
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text('🇺🇦', style: TextStyle(fontSize: 24)),
                title: const Text('Українська'),
                trailing:
                    LocaleService.localeNotifier.value?.languageCode == 'uk'
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
                    LocaleService.localeNotifier.value?.languageCode == 'en'
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

  void _showThemeSelector() {
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final loc = AppLocalizations.of(context)!;
        return SafeArea(
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeService.themeModeNotifier,
            builder: (context, currentMode, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Text(loc.themeSelectionTitle, style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.brightness_auto),
                    title: Text(loc.systemMode),
                    trailing: currentMode == ThemeMode.system
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      ThemeService.changeTheme(ThemeMode.system);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.light_mode),
                    title: Text(loc.lightMode),
                    trailing: currentMode == ThemeMode.light
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      ThemeService.changeTheme(ThemeMode.light);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: Text(loc.darkMode),
                    trailing: currentMode == ThemeMode.dark
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      ThemeService.changeTheme(ThemeMode.dark);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
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
              ThemeService.changeTheme(ThemeMode.system);
              if (!mounted) return;
              setState(() {
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
    final textTheme = Theme.of(context).textTheme;
    final loc = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settingsTitle, style: textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeService.themeModeNotifier,
              builder: (context, currentMode, child) {
                String themeName = loc.systemMode;
                if (currentMode == ThemeMode.light) themeName = loc.lightMode;
                if (currentMode == ThemeMode.dark) themeName = loc.darkMode;

                return ListTile(
                  leading: Icon(
                    Icons.brightness_6,
                    color: theme.colorScheme.onSurface,
                  ),
                  title: Text(
                    loc.themeSelectionTitle,
                    style: textTheme.bodyLarge,
                  ),
                  subtitle: Text(themeName, style: textTheme.bodyMedium),
                  onTap: _showThemeSelector,
                );
              },
            ),
            const Divider(),
            ValueListenableBuilder<Locale?>(
              valueListenable: LocaleService.localeNotifier,
              builder: (context, locale, child) {
                // Визначаємо, що писати в підзаголовку
                String subtitleText =
                    loc.systemLanguage; // Наш новий ключ локалізації
                if (locale?.languageCode == 'uk') subtitleText = 'Українська';
                if (locale?.languageCode == 'en') subtitleText = 'English';

                return ListTile(
                  leading: Icon(
                    Icons.language,
                    color: theme.colorScheme.onSurface,
                  ),
                  title: Text(loc.appLanguage, style: textTheme.bodyLarge),
                  subtitle: Text(subtitleText, style: textTheme.bodyMedium),
                  onTap: _showLanguageSelector,
                );
              },
            ),
            const Divider(),
            SwitchListTile(
              secondary: Icon(
                Icons.notifications,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(loc.notifications, style: textTheme.bodyLarge),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.cleaning_services_outlined,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(loc.clearData, style: textTheme.bodyLarge),
              onTap: _confirmClearData,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text(
                loc.deleteAccount,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: _onDeleteAccountPressed,
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(loc.aboutApp, style: textTheme.bodyLarge),
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
