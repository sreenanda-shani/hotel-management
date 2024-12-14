import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  List<DocumentSnapshot> _notifications = []; // Local list of notifications

  // Function to send notification
  Future<void> sendNotification(String title, String message) async {
    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and message cannot be empty')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent successfully')),
      );
      _titleController.clear();
      _messageController.clear();
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send notification')),
      );
    }
  }

  // Function to fetch notifications from Firestore
  void fetchNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get()
        .then((snapshot) {
      setState(() {
        _notifications = snapshot.docs; // Update local list
      });
    }).catchError((e) {
      print('Error fetching notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch notifications')),
      );
    });
  }

  // Function to clear local notifications
  void clearNotifications() {
    setState(() {
      _notifications.clear(); // Clear the local list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications cleared locally')),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications(); // Fetch notifications when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: clearNotifications, // Clear local notifications
            tooltip: 'Clear Notifications',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Notification Message',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  sendNotification(
                    _titleController.text.trim(),
                    _messageController.text.trim(),
                  );
                },
                child: const Text('Send Notification'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _notifications.isEmpty
                  ? const Center(child: Text('No notifications found.'))
                  : ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index].data() as Map<String, dynamic>;
                        // Safely check if 'title' and 'message' exist
                        final title = notification['title'] ?? 'No title available';
                        final message = notification['message'] ?? 'No message available';
                        final timestamp = notification['timestamp'];

                        return Card(
                          child: ListTile(
                            title: Text(title),
                            subtitle: Text(message),
                            trailing: Text(
                              timestamp != null
                                  ? (timestamp as Timestamp).toDate().toString()
                                  : 'Unknown time',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
