import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  // Sample data for notifications
  final List<String> notifications = [
    "Your profile has been updated successfully.",
    "New message from John.",
    "Your order has been shipped.",
    "Reminder: Your appointment is tomorrow at 10 AM.",
    "Your password has been changed."
  ];

   NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return NotificationCard(notification: notifications[index]);
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          notification,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(
          Icons.notifications,
          color: Colors.blue,
        ),
        onTap: () {
          // You can add an action on notification tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification tapped: $notification')),
          );
        },
      ),
    );
  }
}