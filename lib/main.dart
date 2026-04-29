import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker_app/firebase_options.dart';
import 'package:gym_tracker_app/app.dart';
import 'package:gym_tracker_app/core/locale/locale_serviece.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await initializeDateFormatting('uk_UA', null);
  await ThemeService.init();
  await LocaleService.init();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  tz.initializeTimeZones();
  try {
    final dynamic localZone = await FlutterTimezone.getLocalTimezone();
    String tzName = (localZone is String)
        ? localZone
        : localZone.name.toString();
    tz.setLocalLocation(tz.getLocation(tzName));
  } catch (_) {}

  runApp(const MyApp());
}
