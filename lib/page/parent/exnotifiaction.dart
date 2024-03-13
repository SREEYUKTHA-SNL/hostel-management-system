import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/parent/notifications.dart';

class ExNotification extends StatefulWidget {
  const ExNotification({super.key});

  @override
  State<ExNotification> createState() => _ExNotificationState();
}

class _ExNotificationState extends State<ExNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Column(children: [
        ElevatedButton.icon(
          icon: Icon(Icons.notifications_outlined),
          label: Text('Get Notifications'),
          onPressed: () {
            LocalNotifications.showNotification(
                title: "Notificatons",
                body: "This is a notification",
                payload: "this is simple");
          },
        )
      ]),
    );
  }
}
