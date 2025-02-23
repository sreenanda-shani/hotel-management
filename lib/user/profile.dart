import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/user/edit_profile';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserData() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    print(userId);
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userId) // Filtering by uid field        
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color.fromARGB(255, 0, 123, 123);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: tealColor,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fetchUserData(),
        builder: (context, snapshot) {
          debugPrint('📡 StreamBuilder state: ${snapshot.connectionState}');
          debugPrint('🚨 Error: ${snapshot.error}');
          debugPrint('📊 Snapshot Data: ${snapshot.data?.docs}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No user data found.'));
          }

          final userDetails = snapshot.data!.docs.first.data();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundColor: tealColor.withOpacity(0.2),
                  backgroundImage: userDetails['profile_picture'] != null
                      ? NetworkImage(userDetails['profile_picture'])
                      : null,
                  child: userDetails['profile_picture'] == null
                      ? const Icon(Icons.account_circle, size: 120, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ProfileDetailRow(
                          icon: Icons.person,
                          label: 'Name',
                          value: userDetails['fullName'] ?? 'N/A',
                          iconColor: tealColor,
                        ),
                        ProfileDetailRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: userDetails['email'] ?? 'N/A',
                          iconColor: tealColor,
                        ),
                        ProfileDetailRow(
                          icon: Icons.location_on,
                          label: 'Address',
                          value: userDetails['address'] ?? 'N/A',
                          iconColor: tealColor,
                        ),
                        ProfileDetailRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: userDetails['phone'] ?? 'N/A',
                          iconColor: tealColor,
                        ),
                        ProfileDetailRow(
                          icon: Icons.transgender,
                          label: 'Gender',
                          value: userDetails['gender'] ?? 'N/A',
                          iconColor: tealColor,
                        ),
                        ProfileDetailRow(
                          icon: Icons.security,
                          label: 'Aadhar',
                          value: userDetails['idProofNumber'] ?? 'N/A',
                          iconColor: tealColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tealColor,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

// Profile Detail Widget
class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const ProfileDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 26, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: iconColor),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
