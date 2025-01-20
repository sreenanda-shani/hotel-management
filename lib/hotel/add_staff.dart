import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController staffIdController = TextEditingController();

  bool loading = false;
  bool _isPasswordVisible = false;
  String? selectedRole = 'Receptionist'; // Default role is Receptionist

  // Add Staff handler function to process form data
  Future<void> addStaffHandler() async {
    setState(() {
      loading = true;
    });

    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String staffId = staffIdController.text;
    String role = selectedRole!;

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        staffId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      setState(() {
        loading = false;
      });
      return;
    }

    try {
      // Add staff data to Firestore
      await FirebaseFirestore.instance.collection('staff').doc(staffId).set({
        'fullName': fullName,
        'email': email,
        'password': password, // Note: Don't store plain passwords in production
        'phone': phone,
        'address': address,
        'role': role,
        'staffId': staffId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff added successfully')),
      );

      // Clear the form
      fullNameController.clear();
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      addressController.clear();
      staffIdController.clear();
      setState(() {
        selectedRole = 'Receptionist';
      });

      // Optionally navigate back
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Staff"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'asset/img4.webp',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'asset/download.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField('Full Name', fullNameController),
                    const SizedBox(height: 16),
                    _buildTextField('Email', emailController),
                    const SizedBox(height: 16),
                    _buildPasswordTextField(),
                    const SizedBox(height: 16),
                    _buildTextField('Phone Number', phoneController),
                    const SizedBox(height: 16),
                    _buildTextField('Address', addressController),
                    const SizedBox(height: 16),
                    _buildTextField('Staff ID', staffIdController),
                    const SizedBox(height: 16),
                    _buildRoleSelection(),
                    const SizedBox(height: 24),
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: addStaffHandler,
                            child: const Text('Add Staff'),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(50),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: passwordController,
        obscureText: !_isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(50),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelection() {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        onChanged: (String? newValue) {
          setState(() {
            selectedRole = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Role',
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(50),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        dropdownColor: Colors.black,
        items: [
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
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }
}
