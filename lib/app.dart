import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/locale/locale_serviece.dart';
import 'package:gym_tracker_app/features/auth/pages/verify_email_page.dart';
import 'package:gym_tracker_app/features/welcome/pages/welcome_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/sync_badge.dart';
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
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeModeNotifier,
      builder: (context, currentThemeMode, child) {
        return ValueListenableBuilder<Locale?>(
          valueListenable: LocaleService.localeNotifier,
          builder: (context, currentLocale, child) {
            return MaterialApp(
              title: 'Gym Tracker',
              locale: currentLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', ''), Locale('uk', '')],
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return SyncBadge(child: child!);
              },
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: currentThemeMode == ThemeMode.dark
                      ? Colors.indigo
                      : Colors.teal,
                  brightness: Brightness.light,
                ),
                appBarTheme: const AppBarTheme(
                  centerTitle: false,
                  scrolledUnderElevation: 0.0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                ),
                textTheme: const TextTheme(
                  displaySmall: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  titleLarge: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  titleMedium: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  bodyLarge: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
                  labelLarge: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                appBarTheme: const AppBarTheme(
                  scrolledUnderElevation: 0.0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                ),
                textTheme: const TextTheme(
                  displaySmall: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  titleLarge: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  titleMedium: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  bodyLarge: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
                  labelLarge: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              themeMode: currentThemeMode,
              home: StreamBuilder<fb_auth.User?>(
                stream: fb_auth.FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    if (user.emailVerified) {
                      return const WidgetTree();
                    } else {
                      return const VerifyEmailPage();
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
