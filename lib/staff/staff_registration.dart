import 'package:flutter/material.dart';
import 'package:project1/staff/staff_login.dart';
import 'package:project1/user/services/staff_auth_sevice.dart';

class StaffRegistrationPage extends StatefulWidget {
  const StaffRegistrationPage({super.key});

  @override
  State<StaffRegistrationPage> createState() => _StaffRegistrationPageState();
}

class _StaffRegistrationPageState extends State<StaffRegistrationPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool loading = false;
  bool _isPasswordVisible = false;
  String? selectedRole = 'Receptionist'; // Default role is Receptionist

  // Registration handler function to process form data
  Future<void> registerHandler() async {
    setState(() {
      loading = true;
    });

    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String role = selectedRole!;

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      setState(() {
        loading = false;
      });
      return;
    }

    // Pass the data to the staffRegister method
    await StaffAuthService().staffRegister(
      email: email,
      fullName: fullName,
      password: password,
      phone: phone,
      address: address,
      role: role,
      context: context,
      staffID: '', // You can generate or input a staff ID
      staffId: '', // You can also input a department or generate it
    );

    setState(() {
      loading = false;
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const StaffLoginPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Registration"),
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
                    _buildRoleSelection(),
                    const SizedBox(height: 24),
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: registerHandler,
                            child: const Text('Register'),
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
          'Valet Parking Attendant'
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
