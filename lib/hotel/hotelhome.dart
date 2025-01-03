import 'package:flutter/material.dart';
import 'package:project1/choose_screen.dart';
import 'package:project1/hotel/hotel_profile.dart';
import 'package:project1/hotel/hotel_view.dart';
import 'package:project1/hotel/hotelmanage.dart';
import 'package:project1/user/bookinghistory.dart';
import 'package:project1/user/roombooking.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelApp extends StatelessWidget {
  const HotelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HotelHome(),
    );
  }
}

class HotelHome extends StatelessWidget {
  const HotelHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a GlobalKey for the ScaffoldState to open the drawer
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey, // Set the scaffold key here
      appBar: AppBar(
        backgroundColor: Colors.black,  // Set background color to black
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open the drawer (burger menu)
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer using the key
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HotelProfile()),
              );
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'asset/download.png', // Replace with your logo asset path
                height: 40,  // Adjust the size of the logo
                width: 40,
                fit: BoxFit.cover, // Ensure the image fits within the circle
              ),
            ),
            const SizedBox(width: 8), // Space between logo and text
            const Text(
              'Hotel App',
              style: TextStyle(
                color: Colors.white, // Set text color to white
              ),
            ),
          ],
        ),
      ),
      // Add the Drawer (burger menu)
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header with logo and hotel name
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black, // Set background color for header
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'asset/download.png', // Replace with your logo asset path
                      height: 60,  // Adjust the size of the logo in the drawer
                      width: 60,
                      fit: BoxFit.cover, // Ensure the image fits within the circle
                    ),
                  ),
                  const SizedBox(width: 16), // Space between logo and text
                  const Text(
                    'Hotel Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // List of buttons inside the drawer
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.black),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HotelProfile()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.hotel, color: Colors.black),
              title: const Text('View Rooms'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRoomPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.black),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ChooseScreen()));
                // Add your logout functionality here
                // Example: Navigator.pop(context); // To close the drawer
                // For actual logout logic, you might need to clear the user session
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row for Card Items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard(
                  context,
                  icon: Icons.book_online,
                  title: 'View Bookings',
                  subtitle: 'Check reservations',
                  route: const BookingHistoryPage(),
                ),
                _buildCard(
                  context,
                  icon: Icons.room_preferences,
                  title: 'View Rooms',
                  subtitle: '',
                  route: const ViewRoomPage(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Notification Stream
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final notifications = snapshot.data!.docs;
                  List<Widget> notificationWidgets = [];
                  for (var notification in notifications) {
                    final message = notification['message'];
                    final timestamp = notification['timestamp'];

                    notificationWidgets.add(
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.notifications, size: 30, color: Colors.blueAccent),
                          title: Text(message, style: const TextStyle(fontSize: 16)),
                          subtitle: Text(
                            timestamp.toDate().toString(),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView(
                    children: notificationWidgets,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_preferences),
            label: 'Manage rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Set to 0 for Home page
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          if (index == 0) {
            // Already on Home page
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ManageHotelDetailsPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  HotelProfile()),
            );
          }
        },
      ),
    );
  }

  // Helper method to build Card Widgets
  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget route,
  }) {
    return Container(
      height: 180,
      width: 200,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.blueAccent),
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route),
            );
          },
        ),
      ),
    );
  }
}
