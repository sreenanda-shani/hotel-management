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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('staff')
          .where('hotelUid', isEqualTo: hotelId)
          .get();

      return querySnapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Error fetching staff details: $e');
    }
  }

  // Fetch feedback for a particular staff member
  Future<List<Map<String, dynamic>>> fetchFeedback(String staffId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('stafffeedback')
          .where('staffId', isEqualTo: staffId)
          .get();

      return querySnapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print('Error fetching feedback: $e');
      return [];
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

  // Send notification to a staff member
  Future<void> sendNotification(String staffId, String notificationMessage) async {
    try {
      await FirebaseFirestore.instance.collection('staffpersonalnoti').add({
        'staffId': staffId,
        'notification': notificationMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Show dialog for sending notification
  void _showNotificationDialog(String staffId) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Notification'),
          content: TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Enter your notification message'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final notificationMessage = _controller.text.trim();
                if (notificationMessage.isNotEmpty) {
                  await sendNotification(staffId, notificationMessage);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification sent successfully')),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog before deleting staff
  void _showDeleteDialog(String staffId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Staff'),
          content: const Text('Are you sure you want to delete this staff member?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await deleteStaff(staffId);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Staff deleted successfully')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Delete the staff from Firestore
  Future<void> deleteStaff(String staffId) async {
    try {
      await FirebaseFirestore.instance.collection('staff').doc(staffId).delete();
    } catch (e) {
      print('Error deleting staff: $e');
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

                      const SizedBox(height: 8),

                      // Row for notification button and delete button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Notification button for each staff
                          ElevatedButton(
                            onPressed: () => _showNotificationDialog(staff['id']),
                            child: const Text('Send Notification'),
                          ),

                          // Delete button for each staff
                          ElevatedButton(
                            onPressed: () => _showDeleteDialog(staff['id']),
                            child: const Text('Delete Staff'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Red color for delete button
                            ),
                          ),
                          
                          // Feedback Icon button for each staff
                          IconButton(
                            icon: const Icon(Icons.feedback),
                            onPressed: () async {
                              final feedback = await fetchFeedback(staff['id']);
                              // Handle feedback (show it in a dialog or other UI)
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Feedback'),
                                    content: feedback.isNotEmpty
                                        ? Column(
                                            children: feedback
                                                .map((f) => Text(f['feedback']))
                                                .toList(),
                                          )
                                        : const Text('No feedback available for this staff.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StaffNoti()),
          );
        },
        child: const Icon(Icons.notifications),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
