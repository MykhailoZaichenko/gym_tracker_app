import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    try {
      final dynamic localZone = await FlutterTimezone.getLocalTimezone();
      String tzName = (localZone is String)
          ? localZone
          : localZone.name.toString();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (e) {
      debugPrint('Timezone error: $e');
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
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    const AndroidNotificationChannel mainChannel = AndroidNotificationChannel(
      'main_channel',
      'General Notifications',
      description: 'Main channel for app notifications',
      importance: Importance.max,
      playSound: true,
    );
    await androidPlugin?.createNotificationChannel(mainChannel);

    const AndroidNotificationChannel weightChannel = AndroidNotificationChannel(
      'weight_channel',
      'Weight Reminders',
      description: 'Reminders to record body weight',
      importance: Importance.high,
      playSound: true,
    );
    await androidPlugin?.createNotificationChannel(weightChannel);
  }

  Future<void> scheduleStreakReminder({
    required String title,
    required String body,
    int hour = 20, // За замовчуванням о 20:00
    int minute = 0,
  }) async {
    // 1. Спочатку скасовуємо попереднє нагадування про стрік (ID 100)
    await _notificationsPlugin.cancel(100);

    // Використовуємо канал weight_channel, щоб не плодити нові (або можна створити окремий)
    const androidDetails = AndroidNotificationDetails(
      'weight_channel',
      'Streak Reminders',
      channelDescription: 'Reminders to keep your workout streak alive',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    // 2. Обчислюємо час для завтрашнього дня
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).add(const Duration(days: 1)); // Додаємо рівно один день

    // 3. Плануємо сповіщення
    await _notificationsPlugin.zonedSchedule(
      100, // Фіксований ID для нагадувань про стрік
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Вказуємо absoluteTime, бо це одноразове сповіщення,
      // яке ми будемо вручну переносити після кожного тренування
      matchDateTimeComponents: DateTimeComponents.time,
    );
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
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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
