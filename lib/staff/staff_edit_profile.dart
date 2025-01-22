import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffEditProfile extends StatefulWidget {
  const StaffEditProfile({super.key});

  @override
  State<StaffEditProfile> createState() => _StaffEditProfileState();
}

class _StaffEditProfileState extends State<StaffEditProfile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _role = 'Loading...'; // Role of the staff (fixed)

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch profile data on initialization
  }

  // Fetch profile data from Firestore
  Future<void> _fetchProfileData() async {
    try {
      DocumentSnapshot staffDoc = await FirebaseFirestore.instance
          .collection('staff')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (staffDoc.exists) {
        final profileData = staffDoc.data() as Map<String, dynamic>;
        setState(() {
          _role = profileData['role'] ?? 'N/A';
          _nameController.text = profileData['fullName'] ?? '';
          _phoneController.text = profileData['phone'] ?? '';
          _emailController.text = profileData['email'] ?? '';
          _addressController.text = profileData['address'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  // Update profile in Firestore
  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('staff')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update({
          'fullName': _nameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'address': _addressController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Staff Profile',
      theme: ThemeData(
        primarySwatch: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.green[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Navigate to the previous screen
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Role (non-editable)
                _buildProfileItem('Role', _role, isEditable: false),
                const SizedBox(height: 20),

                // Name input field
                _buildTextField('Full Name', _nameController),
                const SizedBox(height: 16),

                // Phone number input field
                _buildTextField('Phone Number', _phoneController),
                const SizedBox(height: 16),

                // Email input field
                _buildTextField('Email Address', _emailController),
                const SizedBox(height: 16),

                // Address input field
                _buildTextField('Address', _addressController),
                const SizedBox(height: 30),

                // Save button
                Center(
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 60.0), backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ), // Button color
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // A helper widget to display a profile field
  Widget _buildProfileItem(String label, String value, {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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

  // A helper widget to display text input fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
