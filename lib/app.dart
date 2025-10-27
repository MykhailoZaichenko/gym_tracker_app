import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/sources/local/app_db.dart';
import 'package:gym_tracker_app/features/welcome/pages/welcome_page.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        return MaterialApp(
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
  }
}
