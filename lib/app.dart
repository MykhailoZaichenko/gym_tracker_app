import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/locale/locale_serviece.dart';
import 'package:gym_tracker_app/data/sources/local/app_db.dart';
import 'package:gym_tracker_app/features/welcome/pages/welcome_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/theme_service.dart';

Future<bool> _hasLoggedInUser() async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getInt('current_user_id');
  if (id == null) return false;
  final user = await AppDb().getUserById(id);
  return user != null;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeService.isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return ValueListenableBuilder(
          valueListenable: LocaleService.localeNotifier,
          builder: (context, currentLocale, child) {
            return MaterialApp(
              locale: currentLocale,
              // 1. Вказуємо клас, який надає локалізації
              localizationsDelegates: const [
                AppLocalizations.delegate, // Наш згенерований делегат
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // 2. Вказуємо список підтримуваних мов
              supportedLocales: const [
                Locale('en', ''), // English
                Locale('uk', ''), // Ukrainian
              ],
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: isDarkMode ? Colors.indigo : Colors.teal,
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData.dark(),
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: FutureBuilder<bool>(
                future: _hasLoggedInUser(),
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final loggedIn = snap.data == true;
                  return loggedIn ? WidgetTree() : const WelcomePage();
                },
              ),
            );
          },
        );
      },
    );
  }
}
