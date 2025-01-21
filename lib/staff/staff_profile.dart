import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/staff/staff_edit_profile.dart';

class StaffProfile extends StatefulWidget {
  const StaffProfile({super.key});

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Profile',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Staff Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Navigate to the previous screen
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const StaffEditProfile();
                }));
              },
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('staff')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data.'));
            } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
              return const Center(child: Text('No profile data found.'));
            } else {
              final profileData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
              print('Document Data: $profileData');

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture with Shadow and Placeholder
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundImage: profileData['profilePic'] != null
                                  ? NetworkImage(profileData['profilePic'])
                                  : const AssetImage('assets/placeholder.png')
                                      as ImageProvider,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Staff Name and Role
                    Center(
                      child: Text(
                        profileData['name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        profileData['role'] ?? 'N/A',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Personal Information Section
                    _buildBox(
                      title: 'Personal Information',
                      children: [
                        _buildProfileItem('Full Name', profileData['name'] ?? 'N/A'),
                        _buildProfileItem('Phone Number', profileData['phone'] ?? 'N/A'),
                        _buildProfileItem('Email Address', profileData['email'] ?? 'N/A'),
                        _buildProfileItem('Address', profileData['address'] ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Staff Details Section
                    _buildBox(
                      title: 'Staff Details',
                      children: [
                        _buildProfileItem('Role', profileData['role'] ?? 'N/A'),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBox({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  void _editProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Edit Profile Picture feature coming soon!')),
    );
  }
}