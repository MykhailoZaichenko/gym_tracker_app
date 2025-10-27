import 'package:flutter/material.dart';
import 'package:gym_tracker_app/app.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uk_UA', null);
  await ThemeService.init();
  runApp(const MyApp());
}
