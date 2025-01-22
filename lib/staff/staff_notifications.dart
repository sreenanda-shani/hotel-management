import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffNotifications extends StatefulWidget {
  const StaffNotifications({super.key});

  @override
  State<StaffNotifications> createState() => _StaffNotificationsState();
}

class _StaffNotificationsState extends State<StaffNotifications> {
  String? currentHotelId; // To store the hotelId

  // Fetch the hotelId (hotelUid) from the staff collection
  Future<void> fetchHotelId() async {
    try {
      // Assuming the current user's ID is stored in FirebaseAuth or passed down (you can adjust this part)
      // For example, fetch the current user's hotelUid from FirebaseAuth or another source.
      // This code assumes you already have the current user's staffId or another way to identify them.

      // Example for getting current staff ID (assuming FirebaseAuth or similar):
      String staffId = FirebaseAuth.instance.currentUser!.uid;  // Replace with actual logic to get current user id
      
      // Fetch the document for the current staff
      DocumentSnapshot staffDoc = await FirebaseFirestore.instance
          .collection('staff')
          .doc(staffId)  // Fetch staff by ID (could be currentUserId)
          .get();

      if (staffDoc.exists) {
        setState(() {
          currentHotelId = staffDoc['hotelUid'];  // Save hotelUid from the staff document
        });
      }
    } catch (e) {
      throw Exception('Error fetching hotel ID: $e');
    }
  }

  // Fetch notifications that match the hotelId
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    if (currentHotelId == null) {
      // Return empty list if hotelId is not set yet
      return [];
    }
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('staffnoti')
          .where('hotelId', isEqualTo: currentHotelId)  // Filter by hotelId
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                "title": doc['title'],
                "message": doc['message'],
                "timestamp": doc['timestamp'],
              })
          .toList();
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHotelId();  // Fetch hotelId when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No notifications found.'),
            );
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final String title = notification['title'];
              final String message = notification['message'];
              final Timestamp timestamp = notification['timestamp'];
              final DateTime time = timestamp.toDate();

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notification Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Notification Message
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Timestamp
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${time.toLocal()}'.split(' ')[0], // Only the date part
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



