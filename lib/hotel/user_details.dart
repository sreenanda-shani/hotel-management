import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore

// UserDetails screen that displays the profile details
class UserDetails extends StatelessWidget {
  final String userName;

  const UserDetails({super.key, required this.userName});

  // Function to fetch user data from Firestore based on the name
  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      // Fetch the user document from Firestore based on the name
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('booking')
          .where('name', isEqualTo: userName) // Query by name
          .get();

      if (userQuery.docs.isNotEmpty) {
        return userQuery.docs.first.data() as Map<String, dynamic>?; // Return the first match
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
    return null; // Return null if no user found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5.0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found'));
          }

          final userDetails = snapshot.data!;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture Section
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(
                        Icons.account_circle,
                        size: 130,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // User Name
                  Text(
                    userDetails['name'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'User Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Displaying User Details
                  ProfileDetailCard(
                    icon: Icons.person,
                    label: 'Name',
                    value: userDetails['name'] ?? 'N/A',
                  ),
                  ProfileDetailCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: userDetails['email'] ?? 'N/A',
                  ),
                  ProfileDetailCard(
                    icon: Icons.phone,
                    label: 'Mobile',
                    value: userDetails['mobile'] ?? 'N/A',
                  ),
                  ProfileDetailCard(
                    icon: Icons.payment,
                    label: 'Payment ID',
                    value: userDetails['paymentId'] ?? 'N/A',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget to display individual profile details in a card
class ProfileDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: Colors.blueAccent),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
