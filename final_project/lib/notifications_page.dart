// notifications_page.dart

import 'package:flutter/material.dart';
import 'notification_helper.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications
    NotificationHelper.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Use the NotificationHelper to show the notification
            NotificationHelper.showNotification(
              'Reminder',
              'Please fill in VIN, Color, Mileage, and Fuel Capacity for the vehicle.',
            );
          },
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}


