import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:project1/staff/staff_feedback.dart';
import 'package:project1/staff/staff_notifications.dart';
import 'package:project1/staff/staff_profile.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({Key? key}) : super(key: key);

  @override
  _StaffHomeScreenState createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  int _selectedIndex = 0;
  String staffRole = 'Loading...'; // Variable to hold the staff role

  // Fetch role from Firestore based on the current user's UID
  Future<void> fetchStaffRole() async {
    try {
      // Get the current user's UID
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Query the staff collection for the document with the current user's UID
        DocumentSnapshot staffDoc = await FirebaseFirestore.instance
            .collection('staff')
            .doc(currentUser.uid) // Document ID is the UID of the current user
            .get();

        if (staffDoc.exists) {
          // Get the role field from the document
          String fetchedRole = staffDoc['role'] ?? 'No role found';

          setState(() {
            staffRole = fetchedRole; // Update the role in the state
          });
        } else {
          setState(() {
            staffRole = 'Staff not found';
          });
        }
      }
    } catch (e) {
      setState(() {
        staffRole = 'Error fetching role';
      });
      print('Error fetching staff details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStaffRole(); // Fetch staff role when the screen is initialized
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Staff Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StaffProfile()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('asset/download.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Staff Name',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Role: Manager',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StaffProfile()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StaffNotifications()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StaffFeedbackPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout functionality
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'asset/img4.webp',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back, Staff!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'We\'ve missed you!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            AnimatedScale(
              scale: 1.2, // Slight scale effect on interaction
              duration: Duration(milliseconds: 200),
              child: Icon(
                Icons.sentiment_satisfied,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
                const SizedBox(height: 16),

                // Display the role inside a card
               Center(
  child: Card(
    elevation: 10, // Increased elevation for a deeper shadow
    color: const Color.fromARGB(255, 5, 11, 22), // Dark color for the card
    shadowColor: Colors.black.withOpacity(0.6), // Darker shadow for depth
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Rounded corners with more curvature
    ),
    child: Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7), const Color.fromARGB(255, 199, 199, 199)], // Gradient color effect
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Role:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$staffRole',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    ),
  ),
),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
      ),
    );
  }
}
