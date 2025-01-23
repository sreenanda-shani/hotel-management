import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // To format the timestamp

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<DocumentSnapshot> _notifications = []; // Local list of notifications

  // Fetch notifications from Firestore
  void fetchNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()  // Real-time updates
        .listen((snapshot) {
      setState(() {
        _notifications = snapshot.docs;  // Update local list with new data
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();  // Fetch notifications when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _notifications.isEmpty
            ? const Center(child: Text('No notifications available.'))
            : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index].data() as Map<String, dynamic>;
                  // Extract title, message, and timestamp from the notification document
                  final title = notification['title'] ?? 'No title available';
                  final message = notification['message'] ?? 'No message available';
                  final timestamp = notification['timestamp'];

                  return NotificationCard(
                    title: title,
                    message: message,
                    timestamp: timestamp,
                  );
                },
              ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final Timestamp timestamp;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // Format the timestamp to a user-friendly format
    final formattedTime = DateFormat('MMM dd, yyyy, hh:mm a').format(timestamp.toDate());

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,  // Display the formatted timestamp
              style: const TextStyle(fontSize: 12, color: Colors.teal),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.notifications,
          color: Colors.teal,
        ),
        onTap: () {
          // Action on tap (e.g., navigate to more details, or show a message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification tapped: $title')),
          );
        },
      ),
    );
  }
}
