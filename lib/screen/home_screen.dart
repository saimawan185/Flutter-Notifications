import 'package:flutter/material.dart';
import 'package:flutter_notifications/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await NotificationsService().showNotification(0);
                },
                child: const Text(
                  "Show Notification",
                  style: TextStyle(color: Colors.blueAccent),
                )),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  await NotificationsService()
                      .scheduleNotification(1, 0, 0, 10);
                },
                child: const Text("Schedule Notification")),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  await NotificationsService().showPeriodicNotification(2);
                },
                child: const Text(
                  "Show Periodic Notification",
                  style: TextStyle(color: Colors.green),
                )),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  await NotificationsService().showNotificationWithSound(3);
                },
                child: const Text(
                  "Show Notification with Sound",
                  style: TextStyle(color: Colors.black),
                )),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  await NotificationsService().cancleNotification(1);
                },
                child: Text(
                  "Cancel Notification",
                  style: TextStyle(color: Colors.redAccent.shade400),
                )),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  await NotificationsService().cancleAllNotifications();
                },
                child: const Text(
                  "Cancel All Notifications",
                  style: TextStyle(color: Colors.redAccent),
                )),
          ],
        ),
      ),
    );
  }
}
