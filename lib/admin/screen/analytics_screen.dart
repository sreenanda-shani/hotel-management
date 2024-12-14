import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int totalUsers = 0;
  int totalNotifications = 0;

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  // Fetch analytics data from Firestore
  Future<void> fetchAnalytics() async {
    try {
      // Fetch total users
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        totalUsers = userSnapshot.size; // Count of user documents
      });

      // Fetch total notifications
      QuerySnapshot notificationSnapshot =
          await FirebaseFirestore.instance.collection('notifications').get();
      setState(() {
        totalNotifications = notificationSnapshot.size; // Count of notification documents
      });
    } catch (e) {
      print('Error fetching analytics data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch analytics data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Analytics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blue, size: 40),
                title: const Text('Total Users'),
                subtitle: Text(
                  totalUsers.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications,
                    color: Colors.orange, size: 40),
                title: const Text('Total Notifications Sent'),
                subtitle: Text(
                  totalNotifications.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'More analytics features coming soon...',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}