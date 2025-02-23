import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffNotifications extends StatefulWidget {
  const StaffNotifications({super.key});

  @override
  State<StaffNotifications> createState() => _StaffNotificationsState();
}

class _StaffNotificationsState extends State<StaffNotifications> {
  String? currentHotelId;
  Future<void> fetchHotelId() async {
    try {
      String staffId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot staffDoc = await FirebaseFirestore.instance
          .collection('staff')
          .doc(staffId)
          .get();

      if (staffDoc.exists) {
        setState(() {
          currentHotelId = staffDoc['hotelUid'];
        });
      }
    } catch (e) {
      throw Exception('Error fetching hotel ID: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    if (currentHotelId == null) {
      return [];
    }
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('staffnoti')
          .where('hotelId', isEqualTo: currentHotelId)
          .get();

// Sort the results in memory
      var sortedDocs = querySnapshot.docs.toList()
        ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

      return sortedDocs
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
    fetchHotelId();
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
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                          '${time.toLocal()}'.split(' ')[0],
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