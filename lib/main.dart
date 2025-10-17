import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/constants.dart';
import 'package:gym_tracker_app/data/notiers.dart';
import 'package:gym_tracker_app/data/db/app_db.dart';

import 'package:gym_tracker_app/views/pages/welcome_page.dart';
import 'package:gym_tracker_app/views/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

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
    initThemeMode();
    super.initState();
  }

  void initThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isDarkMode = prefs.getBool(KCOnstats.themeModeKey);
    isDarkModeNotifier.value = isDarkMode ?? false; // default light mode
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
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
