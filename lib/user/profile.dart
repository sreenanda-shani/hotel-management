import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'edit_profile.dart'; // Import the EditProfilePage

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      // Fetch the current user ID from Firebase Auth
      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        debugPrint('User is not logged in');
        return null;
      }

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map<String, dynamic>?> (
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Placeholder
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(
                    Icons.account_circle,
                    size: 120,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // User Details
                ProfileDetailRow(
                  icon: Icons.person,
                  label: 'Name',
                  value: userDetails['name'] ?? 'N/A',
                ),
                ProfileDetailRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: userDetails['email'] ?? 'N/A',
                ),
                ProfileDetailRow(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: userDetails['address'] ?? 'N/A',
                ),
                ProfileDetailRow(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: userDetails['phone'] ?? 'N/A',
                ),
                ProfileDetailRow(
                  icon: Icons.transgender,
                  label: 'Gender',
                  value: userDetails['gender'] ?? 'N/A',
                ),
                ProfileDetailRow(
                  icon: Icons.security,
                  label: 'Aadhar',
                  value: userDetails['aadhar'] ?? 'N/A',
                ),
                const SizedBox(height: 20),

                // Edit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to EditProfilePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// A helper widget for displaying profile details
class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
