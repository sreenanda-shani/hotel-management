import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int totalUsers = 0;
  int totalNotifications = 0;
  int totalBookings = 0;
  int totalComplaints = 0;

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
          await FirebaseFirestore.instance.collection('user').get();
      setState(() {
        totalUsers = userSnapshot.size; // Count of user documents
      });

      // Fetch total notifications
      QuerySnapshot notificationSnapshot =
          await FirebaseFirestore.instance.collection('notifications').get();
      setState(() {
        totalNotifications = notificationSnapshot.size; // Count of notification documents
      });

      // Fetch total bookings
      QuerySnapshot bookingSnapshot =
          await FirebaseFirestore.instance.collection('booking').get();
      setState(() {
        totalBookings = bookingSnapshot.size; // Count of booking documents
      });

      // Fetch total complaints
      QuerySnapshot complaintSnapshot =
          await FirebaseFirestore.instance.collection('complaints').get();
      setState(() {
        totalComplaints = complaintSnapshot.size; // Count of complaint documents
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
        title: const Text('Analytics', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildCard(
              icon: Icons.person,
              iconColor: Colors.blue,
              title: 'Total Users',
              value: totalUsers.toString(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.notifications,
              iconColor: Colors.orange,
              title: 'Total Notifications Sent',
              value: totalNotifications.toString(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.book_online,
              iconColor: Colors.green,
              title: 'Total Bookings',
              value: totalBookings.toString(),
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.feedback,
              iconColor: Colors.red,
              title: 'Total Complaints',
              value: totalComplaints.toString(),
            ),
            const SizedBox(height: 20),
            const Text(
              'More analytics features coming soon...',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create the analytics cards
  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor, size: 32),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}
