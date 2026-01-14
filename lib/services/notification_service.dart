import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    // 🔥 ВАЖЛИВО: Спробуємо встановити локальний час.
    // Без цього tz.local може бути UTC, і сповіщення приходитимуть із запізненням на 2-3 години.
    try {
      final String timeZoneName =
          (await FlutterTimezone.getLocalTimezone()) as String;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      print("Error setting local timezone: $e");
      // Фолбек на UTC, якщо не вдалося визначити (краще, ніж нічого)
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {},
    );

    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      await _createNotificationChannel();
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'main_channel',
      'General Notifications',
      description: 'Main channel for app notifications',
      importance: Importance.max,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'main_channel',
      'General Notifications',
      channelDescription: 'Main channel for app notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
    );
  }

  Future<void> scheduleRemindersForDays({
    required List<int> days,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await cancelWeightReminders();

    const androidDetails = AndroidNotificationDetails(
      'weight_channel',
      'Weight Reminders',
      channelDescription: 'Reminders to record body weight',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    for (final day in days) {
      final scheduledDate = _nextInstanceOfDayAndTime(day, hour, minute);

      await _notificationsPlugin.zonedSchedule(
        day,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> cancelWeightReminders() async {
    for (int i = 0; i <= 7; i++) {
      await _notificationsPlugin.cancel(i);
    }
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    return scheduledDate;
  }

  Future<void> cancelReminders() async {
    await _notificationsPlugin.cancel(0);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
