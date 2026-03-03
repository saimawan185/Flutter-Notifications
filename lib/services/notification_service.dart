// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationsService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //First method to run to init Flutter Local Notifications
  Future<void> initialize() async {
    // Notification Permission request
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    //Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    //iOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(requestProvisionalPermission: true);

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialization of Flutter Local Notifications Plugin
    flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  //Handle onTap on Notifications
  static void onNotificationTap(NotificationResponse notificationResponse) {
    log("Tap on Notification");
    final String? payload = notificationResponse.payload;
    final Map<String, dynamic> data = notificationResponse.data;

    //Perform actions based on Payload or Data
    if (payload == 'chat') {
      //Go to Chat Screen
    }

    if (data['isChat'] == true) {
      //Perform action
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
    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: "Notification",
      body: "This is test notification",
      notificationDetails: platformChannelSpecifics,
    );
  }

  //Schedule Notification - This will show notification after given time
  Future<void> scheduleNotification(
    int id,
    int hour,
    int mints,
    int seconds,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'Test Notificatoin',
      channelDescription: 'This is test notification!',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

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
        id: id,
        title: 'Scheduled Notification',
        body: 'This is scheduled test notification!',
        scheduledDate: tz.TZDateTime.from(time, tz.local),
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exact,
      );
    }
  }

  //Show Periodic Notification - This will show notification after every minute
  Future<void> showPeriodicNotification(int id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '2',
      'Periodic Test Notificatoin',
      channelDescription: 'This is periodic test notification!',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

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
      id: id,
      title: "Periodic Notification",
      body: "This is test periodic notification",
      repeatInterval: RepeatInterval.everyMinute, //You can set Intervals here
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  //Show Notification with Sound - This will simply show notification with sound
  Future<void> showNotificationWithSound(int id) async {
    //sound is in android->app->sr->main->res->raw->sound.wav
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '3',
      'Test Notificatoin with Sound',
      channelDescription: 'This is test notification with sound!',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('sound'),
    );

    //sound is in ios/Runner/sound.wav
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    tz.initializeTimeZones();

    log("Show Notification with Sound");
    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: "Notification with Sound",
      body: "This is test notification with sound",
      notificationDetails: platformChannelSpecifics,
    );
  }

  //Cancel All Notifications - This will cancel all notifications
  Future<void> cancleAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //Cancel Notification - THis will cancel specific notification using its id
  Future<void> cancleNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }
}
