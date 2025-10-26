import 'dart:io';
import 'dart:math';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<bool?> requestNotificationPermission() async {
    if (Platform.isIOS) {
      return await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else {
      return flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  AndroidNotificationSound getSound(String type) {
    if (type == "open_full") {
      return const RawResourceAndroidNotificationSound("cua_cuon_da_mo");
    } else if (type == "close_full") {
      return const RawResourceAndroidNotificationSound("cua_cuon_da_dong");
    }
    // else if (type == "smoke_warning") {
    //   return const RawResourceAndroidNotificationSound("warning_alarm");
    // } else if (type == "battery_warning") {
    //   return const RawResourceAndroidNotificationSound("new_alarm");
    // }
    else {
      return const RawResourceAndroidNotificationSound("");
    }
  }

  Future<void> sendSimpleNotification(String title, String body) async {
    Random random = Random();
    int notificationID =
        random.nextInt(1000000); // Unique ID for each notification

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      notificationID.toString(), // Use unique ID for channel
      'default_channel',
      channelDescription: 'default_channel description',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      notificationID, // Use unique ID for notification
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> sendSoundNotification(
      String title, String body, String type) async {
    Random random = Random();
    int notificationID =
        random.nextInt(1000000); // Unique ID for each notification

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      notificationID.toString(), // Use unique ID for channel
      'importance_channel',
      channelDescription: 'importance_channel description',
      importance: Importance.max,
      priority: Priority.max,
      sound: getSound(type),
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      notificationID, // Use unique ID for notification
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> sendCustomSoundNotification(
      String title, String body, String soundName) async {
    Random random = Random();
    int notificationID = random.nextInt(1000000);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      notificationID.toString(),
      'importance_channel',
      channelDescription: 'importance_channel description',
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound(soundName),
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      notificationID,
      title,
      body,
      notificationDetails,
    );
  }

  static Future zonedScheduleNotification(int duration, String body) async {
    Random random = Random();
    String notificationID = random.nextInt(1000000).toString();
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(notificationID, 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    tz.initializeTimeZones();

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Thông báo',
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: duration)),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
