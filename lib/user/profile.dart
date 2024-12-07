import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy values for the user profile
  String name = "John Doe";
  String email = "johndoe@example.com";
  String aadhar = "1234 5678 9123";
  String mobile = "9876543210";
  String address = "1234 Main St, Springfield, IL";
  String gender = "Male";  // Could be 'Male', 'Female', or 'Other'
  String imageUrl = "https://via.placeholder.com/150"; // Replace with a default image or profile picture URL

  // Function to simulate editing the profile
  void editProfile() {
    setState(() {
      name = "Jane Doe";  // This is a placeholder; update it with actual user input or profile editing logic
      email = "janedoe@example.com";  // Update the email if changed
      aadhar = "9876 5432 1098";  // Update the Aadhar number
      mobile = "1234567890";  // Update the mobile number
      address = "5678 Elm St, Springfield, IL";  // Update the address
      gender = "Female";  // Update gender if changed
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  // Function to simulate logging out
  void logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Data not available"));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Profile not found"));
          } else {
            // Fetch user profile data from Firestore
            var profileData = snapshot.data?.data() as Map<String, dynamic>;
            String name = profileData['name'] ?? "John Doe";
            String email = profileData['email'] ?? "johndoe@example.com";
            String aadhar = profileData['aadhar'] ?? "1234 5678 9123";
            String mobile = profileData['mobile'] ?? "9876543210";
            String address = profileData['address'] ?? "1234 Main St, Springfield, IL";
            String gender = profileData['gender'] ?? "Male";
            String imageUrl = profileData['imageUrl'] ?? "https://via.placeholder.com/150";

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 20),
                    // User Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email
                    _buildInfoCard("Email", email),
                    const SizedBox(height: 10),
                    // Aadhar Number
                    _buildInfoCard("Aadhar", aadhar),
                    const SizedBox(height: 10),
                    // Mobile Number
                    _buildInfoCard("Mobile", mobile),
                    const SizedBox(height: 10),
                    // Address
                    _buildInfoCard("Address", address),
                    const SizedBox(height: 10),
                    // Gender
                    _buildInfoCard("Gender", gender),
                    const SizedBox(height: 30),

                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: editProfile, // Simulate profile editing
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                    const SizedBox(height: 16),

                    // Log out Button
                    ElevatedButton(
                      onPressed: logout, // Log out functionality
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Log Out'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Helper widget to create information cards
  Widget _buildInfoCard(String label, String value) {
    return Card(
      color: Colors.blueGrey.shade50,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
