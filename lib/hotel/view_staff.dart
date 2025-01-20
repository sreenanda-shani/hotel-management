import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewStaffPage extends StatelessWidget {
  final String hotelId;

  const ViewStaffPage({super.key, required this.hotelId});

  Future<List<Map<String, dynamic>>> fetchStaffDetails(String hotelId) async {
    try {
      // Query Firestore to get staff where staffId matches hotelId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('staff')
          .where('staffId', isEqualTo: hotelId)
          .get();

      // Map the results to a list of maps
      return querySnapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Error fetching staff details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Staff Details'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchStaffDetails(hotelId),
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
              child: Text('No staff found for this hotel.'),
            );
          }

          // Extract staff details
          final staffList = snapshot.data!;

          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${staff['fullName']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Email: ${staff['email']}'),
                      Text('Phone: ${staff['phone']}'),
                      Text('Address: ${staff['address']}'),
                      Text('Role: ${staff['role']}'),
                      Text('Staff ID: ${staff['staffId']}'),
                      const SizedBox(height: 8),
                      Text(
                        'Created At: ${(staff['createdAt'] as Timestamp?)?.toDate().toString() ?? 'N/A'}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
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
