import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/locale/locale_serviece.dart';
import 'package:gym_tracker_app/features/auth/pages/verify_email_page.dart';
import 'package:gym_tracker_app/features/welcome/pages/welcome_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/theme_service.dart';

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
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return ValueListenableBuilder<Locale>(
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
              home: StreamBuilder<fb_auth.User?>(
                stream: fb_auth.FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  // Поки перевіряємо статус
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasData) {
                    final user = snapshot.data!;

                    // Перевіряємо, чи підтверджена пошта
                    if (user.emailVerified) {
                      return const WidgetTree(); // Пускаємо в додаток
                    } else {
                      return const VerifyEmailPage(); // Просимо підтвердити
                    }
                  }

                  return const WelcomePage();
                },
              ),
            );
          },
        );
      },
    );
  }
}
