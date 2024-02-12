// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationsService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotificationClicked = BehaviorSubject<String>();

  Future<void> initialize() async {
    //Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    //iOS
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) {});

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    await Permission.notification.request();
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onNotificationClicked.add(notificationResponse.payload!);
  }

  //Schedule Notification - This will show notification after 10 seconds
  Future<void> scheduleNotification(
      int id, int hour, int mints, int seconds) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1', 'Test Notificatoin',
            channelDescription: 'This is test notification!',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    tz.initializeTimeZones();

    DateTime time = DateTime.now()
        .add(Duration(hours: hour, minutes: mints, seconds: seconds));

    if (time.isAfter(DateTime.now())) {
      log("Notification Scheduled");
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Scheduled Notification',
        'This is scheduled test notification!',
        tz.TZDateTime.from(time, tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  //Show Notification - This will simply show notification
  Future<void> showNotification(int id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('0', 'Test Notificatoin',
            channelDescription: 'This is test notification!',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    tz.initializeTimeZones();

    log("Show Notification");
    await flutterLocalNotificationsPlugin.show(id, "Notification",
        "This is test notification", platformChannelSpecifics);
  }

  //Show Periodic Notification - This will show notification after every minute
  Future<void> showPeriodicNotification(int id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('2', 'Periodic Test NotXificatoin',
            channelDescription: 'This is periodic test notification!',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    tz.initializeTimeZones();

    log("Show Periodic Notification");

    await flutterLocalNotificationsPlugin.periodicallyShow(
        id,
        "Periodic Notification",
        "This is test periodic notification",
        RepeatInterval.everyMinute,
        platformChannelSpecifics);
  }

  //Show Notification with Sound - This will simply show notification with sound
  Future<void> showNotificationWithSound(int id) async {
    //sound is in android->app->sr->main->res->raw
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('3', 'Test Notificatoin with Sound',
            channelDescription: 'This is test notification with sound!',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            sound: RawResourceAndroidNotificationSound('sound'));

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    tz.initializeTimeZones();

    log("Show Notification with Sound");
    await flutterLocalNotificationsPlugin.show(id, "Notification with Sound",
        "This is test notification with sound", platformChannelSpecifics);
  }

  //Cancel All Notifications - This will cancel all notifications
  Future<void> cancleAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //Cancel Notification - THis will cancel specific notification using its id
  Future<void> cancleNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
