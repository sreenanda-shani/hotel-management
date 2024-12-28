import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/hotel/hotel_booking.dart';
import 'package:project1/hotel/hotel_rooms.dart';
import 'package:project1/hotel/hotel_view.dart';
import 'package:project1/hotel/hotelmanage.dart';
import 'chat_screen.dart'; // Import the ChatScreenPage

class HotelHome extends StatefulWidget {
  const HotelHome({super.key});

  @override
  State<HotelHome> createState() => _HotelHomeState();
}

class _HotelHomeState extends State<HotelHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hotel Management",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
      ),
      body: Container(
        // Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('asset/img4.webp'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Container(
              // Group container for navigation buttons
              decoration: BoxDecoration(
                color: const Color.fromARGB(260, 202, 197, 197)
                    .withOpacity(0.85), // Slight transparency
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome to Hotel Management",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildNavigationButton(
                      context,
                      icon: Icons.book,
                      label: "View Bookings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookingHistoryPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildNavigationButton(
                      context,
                      icon: Icons.manage_accounts,
                      label: "Manage Hotel Details",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ManageHotelDetailsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildNavigationButton(
                      context,
                      icon: Icons.room_service,
                      label: "Manage Rooms",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ManageRoomDetailsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildNavigationButton(
                      context,
                      icon: Icons.room,
                      label: "View Rooms",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewRoomPage(
                              roomData: {
                                'id': 'dummyId',
                                'roomNumber': 101,
                                'rent': 100.0,
                                'acType': 'AC',
                                'bedType': 'Double Bed',
                                'wifiAvailable': true,
                                'balconyAvailable': false,
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const ChatScreenPage()), // Navigate to Chat Screen
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.chat, size: 30),
      ),
    );
  }

  // Button Builder
  Widget _buildNavigationButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 28),
      label: Text(label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 60),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shadowColor: Colors.black.withOpacity(0.2),
      ),
    );
  }
}

class ChatScreenPage extends StatelessWidget {
  const ChatScreenPage({super.key});

  // Function to fetch the sender's name from Firestore
  Future<String> fetchSenderName(String senderId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(
              'user') // Assuming the user information is in the 'users' collection
          .doc(senderId)
          .get();

      if (userDoc.exists) {
        return userDoc['name'] ??
            'Unknown'; // Retrieve the name or 'Unknown' if not found
      }
    } catch (e) {
      debugPrint('Error fetching sender name: $e');
    }
    return 'Unknown'; // Return 'Unknown' if an error occurs or user is not found
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Screen'),
          backgroundColor: Colors.black.withOpacity(0.7),
        ),
        body: const Center(
          child: Text('Please log in to view chats.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        backgroundColor: Colors.black.withOpacity(0.7),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('receiverId',
                isEqualTo: currentUserId) // Filter by receiverId
            .orderBy('timestamp',
                descending: true) // Order by timestamp for latest chats first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats available.'));
          }

          final chats = snapshot.data!.docs;

          // Group chats by senderId
          final Map<String, List<Map<String, dynamic>>> groupedChats = {};

          for (var chat in chats) {
            final senderId = chat['senderId'];
            if (!groupedChats.containsKey(senderId)) {
              groupedChats[senderId] = [];
            }
            // Correct data retrieval
            groupedChats[senderId]!.add(chat.data() as Map<String, dynamic>);
          }

          // Display a list tile for each sender
          return ListView.builder(
            itemCount: groupedChats.keys.length,
            itemBuilder: (context, index) {
              final senderId = groupedChats.keys.elementAt(index);
              final senderChats = groupedChats[senderId]!;
              final latestChat =
                  senderChats.first; // Get the latest chat from this sender

              final message = latestChat['message'];

              // Fetch the sender's name using the fetchSenderName function
              return FutureBuilder<String>(
                future: fetchSenderName(senderId),
                builder: (context, nameSnapshot) {
                  if (nameSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                      subtitle: Text('Fetching sender details'),
                    );
                  }

                  if (nameSnapshot.hasError || !nameSnapshot.hasData) {
                    return ListTile(
                      title: const Text('Error loading sender details'),
                      subtitle: Text(message),
                    );
                  }

                  final senderName = nameSnapshot.data!;

                  return ListTile(
                    title: Text(senderName), // Display sender's name
                    subtitle: Text(message), // Display the latest chat message
                    leading: const Icon(Icons.account_circle, size: 40),
                    trailing: const Icon(Icons.chat_bubble_outline),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(senderId: senderId),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
