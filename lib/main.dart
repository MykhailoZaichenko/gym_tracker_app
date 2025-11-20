import 'package:flutter/material.dart';
import 'package:gym_tracker_app/app.dart';
import 'package:gym_tracker_app/core/locale/locale_serviece.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uk_UA', null);
  await ThemeService.init();
  await LocaleService.init();
  runApp(const MyApp());
}
