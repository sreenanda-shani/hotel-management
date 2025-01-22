import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/hotel/staff_noti.dart';

class ViewStaffPage extends StatefulWidget {
  final String hotelId;

  const ViewStaffPage({super.key, required this.hotelId});

  @override
  _ViewStaffPageState createState() => _ViewStaffPageState();
}

class _ViewStaffPageState extends State<ViewStaffPage> {
  // Define the list of roles
  final List<String> roles = [
    'Receptionist',
    'Room Cleaning',
    'Manager',
    'Concierge',
    'Chef',
    'Waiter/Waitress',
    'Security',
    'Maintenance',
    'Event Coordinator',
    'Bellhop',
    'Front Desk Supervisor',
    'Housekeeper',
    'Food and Beverage Manager',
    'Spa Therapist',
    'Valet Parking Attendant',
  ];

  // Fetch staff details from Firestore
  Future<List<Map<String, dynamic>>> fetchStaffDetails(String hotelId) async {
    try {
      // Query Firestore to get staff where hotelUid matches the provided hotelId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('staff')
          .where('hotelUid', isEqualTo: hotelId) // Matching on hotelUid
          .get();

      // Map the results to a list of maps
      return querySnapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Error fetching staff details: $e');
    }
  }

  // Update the staff's role in Firestore
  Future<void> updateRoleInFirestore(String staffId, String newRole) async {
    try {
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(staffId)
          .update({'role': newRole});
    } catch (e) {
      print('Error updating role: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Staff Details'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: fetchStaffDetails(widget.hotelId),
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

          final staffList = snapshot.data!;

          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              String? selectedRole = staff['role']; // Current role for the staff

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
                      const SizedBox(height: 16),

                      // Dropdown button for role selection
                      DropdownButton<String>(
                        value: selectedRole,
                        onChanged: (String? newRole) async {
                          if (newRole != null && newRole != selectedRole) {
                            // Update role in Firestore
                            await updateRoleInFirestore(staff['id'], newRole);

                            // Update the local state
                            setState(() {
                              selectedRole = newRole;
                            });
                          }
                        },
                        items: roles.map<DropdownMenuItem<String>>((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        hint: const Text('Select Role'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      
      // Floating Action Button with Notification Icon
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the "StaffNoti" page when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StaffNoti()), // Navigate to StaffNotiPage
          );
        },
        child: const Icon(Icons.notifications),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
